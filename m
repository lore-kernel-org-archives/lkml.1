Return-Path: <linux-kernel-owner+w=401wt.eu-S935999AbZLQBeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935999AbZLQBeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936030AbZLQBed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:34:33 -0500
Received: from kroah.org ([198.145.64.141]:48040 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763653AbZLQBUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:38 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:05 2009
Message-Id: <20091217011605.019497617@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jarek Poplawski <jarkao2@gmail.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [54/90] net: Fix the rollback test in dev_change_name()
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 91e9c07bd635353d1a278bdb38dbb56ac371bcb8 ]

net: Fix the rollback test in dev_change_name()

In dev_change_name() an err variable is used for storing the original
call_netdevice_notifiers() errno (negative) and testing for a rollback
error later, but the test for non-zero is wrong, because the err might
have positive value as well - from dev_alloc_name(). It means the
rollback for a netdevice with a number > 0 will never happen. (The err
test is reordered btw. to make it more readable.)

Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/dev.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -933,14 +933,15 @@ rollback:
 	ret = notifier_to_errno(ret);
 
 	if (ret) {
-		if (err) {
-			printk(KERN_ERR
-			       "%s: name change rollback failed: %d.\n",
-			       dev->name, ret);
-		} else {
+		/* err >= 0 after dev_alloc_name() or stores the first errno */
+		if (err >= 0) {
 			err = ret;
 			memcpy(dev->name, oldname, IFNAMSIZ);
 			goto rollback;
+		} else {
+			printk(KERN_ERR
+			       "%s: name change rollback failed: %d.\n",
+			       dev->name, ret);
 		}
 	}
 


