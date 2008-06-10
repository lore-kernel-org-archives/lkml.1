Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375AbYFJQFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbYFJQFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 12:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYFJQFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 12:05:07 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:50138 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbYFJQFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 12:05:06 -0400
Date: Tue, 10 Jun 2008 19:04:08 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] always enable FW_LOADER unless EMBEDDED=y
Message-ID: <20080610160408.GB11685@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley recently discovered that we have 
{request,release}_firmware() dummies for the case of the actual 
functions not being available and has a fix for the bug that was 
actually causing build errors for built-in users with 
CONFIG_FW_LOADER=m.

But now missing selects on FW_LOADER are no longer visible at 
compile-time at all and can become runtime problems.

FW_LOADER is infrastructure with relatively small codesize we can 
safely enable for everyone, and only for people who really need small 
kernels (and can be expected to know what they are doing) it matters 
being able to disable it.

This patch therefore always sets FW_LOADER=y and allows users only to 
disable it with EMBEDDED=y.

As a bonus, we can then get rid of all "select FW_LOADER" plus the due 
to it required "depends on HOTPLUG" which removes some complexity from 
our Kconfig files.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 2 Jun 2008

462ee1ceb263f523b6f4e3bd30a0f63810f05c67 diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index d7da109..629e255 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -27,8 +27,9 @@ config PREVENT_FIRMWARE_BUILD
 	  If unsure say Y here.
 
 config FW_LOADER
-	tristate "Userspace firmware loading support"
+	tristate "Userspace firmware loading support" if EMBEDDED
 	depends on HOTPLUG
+	default y
 	---help---
 	  This option is provided for the case where no in-kernel-tree modules
 	  require userspace firmware loading support, but a module built outside

