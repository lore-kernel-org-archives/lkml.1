Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbXIFOoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbXIFOoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 10:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbXIFOoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 10:44:06 -0400
Received: from krichy.tvnetwork.hu ([80.95.68.194]:58495 "HELO
	krichy.tvnetwork.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752824AbXIFOoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 10:44:04 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Sep 2007 10:44:04 EDT
Date: Thu, 6 Sep 2007 16:37:20 +0200 (CEST)
From: Richard Kojedzinszky <krichy@tvnetwork.hu>
To: Willy Tarreau <w@1wt.eu>
cc: Axel Reinhold <axel@freakout.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.4.35.1 and panic at boot with arch=c3 and gcc-4.x
In-Reply-To: <20070905220027.GB11602@1wt.eu>
Message-ID: <Pine.LNX.4.64.0709061636500.11037@krichy.tvnetwork.hu>
References: <20070905220027.GB11602@1wt.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Willy,

I can confirm that this fixes the problem, the kernel indeed boots on such 
a board.

regards,
Kojedzinszky Richard
TvNetWork Nyrt.
E-mail: krichy (at) tvnetwork [dot] hu
PGP: 0x24E79141
   Fingerprint = 6847 ECFF EF58 0C09 18A5  16CF 270F 0C6F 24E7 9141

On Thu, 6 Sep 2007, Willy Tarreau wrote:

> Date: Thu, 6 Sep 2007 00:00:27 +0200
> From: Willy Tarreau <w@1wt.eu>
> To: Axel Reinhold <axel@freakout.de>,
>     Richard Kojedzinszky <krichy@tvnetwork.hu>
> Cc: linux-kernel@vger.kernel.org
> Subject: 2.4.35.1 and panic at boot with arch=c3 and gcc-4.x
> 
> Axel, Richard,
>
> you both reported a very similar problem to me (panic at boot on VIA c3
> with 2.4.35.1 when built with gcc-4.1). I could reproduce the problem
> with your configs here and compare the code with your working builds.
>
> I finally tracked the problem down to a dirty trick used to prevent
> do_test_wp_bit() from being inlined (Axel, you identified the right
> file). Unfortunately, this trick does not work anymore when gcc-4.x
> is used without -fno-unit-at-a-time, so let's use the correct method
> instead. I really hope that this trick is not used anywhere else!
>
> The following patch fixes the issue for me. Could you please give it a
> try before I merge it?
>
> Thanks in advance,
> Willy
>
> --
>> From 6ede67f873403d7e19fc0099952badd1db73ed66 Mon Sep 17 00:00:00 2001
> From: Willy Tarreau <w@1wt.eu>
> Date: Wed, 5 Sep 2007 23:39:11 +0200
> Subject: [PATCH] i386: do_test_wp_bit() must not be inlined
>
> do_test_wp_bit() has a comment stating that it must not be inlined.
> Unfortunately, the trick to prevent it from being inlined is not
> reliable under gcc 4.x.
>
> The simple fix consists in specifying the noinline attribute.
> Tested and confirmed to produce the correct code for gcc versions
> 2.95.3, 3.3.6, 3.4.6, 4.0.2, 4.1.1 and 4.2.1.
>
> Special thanks to Axel Reinhold and Richard Kojedzinszky for their
> continuous feedback when trying to solve this issue.
>
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
> arch/i386/mm/init.c |    6 +++---
> 1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/i386/mm/init.c b/arch/i386/mm/init.c
> index 0dc1751..2d81117 100644
> --- a/arch/i386/mm/init.c
> +++ b/arch/i386/mm/init.c
> @@ -381,7 +381,7 @@ void __init paging_init(void)
>  * This function cannot be __init, since exceptions don't work in that
>  * section.
>  */
> -static int do_test_wp_bit(unsigned long vaddr);
> +static int __attribute__((noinline)) do_test_wp_bit(unsigned long vaddr);
>
> void __init test_wp_bit(void)
> {
> @@ -561,8 +561,8 @@ void __init mem_init(void)
>
> }
>
> -/* Put this after the callers, so that it cannot be inlined */
> -static int do_test_wp_bit(unsigned long vaddr)
> +/* This function must not be inlined */
> +static int __attribute__((noinline)) do_test_wp_bit(unsigned long vaddr)
> {
> 	char tmp_reg;
> 	int flag;
> -- 
> 1.5.2.5
>
