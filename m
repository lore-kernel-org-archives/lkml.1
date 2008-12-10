Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbYLJTpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbYLJTpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 14:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755870AbYLJTpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 14:45:40 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45625 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342AbYLJTpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 14:45:39 -0500
Date: Wed, 10 Dec 2008 14:43:34 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: greg@kroah.com, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: nhorman@tuxdriver.com
Subject: [PATCH] ibmphp: Fix module ref count underflow
Message-ID: <20081210194334.GA25257@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey-
	I happened to notice that the ibmphp hotplug driver does something
rather silly in its init routine.  It purposely calls module_put so as to
underflow its module ref count to avoid being removed from the kernel.  This is
bad practice, and wrong, since it provides a window for subsequent module_gets
to reset the refcount to zero, allowing an unload to race in and cause all sorts
of mysterious panics.  If the module is unsafe to load, it should inform the
kernel as such with a call to __unsafe.  The patch below does that.

Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

 ibmphp_core.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)


diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
index c892daa..3706d4e 100644
--- a/drivers/pci/hotplug/ibmphp_core.c
+++ b/drivers/pci/hotplug/ibmphp_core.c
@@ -1402,9 +1402,11 @@ static int __init ibmphp_init(void)
 		goto error;
 	}
 
-	/* lock ourselves into memory with a module 
-	 * count of -1 so that no one can unload us. */
-	module_put(THIS_MODULE);
+	/*
+	 * Its unsafe to unload this module, so tell
+	 * the kernel to avoid inadvertent unloads
+	 */
+	__unsafe(THIS_MODULE);
 
 exit:
 	return rc;
-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
