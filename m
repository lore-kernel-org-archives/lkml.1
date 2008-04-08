Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbYDHLrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbYDHLrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbYDHLq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:46:59 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:48553 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752257AbYDHLq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:46:58 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Apr 2008 07:46:58 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=cqmeHh65H4tx+6srUD1lKj805p/i0460mS/JuH1Da2EUXlmOsivZrObUbtqqNOCQwE3IDj1oONK0Vi+B/uOKgLTO3dDbG+I4tBuuYpa5vBRPW1HJrddEeGj03pJ7JWeXCP2wsOobwNYrWv0HKgx6qlD7rxoZx5fqjfjT+d0+AXg=  ;
X-YMail-OSG: aDlh_EYVM1l35ADiP1b0qE8Wf5yNpMSBPLnxDNVbD_BkfM1wfh_e_IcLyTUrb8ju2O341DnD2A--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 1/2] futex: rely on get_user_pages() for shared futexes
Date: Tue, 8 Apr 2008 21:40:04 +1000
User-Agent: KMail/1.9.5
Cc: Eric Dumazet <dada1@cosmosbay.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
References: <20080404193332.348493000@chello.nl> <20080404193817.574188000@chello.nl>
In-Reply-To: <20080404193817.574188000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804082140.04356.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 April 2008 06:33, Peter Zijlstra wrote:
> On the way of getting rid of the mmap_sem requirement for shared futexes,
> start by relying on get_user_pages().
>
> This requires we get the page associated with the key, and put the page
> when we're done with it.

Hi Peter,

Cool.

I'm all for removing mmap_sem requirement from shared futexes...
Are there many apps which make a non-trivial use of them I wonder?
I guess it will help legacy (pre-FUTEX_PRIVATE) usespaces in
performance too, though.

What I'm worried about with this is invalidate or truncate races.
With direct IO, it obviously doesn't matter because the only
requirement is that the page existed at the address at some point
during the syscall... 

So I'd really like you to not carry the page around in the key, but
just continue using the same key we have now. Also, lock the page
and ensure it hasn't been truncated before taking the inode from the
key and incrementing its count (page lock's extra atomics should be
more or less cancelled out by fewer mmap_sem atomic ops).

get_futex_key should look something like this I would have thought:?

BTW. I like that it removes a lot of fshared crap from around
the place. And also this is a really good user of fast_gup
because I guess it should usually be faulted in. The problem is
that this could be a little more expensive for architectures that
don't implement fast_gup. Though most should be able to.

@@ -191,7 +191,6 @@ static int get_futex_key(u32 __user *uad
 {
        unsigned long address = (unsigned long)uaddr;
        struct mm_struct *mm = current->mm;
-       struct vm_area_struct *vma;
        struct page *page;
        int err;

@@ -210,27 +209,26 @@ static int get_futex_key(u32 __user *uad
         * Note : We do have to check 'uaddr' is a valid user address,
         *        but access_ok() should be faster than find_vma()
         */
-       if (!fshared) {
+       if (likely(!fshared)) {
                if (unlikely(!access_ok(VERIFY_WRITE, uaddr, sizeof(u32))))
                        return -EFAULT;
                key->private.mm = mm;
                key->private.address = address;
                return 0;
        }
-       /*
-        * The futex is hashed differently depending on whether
-        * it's in a shared or private mapping.  So check vma first.
-        */
-       vma = find_extend_vma(mm, address);
-       if (unlikely(!vma))
-               return -EFAULT;
-
-       /*
-        * Permissions.
-        */
-       if (unlikely((vma->vm_flags & (VM_IO|VM_READ)) != VM_READ))
-               return (vma->vm_flags & VM_IO) ? -EPERM : -EACCES;

+again:
+       err = fast_gup(address, 1, 0, &page);
+       if (err < 0)
+               return err;
+
+       lock_page(page);
+       if (!page->mapping) { /* PageAnon pages shouldn't get caught here */
+               unlock_page(page);
+               put_page(page);
+               goto again;
+       }
+
        /*
         * Private mappings are handled in a simple way.
         *
@@ -240,38 +238,19 @@ static int get_futex_key(u32 __user *uad
         * VM_MAYSHARE here, not VM_SHARED which is restricted to shared
         * mappings of _writable_ handles.
         */
-       if (likely(!(vma->vm_flags & VM_MAYSHARE))) {
-               key->both.offset |= FUT_OFF_MMSHARED; /* reference taken on mm 
*
/
+       if (PageAnon(page)) {
+               key->both.offset |= FUT_OFF_MMSHARED; /* ref taken on mm */
                key->private.mm = mm;
                key->private.address = address;
-               return 0;
-       }
-
-       /*
-        * Linear file mappings are also simple.
-        */
-       key->shared.inode = vma->vm_file->f_path.dentry->d_inode;
-       key->both.offset |= FUT_OFF_INODE; /* inode-based key. */
-       if (likely(!(vma->vm_flags & VM_NONLINEAR))) {
-               key->shared.pgoff = (((address - vma->vm_start) >> PAGE_SHIFT)
-                                    + vma->vm_pgoff);
-               return 0;
-       }
-
-       /*
-        * We could walk the page table to read the non-linear
-        * pte, and get the page index without fetching the page
-        * from swap.  But that's a lot of code to duplicate here
-        * for a rare case, so we simply fetch the page.
-        */
-       err = get_user_pages(current, mm, address, 1, 0, 0, &page, NULL);
-       if (err >= 0) {
-               key->shared.pgoff =
-                       page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
-               put_page(page);
-               return 0;
+       } else {
+               key->both.offset |= FUT_OFF_INODE; /* inode-based key. */
+               key->shared.inode = page->mapping->inode;
+               key->shared.pgoff = page->index;
        }
-       return err;
+out:
+       unlock_page(page);
+       put_page(page);
+       return 0;
 }

 /*

