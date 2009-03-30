Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbZC3OtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbZC3OtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 10:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbZC3OtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 10:49:05 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:50182 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbZC3OtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 10:49:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=BGFP8YD3v3ZK7FLj7vpK2+LOvTorC0/OLG3fnNdC72brVFFVJjO85RjuN1SYHr+9rA
         4xylA7MnXuDd4oA3TT/Zf5S4pPWxxsvPeP6gSkciqGs8RP/kHdFxDV95RNPFa5e4Naaj
         eLaQcsmjsoqZtMzmrb4zcABMIgZe0z2Jr7USk=
Message-ID: <49D0DBA2.20101@vflare.org>
Date: Mon, 30 Mar 2009 20:18:02 +0530
From: Nitin Gupta <nitingupta910@gmail.com>
Reply-To: ngupta@vflare.org
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>, Ed Tomlinson <edt@aei.ca>,
       linux-mm-cc@laptop.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] compressed in-memory swapping take5
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Project home: http://compcache.googlecode.com

It allows creating a RAM based block device which acts as swap disk.
Pages swapped to this device are compressed and stored in memory itself.
This is a big win over swapping to slow hard-disk which are typically used
as swap disk. For flash, these suffer from wear-leveling issues when used
as swap disk - so again its helpful. For swapless systems, it allows more
apps to run.

* Changelog: take5 vs take4
xvmalloc changes:
  - Use kzalloc() instead of kmalloc() + memset().
  - Remove redundant initialization of pool freelists to 0.

* Changelog: take4 vs take3
xvmalloc changes:
  - Fixed regression in take3 that caused ramzswap write failures.
    This happened due to error in find_block() where we did not do
    explicit cast to 'unsigned long' when checking for bits set in
    bitmap. Now changed it to use kernel build-in test_bit().
  - Fix divide by zero error in proc read function.
ramzswap changes:
  - Forward write requests to backing swap device if allocation for
    compressed page fails.
  - Code cleanups.

* Changelog: take3 vs take2
xvmalloc changes:
  - Use kernel defined macros and constants in xvmalloc and remove
    equivalent defines for ALIGN, roundup etc.
  - Use kernel bitops (set_bit, clear_bit)
  - Moved it to drivers/block since its not clear if it has any other
    user.
ramzswap changes:
  - All instances of compcache renamed to ramzswap.
    Also renamed module to ramzswap
  - Renamed "backing_dev" parameter to "backing_swap"
  - Documentation changes to reflect above changes.
  - Remove "table index" from object header (4 bytes). This will be
    needed when memory defragmentation is implemented. So, avoid this
    (small) overhead for now.

* Changelog: take2 vs initial revision:
xvmalloc changes:
  - Use Linux kernel coding style for xvmalloc
  - Collapse all individual flag test/set/get to generic {test_set_get}_flag
  - Added BLOCK_NEXT() macro to reach next contiguous block
  - Other minor cleanups - no functional changes
compcache block device code:
  - compcache core changes due to change in xvmalloc interface names

* Testing notes:
  - Multiple cycles of 'scan' benchmark available at:
http://linux-mm.org/PageReplacementTesting
It does scans of anonymous mapped memory, both cyclic and use once.

Config:
Arch: x86 and x64
CPUs: 1/2, RAM: 512MB
backing swap: 768MB, ramzswap memlimit: 76MB (15% of RAM).

Continuously run 'scan' till it triggers 200K R/W operations on ramzswap.
Any incompressible pages were correctly forwarded to backing swap device.
cmd: ./scan 450 20 # scan over 450MB, 20 times.

  - Links to more performance numbers, use cases can be found at:
http://lkml.org/lkml/2009/3/17/116

Thanks to Ed Tomlinson for reporting bug in 'take3' patches
and to all the reviewers.

Thanks,
Nitin

