Return-Path: <linux-kernel-owner+w=401wt.eu-S965171AbXBFDGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965171AbXBFDGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 22:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965251AbXBFDGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 22:06:23 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46482 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965171AbXBFDGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 22:06:22 -0500
Date: Mon, 5 Feb 2007 19:06:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20-rc6-mm3 and NTFS: BUG: at arch/i386/mm/highmem.c:52
 kmap_atomic()
Message-Id: <20070205190619.9f8a091a.akpm@linux-foundation.org>
In-Reply-To: <45C7EE27.1020802@shaw.ca>
References: <45C7EE27.1020802@shaw.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Feb 2007 20:55:35 -0600 Robert Hancock <hancockr@shaw.ca> wrote:

> Seeing these BUGs on 2.6.20-rc6-mm3 when mounting an NTFS partition. I 
> saw some reports of something like this on -mm1, was this supposed to be 
> patched already?
> 
> BUG: at arch/i386/mm/highmem.c:52 kmap_atomic()
>   [<c041f810>] kmap_atomic+0xb4/0x1cd
>   [<e0de8276>] ntfs_end_buffer_async_read+0x276/0x2db [ntfs]
>   [<c048f92b>] end_bio_bh_io_sync+0x0/0x39
>   [<c048f959>] end_bio_bh_io_sync+0x2e/0x39
>   [<c049138f>] bio_endio+0x5b/0x63
>   [<c05ffe97>] _spin_lock_irqsave+0x9/0xd
>   [<c042f3f6>] lock_timer_base+0x15/0x2f
>   [<c04d9f03>] __end_that_request_first+0x176/0x421
>   [<e08c45a6>] scsi_delete_timer+0xf/0x50 [scsi_mod]
>   [<e08c6817>] scsi_request_fn+0x2d4/0x324 [scsi_mod]
>   [<e092ee7b>] ata_scsi_qc_complete+0x344/0x354 [libata]
>   [<c04dba71>] __blk_run_queue+0x17/0x35
>   [<e08c5601>] scsi_end_request+0x1a/0xa8 [scsi_mod]
>   [<e08c5826>] scsi_io_completion+0x15a/0x32b [scsi_mod]
>   [<c0409f81>] pit_next_event+0x2b/0x2f
>   [<e08505c9>] sd_rw_intr+0x21b/0x245 [sd_mod]
>   [<e08c13ff>] scsi_finish_command+0x84/0x8b [scsi_mod]
>   [<c04dc19b>] blk_done_softirq+0x49/0x54
>   [<c042b645>] __do_softirq+0x5d/0xba
>   [<c042b6d4>] do_softirq+0x32/0x36
>   [<c042b926>] irq_exit+0x38/0x6b
>   [<c0406eb7>] do_IRQ+0x87/0x9c
>   [<c0405837>] common_interrupt+0x23/0x28
>   [<c043007b>] __dequeue_signal+0x97/0x14e
>   [<c052709f>] acpi_processor_idle+0x209/0x3ca
>   [<c0526e96>] acpi_processor_idle+0x0/0x3ca
>   [<c0403410>] cpu_idle+0xaa/0xd0
>   [<c071ca1f>] start_kernel+0x435/0x43d
>   [<c071c1ae>] unknown_bootoption+0x0/0x202

Yes, that was a real bug.  It got fixed in 2.6.20.

Below is the fix, which I have just uploaded to the hot-fixes directory,
thanks.


--- a/fs/ntfs/aops.c~ntfs-kmap_atomic-atomicity-fix
+++ a/fs/ntfs/aops.c
@@ -92,10 +92,12 @@ static void ntfs_end_buffer_async_read(s
 			ofs = 0;
 			if (file_ofs < init_size)
 				ofs = init_size - file_ofs;
+			local_irq_save(flags);
 			kaddr = kmap_atomic(page, KM_BIO_SRC_IRQ);
 			memset(kaddr + bh_offset(bh) + ofs, 0,
 					bh->b_size - ofs);
 			kunmap_atomic(kaddr, KM_BIO_SRC_IRQ);
+			local_irq_restore(flags);
 			flush_dcache_page(page);
 		}
 	} else {
@@ -143,11 +145,13 @@ static void ntfs_end_buffer_async_read(s
 		recs = PAGE_CACHE_SIZE / rec_size;
 		/* Should have been verified before we got here... */
 		BUG_ON(!recs);
+		local_irq_save(flags);
 		kaddr = kmap_atomic(page, KM_BIO_SRC_IRQ);
 		for (i = 0; i < recs; i++)
 			post_read_mst_fixup((NTFS_RECORD*)(kaddr +
 					i * rec_size), rec_size);
 		kunmap_atomic(kaddr, KM_BIO_SRC_IRQ);
+		local_irq_restore(flags);
 		flush_dcache_page(page);
 		if (likely(page_uptodate && !PageError(page)))
 			SetPageUptodate(page);
_

