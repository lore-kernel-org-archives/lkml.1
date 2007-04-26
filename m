Return-Path: <linux-kernel-owner+w=401wt.eu-S1031340AbXDZRH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031340AbXDZRH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbXDZRHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:07:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39696 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbXDZRBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:01:03 -0400
Date: Thu, 26 Apr 2007 09:56:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, solo@google.com,
       mbligh@mbligh.org, clameter@sgi.com
Subject: [patch 26/33] page migration: fix NR_FILE_PAGES accounting
Message-ID: <20070426165658.GA1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="page-migration-fix-nr_file_pages-accounting.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Christoph Lameter <clameter@sgi.com>

NR_FILE_PAGES must be accounted for depending on the zone that the page
belongs to.  If we replace the page in the radix tree then we may have to
shift the count to another zone.

Suggested-by: Ethan Solomita <solo@google.com>
Cc: Martin Bligh <mbligh@mbligh.org>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/migrate.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -297,7 +297,7 @@ static int migrate_page_move_mapping(str
 	void **pslot;
 
 	if (!mapping) {
-		/* Anonymous page */
+		/* Anonymous page without mapping */
 		if (page_count(page) != 1)
 			return -EAGAIN;
 		return 0;
@@ -333,6 +333,19 @@ static int migrate_page_move_mapping(str
 	 */
 	__put_page(page);
 
+	/*
+	 * If moved to a different zone then also account
+	 * the page for that zone. Other VM counters will be
+	 * taken care of when we establish references to the
+	 * new page and drop references to the old page.
+	 *
+	 * Note that anonymous pages are accounted for
+	 * via NR_FILE_PAGES and NR_ANON_PAGES if they
+	 * are mapped to swap space.
+	 */
+	__dec_zone_page_state(page, NR_FILE_PAGES);
+	__inc_zone_page_state(newpage, NR_FILE_PAGES);
+
 	write_unlock_irq(&mapping->tree_lock);
 
 	return 0;

-- 
