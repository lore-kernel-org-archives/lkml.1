Return-Path: <linux-kernel-owner+w=401wt.eu-S1765478AbYDOQRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765478AbYDOQRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 12:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbYDOQRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 12:17:10 -0400
Received: from saeurebad.de ([85.214.36.134]:34711 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbYDOQRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 12:17:09 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: LKML <linux-kernel@vger.kernel.org>, Roel Kluin <12o3l@tiscali.nl>,
       Andreas Schwab <schwab@suse.de>, Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2] mm: Fix possible off-by-one in walk_pte_range()
References: <12082680403770-git-send-email-hannes@saeurebad.de>
	<18436.52094.242415.163660@harpo.it.uu.se>
Date: Tue, 15 Apr 2008 18:16:53 +0200
In-Reply-To: <18436.52094.242415.163660@harpo.it.uu.se> (Mikael Pettersson's
	message of "Tue, 15 Apr 2008 17:36:30 +0200")
Message-ID: <8763ujhz4a.fsf_-_@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Mikael Pettersson <mikpe@it.uu.se> writes:

> Johannes Weiner writes:
>  > After the loop in walk_pte_range() pte might point to the first address
>  > after the pmd it walks.  The pte_unmap() is then applied to something
>  > bad.
>  > 
>  > Spotted by Roel Kluin and Andreas Schwab.
>  > 
>  > Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
>  > CC: Roel Kluin <12o3l@tiscali.nl>
>  > CC: Andreas Schwab <schwab@suse.de>
>  > CC: Matt Mackall <mpm@selenic.com>
>  > CC: Andrew Morton <akpm@linux-foundation.org>
>  > ---
>  > 
>  > A bug is unlikely, though.  kunmap_atomic() looks up the kmap entry by
>  > map-type instead of the address the pte points.  So the worst thing I
>  > could find with a quick grep was that a wrong TLB entry is being
>  > flushed.  Still, the code is wrong :)
>  > 
>  > diff --git a/mm/pagewalk.c b/mm/pagewalk.c
>  > index 1cf1417..cf3c004 100644
>  > --- a/mm/pagewalk.c
>  > +++ b/mm/pagewalk.c
>  > @@ -13,7 +13,7 @@ static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  >  		err = walk->pte_entry(pte, addr, addr + PAGE_SIZE, private);
>  >  		if (err)
>  >  		       break;
>  > -	} while (pte++, addr += PAGE_SIZE, addr != end);
>  > +	} while (addr += PAGE_SIZE, addr != end && pte++);
>
> Instead of obfuscating the code by putting "&& pte++" in the
> condition (it will always be true in valid C), you should IMO
> rewrite the do-while as a for loop + break, like this:
>
> 	for (;;) {
> 	    // same body as before
> 	    addr += PAGE_SIZE;
> 	    if (addr == end)
> 	        break;
> 	    pte++;
> 	}

Sorry, I think too lispy :)

	Hannes
---

From: Johannes Weiner <hannes@saeurebad.de>
Subject: [PATCH] mm: Fix possible off-by-one in walk_pte_range()

After the loop in walk_pte_range() pte might point to the first address
after the pmd it walks.  The pte_unmap() is then applied to something
bad.

Spotted by Roel Kluin and Andreas Schwab.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Roel Kluin <12o3l@tiscali.nl>
CC: Andreas Schwab <schwab@suse.de>
CC: Matt Mackall <mpm@selenic.com>
CC: Andrew Morton <akpm@linux-foundation.org>
---

A bug is unlikely, though.  kunmap_atomic() looks up the kmap entry by
map-type instead of the address the pte points.  So the worst thing I
could find with a quick grep was that a wrong TLB entry is being
flushed.  Still, the code is wrong :)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 1cf1417..0afd238 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -9,11 +9,15 @@ static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	int err = 0;
 
 	pte = pte_offset_map(pmd, addr);
-	do {
+	for (;;) {
 		err = walk->pte_entry(pte, addr, addr + PAGE_SIZE, private);
 		if (err)
 		       break;
-	} while (pte++, addr += PAGE_SIZE, addr != end);
+		addr += PAGE_SIZE;
+		if (addr == end)
+			break;
+		pte++;
+	}
 
 	pte_unmap(pte);
 	return err;
