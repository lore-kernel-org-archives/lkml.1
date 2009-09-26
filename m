Return-Path: <linux-kernel-owner+w=401wt.eu-S1753090AbZIZSzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbZIZSzQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 14:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbZIZSy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 14:54:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:36406 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbZIZSyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 14:54:21 -0400
Date: Sat, 26 Sep 2009 20:54:06 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org
Subject: [PATCH 8/9] Add explicit bound checks in mm/migrate.c
Message-ID: <20090926205406.30d55b08@infradead.org>
In-Reply-To: <20090926204951.424e567e@infradead.org>
References: <20090926204951.424e567e@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 8/9] Add explicit bound checks in mm/migrate.c
CC: akpm@linux-foundation.org

The memory migration code has some curious copy_from_user bounds,
that are likely ok, but are not immediately obvious to me or to GCC.

This patch adds a simple explicit bound check; this allows GCC
and me to be more assured that the copy_from_user will never overwrite
its destination buffer.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>


diff --git a/mm/migrate.c b/mm/migrate.c
index 1a4bf48..5b9ebc5 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1044,11 +1044,15 @@ static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
 	int err;
 
 	for (i = 0; i < nr_pages; i += chunk_nr) {
+		unsigned int copy;
 		if (chunk_nr + i > nr_pages)
 			chunk_nr = nr_pages - i;
 
-		err = copy_from_user(chunk_pages, &pages[i],
-				     chunk_nr * sizeof(*chunk_pages));
+		copy = chunk_nr * sizeof(*chunk_pages);
+		if (copy > DO_PAGES_STAT_CHUNK_NR)
+			return -EFAULT;
+
+		err = copy_from_user(chunk_pages, &pages[i], copy);
 		if (err) {
 			err = -EFAULT;
 			goto out;


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
