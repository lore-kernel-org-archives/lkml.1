Return-Path: <linux-kernel-owner+w=401wt.eu-S1751912Ab0AKCop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab0AKCop (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 21:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760Ab0AKCoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 21:44:44 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:52014 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab0AKCon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 21:44:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=bYFeN1UOMgingsVcXTFqoIqvIQuESDvRbpJ+7xvYNQmlTsf6Y3Y+OrAKKuoOiMDtQO
         DLYKjHJ11sHY12/1076w2rkQLnufAISVX4ahPDD3KBExFzJ+f24pywluugrJ3Z1YxaWM
         lOwXXEHukO/Ef4envog0WNdehmz57WHrC8eZM=
Date: Mon, 11 Jan 2010 11:42:24 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH -mmotm-2010-01-06-14-34] Fix fault count of task in GUP
Message-Id: <20100111114224.bbf0fc62.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


get_user_pages calls handle_mm_fault to pin the arguemented
task's page. handle_mm_fault cause major or minor fault and
get_user_pages counts it into task which is passed by argument.

But the fault happens in current task's context.
So we have to count it not argumented task's context but current
task's one.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
CC: Nick Piggin <npiggin@suse.de>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---
 mm/memory.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 521abf6..2513581 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1486,9 +1486,9 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 					BUG();
 				}
 				if (ret & VM_FAULT_MAJOR)
-					tsk->maj_flt++;
+					current->maj_flt++;
 				else
-					tsk->min_flt++;
+					current->min_flt++;
 
 				/*
 				 * The VM_FAULT_WRITE bit tells us that
-- 
1.5.6.3


-- 
Kind regards,
Minchan Kim
