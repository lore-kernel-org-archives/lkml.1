Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZG1Px2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZG1Px2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbZG1Px1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:53:27 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:54744 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991AbZG1Px0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:53:26 -0400
Date: Tue, 28 Jul 2009 17:53:24 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/9] virt/kvm: correct error-handling code
Message-ID: <Pine.LNX.4.64.0907281752560.28189@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

This code is not executed before file has been initialized to the result of
calling eventfd_fget.  This function returns an ERR_PTR value in an error
case instead of NULL.  Thus the test that file is not NULL is always true.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@match exists@
expression x, E;
statement S1, S2;
@@

x = eventfd_fget(...)
... when != x = E
(
*  if (x == NULL || ...) S1 else S2
|
*  if (x == NULL && ...) S1 else S2
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 virt/kvm/eventfd.c                  |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 99017e8..bb4ebd8 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -230,7 +230,7 @@ fail:
 	if (eventfd && !IS_ERR(eventfd))
 		eventfd_ctx_put(eventfd);
 
-	if (file && !IS_ERR(file))
+	if (!IS_ERR(file))
 		fput(file);
 
 	kfree(irqfd);
