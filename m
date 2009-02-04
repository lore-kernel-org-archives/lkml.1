Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbZBDJ42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbZBDJ42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 04:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbZBDJ4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 04:56:16 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36746 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbZBDJ4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 04:56:14 -0500
Date: Wed, 4 Feb 2009 18:55:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Swamy Gowda" <swamy@virident.com>, <linux-kernel@vger.kernel.org>,
       cl@linux-foundation.org, Brice.Goglin@inria.fr,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [RFC][PATCH] release mmap_sem before starting migration (Was Re:
 Need to take mmap_sem lock in move_pages.
Message-Id: <20090204185501.837ff5d6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090204184028.09a4bbae.kamezawa.hiroyu@jp.fujitsu.com>
References: <28631E6913C8074E95A698E8AC93D091B21561@caexch1.virident.info>
	<20090204183600.f41e8b7e.kamezawa.hiroyu@jp.fujitsu.com>
	<20090204184028.09a4bbae.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009 18:40:28 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Wed, 4 Feb 2009 18:36:00 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>       Maybe up_read() can be moved before do_migrate_pages(), I think.
> 
How about this ?
==

mmap_sem can be released after page table walk ends.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: mmotm-2.6.29-Feb03/mm/migrate.c
===================================================================
--- mmotm-2.6.29-Feb03.orig/mm/migrate.c
+++ mmotm-2.6.29-Feb03/mm/migrate.c
@@ -875,13 +875,13 @@ put_and_set:
 set_status:
 		pp->status = err;
 	}
+	up_read(&mm->mmap_sem);
 
 	err = 0;
 	if (!list_empty(&pagelist))
 		err = migrate_pages(&pagelist, new_page_node,
 				(unsigned long)pm);
 
-	up_read(&mm->mmap_sem);
 	return err;
 }
 

