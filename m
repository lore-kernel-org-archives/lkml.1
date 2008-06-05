Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbYFEMoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbYFEMoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 08:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757072AbYFEMoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 08:44:05 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:63481 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941AbYFEMoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 08:44:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:user-agent:mime-version
         :content-type;
        b=c7gB7F64x+iiDK7PPMPFnVYRUPYJlXOpnXn+cV5U6TQQecD9es8Vf0QhJdvFakiZKO
         YVVkNuhJ91AB99HOQWWQgrArI2OKwXg5+wmRSs+DAgkThOoK2YO/hJFL4JggfYolS/+G
         h11qMsjP8wFYLi6dxQS5k3TPvVpM4kXGPgv1M=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: different conditions in arch_get_unmapped_area_topdown
Date: Thu, 05 Jun 2008 14:43:55 +0200
Message-ID: <m31w3cjblg.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Here's do-while loop from generic arch_get_unmapped_area_topdown() from mm/mmap.c:

        do {
                /*
                 * Lookup failure means no vma is above this address,
                 * else if new region fits below vma->vm_start,
                 * return with success:
                 */
                vma = find_vma(mm, addr);
                if (!vma || addr+len <= vma->vm_start)
                        /* remember the address as a hint for next time */
                        return (mm->free_area_cache = addr);
                
                /* remember the largest hole we saw so far */
                if (addr + mm->cached_hole_size < vma->vm_start)
                        mm->cached_hole_size = vma->vm_start - addr;
                       
                /* try just below the current vma->vm_start */
                addr = vma->vm_start-len;
        } while (len < vma->vm_start);

And here's from arch/x86/mm/hugetlbpage.c:

        do {
                /*
                 * Lookup failure means no vma is above this address,
                 * i.e. return with success:
                 */
                if (!(vma = find_vma_prev(mm, addr, &prev_vma)))
                        return addr;
       
                /*
                 * new region fits between prev_vma->vm_end and
                 * vma->vm_start, use it:
                 */
                if (addr + len <= vma->vm_start &&
                            (!prev_vma || (addr >= prev_vma->vm_end))) {
                        /* remember the address as a hint for next time */
                        mm->cached_hole_size = largest_hole;
                        return (mm->free_area_cache = addr);
                } else {
                        /* pull free_area_cache down to the first hole */
                        if (mm->free_area_cache == vma->vm_end) {
                                mm->free_area_cache = vma->vm_start;
                                mm->cached_hole_size = largest_hole;
                        }
                }
           
                /* remember the largest hole we saw so far */
                if (addr + largest_hole < vma->vm_start)
                        largest_hole = vma->vm_start - addr;

                /* try just below the current vma->vm_start */
                addr = (vma->vm_start - len) & HPAGE_MASK;
        } while (len <= vma->vm_start);

Why conditions in "while" differ from each other? Can the second case lead to infinite loop?

Thanks!
-- 
wbr, Vitaly
