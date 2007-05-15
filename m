Return-Path: <linux-kernel-owner+w=401wt.eu-S1760703AbXEOJIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703AbXEOJIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 05:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758084AbXEOJIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 05:08:13 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:56185 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758048AbXEOJIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 05:08:12 -0400
Date: Tue, 15 May 2007 10:17:58 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       linux-kernel@vger.kernel.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       dang@gentoo.org, stable@kernel.org
Subject: Re: [Bugme-new] [Bug 8479] New: gettimeofday returning 1000000 in
 tv_usec on core2duo
Message-Id: <20070515101758.51d6bc47.dada1@cosmosbay.com>
In-Reply-To: <200705150922.47702.ak@suse.de>
References: <200705150417.l4F4HlvS013354@fire-2.osdl.org>
	<46494DFC.6080104@cosmosbay.com>
	<20070514232301.69e27bbe.akpm@linux-foundation.org>
	<200705150922.47702.ak@suse.de>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 09:22:47 +0200
Andi Kleen <ak@suse.de> wrote:

> 
> > >
> > > I remember I already hit this and corrected it
> > >
> > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blobdi
> > >ff;f=arch/x86_64/kernel/vsyscall.c;h=dc32cef961950915fbaa185e36ab802d5f7ce
> > >a3b;hp=ba330f87067996a17495f7d03466d646c718b52c;hb=c8118c6c07f2edfd697aaa0
> > >b93e08c3b65a5a675;hpb=272a3713bb9e302e0455c894c41180a482d2c8a3
> >
> > Oh, OK.
> >
> > > Maybe a stable push is necessary ?
> >
> > yup.  Please always think of -stable when preparing fixes.  I'm sure many
> > useful fixes are slipping past simply because those who _are_ looking out
> > for backportable fixes are missing things.
> >
> > Greg, Chris: please consider c8118c6c07f2edfd697aaa0b93e08c3b65a5a675
> > for -stable, if it isn't already there.
> 
> The full patch is overkill because 99% of it is an totally unrelated 
> optimization. Only the > -> >= change should be backported

OK, here is the fix only patch, for linux-2.6.21-stable only, since 2.6.22 is already fixed.

[PATCH] x86_64 : Fix vgettimeofday()

vgettimeofday() may return some bad timeval values, (tv_usec = 1000000), because of a wrong compare.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

--- arch/x86_64/kernel/vsyscall.c
+++ arch/x86_64/kernel/vsyscall.c
@@ -132,7 +132,7 @@ static __always_inline void do_vgettimeo
 
 	/* convert to usecs and add to timespec: */
 	tv->tv_usec += nsec_delta / NSEC_PER_USEC;
-	while (tv->tv_usec > USEC_PER_SEC) {
+	while (tv->tv_usec >= USEC_PER_SEC) {
 		tv->tv_sec += 1;
 		tv->tv_usec -= USEC_PER_SEC;
 	}
