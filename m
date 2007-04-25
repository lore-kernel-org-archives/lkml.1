Return-Path: <linux-kernel-owner+w=401wt.eu-S1161869AbXDYP7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161869AbXDYP7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423334AbXDYP7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:59:41 -0400
Received: from sceptre.pobox.com ([207.106.133.20]:38722 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161864AbXDYP70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:59:26 -0400
X-Greylist: delayed 4633 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Apr 2007 11:59:26 EDT
Message-ID: <462F7AD9.8020300@hp.com>
Date: Wed, 25 Apr 2007 11:59:21 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Reply-To: Alan.Brunelle@pobox.com
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/15] cfq-iosched: speed up rbtree handling
References: <11774025432481-git-send-email-jens.axboe@oracle.com> <11774025432403-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <11774025432403-git-send-email-jens.axboe@oracle.com>
Content-Type: multipart/mixed;
 boundary="------------050209080801050504000306"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050209080801050504000306
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jens -

The attached patch speeds it up even more - I'm finding a >9% reduction 
in %system with no loss in IO performance. This just sets the cached 
element when the first is looked for.

Alan

--------------050209080801050504000306
Content-Type: text/plain;
 name="fix-left"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-left"

From: Alan D. Brunelle <Alan.Brunelle@hp.com>

Update cached leftmost every time it is found.

Signed-off-by: Alan D. Brunelle <Alan.Brunelle@hp.com>
---

 block/cfq-iosched.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 8093733..a86a7c3 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -388,10 +388,10 @@ cfq_choose_req(struct cfq_data *cfqd, struct request *rq1, struct request *rq2)
  */
 static struct rb_node *cfq_rb_first(struct cfq_rb_root *root)
 {
-	if (root->left)
-		return root->left;
+	if (!root->left)
+		root->left = rb_first(&root->rb);
 
-	return rb_first(&root->rb);
+	return root->left;
 }
 
 static void cfq_rb_erase(struct rb_node *n, struct cfq_rb_root *root)

--------------050209080801050504000306--
