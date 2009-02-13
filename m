Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbZBMJAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbZBMJAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 04:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbZBMJA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 04:00:28 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:37746 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774AbZBMJA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 04:00:26 -0500
Message-ID: <499544AD.3030804@st.com>
Date: Fri, 13 Feb 2009 11:00:13 +0100
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-mm@vger.kernel.org
Subject: Re: [PATCH] slab: fix slab flags for archs use alignment larger 64-bit
References: <1234461073-23281-1-git-send-email-peppe.cavallaro@st.com> <20090212185640.GA6111@linux-sh.org>
In-Reply-To: <20090212185640.GA6111@linux-sh.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> No, this change in itself is not sufficient. The redzone marker placement
> as well as that of the user store need to know about the minalign as well
> before slab debug can work correctly.
>
> I last looked at this when introducing ARCH_SLAB_MINALIGN:
>
> http://article.gmane.org/gmane.linux.kernel/262528
>
> But it would need some rework for the current slab code.
>
> Note that the ARCH_KMALLOC_MINALIGN value has no meaning here, as this
> relates to slab caches in general, of which kmalloc just happens to have
> a few. This is also why the rest of the kmem_cache_create() code
> references ARCH_SLAB_MINALIGN in the first place. But that in itself is
> irrelevant since for the kmalloc slab caches, ARCH_KMALLOC_MINALIGN is
> already passed in as the align value for kmem_cache_create(), so ralign
> is already set to L1_CACHE_BYTES immediately before that check.
>
> What exactly are you having problems with that made you come up with this
> patch? It would be helpful to know precisely what your issues are, as
> this change in itself is only related to slab debug, and not general
> operation
Thanks for your feedback.

This patch is only to fix the debug information reported in
/proc/slab_allocators .

On SH, I've noticed that /proc/slab_allocators has no size-X entries.
I guess, we should find these fields, shouldn't we?

IIUC, and as you explained above, ralign is already set to the cache
line size by the following code:
...
/* 3) caller mandated alignment */
if (ralign < align)
ralign = align;

Then, there is following check:
...
/* disable debug if necessary */
if (ralign > _alignof__(unsigned long long))
flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);

In my point of view, just this check appears "incoherent" (please, note
I'm not familiar with the slab internals).
It always makes sense in case of x86 where ARCH_KMALLOC_MINALIGN is
defined as: __alignof__(unsigned long long) as well.
In case of sh, we always disable debug for 32 aligned objects. As side
effect, within the leaks_show function we immediately exit for them.
Indeed, after applying the patch, I attached, I was able to find size-X
fields within the slab_allocators proc entry.


