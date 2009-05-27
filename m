Return-Path: <linux-kernel-owner+w=401wt.eu-S932184AbZE0PRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbZE0PRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 11:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757412AbZE0PRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 11:17:12 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:45632 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609AbZE0PRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 11:17:11 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/2] kvm: validate irqfd type
To: mst@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, mtosatti@redhat.com
Date: Wed, 27 May 2009 10:37:06 -0400
Message-ID: <20090527143706.14024.14341.stgit@dev.haskins.net>
In-Reply-To: <20090527143251.14024.89090.stgit@dev.haskins.net>
References: <20090527143251.14024.89090.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should be more vigilant in validating the fd type passed down for use
in irqfd.  A malicious userspace could do something nasty like pass the
kvm fd which would cause problems such as a reference leak on the kvm
object on shutdown.

Therefore, we use the eventfd_fget() routine in place of the plain fget()
to at least make sure its of the proper type.

Reported-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 virt/kvm/eventfd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index c63ff6a..f3f2ea1 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -27,6 +27,7 @@
 #include <linux/poll.h>
 #include <linux/file.h>
 #include <linux/list.h>
+#include <linux/eventfd.h>
 
 /*
  * --------------------------------------------------------------------
@@ -102,7 +103,7 @@ kvm_assign_irqfd(struct kvm *kvm, int fd, int gsi)
 	/*
 	 * Embed the file* lifetime in the irqfd.
 	 */
-	file = fget(fd);
+	file = eventfd_fget(fd);
 	if (IS_ERR(file)) {
 		ret = PTR_ERR(file);
 		goto fail;

