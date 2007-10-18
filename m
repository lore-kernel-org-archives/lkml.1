Return-Path: <linux-kernel-owner+w=401wt.eu-S1763481AbXJRMjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763481AbXJRMjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 08:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757553AbXJRMjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 08:39:16 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:31951 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757373AbXJRMjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 08:39:15 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Subject: Use virtual cpu accounting if available for guest times.
Date: Thu, 18 Oct 2007 14:39:10 +0200
User-Agent: KMail/1.9.7
Cc: Laurent Vivier <Laurent.Vivier@bull.net>, linux-kernel@vger.kernel.org,
       kvm-devel <kvm-devel@lists.sourceforge.net>
References: <47135D1B.1060004@bull.net> <11926264852739-git-send-email-Laurent.Vivier@bull.net>
In-Reply-To: <11926264852739-git-send-email-Laurent.Vivier@bull.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710181439.10390.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi,

ppc and s390 offer the possibility to track process times precisely
by looking at cpu timer on every context switch, irq, softirq etc.
We can use that infrastructure as well for guest time accounting.
We need to account the used time before we change the state. 
This patch adds a call to account_system_vtime to kvm_guest_enter
and kvm_guest exit. If CONFIG_VIRT_CPU_ACCOUNTING is not set,
account_system_vtime is defined in hardirq.h as an empty function,
which means this patch does not change the behaviour on other
platforms.

I compile tested this patch on x86 and function tested the patch on
s390.

Avi, please apply.


Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

---
 drivers/kvm/kvm.h |    3 +++
 1 file changed, 3 insertions(+)

Index: kvm/drivers/kvm/kvm.h
===================================================================
--- kvm.orig/drivers/kvm/kvm.h
+++ kvm/drivers/kvm/kvm.h
@@ -7,6 +7,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/hardirq.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
@@ -669,11 +670,13 @@ __init void kvm_arch_init(void);
 
 static inline void kvm_guest_enter(void)
 {
+	account_system_vtime(current);
 	current->flags |= PF_VCPU;
 }
 
 static inline void kvm_guest_exit(void)
 {
+	account_system_vtime(current);
 	current->flags &= ~PF_VCPU;
 }
 
