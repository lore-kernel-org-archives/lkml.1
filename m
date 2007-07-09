Return-Path: <linux-kernel-owner+w=401wt.eu-S1759239AbXGIDsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239AbXGIDsR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 23:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758750AbXGIDsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 23:48:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:60722 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758727AbXGIDsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 23:48:03 -0400
Subject: removing flush_tlb_mm as a generic hook ?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-mm@kvack.org
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 09 Jul 2007 13:47:54 +1000
Message-Id: <1183952874.3388.349.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks !

While toying around with various MM callbacks, I found out that
flush_tlb_mm() as a generic hook provided by the archs has been mostly
obsoleted by the mmu_gather stuff.

(I'm not talking about archs internally wanting to implement it and use
it as a tlb_flush(), I'm talking about possibly making that optional :-)

I see two remaining users:

 - fs/proc/task_mmu.c, which I easily converted to use the mmu_gather
(I'll send a patch if people agree it's worth doing)

 - kernel/fork.c uses it to flush the "old" mm. That's the "meat".

I wonder if it's worth pursuing, that is converting copy_page_range to
use an mmu_gather on the source instead of using flush_tlb_mm. It might
allow some archs that can't just "flush all" easily but have to go
through every PTE individually to improve things a bit on fork, and it
allow them to remove the flush_tlb_mm() logic.

There is one reason why it's not a trivial conversion though, is that
copy_page_range() calls copy_hugetlb_page_range() for huge pages, and
I'm not sure about mixing up the hugetlb stuff with the mmu_gather
stuff, I need to do a bit more code auditing to figure out whether
that's an ok thing to do.

Nothing very urgent or important, it's just that one less hook seems
like a good idea ;-)

Cheers,
Ben.


