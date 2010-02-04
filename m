Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab0BDI6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 03:58:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:57087 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab0BDI6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 03:58:46 -0500
Message-ID: <4B6A8C01.5020403@kernel.org>
Date: Thu, 04 Feb 2010 17:57:37 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net,
       Dave Airlie <airlied@gmail.com>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Subject: [PATCH 2.6.33-rc6] idr: revert misallocation bug fix
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 08:57:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 859ddf09743a8cc680af33f7259ccd0fd36bfe9d tried to fix
misallocation bug but broke full bit marking by not clearing
pa[idp->layers] and also is causing X failures due to lookup failure
in drm code.  The cause of the latter hasn't been found yet.  Revert
the fix for now.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Sorry this wasn't found before hitting mainline.  It looks like this
will have to stay broken for a bit more.  I'll make an userland
test rig and find out what's going on.

Thanks.

 lib/idr.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index ba7d37c..1cac726 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -140,7 +140,8 @@ static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
 	id = *starting_id;
  restart:
 	p = idp->top;
-	l = p->layer;
+	l = idp->layers;
+	pa[l--] = NULL;
 	while (1) {
 		/*
 		 * We run around this while until we reach the leaf node...
@@ -154,8 +155,8 @@ static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
 			oid = id;
 			id = (id | ((1 << (IDR_BITS * l)) - 1)) + 1;
 
-			/* did id go over the limit? */
-			if (id >= (1 << (idp->layers * IDR_BITS))) {
+			/* if already at the top layer, we need to grow */
+			if (!(p = pa[l])) {
 				*starting_id = id;
 				return IDR_NEED_TO_GROW;
 			}
