Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbZEZLg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbZEZLg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 07:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbZEZLgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 07:36:19 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53330 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980AbZEZLgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 07:36:19 -0400
Date: Tue, 26 May 2009 04:36:18 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: xemul@parallels.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com, mingo@elte.hu,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 14/38] Remove struct mm_struct::exe_file et al
Message-ID: <20090526113618.GJ28083@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't see any mention in the changelog of the point brought up by Ingo:

http://lkml.org/lkml/2009/4/10/105

You also haven't responded to my comment about holding mmap
semaphore:

http://lkml.indiana.edu/hypermail/linux/kernel/0904.1/01417.html

Also, please consider combining with Ingo's point with mine: the mmap
semaphore will be held for the duration of that long VMA walk. Plus
any userspace task can trigger that walk as often as they like via
readlink.

It also appears you haven't responded to Eric and Andrew's suggestion
of a struct path in place of a file reference: 

http://lkml.indiana.edu/hypermail/linux/kernel/0904.1/01698.html

Lastly, please keep me on Cc for future revisions of this patch since
I am interested in following changes to the implementation of
/proc/*/exe.

Thanks,
	-Matt Helsley

----- Forwarded message from Alexey Dobriyan <adobriyan@gmail.com> -----

From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Subject: [PATCH 14/38] Remove struct mm_struct::exe_file et al
Date: Fri, 22 May 2009 08:55:08 +0400
Cc: xemul@parallels.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
        mingo@elte.hu, torvalds@linux-foundation.org,
        Alexey Dobriyan <adobriyan@gmail.com>

Commit 925d1c401fa6cfd0df5d2e37da8981494ccdec07 aka "procfs task exe
symlink".
introduced struct mm_struct::exe_file and struct
mm_struct::num_exe_file_vmas.

The rationale is weak: unifying MMU and no-MMU version of /proc/*/exe
code.
For this a) struct mm_struct becomes bigger, b) mmap/munmap/exit become
slower,
c) patch adds more code than removes in fact.

After commit 8feae13110d60cc6287afabc2887366b0eb226c2 aka
"NOMMU: Make VMAs per MM as for MMU-mode linux" no-MMU kernels also
maintain list of VMAs in ->mmap, so we can switch back for MMU version
of /proc/*/exe.

This also helps C/R, no need to save and restore ->exe_file and to count
additional references to check if there is a leak of struct file outside
group of checkpointed resources.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/exec.c                |    2 -
 fs/proc/base.c           |  105
+++++++++++++---------------------------------
 include/linux/mm.h       |   12 -----
 include/linux/mm_types.h |    6 ---
 include/linux/proc_fs.h  |   20 ---------
 kernel/fork.c            |    3 -
 mm/mmap.c                |   22 ++--------
 mm/nommu.c               |   16 +------
 8 files changed, 36 insertions(+), 150 deletions(-)

