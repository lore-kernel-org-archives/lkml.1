Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbYAAXmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbYAAXmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 18:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756926AbYAAXlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 18:41:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38118 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756221AbYAAXk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 18:40:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 2/4] PM: Do not destroy/create devices while suspended in msr.c (rev. 2)
Date: Wed, 2 Jan 2008 00:40:01 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>
References: <200801020032.45529.rjw@sisk.pl>
In-Reply-To: <200801020032.45529.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801020040.02190.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The MSR driver should not attempt to destroy/create a device while
suspended, unless this device corresponds to a nonboot CPU that
failed to go online during a resume, in which case the PM core should
be asked to remove it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/kernel/msr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/msr.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/msr.c
+++ linux-2.6/arch/x86/kernel/msr.c
@@ -155,15 +155,15 @@ static int __cpuinit msr_class_cpu_callb
 
 	switch (action) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		err = msr_device_create(cpu);
 		break;
 	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		msr_device_destroy(cpu);
 		break;
+	case CPU_UP_CANCELED_FROZEN:
+		destroy_suspended_device(msr_class, MKDEV(MSR_MAJOR, cpu));
+		break;
 	}
 	return err ? NOTIFY_BAD : NOTIFY_OK;
 }

