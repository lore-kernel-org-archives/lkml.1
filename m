Return-Path: <linux-kernel-owner+w=401wt.eu-S1757220AbXEUMjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbXEUMjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 08:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbXEUMjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 08:39:16 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:52798 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755093AbXEUMjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 08:39:15 -0400
Date: Mon, 21 May 2007 14:30:44 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Folkert van Heusden <folkert@vanheusden.com>
cc: Andrea Righi <righiandr@users.sourceforge.net>, Andi Kleen <ak@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Rik van Riel <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
In-Reply-To: <20070521110406.GA14802@vanheusden.com>
Message-ID: <Pine.LNX.4.61.0705211420100.4452@yvahk01.tjqt.qr>
References: <464C9D82.60105@redhat.com> <Pine.LNX.4.61.0705202235430.13923@yvahk01.tjqt.qr>
 <20070520205500.GJ22452@vanheusden.com> <200705202314.57758.ak@suse.de>
 <46517817.1080208@users.sourceforge.net> <20070521110406.GA14802@vanheusden.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 21 2007 13:04, Folkert van Heusden wrote:
>
>What about the following enhancement: I check with sig_fatal if it would
>kill the process and only then emit a message. So when an application
>takes care itself of handling it nothing is printed.

>+	/* emit some logging for unhandled signals
>+	 */
>+	if (sig_fatal(t, sig))

Not unhandled_signal()?

>+	{

if (sig_fatal(t, sig)) {

>+		printk(KERN_WARNING "Sig %d send to %d owned by %d.%d (%s)\n",

s/send/sent/;

>+		sig, t -> pid, t -> uid, t -> gid, t -> comm);

t->pid, t->uid, t->gid, t->comm);

>+	}
>+
> 	/*
> 	 * fast-pathed signals for kernel-internal things like SIGSTOP
> 	 * or SIGKILL.
>
>of course, this can also be limited to only the interesting signals:
>
>Signed-off by: Folkert van Heusden <folkert@vanheusden.com>
>
>--- kernel/signal.c.org	2007-05-20 22:47:13.000000000 +0200
>+++ kernel/signal.c	2007-05-21 12:59:52.000000000 +0200
>@@ -739,6 +739,28 @@
> 	struct sigqueue * q = NULL;
> 	int ret = 0;
> 
>+	/* emit some logging for nasty signals
>+	 * especially SIGSEGV and friends aught to be looked at when happening
>+	 */
>+	switch(sig) {
>+	case SIGQUIT: 
>+	case SIGILL: 
>+	case SIGTRAP:
>+	case SIGABRT: 
>+	case SIGBUS: 
>+	case SIGFPE:
>+	case SIGSEGV: 
>+	case SIGXCPU: 
>+	case SIGXFSZ:
>+	case SIGSYS: 
>+	case SIGSTKFLT:
>+		if (sig_fatal(t, sig))
>+		{
>+			printk(KERN_WARNING "Sig %d send to %d owned by %d.%d (%s)\n",
>+			sig, t -> pid, t -> uid, t -> gid, t -> comm);
>+		}
>+	}
>+
> 	/*
> 	 * fast-pathed signals for kernel-internal things like SIGSTOP
> 	 * or SIGKILL.
>



	Jan
-- 
