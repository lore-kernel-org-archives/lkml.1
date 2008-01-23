Return-Path: <linux-kernel-owner+w=401wt.eu-S1753620AbYAWJfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbYAWJfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 04:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbYAWJfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 04:35:30 -0500
Received: from ns2.suse.de ([195.135.220.15]:40977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbYAWJf3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 04:35:29 -0500
To: =?iso-8859-1?q?Lo=EFc_Greni=E9?= <loic.grenie@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: vmalloc_32 and SLAB incompatible in 2.6.23.9
References: <9b06e8d20801230114v1e09e5e8s6a4b438562c62619@mail.gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 23 Jan 2008 10:35:28 +0100
In-Reply-To: <9b06e8d20801230114v1e09e5e8s6a4b438562c62619@mail.gmail.com>
Message-ID: <p73wsq0lw9r.fsf@crumb.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Loïc Grenié" <loic.grenie@gmail.com> writes:

>      Since GFP_DMA32 is not considered a valid flag, vmalloc_32 and
>   SLAB are incompatible in kernel 2.6.23.9 (and probably later ones).
>   It might be as simple as adding GFP_DMA32 everywhere where
>   GFP_DMA is used in mm/slab.c, but I don't dare do it. I personally
>   switched to SLUB.

I don't think it would really work for slub either.

If you look at /proc/slabinfo you see that there are separate DMA
caches. That is because sl[abo]b all cache objects and if the 
objects have different requirements (like GFP_DMA, GFP_DMA32, GFP_KERNEL)
they would need different caches. Otherwise you risk getting
later objects originally allocated with the wrong flags.

To make GFP_DMA32 work would require adding another set of DMA32
caches to all kmalloc caches etc or a separate one for each
custom kmem cache that you use that only gets _DMA32 objects.

Better just use __get_free_pages() directly. 

-Andi
