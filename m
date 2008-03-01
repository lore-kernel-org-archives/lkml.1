Return-Path: <linux-kernel-owner+w=401wt.eu-S1758070AbYCAS5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbYCAS5Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 13:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbYCAS5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 13:57:13 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60316 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbYCAS5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 13:57:10 -0500
Date: Sat, 1 Mar 2008 10:56:46 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
To: mingo@elte.hu, torvalds@linux-foundation.org, hans.rosenfeld@amd.com
Cc: linux-kernel@vger.kernel.org
Subject: bisected boot regression post 2.6.25-rc3.. please revert
Message-ID: <20080301105646.2c8620d9@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, Ingo, Hans,

Please revert commit cded932b75ab0a5f9181ee3da34a0a488d1a14fd
( x86: fix pmd_bad and pud_bad to support huge pages )
since it prevents the kernel to finish booting on my (Penryn based)
laptop. The boot stops right after freeing the init memory.
Took a while to bisect (due to it touching page*.h, which forces a
full recompile), but it definitely is caused by this commit...

Please revert.



[arjan@localhost linux.trees.git]$ git-bisect good
cded932b75ab0a5f9181ee3da34a0a488d1a14fd is first bad commit
commit cded932b75ab0a5f9181ee3da34a0a488d1a14fd
Author: Hans Rosenfeld <hans.rosenfeld@amd.com>
Date:   Mon Feb 18 18:10:47 2008 +0100

    x86: fix pmd_bad and pud_bad to support huge pages
    
    I recently stumbled upon a problem in the support for huge pages. If a
    program using huge pages does not explicitly unmap them, they remain
    mapped (and therefore, are lost) after the program exits.
    
    I observed that the free huge page count in /proc/meminfo decreased when
    running my program, and it did not increase after the program exited.
    After running the program a few times, no more huge pages could be
    allocated.
    
    The reason for this seems to be that the x86 pmd_bad and pud_bad
    consider pmd/pud entries having the PSE bit set invalid. I think there
    is nothing wrong with this bit being set, it just indicates that the
    lowest level of translation has been reached. This bit has to be (and
    is) checked after the basic validity of the entry has been checked, like
    in this fragment from follow_page() in mm/memory.c:
    
      if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
              goto no_page_table;
    
      if (pmd_huge(*pmd)) {
              BUG_ON(flags & FOLL_GET);
              page = follow_huge_pmd(mm, address, pmd, flags & FOLL_WRITE);
              goto out;
      }
    
    Note that this code currently doesn't work as intended if the pmd refers
    to a huge page, the pmd_huge() check can not be reached if the page is
    huge.
    
    Extending pmd_bad() (and, for future 1GB page support, pud_bad()) to
    allow for the PSE bit being set fixes this. For similar reasons,
    allowing the NX bit being set is necessary, too. I have seen huge pages
    having the NX bit set in their pmd entry, which would cause the same
    problem.
    
    Signed-Off-By: Hans Rosenfeld <hans.rosenfeld@amd.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

:040000 040000 1051a11e76304c0fa9229af65cbbd288a8125651
fd91df38defe41df09dde3c0955fb32a4476467a M	include


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
