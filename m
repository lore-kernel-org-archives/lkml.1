Return-Path: <linux-kernel-owner+w=401wt.eu-S1762263AbZJOAou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762263AbZJOAou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 20:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761714AbZJOAou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 20:44:50 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:20661 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761637AbZJOAot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 20:44:49 -0400
X-Trace: 274112631/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.53.219/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.53.219
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgYBAC8N1kpPRTXb/2dsb2JhbAAIj28Byk6ELgQ
X-IronPort-AV: E=Sophos;i="4.44,562,1249254000"; 
   d="scan'208";a="274112631"
Date: Thu, 15 Oct 2009 01:44:10 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/9] swap_info and swap_map patches
Message-ID: <Pine.LNX.4.64.0910150130001.2250@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a series of nine patches around the swap_info_struct: against
2.6.32-rc4, but intended for mmotm, which is currently similar here.

They start out with some old and not very important cleanups, but get
around to solving the swap count overflow problem: our handling above
32765 has depended on hoping that it won't coincide with other races.

That problem exists in theory today (when pid_max is raised from its
default), though never reported in practice; but the motivation for
solving it now comes from the impending KSM swapping patches - it
becomes very easy for anyone to overflow the maximum that way.

But most people will never have a swap count overflow in their life:
the benefit for them is that the vmalloc'ed swap_map halves in size.

This is all internal housekeeping: no change to actual swapping and
page reclaim.

 include/linux/swap.h |   66 ++-
 mm/memory.c          |   19 
 mm/page_io.c         |   19 
 mm/rmap.c            |    6 
 mm/shmem.c           |   11 
 mm/swapfile.c        |  834 +++++++++++++++++++++++++----------------
 6 files changed, 599 insertions(+), 356 deletions(-)

Hugh
