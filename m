Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbZF2Rfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbZF2Rfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 13:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757528AbZF2Rew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 13:34:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39853 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757493AbZF2Rev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 13:34:51 -0400
Date: Mon, 29 Jun 2009 20:34:21 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>, avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: [PATCHv4 3/6] kvm: switch pit creation to slots_lock
Message-ID: <20090629173421.GD22855@redhat.com>
References: <cover.1246294571.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1246294571.git.mst@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

switch pit creation to slots_lock. slots_lock is already taken for read
everywhere, so we only need to take it for write when creating pit.
This is in preparation to removing in_range and kvm->lock around it.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/kvm/x86.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5a66bb9..a2505ca 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2115,7 +2115,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 				   sizeof(struct kvm_pit_config)))
 			goto out;
 	create_pit:
-		mutex_lock(&kvm->lock);
+		down_write(&kvm->slots_lock);
 		r = -EEXIST;
 		if (kvm->arch.vpit)
 			goto create_pit_unlock;
@@ -2124,7 +2124,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		if (kvm->arch.vpit)
 			r = 0;
 	create_pit_unlock:
-		mutex_unlock(&kvm->lock);
+		up_write(&kvm->slots_lock);
 		break;
 	case KVM_IRQ_LINE_STATUS:
 	case KVM_IRQ_LINE: {
-- 
1.6.2.2

