Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbZHUTjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbZHUTjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 15:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755752AbZHUTja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 15:39:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755743AbZHUTj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 15:39:29 -0400
Subject: Re: [tip:tracing/urgent] tracing: Fix too large stack usage in
 do_one_initcall()
From: Steven Rostedt <srostedt@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-tip-commits@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       Kyle McMartin <kyle@mcmartin.ca>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, catalin.marinas@arm.com,
       a.p.zijlstra@chello.nl, jens.axboe@oracle.com, fweisbec@gmail.com,
       stable@kernel.org, tglx@linutronix.de
In-Reply-To: <20090821191759.GA8607@elte.hu>
References: <tip-4a683bf94b8a10e2bb0da07aec3ac0a55e5de61f@git.kernel.org>
	 <20090821111450.GA32037@elte.hu>
	 <20090821104820.60948082.akpm@linux-foundation.org>
	 <20090821191759.GA8607@elte.hu>
Content-Type: text/plain
Organization: Red Hat
Date: Fri, 21 Aug 2009 15:37:01 -0400
Message-Id: <1250883421.2964.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-21 at 21:17 +0200, Ingo Molnar wrote:
> 
> we do have an ftrace plugin for it, yes. But it has high cost (it 
> traces all the time to find the maximum), so i'm not sure how 
> realistic it would be to integrate it into the kerneloops daemon for 
> example.
> 
> It could certainly be done - a sufficiently enabled kernel has to be 
> built (perhaps a kernel-debug package) and the 
> /debug/tracing/max_stack_trace value can be monitored for 'too much' 
> values.

Since it uses the function tracer infrastructure, it only has high
overhead when enabled (if the dynamic ftrace is also enabled). But if
the kernel needs to be running with it enabled all the time it may be an
issue. But if someone is seeing problems with the stack, it would be
beneficial to have them enable it.

I recommend that CONFIG_STACK_TRACER to be enabled on all builds.
Because of the nops by the function tracer, it adds no overhead for
being configured in. Only when enabled and running does it add the extra
overhead.

Fedora 11 has it already enabled:

[rostedt@redhat ~]$ uname -r
2.6.29.5-191.fc11.x86_64
[rostedt@redhat ~]$ ls /debug/tracing/stack_trace 
/debug/tracing/stack_trace

Unforturnately, that kernel did not have the text to show how to enable
it:

[rostedt@redhat ~]$ cat /debug/tracing/stack_trace
        Depth   Size      Location    (0 entries)
        -----   ----      --------
[rostedt@redhat ~]$ 


But it still works when one knows how:

[root@redhat rostedt]# echo 1 > /proc/sys/kernel/stack_tracer_enabled 
[root@redhat rostedt]# cat /debug/tracing/stack_trace 
        Depth   Size      Location    (44 entries)
        -----   ----      --------
  0)     3072      48   enqueue_entity+0xe6/0x1b8
  1)     3024      32   enqueue_task_fair+0x2a/0x6d
  2)     2992      32   enqueue_task+0x51/0x5c
  3)     2960      32   activate_task+0x2d/0x35
  4)     2928      96   try_to_wake_up+0x1d3/0x26d
  5)     2832      16   default_wake_function+0x12/0x14
  6)     2816      32   autoremove_wake_function+0x16/0x39
  7)     2784      80   __wake_up_common+0x4e/0x84
  8)     2704      64   __wake_up+0x39/0x4d
  9)     2640      32   insert_work+0x51/0x55
 10)     2608      48   __queue_work+0x2f/0x42
 11)     2560      16   queue_work_on+0x44/0x4b
 12)     2544      16   queue_work+0x1f/0x21
 13)     2528      16   queue_delayed_work+0x13/0x28
 14)     2512      32   ata_pio_queue_task+0x35/0x39
 15)     2480      32   ata_sff_qc_issue+0x1f1/0x22e
 16)     2448      48   ata_qc_issue+0x222/0x25a
 17)     2400      80   __ata_scsi_queuecmd+0x193/0x1ef
 18)     2320      64   ata_scsi_queuecmd+0x5b/0x93
 19)     2256      48   scsi_dispatch_cmd+0x1a9/0x22b
 20)     2208      96   scsi_request_fn+0x46a/0x496
 21)     2112      32   __generic_unplug_device+0x32/0x37
 22)     2080      48   blk_execute_rq_nowait+0x84/0xb5
 23)     2032     160   blk_execute_rq+0x85/0xa7
 24)     1872      80   scsi_execute+0xf6/0x148
 25)     1792     128   scsi_execute_req+0x87/0xb9
 26)     1664      96   sr_test_unit_ready+0x65/0xcb
 27)     1568     144   sr_media_change+0x4f/0x247
 28)     1424      48   media_changed+0x54/0x8c
 29)     1376      16   cdrom_media_changed+0x31/0x37
 30)     1360      16   sr_block_media_changed+0x19/0x1b
 31)     1344      32   check_disk_change+0x29/0x5b
 32)     1312     448   cdrom_open+0x889/0x902
 33)      864      64   sr_block_open+0x90/0xad
 34)      800     112   __blkdev_get+0x26c/0x359
 35)      688      16   blkdev_get+0x10/0x12
 36)      672      48   blkdev_open+0x76/0xac
 37)      624      80   __dentry_open+0x143/0x273
 38)      544      32   nameidata_to_filp+0x42/0x53
 39)      512     304   do_filp_open+0x3fd/0x7b8
 40)      208      64   do_sys_open+0x59/0xda
 41)      144      16   sys_open+0x20/0x22
 42)      128     128   system_call_fastpath+0x16/0x1b

-- Steve


