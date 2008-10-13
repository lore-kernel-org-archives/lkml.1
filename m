Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbYJMUWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbYJMUWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYJMUWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:22:04 -0400
Received: from iona.labri.fr ([147.210.8.143]:48028 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbYJMUWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:22:03 -0400
Message-ID: <48F3ADAF.2080200@inria.fr>
Date: Mon, 13 Oct 2008 22:21:03 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Andrew Morton <akpm@osdl.org>,
       Nathalie Furmento <nathalie.furmento@labri.fr>
Subject: [PATCH 1/5] mm: stop returning -ENOENT from sys_move_pages() if nothing
 got migrated
References: <48F3AD47.1050301@inria.fr>
In-Reply-To: <48F3AD47.1050301@inria.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point in returning -ENOENT from sys_move_pages() if all
pages were already on the right node, while we return 0 if only 1 page
was not. Most application don't know where their pages are allocated,
so it's not an error to try to migrate them anyway.

Just return 0 and let the status array in user-space be checked if the
application needs details.

It will make the upcoming chunked-move_pages() support much easier.

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
---
 mm/migrate.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 2a80136..e505b2f 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -926,11 +926,10 @@ set_status:
 		pp->status = err;
 	}
 
+	err = 0;
 	if (!list_empty(&pagelist))
 		err = migrate_pages(&pagelist, new_page_node,
 				(unsigned long)pm);
-	else
-		err = -ENOENT;
 
 	up_read(&mm->mmap_sem);
 	return err;
-- 
1.5.6.5



