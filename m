Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbYCNF0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbYCNF0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 01:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYCNF02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 01:26:28 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:48494 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbYCNF02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 01:26:28 -0400
Date: Fri, 14 Mar 2008 08:26:06 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Laurent Riffard <laurent.riffard@free.fr>, linux-kernel@vger.kernel.org,
       roland@redhat.com, mingo@elte.hu, xemul@openvz.org
Subject: Re: 2.6.25-rc5-mm1: "consolechars" hangs on boot
Message-ID: <20080314052606.GA226@tv-sign.ru>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <47D9A5A2.4000009@free.fr> <20080313153851.2023980c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313153851.2023980c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13, Andrew Morton wrote:
>
> On Thu, 13 Mar 2008 23:07:30 +0100
> Laurent Riffard <laurent.riffard@free.fr> wrote:
> 
> > Le 11.03.2008 09:14, Andrew Morton a __crit :
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/
> > > 
> > 
> > With 2.6.25-rc5-mm1, my system (Ubuntu 7.10/Gutsy) reliably hangs on
> > boot. Sysrq-T shows 12 "consolechars" processes stuck in do_exit call.
> > 
> > The bisection said "Sucker is
> > patches/signals-send_signal-factor-out-signal_group_exit-checks.patch"
> > 
> > Actually, it's 2.6.25-rc5-mm1 + add-warn_on_secs-macro-fix-fix.patch,
> > I guess this patch is innocent.

Laurent, thanks a lot!

What was the state of consolechars? Where exactly did it hang? do_exit+??

> Actually I later dropped
> signals-send_signal-factor-out-signal_group_exit-checks.patch at Oleg's
> request.
> 
> But I don't think we did that because it was known to be buggy, so perhaps
> the same bug crept back in in another form..

Yes, currently I suspect we have another bug.

And. While doing this patch I forgot we should fix the bugs with init first!
(will try to make the patch soon).

Laurent, any chance you can try 2.6.25-rc5-mm1 + the patch below?
Unlikely it can help, but would be great to be sure.

Oleg.

--- MM/kernel/signal.c~	2008-03-14 08:08:07.000000000 +0300
+++ MM/kernel/signal.c	2008-03-14 08:08:17.000000000 +0300
@@ -719,6 +719,10 @@ static void complete_signal(int sig, str
 		/*
 		 * This signal will be fatal to the whole group.
 		 */
+if (is_global_init(p)) {
+	printk(KERN_CRIT "ERR!! init is killed by %d\n", sig);
+	WARN_ON_ONCE(1);
+} else
 		if (!sig_kernel_coredump(sig)) {
 			/*
 			 * Start a group exit and wake everybody up.

