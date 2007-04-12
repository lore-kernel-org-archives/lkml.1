Return-Path: <linux-kernel-owner+w=401wt.eu-S1751615AbXDLTP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbXDLTP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 15:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbXDLTP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 15:15:58 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55871 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbXDLTP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 15:15:56 -0400
Date: Thu, 12 Apr 2007 12:15:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cameron Schaus <cam@schaus.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20 OOM with 8Gb RAM
Message-Id: <20070412121553.c7fd3249.akpm@linux-foundation.org>
In-Reply-To: <20070412173830.GA31323@schaus.ca>
References: <20070412173830.GA31323@schaus.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007 11:38:30 -0600
Cameron Schaus <cam@schaus.ca> wrote:

> I am running the latest FC5-i686-smp kernel, 2.6.20, on a machine with
> 8Gb of RAM, and 2 Xeon processors.  The system has a 750Mb ramdisk,
> and one process allocating and deallocating memory that is also
> writing lots of files to the ramdisk.  The process also reads and
> writes from the network.  After the process runs for a while, the
> linux OOM killer starts killing processes, even though there is lots
> of memory available.
> 
> The system does not ordinarily use swap space, but I've added swap to
> see if it makes a difference, but it only defers the problem.
> 
> The OOM dump below shows that memory in the NORMAL_ZONE is exhausted,
> but there is still plenty of memory (6Gb+) in the HighMem Zone.  I can
> provide .config and dmesg data if these would be helpful.
> 
> Why is the OOM killer being invoked when there is still memory
> available for use?
> 
> java invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
> java invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
>  [<c0455f84>] out_of_memory+0x69/0x191
>  [<c0457460>] __alloc_pages+0x220/0x2aa
>  [<c046c80a>] cache_alloc_refill+0x26f/0x468
>  [<c046ca76>] __kmalloc+0x73/0x7d
>  [<c05bb4ce>] __alloc_skb+0x49/0xf7
>  [<c05e483d>] tcp_sendmsg+0x169/0xa04
>  [<c05fd76d>] inet_sendmsg+0x3b/0x45
>  [<c05b57d5>] sock_aio_write+0xf9/0x105
>  [<c0455708>] generic_file_aio_read+0x173/0x1a3
>  [<c046fd11>] do_sync_write+0xc7/0x10a
>  [<c04379fd>] autoremove_wake_function+0x0/0x35
>  [<c05e413e>] tcp_ioctl+0x10a/0x115
>  [<c05e4034>] tcp_ioctl+0x0/0x115
>  [<c05fd406>] inet_ioctl+0x8d/0x91
>  [<c0470564>] vfs_write+0xbc/0x154
>  [<c0470b62>] sys_write+0x41/0x67
>  [<c0403ef6>] sysenter_past_esp+0x5f/0x85

All of ZONE_NORMAL got used by ramdisk, and networking wants to
allocate a page from ZONE_NORMAL.  An oom-killing is the correct
response, although probably not effective.

ramdisk is a nasty thing - cannot you use ramfs or tmpfs?
