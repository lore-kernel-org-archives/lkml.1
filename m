Return-Path: <linux-kernel-owner+w=401wt.eu-S1751865AbZGVFIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbZGVFIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 01:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZGVFIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 01:08:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57575 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbZGVFIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 01:08:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 22 Jul 2009 14:06:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 0/4] kcore: cleanup and fix bahavior to find physcal memory
 range v2
Message-Id: <20090722140613.0a751811.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sorry I can't find who should be in CC.

This includes some amounts changes to arch-specici code, 
but very special codes for kcore. Can I test this in -mm if no objections ?

Now, /proc/kcore 's physical memory information is set up at boot
via kclist_add(). But it's not updated at memory hotplug etc and
it can include much memory holes. This patch is for generatinc /proc/kcore
based on memory management information maintained by the kernel.

 For usual archs, /proc/iomem is used
 For ppc, lmb information will be used.

This is v2. bugs/bahavior is fixed. Below is output of
"readelf -l /proc/kcore" before/after the patch. (on my vm host..)


=====[Before]======
Elf file type is CORE (Core file)
Entry point 0x0
There are 6 program headers, starting at offset 64

Program Headers:
  Type           Offset             VirtAddr           PhysAddr
                 FileSiz            MemSiz              Flags  Align
  NOTE           0x0000000000000190 0x0000000000000000 0x0000000000000000
                 0x00000000000021a4 0x0000000000000000         0
  LOAD           0x00007fffff603000 0xffffffffff600000 0x0000000000000000
                 0x0000000000800000 0x0000000000800000  RWE    1000
  LOAD           0x00007fffa0003000 0xffffffffa0000000 0x0000000000000000
                 0x000000005f000000 0x000000005f000000  RWE    1000
  LOAD           0x00007fff8100c000 0xffffffff81009000 0x0000000000000000
                 0x000000000111a000 0x000000000111a000  RWE    1000
  LOAD           0x0000490000003000 0xffffc90000000000 0x0000000000000000
                 0x00001fffffffffff 0x00001fffffffffff  RWE    1000
  LOAD           0x0000080000003000 0xffff880000000000 0x0000000000000000
                 0x0000000065400000 0x0000000065400000  RWE    1000

====[After]=====


Elf file type is CORE (Core file)
Entry point 0x0
There are 8 program headers, starting at offset 64

Program Headers:
  Type           Offset             VirtAddr           PhysAddr
                 FileSiz            MemSiz              Flags  Align
  NOTE           0x0000000000000200 0x0000000000000000 0x0000000000000000
                 0x00000000000021a4 0x0000000000000000         0
  LOAD           0x0000080065303000 0xffff880065300000 0x0000000000000000
                 0x0000000000100000 0x0000000000100000  RWE    1000
  LOAD           0x0000080000103000 0xffff880000100000 0x0000000000000000
                 0x00000000651f0000 0x00000000651f0000  RWE    1000
  LOAD           0x0000080000013000 0xffff880000010000 0x0000000000000000
                 0x000000000008f000 0x000000000008f000  RWE    1000
  LOAD           0x0000490000003000 0xffffc90000000000 0x0000000000000000
                 0x00001fffffffffff 0x00001fffffffffff  RWE    1000
  LOAD           0x00007fff8100c000 0xffffffff81009000 0x0000000000000000
                 0x000000000111a000 0x000000000111a000  RWE    1000
  LOAD           0x00007fffa0003000 0xffffffffa0000000 0x0000000000000000
                 0x000000005f000000 0x000000005f000000  RWE    1000
  LOAD           0x00007fffff603000 0xffffffffff600000 0x0000000000000000
                 0x0000000000800000 0x0000000000800000  RWE    1000



You can see the section

    LOAD         0x0000080000003000 0xffff880000000000 0x0000000000000000
                 0x0000000065400000 0x0000000065400000  RWE    1000
is divided into

  LOAD           0x0000080065303000 0xffff880065300000 0x0000000000000000
                 0x0000000000100000 0x0000000000100000  RWE    1000
  LOAD           0x0000080000103000 0xffff880000100000 0x0000000000000000
                 0x00000000651f0000 0x00000000651f0000  RWE    1000
  LOAD           0x0000080000013000 0xffff880000010000 0x0000000000000000
                 0x000000000008f000 0x000000000008f000  RWE    1000

This is on physical memory information.

And yes, this host's memory map is following. 
(This is same to /proc/iomem, of course)
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000652f0
[    0.000000]     0: 0x00065300 -> 0x00065400


Thanks,
-Kame

