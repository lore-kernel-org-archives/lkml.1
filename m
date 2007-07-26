Return-Path: <linux-kernel-owner+w=401wt.eu-S935431AbXGZVYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935431AbXGZVYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 17:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759833AbXGZVYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 17:24:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:16283 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759530AbXGZVYW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 17:24:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,584,1175497200"; 
   d="scan'208";a="255268801"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] ia64: fix build failure on fs/quota.c
Date: Thu, 26 Jul 2007 14:24:19 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A0205DE5E@scsmsx411.amr.corp.intel.com>
In-Reply-To: <1185472136.20910.15.camel@dchapman.boston.redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ia64: fix build failure on fs/quota.c
Thread-Index: AcfPuYKxJqMqn7e9Squ8EgVmf3s01gAD411A
From: "Luck, Tony" <tony.luck@intel.com>
To: "Doug Chapman" <doug.chapman@hp.com>, <linux-kernel@vger.kernel.org>
Cc: <linux-ia64@vger.kernel.org>, <vtaras@openvz.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Andi Kleen" <ak@suse.de>
X-OriginalArrivalTime: 26 Jul 2007 21:24:21.0123 (UTC) FILETIME=[54CAB530:01C7CFCB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This issue wandered off onto a long thread "build fix for x86_64" which
died out without a final patch.  Here's the summary:

> +#if defined(CONFIG_X86_64) || (defined(CONFIG_IA64) && defined(CONFIG_COMPAT))

It was pointed out that x86-64 also has a CONFIG_COMPAT, so the "right"
#ifdef mess would be:

#if defined(CONFIG_COMPAT) && (defined(CONFIG_IA64) || defined(CONFIG_X86_64))

But this was thought too ugly.  Andi Kleen proposed making a new CONFIG
variable for this situation: CONFIG_COMPAT_FOR_U64_ALIGMNENT which could
be set in ia64 and x86-64 Kconfig files with:

config COMPAT_FOR_U64_ALIGMNENT
	def_bool COMPAT

So the C-code would simply have:

#if defined(COMPAT_COMPAT_FOR_U64_ALIGMNENT)

(IIRC the syntax correctly).  Peter Anvin had some worries about future
issues ... but I think he agreed that this was Ok.

Anyone still have any objections to this?

Signed-off-by: Tony Luck <tony.luck@intel.com>

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 36c7b96..21aa4fc 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -425,6 +425,9 @@ config COMPAT
 	depends on IA32_SUPPORT
 	default y
 
+config COMPAT_FOR_U64_ALIGNMENT
+	def_bool COMPAT
+
 config IA64_MCA_RECOVERY
 	tristate "MCA recovery from errors other than TLB."
 
diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index 45f82ae..ffa0364 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -765,6 +765,9 @@ config COMPAT
 	depends on IA32_EMULATION
 	default y
 
+config COMPAT_FOR_U64_ALIGNMENT
+	def_bool COMPAT
+
 config SYSVIPC_COMPAT
 	bool
 	depends on COMPAT && SYSVIPC
diff --git a/fs/quota.c b/fs/quota.c
index e6577ac..99b24b5 100644
--- a/fs/quota.c
+++ b/fs/quota.c
@@ -387,7 +387,7 @@ asmlinkage long sys_quotactl(unsigned int cmd, const char __user *special, qid_t
 	return ret;
 }
 
-#if defined(CONFIG_X86_64) || defined(CONFIG_IA64)
+#if defined(CONFIG_COMPAT_FOR_U64_ALIGNMENT)
 /*
  * This code works only for 32 bit quota tools over 64 bit OS (x86_64, ia64)
  * and is necessary due to alignment problems.
