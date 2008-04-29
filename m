Return-Path: <linux-kernel-owner+w=401wt.eu-S1765289AbYD2Rcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765289AbYD2Rcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759425AbYD2RWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:22:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759395AbYD2RWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:22:05 -0400
Date: Tue, 29 Apr 2008 10:19:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johannes Weiner <hannes@saeurebad.de>, Roel Kluin <12o3l@tiscali.nl>,
       Andreas Schwab <schwab@suse.de>, Matt Mackall <mpm@selenic.com>,
       Mikael Pettersson <mikpe@it.uu.se>
Subject: [31/37] mm: fix possible off-by-one in walk_pte_range()
Message-ID: <20080429171910.GF14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mm-fix-possible-off-by-one-in-walk_pte_range.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Johannes Weiner <hannes@saeurebad.de>

commit 556637cdabcd5918c7d4a1a2679b8f86fc81e891 upstream


After the loop in walk_pte_range() pte might point to the first address after
the pmd it walks.  The pte_unmap() is then applied to something bad.

Spotted by Roel Kluin and Andreas Schwab.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Roel Kluin <12o3l@tiscali.nl>
Cc: Andreas Schwab <schwab@suse.de>
Acked-by: Matt Mackall <mpm@selenic.com>
Acked-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/pagewalk.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -9,11 +9,15 @@ static int walk_pte_range(pmd_t *pmd, un
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

-- 
