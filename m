Return-Path: <linux-kernel-owner+w=401wt.eu-S1762281AbXHUG5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762281AbXHUG5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761261AbXHUGyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:54:51 -0400
Received: from canuck.infradead.org ([209.217.80.40]:44298 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760722AbXHUGyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:54:49 -0400
Date: Mon, 20 Aug 2007 23:55:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 14/20] Hibernation: do not try to mark invalid PFNs as
	nosave
Message-ID: <20070821065537.GO5275@kroah.com>
References: <20070821064251.972690753@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hibernation-do-not-try-to-mark-invalid-pfns-as-nosave.patch"
In-Reply-To: <20070821065210.GA5275@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Rafael J. Wysocki <rjw@sisk.pl>

On some systems some PFNs reported by the early initialization code as 'nosave'
may be invalid. =A0If we try to set the corresponding bits in the hibernation
bitmap, BUG_ON() in memory_bm_find_bit() will be triggered and the system
won't be able to boot (cf. https://bugzilla.novell.com/show_bug.cgi?id=296242).

Prevent this from happening by verifying if the 'nosave' PFNs are valid in
mark_nosave_pages().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/power/snapshot.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -709,7 +709,8 @@ static void mark_nosave_pages(struct mem
 				region->end_pfn << PAGE_SHIFT);
 
 		for (pfn = region->start_pfn; pfn < region->end_pfn; pfn++)
-			memory_bm_set_bit(bm, pfn);
+			if (pfn_valid(pfn))
+				memory_bm_set_bit(bm, pfn);
 	}
 }
 

-- 
