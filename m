Return-Path: <linux-kernel-owner+w=401wt.eu-S1758879AbZEMJg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbZEMJg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 05:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbZEMJgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 05:36:48 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54798 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZEMJgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 05:36:47 -0400
Date: Wed, 13 May 2009 11:26:31 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: [PATCH] Physical Memory Management [0/1]
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>
Message-id: <op.utu26hq77p4s8u@amdc030>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.00 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,
 
In the next message a patch which allows allocation of large continuous blocks of physical memory will be sent.  This functionality makes it similar to bigphysarea, however PMM has many more features:
 
1. Each allocated block of memory has a reference counter so different kernel modules may share the same buffer with a well known get/put semantics.
 
2. It aggregates physical memory allocating and management API in one place. This is good because there is a single place to debug and test for all devices. Moreover, because each device does not need to reserve it's own area of physical memory a total size of reserved memory is smaller. Say, we have 3 accelerators. Each of them can operate on 1MiB blocks, so each of them would have to reserve 1MiB for itself (this means total of 3MiB of reserved memory). However, if at most two of those devices can be used at once, we could reserve 2MiB saving 1MiB.
 
3. PMM has it's own allocator which runs in O(log n) bound time where n is total number of areas and free spaces between them -- the upper time limit may be important when working on data sent in real time (for instance an output of a camera).  Currently a best-fit algorithm is used but you can easily replace it if it does not meet your needs. 
 
4. Via a misc char device, the module allows allocation of continuous blocks from user space. Such solution has several advantages. In particular, other option would be to add a allocation calls for each individual devices (think hardware accelerators) -- this would double the same code in several drivers plus it would lead to inconsistent API for doing the very same think. Moreover, when creating pipelines (ie. encoded image --[decoder]--> decoded image --[scaler]--> scaled image) devices would have to develop a method of sharing buffers. With PMM user space program allocates a block and passes it as an output buffer for the first device and input buffer for the other.
 
5. PMM is integrated with System V IPC, so that user space programs may "convert" allocated block into a segment of System V shared memory. This makes it possible to pass PMM buffers to PMM-unaware but SysV-aware applications. Notable example are X11. This makes it possible to deploy a zero-copy scheme when communicating with X11. For instance, image scaled in previous example could be passed directly to X server without the need to copy it to a newly created System V shared memory.
 
6. PMM has a notion of memory types. In attached patch only a general memory type is defined but you can easily add more types for a given platform. To understand what in PMM terms is memory type we can use an example: a general memory may be a main RAM memory which we have a lot but it is quite slow and another type may be a portion of L2 cache configured to act as fast memory. Because PMM may be aware of those, again, allocation of different kinds of memory has a common, consistent API.

As the patch is quite large, it will be attached to the next message. It is also available at <URL:http://home.elka.pw.edu.pl/~mnazarew/pmm.diff>.

-- 
Best regards,                                            _     _
 .o. | Liege of Serenly Enlightened Majesty of         o' \,=./ `o
 ..o | Computer Science,  Michal‚ "mina86" Nazarewicz     (o o)
 ooo +-<m.nazarewicz@samsung.com>-<mina86@jabber.org>-ooO--(_)--Ooo--

