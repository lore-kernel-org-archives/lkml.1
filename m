Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbZFWJCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbZFWJCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 05:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbZFWJCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 05:02:32 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:30441 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbZFWJCb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 05:02:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=VPdUZf5yL/gN9TOTn2LZ7Zp823GCmR7LXLySQNZKHGtQybJ9EAQKocZ+dOlifJWNN+
         aM5kZDf4Ls8SlbPE8AGuEOPFRZ0YgpDfrlpfGeTik+C+RLFeNnx1z9JPEIWHhqwXi5r8
         Js73TWKPP3gF2p1VzYAU5YGt34msK6WqYgi4Q=
MIME-Version: 1.0
In-Reply-To: <fc71709d0906230117h2bee4d7en9f3aadeae3cb9545@mail.gmail.com>
References: <fc71709d0906230117h2bee4d7en9f3aadeae3cb9545@mail.gmail.com>
Date: Tue, 23 Jun 2009 17:02:31 +0800
Message-ID: <fc71709d0906230202w14da8ffdpf457f7a6ed658a28@mail.gmail.com>
Subject: Re: mm: dirty page problem
From: xue yong <ultraice.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did some search in the changlogs between 2..6.16 adn 2.6.19.
I found this in http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.19

and I concluded that the kernel below 2.6.19 can't tracking shared
dirty pages, am I right?

commit edc79b2a46ed854595e40edcf3f8b37f9f14aa3f
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Mon Sep 25 23:30:58 2006 -0700

    [PATCH] mm: balance dirty pages

    Now that we can detect writers of shared mappings, throttle them.
Avoids OOM
    by surprise.

    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Hugh Dickins <hugh@veritas.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

commit d08b3851da41d0ee60851f2c75b118e1f7a5fc89
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Mon Sep 25 23:30:57 2006 -0700

    [PATCH] mm: tracking shared dirty pages

    Tracking of dirty pages in shared writeable mmap()s.

    The idea is simple: write protect clean shared writeable pages, catch the
    write-fault, make writeable and set dirty.  On page write-back clean all the
    PTE dirty bits and write protect them once again.

    The implementation is a tad harder, mainly because the default
    backing_dev_info capabilities were too loosely maintained.  Hence it is not
    enough to test the backing_dev_info for cap_account_dirty.

    The current heuristic is as follows, a VMA is eligible when:
     - its shared writeable
        (vm_flags & (VM_WRITE|VM_SHARED)) == (VM_WRITE|VM_SHARED)
     - it is not a 'special' mapping
        (vm_flags & (VM_PFNMAP|VM_INSERTPAGE)) == 0
     - the backing_dev_info is cap_account_dirty
        mapping_cap_account_dirty(vma->vm_file->f_mapping)
     - f_op->mmap() didn't change the default page protection

    Page from remap_pfn_range() are explicitly excluded because their COW
    semantics are already horrid enough (see vm_normal_page() in
do_wp_page()) and
    because they don't have a backing store anyway.

    mprotect() is taught about the new behaviour as well.  However it overrides
    the last condition.

    Cleaning the pages on write-back is done with page_mkclean() a new
rmap call.
    It can be called on any page, but is currently only implemented for mapped
    pages, if the page is found the be of a VMA that accounts dirty
pages it will
    also wrprotect the PTE.

    Finally, in fs/buffers.c:try_to_free_buffers(); remove
clear_page_dirty() from
    under ->private_lock.  This seems to be safe, since ->private_lock
is used to
    serialize access to the buffers, not the page itself.  This is
needed because
    clear_page_dirty() will call into page_mkclean() and would thereby violate
    locking order.

    [dhowells@redhat.com: Provide a page_mkclean() implementation for NOMMU]
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Hugh Dickins <hugh@veritas.com>
    Signed-off-by: David Howells <dhowells@redhat.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>


On Tue, Jun 23, 2009 at 4:17 PM, xue yong<ultraice.kernel@gmail.com> wrote:
> I wrote a test program. It  mmap  a file and do some write, so some
> pages become dirty.
> and then I do "cat /proc/meminfo", so I get dirty pages that I have
> written. this happened in my home
> computer with debian, self compiled kernel 2.6.18-5 installed.
>
>
> but in my company, on the servers (suse kernel 2.6.16.54), after the
> test program have written the data, there was no change in
> dirty pages column of "cat /proc/meminfo" 's output. after I killed
> the test program, the dirty pages changed immediately.
>
>
> I dont know why such different behavior, can you help me?
>
>
> becauce we want a program mmap some files, and after the files'
> contents were changed, the OS can write out these dirty
> data back to disk periodly.
>
>
>
>
> Best regards!
>
