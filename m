Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbYGWVMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbYGWVMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 17:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbYGWVMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 17:12:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:28336 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbYGWVMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 17:12:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ieNTU0MubV8vy73z7wAJXOPQQKFzfRrT7cZn6YhKqZcShXEU5ghg8kddEJlFhWR4YQ
         H5iy/5i53Ys6pqRiZpwR2Ubcn4ErxKzBlH8XC0VGw2MKvGK7PIdxjn3U/IdL2hxj0GkK
         PXoXJywZaTE2m8gOTR+EY+AMDXP3dYQCLny+M=
Message-ID: <48f7fe350807231412v1d655caew74a79f3a4d42ea71@mail.gmail.com>
Date: Wed, 23 Jul 2008 17:12:08 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       williams@redhat.com
Subject: Re: [-rt][patches] fix compilation errors
In-Reply-To: <48f7fe350807221641yf06a102x9cd3a4d51841525f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350807201416v55b12dacq99e1922b56f02b37@mail.gmail.com>
	 <48f7fe350807221641yf06a102x9cd3a4d51841525f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is another compile fix:

diff --git a/fs/xfs/linux-2.6/xfs_fs_subr.c b/fs/xfs/linux-2.6/xfs_fs_subr.c
index 1eefe61..097feb0 100644
--- a/fs/xfs/linux-2.6/xfs_fs_subr.c
+++ b/fs/xfs/linux-2.6/xfs_fs_subr.c
@@ -33,7 +33,7 @@ xfs_tosspages(
 {
 	struct address_space *mapping = ip->i_vnode->i_mapping;

-	if (mapping->nrpages)
+	if (mapping_nrpages(mapping))
 		truncate_inode_pages(mapping, first);
 }

@@ -47,7 +47,7 @@ xfs_flushinval_pages(
 	struct address_space *mapping = ip->i_vnode->i_mapping;
 	int		ret = 0;

-	if (mapping->nrpages) {
+	if (mapping_nrpages(mapping)) {
 		xfs_iflags_clear(ip, XFS_ITRUNCATED);
 		ret = filemap_write_and_wait(mapping);
 		if (!ret)
diff --git a/fs/xfs/linux-2.6/xfs_lrw.c b/fs/xfs/linux-2.6/xfs_lrw.c
index 5e3b575..b6b8d39 100644
--- a/fs/xfs/linux-2.6/xfs_lrw.c
+++ b/fs/xfs/linux-2.6/xfs_lrw.c
@@ -242,7 +242,7 @@ xfs_read(
 	}

 	if (unlikely(ioflags & IO_ISDIRECT)) {
-		if (inode->i_mapping->nrpages)
+		if (mapping_nrpages(inode->i_mapping))
 			ret = xfs_flushinval_pages(ip, (*offset & PAGE_CACHE_MASK),
 						    -1, FI_REMAPF_LOCKED);
 		mutex_unlock(&inode->i_mutex);
@@ -654,7 +654,7 @@ start:
 			return XFS_ERROR(-EINVAL);
 		}

-		if (!need_i_mutex && (mapping->nrpages || pos > xip->i_size)) {
+		if (!need_i_mutex && (mapping_nrpages(mapping) || pos > xip->i_size)) {
 			xfs_iunlock(xip, XFS_ILOCK_EXCL|iolock);
 			iolock = XFS_IOLOCK_EXCL;
 			need_i_mutex = 1;
@@ -722,7 +722,7 @@ retry:
 	current->backing_dev_info = mapping->backing_dev_info;

 	if ((ioflags & IO_ISDIRECT)) {
-		if (mapping->nrpages) {
+		if (mapping_nrpages(mapping)) {
 			WARN_ON(need_i_mutex == 0);
 			xfs_inval_cached_trace(xip, pos, -1,
 					(pos & PAGE_CACHE_MASK), -1);


On Tue, Jul 22, 2008 at 7:41 PM, Ryan Hope <rmh3093@gmail.com> wrote:
> Bump to CC Clark Williams...
>
> On Sun, Jul 20, 2008 at 5:16 PM, Ryan Hope <rmh3093@gmail.com> wrote:
>> I had some issues compiling the master branch of the -rt kernel today,
>> the following patches should fix the issues that I encountered:
>>
>> diff --git a/6b92edd2d46e88c69b3979c4f5f55aba974775e8:arch/x86/kernel/io_apic_32.c
>> b/f4b693300667c67b9236454f1076ecdc1c3543aa:arch/x86/kernel/io_apic_32.c
>> index 167ebcbe7a4e96aa1e4140b59972de820465e32a..d3531ee6e0ddcdb6291cc570a500b30cb4c0ca28
>> 100644
>> --- a/6b92edd2d46e88c69b3979c4f5f55aba974775e8:arch/x86/kernel/io_apic_32.c
>> +++ b/f4b693300667c67b9236454f1076ecdc1c3543aa:arch/x86/kernel/io_apic_32.c
>> @@ -1319,7 +1319,7 @@ static void __init setup_IO_APIC_irqs(void)
>>                if (IO_APIC_IRQ(irq)) {
>>                        vector = assign_irq_vector(irq);
>>                        entry.vector = vector;
>> -                       ioapic_register_intr(irq, vector, IOAPIC_AUTO);
>> +                       ioapic_register_intr(irq, vector, IOAPIC_AUTO, apic > 0);
>>
>>                        if (!apic && (irq < 16))
>>                                disable_8259A_irq(irq);
>> @@ -1358,7 +1358,7 @@ static void __init setup_timer_IRQ0_pin(unsigned
>> int apic, unsigned int pin,
>>         * The timer IRQ doesn't have to know that behind the
>>         * scene we may have a 8259A-master in AEOI mode ...
>>         */
>> -       ioapic_register_intr(0, vector, IOAPIC_EDGE);
>> +       ioapic_register_intr(0, vector, IOAPIC_EDGE, apic > 0);
>>
>>        /*
>>         * Add it to the IO-APIC irq-routing table:
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 8ca2763..f80c649 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -2182,7 +2182,7 @@ static int ext4_da_writepages(struct
>> address_space *mapping,
>>         * a transaction for special inodes like journal inode on last iput()
>>         * because that could violate lock ordering on umount
>>         */
>> -       if (!mapping->nrpages)
>> +       if (!mapping_nrpages(mapping))
>>                return 0;
>>
>>        /*
>> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
>> index f8b3be8..9f98f63 100644
>> --- a/fs/jbd2/commit.c
>> +++ b/fs/jbd2/commit.c
>> @@ -197,7 +197,7 @@ static int
>> journal_submit_inode_data_buffers(struct address_space *mapping)
>>        int ret;
>>        struct writeback_control wbc = {
>>                .sync_mode =  WB_SYNC_ALL,
>> -               .nr_to_write = mapping->nrpages * 2,
>> +               .nr_to_write = mapping_nrpages(mapping) * 2,
>>                .range_start = 0,
>>                .range_end = i_size_read(mapping->host),
>>                .for_writepages = 1,
>>
>
