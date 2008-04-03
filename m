Return-Path: <linux-kernel-owner+w=401wt.eu-S1761154AbYDCDeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761154AbYDCDeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 23:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759422AbYDCDd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 23:33:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47326 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759317AbYDCDdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 23:33:55 -0400
Date: Wed, 2 Apr 2008 20:31:20 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Miles Lane <miles.lane@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.25-rc8-mm1 -- BUG buffer_head: Redzone overwritten
In-Reply-To: <47F43B7F.6090505@gmail.com>
Message-ID: <Pine.LNX.4.64.0804022016160.1510@schroedinger.engr.sgi.com>
References: <47F43B7F.6090505@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Miles Lane wrote:

> I hit the Redzone BUG while stress testing. I had several processes
> intensively reading my Windows NTFS partition and other processes reading from
> my ext3 partition.  In addition, I was playing music residing on my NTFS
> partition using Rhythmbox.  Lastly, the BUG occurred when I ran "apt-get
> update". 

Hmmm... It looks like all the object fields of the object were 
overwritten. Maybe one symptom of whatever cause the lock imbalance.

> [   58.512165]  [<f8b7dfd8>] snd_hda_multi_out_analog_open+0xd3/0xef


Could be related to sound driver issue? snd_hda seem to occurt in multiple 
traces.

> [11543.669966]
> =============================================================================
> [11543.669979] BUG buffer_head: Redzone overwritten

Well thats nasty thing....

> [11543.669992] INFO: 0xd62af5d4-0xd62af5d7. First byte 0x5a instead of 0xbb

Was overwrittten with 5a inuse poison instead of red zone inactive. Could 
be that the redone was not initialized.

> [11543.669997] INFO: Allocated in 0x5a5a5a5a age=2783036320 cpu=1515870810
> pid=1515870810
> [11543.670023] INFO: Freed in 0x5a5a5a5a age=2783036320 cpu=1515870810
> pid=1515870810

Bogus info because the metadata of the object was corrupted too.

> [11543.670036] INFO: Slab 0xc14db748 objects=42 used=23 fp=0xd62af5a0
> flags=0x150000c3
> [11543.670041] INFO: Object 0xd62af5a0 @offset=1440 fp=0x5a5a5a5a
> [11543.670044]
> [11543.670048] Bytes b4 0xd62af590:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a ZZZZZZZZZZZZZZZZ
> [11543.670078]   Object 0xd62af5a0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a ZZZZZZZZZZZZZZZZ
> [11543.670108]   Object 0xd62af5b0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a ZZZZZZZZZZZZZZZZ
> [11543.670137]   Object 0xd62af5c0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a ZZZZZZZZZZZZZZZZ
> [11543.670166]   Object 0xd62af5d0:  5a 5a 5a 5a

Looks like a newly allocated object.

> ZZZZ            [11543.670195]  Redzone 0xd62af5d4:  5a 5a 5a 5a
> ZZZZ            [11543.670223]  Padding 0xd62af5fc:  5a 5a 5a 5a


But somehow padding and redzone were never set or overwritten?

> ondemand_readahead+0x11a/0x128
> [11543.670494]  [page_cache_async_readahead+0x53/0x5e]
> page_cache_async_readahead+0x53/0x5e
> [11543.670507]  [fuse:generic_file_aio_read+0x1ef/0x650]
> generic_file_aio_read+0x1ef/0x493
> [11543.670533]  [fuse:do_sync_read+0xbb/0x8c3] do_sync_read+0xbb/0xf9
> [11543.670552]  [<c0130fc5>] ? autoremove_wake_function+0x0/0x30
> [11543.670568]  [snd_hda_intel:_spin_unlock_irqrestore+0x56/0x6c] ?
> _spin_unlock_irqrestore+0x56/0x6c

sound driver going to fuse?


> CONFIG_SLUB_DEBUG_ON=y

Ah. The command line possibility is not used.
