Return-Path: <linux-kernel-owner+w=401wt.eu-S933960AbZHEJg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960AbZHEJg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 05:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933817AbZHEJg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 05:36:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49045 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933009AbZHEJg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 05:36:28 -0400
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <200908051136.682859934@firstfloor.org>
To: akpm@linux-foundation.org, npiggin@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com,
       hidehiro.kawai.ez@hitachi.com
Subject: [PATCH] [0/19] HWPOISON: Intro
Date: Wed,  5 Aug 2009 11:36:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[AK: This is a version with the correct file list
and some fixes.  Please disregard the version I posted yesterday]

New version of the hwpoison patchkit. Various changes.
Believed to address all earlier review comments.

Active error truncate is enabled per file system now, so it adds
a new VFS operation "error_remove_page" for this.
This prevents any truncation on metadata pages, on those
it just does invalidate.

Also various bug fixes, most of them from Fengguang.

Please see the individual patches for changelog.

Should be good to go now.

Passes the hwpoison specific parts of the mce-test test suite
(git://git.kernel.org/pub/scm/utils/cpu/mce/mce-test.git)

Also available as git tree from 
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git hwpoison

Andrew, Please consider for merging.

Thanks,
-Andi

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---

Upcoming Intel CPUs have support for recovering from some memory errors
(``MCA recovery''). This requires the OS to declare a page "poisoned", 
kill the processes associated with it and avoid using it in the future. 

This patchkit implements the necessary infrastructure in the VM.

To quote the overview comment:

 * High level machine check handler. Handles pages reported by the
 * hardware as being corrupted usually due to a 2bit ECC memory or cache
 * failure.
 *
 * This focusses on pages detected as corrupted in the background.
 * When the current CPU tries to consume corruption the currently
 * running process can just be killed directly instead. This implies
 * that if the error cannot be handled for some reason it's safe to
 * just ignore it because no corruption has been consumed yet. Instead
 * when that happens another machine check will happen.
 *
 * Handles page cache pages in various states. The tricky part
 * here is that we can access any page asynchronous to other VM
 * users, because memory failures could happen anytime and anywhere,
 * possibly violating some of their assumptions. This is why this code
 * has to be extremely careful. Generally it tries to use normal locking
 * rules, as in get the standard locks, even if that means the
 * error handling takes potentially a long time.
 *
 * Some of the operations here are somewhat inefficient and have non
 * linear algorithmic complexity, because the data structures have not
 * been optimized for this case. This is in particular the case
 * for the mapping from a vma to a process. Since this case is expected
 * to be rare we hope we can get away with this.

The code consists of a the high level handler in mm/memory-failure.c, 
a new page poison bit and various checks in the VM to handle poisoned
pages.

The main target right now is KVM guests, but it works for all kinds
of applications.

For the KVM use there was need for a new signal type so that
KVM can inject the machine check into the guest with the proper
address. This in theory allows other applications to handle
memory failures too. The expection is that near all applications
won't do that, but some very specialized ones might. 

This is not fully complete yet, in particular there are still ways
to access poison through various ways (crash dump, /proc/kcore etc.)
that need to be plugged too.


-Andi
