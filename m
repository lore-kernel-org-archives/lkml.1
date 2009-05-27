Return-Path: <linux-kernel-owner+w=401wt.eu-S1759735AbZE0Ql0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759735AbZE0Ql0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 12:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756720AbZE0QlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 12:41:17 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:47378 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbZE0QlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 12:41:16 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH] kvm: fix coalesced_mmio leak on shutdown
To: avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 27 May 2009 12:41:12 -0400
Message-ID: <20090527164059.23966.75880.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would appear that we are invoking kfree() on the wrong pointer in the
destructor for the coalesced_mmio device.  This would result in a potential
leak during shutdown.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 virt/kvm/coalesced_mmio.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 5ae620d..03ea280 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -80,7 +80,10 @@ static void coalesced_mmio_write(struct kvm_io_device *this,
 
 static void coalesced_mmio_destructor(struct kvm_io_device *this)
 {
-	kfree(this);
+	struct kvm_coalesced_mmio_dev *dev =
+		(struct kvm_coalesced_mmio_dev *)this->private;
+
+	kfree(dev);
 }
 
 int kvm_coalesced_mmio_init(struct kvm *kvm)

