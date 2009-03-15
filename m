Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbZCODmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbZCODmV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 23:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbZCODmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 23:42:13 -0400
Received: from cmpxchg.org ([85.214.51.133]:46587 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203AbZCODmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 23:42:12 -0400
Date: Sun, 15 Mar 2009 04:41:34 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: sidc7 <siddhartha.chhabra@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: COW optimization on exec
Message-ID: <20090315034134.GA9829@cmpxchg.org>
References: <22519639.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22519639.post@talk.nabble.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 14, 2009 at 07:57:54PM -0700, sidc7 wrote:
> 
> The Linux kernel uses the COW optimization for fork, so the processes share
> the same pages, till on of the processes writes to the page. I was
> wondering, if I do a fork and do an exec immediately following the fork,
> will the COW optimization still be applied as it is most likely that the new
> process is going to write to the shared pages? So doing a COW will not give
> much benefit here, if it is done at all. Can anyone clarify if COW will be
> applied in such a case, for e.g. a command shell.

COWing the pages is not much extrawork, it's handled with this code:

        /*
         * If it's a COW mapping, write protect it both
         * in the parent and the child
         */
        if (is_cow_mapping(vm_flags)) {
                ptep_set_wrprotect(src_mm, addr, src_pte);
                pte = pte_wrprotect(pte);
        }

you can find it in mm/memory.c::copy_one_pte().  The fault handler
will then take care of it (it will notice that the pte is
write-protected while the mapping itself allows writes) and then
replace the page with a copy in the faulting process.

The real overhead is copying the page tables in the first place.  But
the kernel can not know whether exec() is soon to be called, so fork()
always must provide the copy-whole-address-space semantics.

If the forking process knows in advance the child will exec
immediately, it can use vfork() which doesn't copy the address space.

	Hannes
