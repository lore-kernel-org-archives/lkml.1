Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375AbYKJIoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbYKJIoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 03:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYKJIoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 03:44:03 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:60130 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbYKJIoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 03:44:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=cXS2Q2pjWnwl0peB8JLllpLiK4a3eSJXI4im/doLEKmCwtVOSVeU6/HOnHjvZlD2Td
         jjuCk1pCqVSndPjXzR+vLLLdOTvpIiin3zXzIg8iC3gRxL4YGYzTtAXXcoT+3eKbMgzz
         P2D36IthKUFB/CD/IjsfcdbVWGlwMkv2yj/PQ=
Message-ID: <628d1650811100043r4ff74d4ch3da0a1740e78ae9a@mail.gmail.com>
Date: Mon, 10 Nov 2008 16:43:59 +0800
From: "wzt wzt" <wzt.wzt@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Is it a bug with __get_vm_area_node?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the __get_vm_area_node() doesn't check the  parameter start and end.

__get_vm_area_node() called by __get_vm_area(), its a export function.

If some drivers pass a bad value to start, such as 0.  it will
something wrong with vmlist.


static struct vm_struct *
__get_vm_area_node(unsigned long size, unsigned long flags, unsigned long start,
                unsigned long end, int node, gfp_t gfp_mask, void *caller)
{

...

        write_lock(&vmlist_lock);
        for (p = &vmlist; (tmp = *p) != NULL ;p = &tmp->next) {
                if ((unsigned long)tmp->addr < addr) {
                        if((unsigned long)tmp->addr + tmp->size >= addr)
                                addr = ALIGN(tmp->size +
                                             (unsigned long)tmp->addr, align);
                        continue;
                }
                if ((size + addr) < addr)
                        goto out;
                if (size + addr <= (unsigned long)tmp->addr)     // if
addr is 0, the loop will be immediately break.
                        goto found;
                addr = ALIGN(tmp->size + (unsigned long)tmp->addr, align);
                if (addr > end - size)
                        goto out;
        }
        if ((size + addr) < addr)
                goto out;
        if (addr > end - size)
                goto out;

// if addr is 0,  it will be add a trash vm_struct to vmlist.
found:
        area->next = *p;
        *p = area;

        area->flags = flags;
        area->addr = (void *)addr;
        area->size = size;
        area->pages = NULL;
        area->nr_pages = 0;
        area->phys_addr = 0;
        area->caller = caller;
        write_unlock(&vmlist_lock);

        return area;
...
}

I don't kown,  weather it's a bug.

If it's a bug, my patch is:

--- linux-2.6.27.orig/mm/vmalloc.c      2008-11-11 00:22:28.000000000 +0800
+++ linux-2.6.27/mm/vmalloc.c   2008-11-11 00:28:31.000000000 +0800
@@ -214,6 +214,9 @@ __get_vm_area_node(unsigned long size, u
        unsigned long align = 1;
        unsigned long addr;

+       if (start < VMALLOC_START || end > VMALLOC_END)
+               return NULL;
+
        BUG_ON(in_interrupt());
        if (flags & VM_IOREMAP) {
                int bit = fls(size);
