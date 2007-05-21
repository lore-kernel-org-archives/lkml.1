Return-Path: <linux-kernel-owner+w=401wt.eu-S1763126AbXEULES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763126AbXEULES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 07:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757273AbXEULEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 07:04:10 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:36066 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072AbXEULEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 07:04:08 -0400
Date: Mon, 21 May 2007 13:04:06 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Andrea Righi <righiandr@users.sourceforge.net>
Cc: Andi Kleen <ak@suse.de>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Rik van Riel <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
Message-ID: <20070521110406.GA14802@vanheusden.com>
References: <464C9D82.60105@redhat.com> <Pine.LNX.4.61.0705202235430.13923@yvahk01.tjqt.qr> <20070520205500.GJ22452@vanheusden.com> <200705202314.57758.ak@suse.de> <46517817.1080208@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46517817.1080208@users.sourceforge.net>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Tue May 22 12:32:47 CEST 2007
X-Message-Flag: www.vanheusden.com
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +	switch(sig) {
> >> +	case SIGQUIT: 
...
> >> +	case SIGSTKFLT:
> > 
> > Unconditional? That's definitely a very bad idea. If anything only unhandled
> > signals should be printed this way because some programs use them internally. 
> > But I think your list is far too long anyways.
> 
> Maybe you could use somthing similar to unhandled_signal() in
> arch/x86_64/mm/fault.c, but I agree that the list seems a bit too long...

What about the following enhancement: I check with sig_fatal if it would
kill the process and only then emit a message. So when an application
takes care itself of handling it nothing is printed.

Signed-off by: Folkert van Heusden <folkert@vanheusden.com>

--- kernel/signal.c.org	2007-05-20 22:47:13.000000000 +0200
+++ kernel/signal.c	2007-05-21 12:59:52.000000000 +0200
@@ -739,6 +739,8 @@
 	struct sigqueue * q = NULL;
 	int ret = 0;
 
+	/* emit some logging for unhandled signals
+	 */
+	if (sig_fatal(t, sig))
+	{
+		printk(KERN_WARNING "Sig %d send to %d owned by %d.%d (%s)\n",
+		sig, t -> pid, t -> uid, t -> gid, t -> comm);
+	}
+
 	/*
 	 * fast-pathed signals for kernel-internal things like SIGSTOP
 	 * or SIGKILL.

of course, this can also be limited to only the interesting signals:

Signed-off by: Folkert van Heusden <folkert@vanheusden.com>

--- kernel/signal.c.org	2007-05-20 22:47:13.000000000 +0200
+++ kernel/signal.c	2007-05-21 12:59:52.000000000 +0200
@@ -739,6 +739,28 @@
 	struct sigqueue * q = NULL;
 	int ret = 0;
 
+	/* emit some logging for nasty signals
+	 * especially SIGSEGV and friends aught to be looked at when happening
+	 */
+	switch(sig) {
+	case SIGQUIT: 
+	case SIGILL: 
+	case SIGTRAP:
+	case SIGABRT: 
+	case SIGBUS: 
+	case SIGFPE:
+	case SIGSEGV: 
+	case SIGXCPU: 
+	case SIGXFSZ:
+	case SIGSYS: 
+	case SIGSTKFLT:
+		if (sig_fatal(t, sig))
+		{
+			printk(KERN_WARNING "Sig %d send to %d owned by %d.%d (%s)\n",
+			sig, t -> pid, t -> uid, t -> gid, t -> comm);
+		}
+	}
+
 	/*
 	 * fast-pathed signals for kernel-internal things like SIGSTOP
 	 * or SIGKILL.


Folkert van Heusden

-- 

Multitail - gibkaja utilita po sledovaniju log-fajlov i vyvoda
kommand. Fil'trovanie, raskrašivanie, slijanie, vizual'noe sravnenie,
i t.d.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
