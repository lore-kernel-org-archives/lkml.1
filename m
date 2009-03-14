Return-Path: <linux-kernel-owner+w=401wt.eu-S1762915AbZCNAwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762915AbZCNAwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbZCNAUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:20:25 -0400
Received: from kroah.org ([198.145.64.141]:35108 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750857AbZCNATv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:51 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:53 2009
Message-Id: <20090314000752.864238523@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [patch 90/96] ext4: Fix lockdep warning
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=ext4-fix-lockdep-warning.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

(cherry picked from commit ba4439165f0f0d25b2fe065cf0c1ff8130b802eb)

We should not call ext4_mb_add_n_trim while holding alloc_semp.

    =============================================
    [ INFO: possible recursive locking detected ]
    2.6.29-rc4-git1-dirty #124
    ---------------------------------------------
    ffsb/3116 is trying to acquire lock:
     (&meta_group_info[i]->alloc_sem){----}, at: [<ffffffff8035a6e8>]
     ext4_mb_load_buddy+0xd2/0x343

    but task is already holding lock:
     (&meta_group_info[i]->alloc_sem){----}, at: [<ffffffff8035a6e8>]
     ext4_mb_load_buddy+0xd2/0x343

http://bugzilla.kernel.org/show_bug.cgi?id=12672

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/mballoc.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4569,23 +4569,26 @@ static int ext4_mb_release_context(struc
 			pa->pa_free -= ac->ac_b_ex.fe_len;
 			pa->pa_len -= ac->ac_b_ex.fe_len;
 			spin_unlock(&pa->pa_lock);
-			/*
-			 * We want to add the pa to the right bucket.
-			 * Remove it from the list and while adding
-			 * make sure the list to which we are adding
-			 * doesn't grow big.
-			 */
-			if (likely(pa->pa_free)) {
-				spin_lock(pa->pa_obj_lock);
-				list_del_rcu(&pa->pa_inode_list);
-				spin_unlock(pa->pa_obj_lock);
-				ext4_mb_add_n_trim(ac);
-			}
 		}
-		ext4_mb_put_pa(ac, ac->ac_sb, pa);
 	}
 	if (ac->alloc_semp)
 		up_read(ac->alloc_semp);
+	if (pa) {
+		/*
+		 * We want to add the pa to the right bucket.
+		 * Remove it from the list and while adding
+		 * make sure the list to which we are adding
+		 * doesn't grow big.  We need to release
+		 * alloc_semp before calling ext4_mb_add_n_trim()
+		 */
+		if (pa->pa_linear && likely(pa->pa_free)) {
+			spin_lock(pa->pa_obj_lock);
+			list_del_rcu(&pa->pa_inode_list);
+			spin_unlock(pa->pa_obj_lock);
+			ext4_mb_add_n_trim(ac);
+		}
+		ext4_mb_put_pa(ac, ac->ac_sb, pa);
+	}
 	if (ac->ac_bitmap_page)
 		page_cache_release(ac->ac_bitmap_page);
 	if (ac->ac_buddy_page)


