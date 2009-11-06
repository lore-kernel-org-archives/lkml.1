Return-Path: <linux-kernel-owner+w=401wt.eu-S933027AbZKFWjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027AbZKFWjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760152AbZKFWWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:22:45 -0500
Received: from kroah.org ([198.145.64.141]:56783 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760142AbZKFWWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:43 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:42 2009
Message-Id: <20091106221542.455186736@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [29/99] do_mbind(): fix memory leak
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=do_mbind-fix-memory-leak.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit b05ca7385a2848abdc72051f832722641daed8b0 upstream.

If migrate_prep is failed, new variable is leaked.  This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/mempolicy.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1024,7 +1024,7 @@ static long do_mbind(unsigned long start
 
 		err = migrate_prep();
 		if (err)
-			return err;
+			goto mpol_out;
 	}
 	{
 		NODEMASK_SCRATCH(scratch);
@@ -1039,10 +1039,9 @@ static long do_mbind(unsigned long start
 			err = -ENOMEM;
 		NODEMASK_SCRATCH_FREE(scratch);
 	}
-	if (err) {
-		mpol_put(new);
-		return err;
-	}
+	if (err)
+		goto mpol_out;
+
 	vma = check_range(mm, start, end, nmask,
 			  flags | MPOL_MF_INVERT, &pagelist);
 
@@ -1062,6 +1061,7 @@ static long do_mbind(unsigned long start
 		putback_lru_pages(&pagelist);
 
 	up_write(&mm->mmap_sem);
+ mpol_out:
 	mpol_put(new);
 	return err;
 }


