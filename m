Return-Path: <linux-kernel-owner+w=401wt.eu-S1759283AbZEKTio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283AbZEKTio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755444AbZEKTid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:38:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:43196 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601AbZEKTic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:38:32 -0400
Message-ID: <4A087E4E.5040906@kernel.org>
Date: Mon, 11 May 2009 12:36:46 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jack Steiner <steiner@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] x86: fix node_possible_map logic -v2
References: <4A05269D.8000701@kernel.org> <4A0527CB.4020807@kernel.org> <20090511175312.GA27905@sgi.com> <4A087955.7040505@kernel.org>
In-Reply-To: <4A087955.7040505@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Jack Steiner wrote:
>> On Fri, May 08, 2009 at 11:50:51PM -0700, Yinghai Lu wrote:
>>> recently there are some changes to about meaning of node_possible_map
>>>
>>> and it is some strange:
>>> the node without memory would be set in node_possible_map
>>> but some node with less NODE_MIN_SIZE will be kicked out of node_possible_map.
>>>
>>> try to fix it by adding strict_setup_node_bootmem.
>>> also remove unparse_node.
>> I still see the same panic. Entry 0 of the node_data array is NULL &
>> it is dereferenced building the zonelists.
>>
>> I'm sure that you are way ahead of me in diagnosing this problem but
>> this is a regression from previous behavior. Fpor example, in 2.6.27, node_data
>> is created for both nodes but node 0 contains no memory:
>>
>> 	(2.7.27)
>> 	<6>SRAT: PXM 0 -> APIC 0 -> Node 0
>> 	<6>SRAT: PXM 1 -> APIC 128 -> Node 1
>> 	<6>SRAT: Node 1 PXM 1 0-fff6c000
>> 	<7>NUMA: Using 63 for the hash shift.
>> 	<6>Bootmem setup node 0 0000000000000000-0000000000000000
>> 	<3>Cannot find 212992 bytes in node 0
>> 	<6>Bootmem setup node 1 0000000000000000-0000000010000000
>> 	<6>  NODE_DATA [000000000139be80 - 00000000013cfe7f]
>> 	<6>  bootmap [00000000013d0000 -  00000000013d1fff] pages 2
>> 	<6>(7 early reservations) ==> bootmem [0000000000 - 0010000000]
>> 	<6>  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
>> 	<6>  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
>> 	<6>  #2 [0000200000 - 000139be38]    TEXT DATA BSS ==> [0000200000 - 000139be38]
>> 	<6>  #3 [000009f000 - 00000e0900]    BIOS reserved ==> [000009f000 - 00000e0900]
>> 	<6>  #4 [00000e0a68 - 0000100000]    BIOS reserved ==> [00000e0a68 - 0000100000]
>> 	<6>  #5 [00000e0900 - 00000e0a68]       EFI memmap ==> [00000e0900 - 00000e0a68]
>> 	<6>  #6 [0000001000 - 0000001030]        ACPI SLIT ==> [0000001000 - 0000001030]
>> 	<6>Bootmem setup node 0 0000000000000000-0000000000000000
>> 	<6>  NODE_DATA [00000000013d2000 - 0000000001405fff]
>> 	<6>  bootmap [0000000000000000 -  ffffffffffffffff] pages 0
>> 	<6>(7 early reservations) ==> bootmem [0000000000 - 0000000000]
>> 	<6>  #0 [0000000000 - 0000001000]   BIOS data page
>> 	<6>  #1 [0000006000 - 0000008000]       TRAMPOLINE
>> 	<6>  #2 [0000200000 - 000139be38]    TEXT DATA BSS
>> 	<6>  #3 [000009f000 - 00000e0900]    BIOS reserved
>> 	<6>  #4 [00000e0a68 - 0000100000]    BIOS reserved
>> 	<6>  #5 [00000e0900 - 00000e0a68]       EFI memmap
>> 	<6>  #6 [0000001000 - 0000001030]        ACPI SLIT
>> 	<6>    NODE_DATA(0) on node 1
>> 	<6>    bootmap(0) on node 1
>> 	<7> [ffffe20000000000-ffffe200003fffff] PMD -> [ffff880001600000-ffff8800019fffff] on node 1
>> 	<4>Zone PFN ranges:
>> 	<4>  DMA      0x00000000 -> 0x00001000
>> 	<4>  DMA32    0x00001000 -> 0x00100000
>> 	<4>  Normal   0x00100000 -> 0x00100000
>> 	<4>Movable zone start PFN for each node
>> 	<4>early_node_map[2] active PFN ranges
>> 	<4>    1: 0x00000000 -> 0x00000006
>> 	<4>    1: 0x00000200 -> 0x00010000
>> 	<4>Could not find start_pfn for node 0
>> 	<7>On node 0 totalpages: 0
>> 	<7>On node 1 totalpages: 65030
>> 	<7>  DMA zone: 3427 pages, LIFO batch:0
>> 	<7>  DMA32 zone: 60480 pages, LIFO batch:15
>>
>> I have not seen any problems running on 2.6.27 using nodes that have no memory.
>>
>>
>> Do we have a clear and unambiguous definition of what a node really is?
>> In this case, is a board (socket) with cpus, a unique PXM but no memory
>> considered a node. Even though it has no memory, it is a node (depending on the
>> definition of "node") for purposes such as scheduling. The memoryless node also
>> has local IO buses that want to direct interrupts to node-local cpus.
>>
> 
> how about 2.6.28, 29, and current linus tree?
> 
> we should not have NODE_DATA to node that doesn't have memory.
> 

also later if memory is hot add to that node, it will get NODE_DATA on the node later.

YH
