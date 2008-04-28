Return-Path: <linux-kernel-owner+w=401wt.eu-S932660AbYD1IIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660AbYD1IIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 04:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765697AbYD1IIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 04:08:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45435 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbYD1IId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 04:08:33 -0400
Date: Mon, 28 Apr 2008 10:08:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Build failure (with insane config)
Message-ID: <20080428080819.GC1415@elte.hu>
References: <adahcdm3b63.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adahcdm3b63.fsf@cisco.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland Dreier <rdreier@cisco.com> wrote:

> For x86-64, arch/x86/lib/Makefile has:
> 
>         lib-y += csum-partial_64.o csum-copy_64.o csum-wrappers_64.o
> 
> so in particular ip_compute_csum() (from csum-partial_64.c) gets put in
> libs, so even though it is exported, it gets thrown away at link time if
> there are no non-modular users.
> 
> However, if someone has an insane config with CONFIG_NET=n and
> CONFIG_VIDEO_BT848=m, then ip_compute_csum() gets discarded but the
> modular code in drivers/media/video/bt8xx/bttv-cards.c calls it and...
> 
>         ERROR: "ip_compute_csum" [drivers/media/video/bt8xx/bttv.ko] undefined!
> 
> I guess one fix is just to put at least csum-partial_64.c in obj-y 
> instead; it does seem broken to have files with EXPORT_SYMBOL() be 
> lib-y, since it is really an invitation for this problem.  Other ideas 
> would be for bttv to depend on or select CONFIG_NET.

well, the TCP/IP checksumming functions are in lib portions on every 
architecture i checked, and the exports are handled by the networking 
code. And the symbol used is named ip_compute_csum(). So i think the 
correct solution is to make CONFIG_VIDEO_BT848 depend on CONFIG_NET ...

especially on embedded there's an advantage in linking out unused core 
kernel functions. But even if we did this change on x86, other 
architectures might (correctly) complain about x86 going it alone. x86 
gets the most use by far, so if we start introducing build assymetries 
like this it will just mess up the build on other architectures.

	Ingo
