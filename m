Return-Path: <linux-kernel-owner+w=401wt.eu-S1763031AbYEXWEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763031AbYEXWEo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 18:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761408AbYEXWEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 18:04:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:17898 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760552AbYEXWEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 18:04:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BRz9O2pJrmlPGr6URI/2KicVcELuXGoleHWGXKYb/4k2+pJaleIZ4yZnMy1VVeK+6Tg7RTXirXnX5gybDwR6GVE0aMneMQGbF6iO6H3hzQ9hoDt50HjxeCRzhEwUtBKp/pITbyNHOkECs/uTvSHb8a0NsRSkjZN4gPbVS4XwSFw=
Message-ID: <86802c440805241504v56f1d3ccud895c1c4fd0d51ef@mail.gmail.com>
Date: Sat, 24 May 2008 15:04:32 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] xen: boot via i386_start_kernel to get early reservations
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4837E4BF.6050604@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805110030.15510.yhlu.kernel@gmail.com>
	 <200805180118.57863.yhlu.kernel@gmail.com>
	 <200805211840.18619.yhlu.kernel@gmail.com>
	 <200805221520.19259.yhlu.kernel@gmail.com> <4837D7DD.7000204@goop.org>
	 <4837E4BF.6050604@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 2:49 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Boot Xen via i386_start_kernel so that all the early reservations are
> made properly; without these, it will start using the kernel and
> pagetables as early heap memory, which is a bit suboptimal.
>
> One tricky part is that reserve_early() will just panic if any of the
> early reservations overlap any others.  When a Xen domain is built, it
> constructs the initial address space as:
>
>  kernel text+data+bss
>  initrd
>  initial pagetable
>
> Therefore, when reserving the pagetable (from &_end to
> init_pg_tables_end), it covers the whole initrd area.  If it then
> tries to reserve the initrd, it will panic because of the overlap.
>
> The simple fix here is to reserve INIT_PG_TABLE first, and then only
> reserve the ramdisk if it doesn't overlap with the previous
> reservations.  A better/more complex fix might be to make
> reserve_early() deal with overlapping reservations.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
...
> ===================================================================
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1264,5 +1264,5 @@ asmlinkage void __init xen_start_kernel(
>        }
>
>        /* Start the world */
> -       start_kernel();
> +       i386_start_kernel();
> }
..

need to do the same thing in arch/x86/lguest.c::lguest_init

YH
