Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbYHPRpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbYHPRpo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 13:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYHPRpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 13:45:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491AbYHPRpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 13:45:17 -0400
Date: Sat, 16 Aug 2008 10:44:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] VMA comment fixes
In-Reply-To: <200808160934.m7G9YgWs028953@hs20-bc2-1.build.redhat.com>
Message-ID: <alpine.LFD.1.10.0808161033350.3324@nehalem.linux-foundation.org>
References: <200808160934.m7G9YgWs028953@hs20-bc2-1.build.redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 16 Aug 2008, Ulrich Drepper wrote:
>
> These seem to be two tiny problems in comments related to VMA data
> structures.  Am I correct?

No.

> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> -	unsigned long vm_flags;		/* Flags, listed below. */
> +	unsigned long vm_flags;		/* Flags, see vmalloc.h. */

It's "see mm.h" for the primary one. The vmalloc.h ones are only used for 
vmalloc'ed areas, no for regular _user_ mappings.

That said, I agree that it's damn confusing that we have two different 
sets of flags, both called VM_xyz. We use the "vm_area_struct" for the 
normal user virtual mappings (mmap) tracking, and we use the "vm_struct" 
for the kernel virtual mappings (vmalloc).

Both have a flags field, and both use VM_xyz for their field names.

> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> -/* bits in vm_struct->flags */
> +/* bits in vm_area_struct->flags */

See above. The vmalloc ones really are in "vm_struct->flags".

The confusion comes at least partly because

 - I think historically we _used_ to use vm_area_struct for both, if I 
   recall correctly

and because

 - we actually have some mixing of the two (for example 
   "remap_vmalloc_range()" will remap a vmalloc mapping _into_ a user 
   mapping, so it takes a _user_ mapping (a "vm_area_struct") _and_ a 
   vmalloc address (internally using a "struct vm_struct") and copies from 
   one to the other.

it might be a good idea to call the vmalloc flags somethign else than 
VM_xyz. But I'm not sure it's worth the churn. I don't remember there 
having ever been any _actual_ confusion by the VM people who have to deal 
with both (because you really very seldom can confuse them).

		Linus
