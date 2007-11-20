Return-Path: <linux-kernel-owner+w=401wt.eu-S1758151AbXKTFzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbXKTFzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 00:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755923AbXKTFze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 00:55:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47699 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757529AbXKTFzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 00:55:24 -0500
Date: Tue, 20 Nov 2007 06:55:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Chris Friedhoff <chris@friedhoff.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc2 STD with s2disk fails to activate suspended system
	after loading - now 2.6.24-rc3
Message-ID: <20071120055519.GD20436@elte.hu>
References: <20071110221629.1d180480.chris@friedhoff.org> <200711191958.36570.rjw@sisk.pl> <20071119234334.2b955b92.chris@friedhoff.org> <200711200058.29663.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711200058.29663.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > increasing CONFIG_BLK_DEV_RAM_SIZE from 7777 to 131072 hasn't 
> > changed the non-functioning of 2.6.24-rc3
> > 
> > s2disk works with 2.6.23.8 ; I tested 4 cycles in a row, 2 from 
> > console and 2 from within X
> 
> I've attached a patch to the bugzilla entry, please test it.
[...]
> --- linux-2.6.orig/init/do_mounts_initrd.c
> +++ linux-2.6/init/do_mounts_initrd.c
> @@ -55,6 +55,8 @@ static void __init handle_initrd(void)
>  	sys_mount(".", "/", NULL, MS_MOVE, NULL);
>  	sys_chroot(".");
>  
> +	current->flags |= PF_NOFREEZE;
> +
>  	pid = kernel_thread(do_linuxrc, "/linuxrc", SIGCHLD);
>  	if (pid > 0)
>  		while (pid != sys_wait4(-1, NULL, 0, NULL)) {

this is not the first time (and not the last time) that a missing 
PF_NOFREEZE is causing hard to debug suspend problems. I think we should 
be more robust about this and at minimum include some debug mechanism 
that determines when a PF_NOFREEZE annotation is missing. (or at least 
detect the condition somehow and report it) This bug took 10 days to 
track down.

	Ingo
