Return-Path: <linux-kernel-owner+w=401wt.eu-S1751744AbXA1LPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbXA1LPA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 06:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbXA1LPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 06:15:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:38447 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbXA1LO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 06:14:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=n/FdhUBv1t4fpiVluJWTcFbW0wcPKkkFlD0g8XYjVAFg+shY+qSRuuWXKKhQ7nWz8SS7NrH2k8UG9ggMbyXD9JKSPVODEv+zePacZS/Qj0p4dlGLG1NmtuoCumrFdXrtRe+cRfkucsQv/+xkRTqNx2XXz/7tkfR+Yb+KgfS2rqI=
Message-ID: <84144f020701280314k21e4388cv4b04ededb7944f22@mail.gmail.com>
Date: Sun, 28 Jan 2007 13:14:57 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@osdl.org>
Subject: Re: [PATCH] slab: cache_grow cleanup
Cc: linux-kernel@vger.kernel.org, hugh@veritas.com, clameter@sgi.com
In-Reply-To: <20070127161229.11637b80.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0701091539160.10824@sbz-30.cs.Helsinki.FI>
	 <20070127161229.11637b80.akpm@osdl.org>
X-Google-Sender-Auth: 2f1a905ce92e37e8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 1/28/07, Andrew Morton <akpm@osdl.org> wrote:
> This gets its local interrupt state mucked up.
>
> BUG: sleeping function called from invalid context at mm/slab.c:3038
> in_atomic():0, irqs_disabled():1
> no locks held by init/1.
> irq event stamp: 656902
> hardirqs last  enabled at (656901): [<c015f48b>] mod_zone_page_state+0x4b/0x50
> hardirqs last disabled at (656902): [<c0171f54>] cache_alloc_refill+0x384/0x6a0
> softirqs last  enabled at (650628): [<c03a6317>] unix_release_sock+0x67/0x220
> softirqs last disabled at (650626): [<c03cfe8e>] _write_lock_bh+0xe/0x40
>  [<c0103f7a>] show_trace_log_lvl+0x1a/0x30
>  [<c0104682>] show_trace+0x12/0x20
>  [<c0104736>] dump_stack+0x16/0x20
>  [<c01175ea>] __might_sleep+0xba/0xd0
>  [<c017262f>] kmem_cache_alloc+0xaf/0xd0
>  [<c0172131>] cache_alloc_refill+0x561/0x6a0
>  [<c0172574>] kmem_cache_zalloc+0xe4/0xf0
>  [<c011cb49>] copy_process+0x89/0x1280
>  [<c011dfcb>] do_fork+0x6b/0x1c0
>  [<c0100e13>] sys_clone+0x33/0x40
>  [<c0102edc>] sysenter_past_esp+0x5d/0x99

Hmm, alloc_slabmgmt calls kmem_cache_alloc with interrupts disabled
which triggers the warning. We won't deadlock though as we enable
interrupts in kmem_getpages in case we need to refill
cachep->slabp_cache. So the debug check is bogus when calling
kmem_cache_alloc within the slab allocator, I think.

I'll whack it some more and resend. Thanks Andrew!

                               Pekka
