Return-Path: <linux-kernel-owner+w=401wt.eu-S964864AbZLGRig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964864AbZLGRig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935510AbZLGRie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:38:34 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:62987 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935482AbZLGRid convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:38:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OMIVOledLZO+irBu+sF9j/Lk1ji4VZFkPUN6zyQ4gHxOE0PzHfrmqAVmOZAyOKdW2j
         tU0Jqbcecy1zodhlmjVq0kgF5Yk2VJseP85QLomfymSYeQpOPzCqMxupR8AzRIAZkHJo
         UZ6XlrlOYOn3z2H5QHTzFNNHI0icNuUd5T/lk=
MIME-Version: 1.0
In-Reply-To: <20091207132009.GI18989@one.firstfloor.org>
References: <20091207115949.GA7610@basil.fritz.box>
	 <20091207211216.E95E.A69D9226@jp.fujitsu.com>
	 <20091207132009.GI18989@one.firstfloor.org>
Date: Tue, 8 Dec 2009 02:38:39 +0900
X-Google-Sender-Auth: 5f0883962e7490d1
Message-ID: <2f11576a0912070938s44172cb9mda6b49e997ac1d74@mail.gmail.com>
Subject: Re: NFS lockdep lock misordering mmap_sem<->i_mutex_key with 
	2.6.32-git1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Trond.Myklebust@netapp.com,
       linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc to linux-fsdevel)

2009/12/7 Andi Kleen <andi@firstfloor.org>:
> On Mon, Dec 07, 2009 at 09:19:28PM +0900, KOSAKI Motohiro wrote:
>> >
>> > While booting 2.6.32-git1 on a NFS root box I got the following
>> > lockdep warning early at boot. I haven't looked at details.
>>
>> It seems typical ABBA deadlock.
>>
>>  vfs_readdir                          [grab i_mutex]
>>    nfs_readdir
>>      nfs_do_filldir
>>        filldir
>>          copy_to_user
>>            [page_fault]                       [grab mmap_sem]
>>
>>  sys_mmap                             [grab mmap_sem]
>>    do_mmap_pgoff
>>      mmap_region
>>        nfs_file_mmap
>>          nfs_revalidate_mapping
>>            nfs_invalidate_mapping     [grab i_mutex]
>>
>> I guess recent lockdep improvement find old bug.
>
> Thanks for the analysis.
>
> I guess should never do copy_*_user while holding i_mutex? There might
> be lots of cases like that.
>
> -Andi

I'm not sure exactly vfs rule. but at least mm/rmap.c explained
collect order is i_mutex -> mmap_sem

rmap.c
---------------------------------------------------------------------
 * Lock ordering in mm:
 *
 * inode->i_mutex       (while writing or truncating, not reading or faulting)
 *   inode->i_alloc_sem (vmtruncate_range)
 *   mm->mmap_sem
 *     page->flags PG_locked (lock_page)
 *       mapping->i_mmap_lock
 *         anon_vma->lock
 *           mm->page_table_lock or pte_lock
 *             zone->lru_lock (in mark_page_accessed, isolate_lru_page)
 *             swap_lock (in swap_duplicate, swap_info_get)
 *               mmlist_lock (in mmput, drain_mmlist and others)
 *               mapping->private_lock (in __set_page_dirty_buffers)
 *               inode_lock (in set_page_dirty's __mark_inode_dirty)
 *                 sb_lock (within inode_lock in fs/fs-writeback.c)
 *                 mapping->tree_lock (widely used, in set_page_dirty,
 *                           in arch-dependent flush_dcache_mmap_lock,
 *                           within inode_lock in __sync_single_inode)
-------------------------------------------------------------------------------------------------


Plus, ext4 have following comment. it imply nfs mmap implementaion is wrong...

--------------------------------------------------------------------------------------
int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
{
        struct page *page = vmf->page;
        loff_t size;
        unsigned long len;
        int ret = -EINVAL;
        void *fsdata;
        struct file *file = vma->vm_file;
        struct inode *inode = file->f_path.dentry->d_inode;
        struct address_space *mapping = inode->i_mapping;

        /*
         * Get i_alloc_sem to stop truncates messing with the inode. We cannot
         * get i_mutex because we are already holding mmap_sem.
         */
