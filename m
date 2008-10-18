Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbYJRTFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbYJRTFW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbYJRTDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:03:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47262 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbYJRTDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:03:01 -0400
Date: Sat, 18 Oct 2008 11:34:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Chris Webb <chris@arachsys.com>,
       NeilBrown <neilb@suse.de>
Subject: [patch 06/17] md: Fix rdev_size_store with size == 0
Message-ID: <20081018183408.GG14035@suse.de>
References: <20081018182721.521723254@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="md-fix-rdev_size_store-with-size-0.patch"
In-Reply-To: <20081018183334.GA14035@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Chris Webb <chris@arachsys.com>

commit 7d3c6f8717ee6c2bf6cba5fa0bda3b28fbda6015 upstream

Fix rdev_size_store with size == 0.
size == 0 means to use the largest size allowed by the
underlying device and is used when modifying an active array.

This fixes a regression introduced by
 commit d7027458d68b2f1752a28016dcf2ffd0a7e8f567

Signed-off-by: Chris Webb <chris@arachsys.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2109,8 +2109,6 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 
 	if (strict_strtoull(buf, 10, &size) < 0)
 		return -EINVAL;
-	if (size < my_mddev->size)
-		return -EINVAL;
 	if (my_mddev->pers && rdev->raid_disk >= 0) {
 		if (my_mddev->persistent) {
 			size = super_types[my_mddev->major_version].
@@ -2121,9 +2119,9 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 			size = (rdev->bdev->bd_inode->i_size >> 10);
 			size -= rdev->data_offset/2;
 		}
-		if (size < my_mddev->size)
-			return -EINVAL; /* component must fit device */
 	}
+	if (size < my_mddev->size)
+		return -EINVAL; /* component must fit device */
 
 	rdev->size = size;
 	if (size > oldsize && my_mddev->external) {

-- 
