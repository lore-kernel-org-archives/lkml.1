Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZI0Q03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZI0Q03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 12:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbZI0Q02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 12:26:28 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:40485 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753720AbZI0Q02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 12:26:28 -0400
X-Trace: 266589622/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.38.252/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.38.252
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtUEADIvv0pPRSb8/2dsb2JhbACBUNEngjOBawU
X-IronPort-AV: E=Sophos;i="4.44,461,1249254000"; 
   d="scan'208";a="266589622"
Date: Sun, 27 Sep 2009 17:26:25 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andi Kleen <andi@firstfloor.org>
cc: Nick Piggin <npiggin@suse.de>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] HWPOISON: remove the unsafe __set_page_locked()
In-Reply-To: <20090926213204.GX30185@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0909271714370.9097@sister.anvils>
References: <20090926031537.GA10176@localhost> <Pine.LNX.4.64.0909261115530.12927@sister.anvils>
 <20090926190645.GB14368@wotan.suse.de> <20090926213204.GX30185@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Sep 2009, Andi Kleen wrote:
> > This is a bit tricky to do right now; you have a chicken and egg
> > problem between locking the page and pinning the inode mapping.
> 
> One possibly simple solution would be to just allocate the page
> locked (GFP_LOCKED). When the allocator clears the flags it already
> modifies the state, so it could as well set the lock bit too. No
> atomics needed.  And then clearing it later is also atomic free.

That's a good idea.

I don't particularly like adding a GFP_LOCKED just for this, and I
don't particularly like having to remember to unlock the thing on the
various(?) error paths between getting the page and adding it to cache.

But it is a good idea, and if doing it that way would really close a
race window which checking page->mapping (or whatever) cannot (I'm
simply not sure about that), then it would seem the best way to go.

Hugh
