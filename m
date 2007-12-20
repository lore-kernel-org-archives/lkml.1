Return-Path: <linux-kernel-owner+w=401wt.eu-S1760295AbXLTUNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295AbXLTUNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759248AbXLTULr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:11:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759242AbXLTULq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:11:46 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 15/15] replace x86_read/write_per_cpu with a common function.
Date: Thu, 20 Dec 2007 18:04:10 -0200
Message-Id: <11981813802836-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11981813691362-git-send-email-gcosta@redhat.com>
References: <11981810504172-git-send-email-gcosta@redhat.com> <11981811293763-git-send-email-gcosta@redhat.com> <11981811852758-git-send-email-gcosta@redhat.com> <11981812041672-git-send-email-gcosta@redhat.com> <1198181215625-git-send-email-gcosta@redhat.com> <1198181224677-git-send-email-gcosta@redhat.com> <11981812412879-git-send-email-gcosta@redhat.com> <11981812771615-git-send-email-gcosta@redhat.com> <1198181309285-git-send-email-gcosta@redhat.com> <11981813192341-git-send-email-gcosta@redhat.com> <11981813292926-git-send-email-gcosta@redhat.com> <11981813384090-git-send-email-gcosta@redhat.com> <1198181348746-git-send-email-gcosta@redhat.com> <11981813592589-git-send-email-gcosta@redhat.com> <11981813691362-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_read_per_cpu() and its writeish sister are not present in x86_64. So in
this patch, we replace them with __get_cpu_var(), which is present in both

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/paravirt.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6-x86/arch/x86/kernel/paravirt.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/paravirt.c	2007-12-20 19:08:11.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/paravirt.c	2007-12-20 19:08:18.000000000 -0800
@@ -238,18 +238,18 @@
 
 static inline void enter_lazy(enum paravirt_lazy_mode mode)
 {
-	BUG_ON(x86_read_percpu(paravirt_lazy_mode) != PARAVIRT_LAZY_NONE);
+	BUG_ON(__get_cpu_var(paravirt_lazy_mode) != PARAVIRT_LAZY_NONE);
 	BUG_ON(preemptible());
 
-	x86_write_percpu(paravirt_lazy_mode, mode);
+	__get_cpu_var(paravirt_lazy_mode) = mode;
 }
 
 void paravirt_leave_lazy(enum paravirt_lazy_mode mode)
 {
-	BUG_ON(x86_read_percpu(paravirt_lazy_mode) != mode);
+	BUG_ON(__get_cpu_var(paravirt_lazy_mode) != mode);
 	BUG_ON(preemptible());
 
-	x86_write_percpu(paravirt_lazy_mode, PARAVIRT_LAZY_NONE);
+	__get_cpu_var(paravirt_lazy_mode) = PARAVIRT_LAZY_NONE;
 }
 
 void paravirt_enter_lazy_mmu(void)
@@ -274,7 +274,7 @@
 
 enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
 {
-	return x86_read_percpu(paravirt_lazy_mode);
+	return __get_cpu_var(paravirt_lazy_mode);
 }
 
 struct pv_info pv_info = {
