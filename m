Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbZFRRK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbZFRRK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbZFRRKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:10:49 -0400
Received: from smtp-out.google.com ([216.239.33.17]:24101 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbZFRRKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:10:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=c3BOHYlY9LIO0nUIj9q9r+aEocxi1/+EB5MVC4wuhkWkRB6mYqFXHFjd96k2ZRJat
	KKM1Oz0vOPkmDlPlSgR1w==
Date: Thu, 18 Jun 2009 10:10:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alexander Beregalov <a.beregalov@gmail.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: replace oomkilladj with oom_adj
In-Reply-To: <1245344528-16477-1-git-send-email-a.beregalov@gmail.com>
Message-ID: <alpine.DEB.2.00.0906181008370.2894@chino.kir.corp.google.com>
References: <1245344528-16477-1-git-send-email-a.beregalov@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009, Alexander Beregalov wrote:

> Commit 2ff05b2b (oom: move oom_adj value from task_struct to mm_struct)
> changed it.
> Fix build.
> 

Andrew had already sent this fix to Greg, thanks.


I'm about to merge "oom: move oom_adj value from task_struct to
mm_struct", and this fixup is needed to repair linux-next's
drivers/staging/android/lowmemorykiller.c.

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/android/lowmemorykiller.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/staging/android/lowmemorykiller.c~oom-move-oom_adj-value-from-task_struct-to-mm_struct-fix drivers/staging/android/lowmemorykiller.c
--- a/drivers/staging/android/lowmemorykiller.c~oom-move-oom_adj-value-from-task_struct-to-mm_struct-fix
+++ a/drivers/staging/android/lowmemorykiller.c
@@ -96,19 +96,21 @@ static int lowmem_shrink(int nr_to_scan,
 
 	read_lock(&tasklist_lock);
 	for_each_process(p) {
+		struct mm_struct *mm;
 		int oom_adj;
 
 		task_lock(p);
-		if (!p->mm) {
+		mm = p->mm;
+		if (!mm) {
 			task_unlock(p);
 			continue;
 		}
-		oom_adj = p->oomkilladj;
+		oom_adj = mm->oom_adj;
 		if (oom_adj < min_adj) {
 			task_unlock(p);
 			continue;
 		}
-		tasksize = get_mm_rss(p->mm);
+		tasksize = get_mm_rss(mm);
 		task_unlock(p);
 		if (tasksize <= 0)
 			continue;
