Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753553AbYLRVP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbYLRVP5 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 16:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYLRVPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 16:15:47 -0500
Received: from ns2.suse.de ([195.135.220.15]:47594 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbYLRVPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 16:15:46 -0500
Date: Thu, 18 Dec 2008 22:15:43 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Ian Campbell <ijc@hellion.org.uk>
Subject: early fixmap causes kmap breakage
Message-ID: <20081218211543.GB10681@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've debugged a problem where i386+pae systems with more than a few CPUs
blow up at boot in the kmap_atomic code.

The problem is that the kmap_atomic pte pages all need to be contiguous
memory because the pte is calculated via the first kmap pte page + an
offset (so as not to have to walk the page tables every time).

The fixmap setup code crudely allocates contiguous pte pages, which is fine,
but if it finds an already populated pmd entry, then it will not switch it
to a new, contiguous pte page. So the early fixmap introduces a discontig
page table right in the middle of the kmap atomic fixmaps.

Commenting out the eaarly fixmap setup in head_32.S gets everything working
properly. What would be the best way to fix this? Could we put the early
fixmap page table in initdata, and then have the fixmap setup proper first
clear its corresponding pmd entry?

Thanks,
Nick

