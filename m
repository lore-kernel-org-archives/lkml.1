Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbZFCEp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbZFCEp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 00:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbZFCEpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 00:45:20 -0400
Received: from smtp-out.google.com ([216.239.45.13]:14226 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZFCEpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 00:45:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Q+zoWHkrX3ciXNMCD0d/FGgMuV69hVNrHUwmgL42GScvKJQkDB3cpvzR6Gxm8PV8p
	eTPDQm5QhsPy6ehPhbNPQ==
Date: Tue, 2 Jun 2009 21:45:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>
Subject: Re: mmotm 2009-06-02-16-11 uploaded (staging)
In-Reply-To: <4A25F814.7030101@oracle.com>
Message-ID: <alpine.DEB.2.00.0906022132490.26434@chino.kir.corp.google.com>
References: <200906022331.n52NVJhG015117@imap1.linux-foundation.org> <4A25F814.7030101@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jun 2009, Randy Dunlap wrote:

> drivers/staging/android/lowmemorykiller.c:106: error: 'struct task_struct' has no member named 'oomkilladj'
> 

Thanks Randy.

This is due to oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch 
which was merged in mmotm early this morning.

I had previously fixed this in an earlier version of the patch series, but 
people didn't agree that an oom killer change should touch staging files 
even though the Android lowmemorykiller is in both mmotm and git HEAD.  
See http://marc.info/?l=linux-kernel&m=124200164711314.

I'm still a little curious about why it was decided like that since it 
seems to be the simplest way to avoid these failures, which leave you with 
a broken build, and an unnecessary burden on maintainers to magically fix 
them up later (which I guess is now?).

So when I moved oomkilladj from struct task_struct to struct mm_struct and 
renamed it to something more appropriate, I still think I should have been 
able to change drivers/staging/android/lowmemorykiller.c for those 
reasons and avoid all of this hassle.

Anyway, here's a patch that should work and will hopefully now be 
accepted.  I know Greg is the maintainer for the staging tree and we're 
talking about mmotm, but I don't know how else to do it anymore.
---
diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -96,19 +96,21 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
 
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
