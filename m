Return-Path: <linux-kernel-owner+w=401wt.eu-S1762228AbZE0WRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762228AbZE0WRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761717AbZE0WPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:15:45 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:60767 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762234AbZE0WPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:15:36 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v2 1/3] kvm: fix potential coalesced_mmio leak on shutdown
To: avi@redhat.com
Cc: chrisw@sous-sol.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 27 May 2009 17:37:39 -0400
Message-ID: <20090527213739.24324.23034.stgit@dev.haskins.net>
In-Reply-To: <20090527213535.24324.62362.stgit@dev.haskins.net>
References: <20090527213535.24324.62362.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would appear that we are invoking kfree() on the wrong pointer in the
destructor for the coalesced_mmio device.  This could result in a potential
leak during shutdown.  This works today because the kvm_io_device is
the first element of the private structure, but this could change in
the future, so lets clean this up.

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

