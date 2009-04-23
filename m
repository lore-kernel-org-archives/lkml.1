Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbZDWHbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbZDWHbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbZDWH1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:27:31 -0400
Received: from sous-sol.org ([216.99.217.87]:48186 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754124AbZDWH1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:27:25 -0400
Message-Id: <20090423072148.553920638@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:28 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk
Subject: [patch 008/100] ext4: fix locking typo in mballoc which could cause soft lockup hangs
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=ext4-fix-locking-typo-in-mballoc-which-could-cause-soft-lockup-hangs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Theodore Ts'o <tytso@mit.edu>

upstream commit: e7c9e3e99adf6c49c5d593a51375916acc039d1e

Smatch (http://repo.or.cz/w/smatch.git/) complains about the locking in
ext4_mb_add_n_trim() from fs/ext4/mballoc.c

  4438          list_for_each_entry_rcu(tmp_pa, &lg->lg_prealloc_list[order],
  4439                                                  pa_inode_list) {
  4440                  spin_lock(&tmp_pa->pa_lock);
  4441                  if (tmp_pa->pa_deleted) {
  4442                          spin_unlock(&pa->pa_lock);
  4443                          continue;
  4444                  }

Brown paper bag time...

Reported-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/ext4/mballoc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4439,7 +4439,7 @@ static void ext4_mb_add_n_trim(struct ex
 						pa_inode_list) {
 		spin_lock(&tmp_pa->pa_lock);
 		if (tmp_pa->pa_deleted) {
-			spin_unlock(&pa->pa_lock);
+			spin_unlock(&tmp_pa->pa_lock);
 			continue;
 		}
 		if (!added && pa->pa_free < tmp_pa->pa_free) {

