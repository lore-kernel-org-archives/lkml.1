Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbYKXMmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbYKXMmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 07:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYKXMmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 07:42:12 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39802 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbYKXMmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 07:42:12 -0500
Subject: Re: [PATCH -tip] kmemcheck: fix dynamic enable/disable
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20081124122013.GA24810@localhost.localdomain>
References: <20081124122013.GA24810@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 24 Nov 2008 14:43:48 +0200
Message-Id: <1227530628.3718.122.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vegard,

On Mon, 2008-11-24 at 13:20 +0100, Vegard Nossum wrote:
> (Ingo: Will send pull request for this later :-))
> 
> 
> From 6f505f59011e565c2dbb7a220702feb0447cc854 Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Mon, 24 Nov 2008 11:52:05 +0100
> Subject: [PATCH] kmemcheck: fix dynamic enable/disable
> 
> On Fri, Oct 10, 2008 at 1:40 PM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> > I received a lot of errors after manually enabling kmemcheck
> > in /proc (it had been turned off due to oneshot mode). It
> > might be a good idea to put a warning that errrors found after
> > enabling it at any time other than boot might be spurious.
> 
> Fixed. This was the problem: Instructions with multiple address
> operands could look up the shadow of an address that had
> previously been un-hidden. After handling the memory access, the
> page would get hidden again. The fix is to verify that the page
> is present before we return a shadow pointer.

I don't quite understand the error condition nor the fix. It's probably
because I fried my brain during the weekend but here goes...
﻿
> diff --git a/arch/x86/mm/kmemcheck/shadow.c b/arch/x86/mm/kmemcheck/shadow.c
> index 196dddc..62a0f63 100644
> --- a/arch/x86/mm/kmemcheck/shadow.c
> +++ b/arch/x86/mm/kmemcheck/shadow.c
> @@ -27,6 +27,8 @@ void *kmemcheck_shadow_lookup(unsigned long address)
>  	pte = kmemcheck_pte_lookup(address);
>  	if (!pte)
>  		return NULL;
> +	if (pte_present(*pte))
> +		return NULL;

OK, so when kmemcheck is disabled in oneshot mode they're made present
and we don't mark them as non-present when we enable kmemcheck again? Is
there a reason we can't do that? You might want add a comment explaining
what's going on here.
 
>  	page = virt_to_page(address);
>  	if (!page->shadow)

> diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
> index 056b4f1..12a4bbd 100644
> --- a/arch/x86/mm/kmemcheck/kmemcheck.c
> +++ b/arch/x86/mm/kmemcheck/kmemcheck.c
> @@ -707,6 +707,16 @@ bool kmemcheck_trap(struct pt_regs *regs)
>  	}
>  
>  	/*
> +	 * At this point, we know that the trap was kmemcheck's. However, if
> +	 * kmemcheck was disabled, we need to return immediately (and stop
> +	 * emulating the REP instruction).
> +	 */
> +	if (!kmemcheck_enabled) {
> +		kmemcheck_hide(regs);
> +		return true;
> +	}

OK, I assume kmemcheck_hide() stops emulating the REP instruction? Why
do we need to do it here and not at kmemcheck disable-time? Also, this
change doesn't seem to be explained in the patch description?

		Pekka

