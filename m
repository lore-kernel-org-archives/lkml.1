Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbXCaSYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbXCaSYv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 14:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbXCaSYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 14:24:51 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:52509 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbXCaSYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 14:24:50 -0400
Message-ID: <460EA727.8070306@gmail.com>
Date: Sat, 31 Mar 2007 20:23:35 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
References: <460D7F70.3090702@gmail.com> <20070331064711.GF6246@kernel.dk>
In-Reply-To: <20070331064711.GF6246@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2007 08:47 AM, Jens Axboe wrote:

> Try this.
> 
> diff --git a/drivers/cdrom/mcdx.c b/drivers/cdrom/mcdx.c
> index f574962..7086313 100644
> --- a/drivers/cdrom/mcdx.c
> +++ b/drivers/cdrom/mcdx.c
> @@ -577,6 +577,11 @@ static void do_mcdx_request(request_queue_t * q)
>  	if (!req)
>  		return;
>  
> +	if (!blk_fs_request(req)) {
> +		end_request(req, 0);
> +		goto again;
> +	}
> +
>  	stuffp = req->rq_disk->private_data;
>  
>  	if (!stuffp->present) {
> @@ -596,7 +601,7 @@ static void do_mcdx_request(request_queue_t * q)
>  	xtrace(REQUEST, "do_request() (%lu + %lu)\n",
>  	       req->sector, req->nr_sectors);
>  
> -	if (req->cmd != READ) {
> +	if (rq_data_dir(req) != READ) {
>  		xwarn("do_request(): non-read command to cd!!\n");
>  		xtrace(REQUEST, "end_request(0): write\n");
>  		end_request(req, 0);
> 

Thank you! Yes, that works in so far that it now indeed does actually 
mount the CD:

root@5va2:~# mount -t iso9660 /dev/mcdx0 /mnt/cdrom
mount: block device /dev/mcdx0 is write-protected, mounting read-only
root@5va2:~# ls /mnt/cdrom/
dott  dott.exe	dottdemo  indydemo  rebel  samdemo

There's quite a bit of noise in dmesg though. Repeated 5 times:

===BUG: scheduling while atomic: mount/0x00000001/1166
  [<c1170bff>] __sched_text_start+0x57/0x574
  [<c1171964>] schedule_timeout+0x70/0x8f
  [<c10199b2>] process_timeout+0x0/0x5
  [<c11716a2>] interruptible_sleep_on_timeout+0x5d/0xa5
  [<c100e695>] default_wake_function+0x0/0xc
  [<c482b8fb>] mcdx_xfer+0xae/0x2a5 [mcdx]
  [<c109bc78>] cfq_init_prio_data+0x57/0x12a
  [<c109bef2>] cfq_get_queue+0x119/0x16e
  [<c109c73b>] cfq_set_request+0x0/0x131
  [<c1094f29>] elv_set_request+0x14/0x22
  [<c10948c7>] elv_rb_del+0x23/0x31
  [<c109b186>] cfq_remove_request+0x63/0xd9
  [<c1094911>] elv_dispatch_sort+0x1c/0x67
  [<c109b63c>] cfq_dispatch_insert+0x38/0x4c
  [<c109b726>] __cfq_dispatch_requests+0x72/0x1ad
  [<c109b95f>] cfq_dispatch_requests+0x50/0x77
  [<c10622eb>] sync_buffer+0x0/0x2e
  [<c1094de9>] elv_next_request+0x5d/0x105
  [<c10622eb>] sync_buffer+0x0/0x2e
  [<c482b473>] do_mcdx_request+0x9b/0xd2 [mcdx]
  [<c1096d06>] __generic_unplug_device+0x1d/0x1f
  [<c1096d19>] generic_unplug_device+0x11/0x29
  [<c1096d3d>] blk_backing_dev_unplug+0xc/0xd
  [<c1062311>] sync_buffer+0x26/0x2e
  [<c11719d3>] __wait_on_bit+0x2c/0x51
  [<c1171a67>] out_of_line_wait_on_bit+0x6f/0x77
  [<c10622eb>] sync_buffer+0x0/0x2e
  [<c102218c>] wake_bit_function+0x0/0x3c
  [<c102218c>] wake_bit_function+0x0/0x3c
  [<c1062371>] __wait_on_buffer+0x22/0x25
  [<c10631c1>] __bread_slow+0x4b/0x60
  [<c10633ad>] __bread+0x18/0x1d
  [<c486f9cf>] isofs_fill_super+0xf0/0x5d7 [isofs]
  [<c10a016d>] radix_tree_delete+0x177/0x1a0
  [<c104971f>] get_sb_bdev+0xc6/0x10f
  [<c1059af0>] mntput_no_expire+0x11/0x73
  [<c10596bf>] alloc_vfsmnt+0x97/0xbe
  [<c4870863>] isofs_get_sb+0x20/0x25 [isofs]
  [<c486f8df>] isofs_fill_super+0x0/0x5d7 [isofs]
  [<c10498ea>] vfs_kern_mount+0x40/0x6f
  [<c1049943>] do_kern_mount+0x2a/0x3a
  [<c105a8e0>] do_new_mount+0x64/0x93
  [<c105af29>] do_mount+0x185/0x19a
  [<c100e75c>] __wake_up_locked+0x1e/0x20
  [<c100e695>] default_wake_function+0x0/0xc
  [<c105b1c4>] sys_mount+0x79/0xb5
  [<c1002830>] syscall_call+0x7/0xb
===

Any access results in te above. A copy from the CD segfaulted:

===
root@5va2:~# cp /mnt/cdrom/dott.exe .

malloc: unwind_prot.c:247: assertion botched
free: called with unallocated block argument
Segmentation fault
===

This sounds like a userspace problem but I sure haven't seen it before. 
There's a few "blk: request botched" followed by similar backtraces in 
the log after that.

It looks like mcdx_xfer() is seriously broken. If you don't particularly 
care for spending time on this thing -- feel free. To top it off, if you 
unload the module, it doesn't clean up after itself and the IRQ is kept 
in use (and a cat /proc/interrupts faults).

I'm only using the thing for the heck of it...

Rene.

