Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbYLNJqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbYLNJqU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 04:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYLNJqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 04:46:09 -0500
Received: from smtp03.uc3m.es ([163.117.176.133]:35312 "EHLO smtp03.uc3m.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbYLNJqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 04:46:07 -0500
X-Greylist: delayed 695 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Dec 2008 04:46:06 EST
From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Message-Id: <200812140934.mBE9YNl06208@inv.it.uc3m.es>
Subject: zero copy copy to device -- help
To: "linux kernel" <linux-kernel@vger.kernel.org>
Date: Sun, 14 Dec 2008 10:34:23 +0100 (MET)
X-Anonymously-To: 
Reply-To: ptb@inv.it.uc3m.es
X-message-flag: Had your Outlook virus, today?  
	http://www.counterpane.com/crypto-gram-0103.html#4
X-WebTV-Stationery: Standard\; BGColor=black\; TextColor=black
Reply-By: Sat, 1 Apr 2006 14:21:08 -0700
X-Mailer: ELM [version 2.4ME+ PL66 (25)]
X-imss-version: 2.051
X-imss-result: Passed
X-imss-scanInfo: M:B L:N SM:2
X-imss-tmaseResult: TT:1 TS:-6.4353 TC:1F TRN:62 TV:5.5.1026(16338.006)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm looking for some help getting a zero-copy idea to work. It almost does.

My device responds to a read request by asking a userspace daemon for
the data, which then goes and gets it from the net.  This is a very
generic mechanism.

The zero-copy idea is to let the driver mmap the kernel request buffers
themselves to the (contiguous) area of the device that the request talks
about, all within the address space of the userspace daemon.  Then 
the daemon uses that address for the network read buffer space.  Zooooom.

Here's a diagram of what happens:

 * net--->[daemon]             [user]--->
 *          |                    A
 *          | write         read |
 *          V                    |
 *        ----- kernel---------------
 *          |                    A
 *          V                    |
 *         [vmap]<========>[buffers]

This cuts out one or two copies. It used to be that the daemon
saved the network data to its own area (mmapped or not ..) and
then a copy_from_user within an ioctl to the driver copied the data
to the kernel request buffers. In other words, things were like this:

 * net--->[daemon]             [user]--->
 *          V write              A
 *         [buf]            read |
 *          V ioctl              |
 *        ----- kernel---------------
 *          |                    A
 *          V                    |
 *          `--cp_f_u------>[buffers]


The zero-copy trick works ..  provided the device has been written to
first.  If this is the first read or write on the device, there's a
hang.  It looks to be an attempt by the kernel to sync the mmapped pages
first, which means reading data into them, which means running the
device driver read, which causes the sync ...  or something very like
that.

Heeeeeeeeeelp!  How do I stoppppppp such viciousness?

When I get the userspace daemon to just try a write into the mmapped
pages after receiving the mmap address OK, the hang happens. So it does
not involve the net. Here is the hang:

 * [12395.076026] Call Trace:
 * [12395.076122]  [<c036345b>] io_schedule+0x1b/0x30
 * [12395.076201]  [<c016a2c1>] sync_page+0x41/0x50
 * [12395.076277]  [<c03636ff>] __wait_on_bit_lock+0x3f/0x70
 * [12395.076355]  [<c016a280>] sync_page+0x0/0x50
 * [12395.077472]  [<c016abda>] __lock_page+0x9a/0xb0
 * [12395.077562]  [<c0141fb0>] wake_bit_function+0x0/0x60
 * [12395.077657]  [<c0141fb0>] wake_bit_function+0x0/0x60
 * [12395.077752]  [<c017c2db>] __do_fault+0x37b/0x3e0
 * [12395.077831]  [<c0122af1>] kunmap_atomic+0x91/0xd0
 * [12395.077907]  [<c0122a9f>] kunmap_atomic+0x3f/0xd0
 * [12395.078031]  [<c017c823>] handle_mm_fault+0x253/0x300
 * [12395.078127]  [<c017a494>] follow_page+0x114/0x1a0
 * [12395.078222]  [<c017a61f>] get_user_pages+0xff/0x2c0
 * [12395.078322]  [<c017c948>] make_pages_present+0x78/0xa0
 * [12395.078418]  [<c017ea6d>] mmap_region+0x40d/0x440
 * [12395.078547]  [<c017e443>] do_mmap_pgoff+0x1f3/0x390
 * [12395.078653]  [<c0109113>] sys_mmap2+0x73/0xa0
 * [12395.078747]  [<c0104462>] sysenter_past_esp+0x6b/0xa1


It's in VM stuff. The mmap address it received didn't have any actual
pages in and they're being faulted in by the nopage mechanism. The
driver supplies the pages one by one, looking in the request it
receives for them. I see the handle_mm_fault, and the driver
says it handled it OK and returned a page address.

The driver's response to a mmap call is just a shell:

   int mmap(struct fike *file, struct vm_area_struct *vma) {
     if (vma_offset_in_disk >= __pa(high_memory) || (file->f_flags &  O_SYNC))
             vma->vm_flags |= VM_IO; // don't core dump this area
             vma->vm_flags |= VM_RESERVED | VM_MAYREAD | VM_MAYWRITE;
     vma->vm_ops = ...;
     bdev = ...;
     lock_kernel();
     bdev->bd_openers++;
     unlock_kernel();
     return 0;
   }

And the nopage method inserted into the vm_ops struct is the real worker:

   struct page * nopage(struct vm_area_struct * vma, unsigned long addr, int *type) {
      .. search through requests pending for req covering page ..
      .. search through req bios for a bio segment covering page ..
         page = bvec->bv_page;
         get_page(page);
         goto got_page;
      ..
      got_no_page:
         if (type)
             *type = VM_FAULT_MAJOR;
         return NOPAGE_SIGBUS;
      got_page:
         if (type)
             *type = VM_FAULT_MINOR;
         return page;
   }

What magic vm flags need setting on the kernel request read buffers to
allow them to be double-used in this way? I'd be extremely grateful
for a clue!

And yes, this is part of a general mechanism for doing zero-copy
to/from any device.

Regards to all

Peter Breuer
