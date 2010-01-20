Return-Path: <linux-kernel-owner+w=401wt.eu-S1752555Ab0ATR4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab0ATR4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 12:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258Ab0ATR4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 12:56:22 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:32840 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab0ATR4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 12:56:21 -0500
Message-ID: <4B574297.7070504@nortel.com>
Date: Wed, 20 Jan 2010 11:51:19 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: issues with kmemleak backport
References: <4B55F3EF.9020408@nortel.com> <4B561D8D.1000003@nortel.com>
In-Reply-To: <4B561D8D.1000003@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jan 2010 17:56:06.0429 (UTC) FILETIME=[D6DE74D0:01CA99F9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the previous message I commented out the per-cpu scan but now I'm
seeing the following:


root@10:/root> BUG: unable to handle kernel paging request at 8152a79c
IP: [<c048ad52>] scan_block+0xd2/0x120
Kcore timestamp : 1263971633.595000
Kcore HighResolution timestamp : 238BAE499D2
Oops: 0000 [#1] SMP
Modules linked in: kmemleak_test pmemfs

Pid: 889, comm: bash Not tainted (2.6.27-pne #32)
EIP: 0060:[<c048ad52>] EFLAGS: 00010082 CPU: 2
EIP is at scan_block+0xd2/0x120
EAX: 00000000 EBX: 8152a79c ECX: 00000000 EDX: 8e7d441b
ESI: 8152a79c EDI: 8152a79d EBP: de893ea8 ESP: de893e8c
 DS: 0068 ES: 0068 FS: 00d8 GS: 0033 SS: 0068
Process bash (pid: 889, ti=de892000 task=df947200 task.ti=de892000)
Stack: c08a758d 8152a79c 8152a7a0 df9889a0 8152b79c 00000246 df9889a0
de893ed0
       c048aee8 00000000 8152a79c 8152a7a0 8152a7a0 8152a79c df947200
c0919220
       00020000 de893f00 c048b074 00000000 00000000 00000202 00000001
df940068
Call Trace:
 [<c048aee8>] ? scan_gray_list+0x148/0x190
 [<c048b074>] ? kmemleak_scan+0x144/0x390
 [<c048b5aa>] ? kmemleak_write+0x1aa/0x2e0
 [<c048a62b>] ? put_object+0x2b/0x40
 [<c048e40c>] ? vfs_write+0x9c/0x140
 [<c048b400>] ? kmemleak_write+0x0/0x2e0
 [<c048e5c3>] ? sys_write+0x43/0xb0
 [<c0403541>] ? system_call_done+0x0/0x4


The code is failing at the "pointer = *ptr;" line in scan_block().

Based on some added instrumentation, we're scanning an object from from
8152a79c to 8152a7a0, which in turn is scanning a block from 8152a79c to
8152a7a0, so this is the first address in the block.

The odd thing is that as far as I can tell this should be a valid
address.  This is a 32-bit x86 kernel, with CONFIG_FLATMEM=y, and the
memory map is:

virtual kernel memory layout:
    fixmap  : 0xfff81000 - 0xfffff000   ( 504 kB)
    pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
    vmalloc : 0xe0800000 - 0xff9fe000   ( 497 MB)
    lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
      .init : 0xc0106000 - 0xc0400000   (3048 kB)
      .data : 0xc0919000 - 0xc095634c   ( 244 kB)
      .text : 0xc0400000 - 0xc081bcdc   (4207 kB)


If anyone has any suggestions, I'd appreciate it.

Thanks,
Chris

