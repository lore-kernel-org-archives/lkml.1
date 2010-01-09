Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644Ab0AIOqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab0AIOqr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 09:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611Ab0AIOqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 09:46:47 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:47027 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab0AIOqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 09:46:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fNC7e4cHwi5V/SIPkcehJcWF+g5hFY7EH5Vu2VkerTYyJpnuVUf1lZCucxQfPF45UW
         V420VaKlGGSwVvxBkrB2t10hlhilA26EPKc/CTFV4cp0lJwjzawBsoBxd89NwVkJ4GJw
         4OmmO2zG3QT5Yr1lf3gs8HFWPSXqqeRwJtgdM=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] kernel/resource.c: fix memory leak
Date: Sat,  9 Jan 2010 17:46:35 +0300
Message-Id: <1263048395-14873-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free res before exit.
Found by cppcheck.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 kernel/resource.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index af96c1e..ae2e177 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -545,11 +545,12 @@ static void __init __reserve_region_with_split(struct resource *root,
 	res->flags = IORESOURCE_BUSY;
 
 	conflict = __request_resource(parent, res);
+	kfree(res);
+
 	if (!conflict)
 		return;
 
 	/* failed, split and try again */
-	kfree(res);
 
 	/* conflict covered whole area */
 	if (conflict->start <= start && conflict->end >= end)
-- 
1.6.6

