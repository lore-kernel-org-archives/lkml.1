Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795Ab0A3A5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab0A3A5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 19:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081Ab0A3A5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 19:57:36 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:51145 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab0A3A5d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 19:57:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=kwI2eOhwCCghe39d/79vCH4XeLfbxl+HxCmiPxURO5DQQQnXL5nG6J+KG90al1/dxH
         2AplCqg2ljTzZ6ep5VORXk/ArNSHjkzDAibMl/iGao43fDa6Vk/rlcBdlzkUKWGbn0MM
         UODHAPTmPLSarAEEaTioYr9R3fpCkPH1coDzk=
MIME-Version: 1.0
Date: Fri, 29 Jan 2010 16:57:31 -0800
Message-ID: <6cafb0f01001291657q4ccbee86rce3143a4be7a1433@mail.gmail.com>
Subject: Bug in find_vma_prev - mmap.c
From: Tony Perkins <da.perk@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code returns vma (mm->mmap) if it sees that addr is lower than first VMA.
However, I think it falsely returns vma (mm->mmap) on the case where
addr is in the first VMA.

If it is the first VMA region:
- *pprev should be set to NULL
- implying prev is NULL
- and should therefore return vma (so in this case, I just added if
it's the first VMA and it's within range)

/* Same as find_vma, but also return a pointer to the previous VMA in *pprev. */
struct vm_area_struct *
find_vma_prev(struct mm_struct *mm, unsigned long addr,
            struct vm_area_struct **pprev)
{
    struct vm_area_struct *vma = NULL, *prev = NULL;
    struct rb_node *rb_node;
    if (!mm)
        goto out;

    /* Guard against addr being lower than the first VMA */
    vma = mm->mmap;

    /* Go through the RB tree quickly. */
    rb_node = mm->mm_rb.rb_node;

    while (rb_node) {
        struct vm_area_struct *vma_tmp;
        vma_tmp = rb_entry(rb_node, struct vm_area_struct, vm_rb);

        if (addr < vma_tmp->vm_end) {
            // TONY: if (vma_tmp->vm_start <= addr) vma = vma_tmp; //
this returns the correct 'vma' when vma is the first node (i.e., no
prev)
            rb_node = rb_node->rb_left;
        } else {
            prev = vma_tmp;
            if (!prev->vm_next || (addr < prev->vm_next->vm_end))
                break;
            rb_node = rb_node->rb_right;
        }
    }

out:
    *pprev = prev;
    return prev ? prev->vm_next : vma;
}

Is this a known issue and/or has this problem been addressed?
Also, please CC my email address with responses.

Thanks,
--tony

--
Aim for Perfection!
