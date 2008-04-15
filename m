Return-Path: <linux-kernel-owner+w=401wt.eu-S1762856AbYDOPhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762856AbYDOPhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 11:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYDOPhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 11:37:24 -0400
Received: from aun.it.uu.se ([130.238.12.36]:57839 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbYDOPhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 11:37:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18436.52094.242415.163660@harpo.it.uu.se>
Date: Tue, 15 Apr 2008 17:36:30 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Roel Kluin <12o3l@tiscali.nl>,
       Andreas Schwab <schwab@suse.de>, Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: Fix possible off-by-one in walk_pte_range()
In-Reply-To: <12082680403770-git-send-email-hannes@saeurebad.de>
References: <12082680403770-git-send-email-hannes@saeurebad.de>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner writes:
 > After the loop in walk_pte_range() pte might point to the first address
 > after the pmd it walks.  The pte_unmap() is then applied to something
 > bad.
 > 
 > Spotted by Roel Kluin and Andreas Schwab.
 > 
 > Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
 > CC: Roel Kluin <12o3l@tiscali.nl>
 > CC: Andreas Schwab <schwab@suse.de>
 > CC: Matt Mackall <mpm@selenic.com>
 > CC: Andrew Morton <akpm@linux-foundation.org>
 > ---
 > 
 > A bug is unlikely, though.  kunmap_atomic() looks up the kmap entry by
 > map-type instead of the address the pte points.  So the worst thing I
 > could find with a quick grep was that a wrong TLB entry is being
 > flushed.  Still, the code is wrong :)
 > 
 > diff --git a/mm/pagewalk.c b/mm/pagewalk.c
 > index 1cf1417..cf3c004 100644
 > --- a/mm/pagewalk.c
 > +++ b/mm/pagewalk.c
 > @@ -13,7 +13,7 @@ static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 >  		err = walk->pte_entry(pte, addr, addr + PAGE_SIZE, private);
 >  		if (err)
 >  		       break;
 > -	} while (pte++, addr += PAGE_SIZE, addr != end);
 > +	} while (addr += PAGE_SIZE, addr != end && pte++);

Instead of obfuscating the code by putting "&& pte++" in the
condition (it will always be true in valid C), you should IMO
rewrite the do-while as a for loop + break, like this:

	for (;;) {
	    // same body as before
	    addr += PAGE_SIZE;
	    if (addr == end)
	        break;
	    pte++;
	}

This makes the ordering constraints very clear.
