Return-Path: <linux-kernel-owner+w=401wt.eu-S967403AbXEHSD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967403AbXEHSD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 14:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967384AbXEHSDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 14:03:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:8397 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967375AbXEHSDX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 14:03:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,506,1170662400"; 
   d="scan'208";a="240803081"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH Resend] - SN: validate smp_affinity mask on intr redirect
Date: Tue, 8 May 2007 11:03:20 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A01719A90@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070508152315.26329.8428.64771@attica.americas.sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH Resend] - SN: validate smp_affinity mask on intr redirect
Thread-Index: AceRh/S8xsD54W4fSYurpi9f92p11gAEQ2Jw
From: "Luck, Tony" <tony.luck@intel.com>
To: "John Keller" <jpk@sgi.com>, <linux-kernel@vger.kernel.org>
CC: <akpm@osdl.org>, <steiner@sgi.com>, <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 08 May 2007 18:03:21.0110 (UTC) FILETIME=[29D48360:01C7919B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 
+#ifndef is_affinity_mask_valid
+#define is_affinity_mask_valid() 1
+#endif
+
 int no_irq_affinity;
 static int irq_affinity_write_proc(struct file *file, const char __user *buffer,
 				   unsigned long count, void *data)
@@ -42,6 +46,9 @@ static int irq_affinity_write_proc(struc
 	if (err)
 		return err;
 
+	if (!is_affinity_mask_valid(new_value))
+		return -EINVAL;

This results in a warning:
kernel/irq/proc.c:49: warning: implicit declaration of function `is_affinity_mask_valid'

I can't put a declaration for is_affinity_mask_valid into
include/asm-ia64/irq.h because that results in errors in
files that include this, but don't have a definition for
cpumask_t.

I could add the declaration as a #else clause to that
#ifndef in kernel/irq/proc.c, but that would no doubt
result is complaints from the style police that function
prototypes belong in header files, not in ".c" files.

Last option is to move the #if to linux/irq.h:

#ifndef is_affinity_mask_valid
#define is_affinity_mask_valid 1
#else
extern bool is_affinity_mask_valid(cpumask_t cpumask);
#endif

But that seems to spoil the whole tricksiness factor and
doesn't really look any better that using ARCH_HAS_IRQ_AFFINITY_MASK_CHECK

-Tony
