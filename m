Return-Path: <linux-kernel-owner+w=401wt.eu-S965031AbXFFWfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965031AbXFFWfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936780AbXFFWe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:34:57 -0400
Received: from gw.goop.org ([64.81.55.164]:55273 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936747AbXFFWe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:34:56 -0400
Message-ID: <4667367D.4090207@goop.org>
Date: Wed, 06 Jun 2007 15:34:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] paravirt: fix error handling in paravirt_disable_iospace
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure everything is backed out if it fails.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/kernel/paravirt.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

===================================================================
--- a/arch/i386/kernel/paravirt.c
+++ b/arch/i386/kernel/paravirt.c
@@ -254,8 +254,11 @@ int paravirt_disable_iospace(void)
 	int ret;
 
 	ret = request_resource(&ioport_resource, &reserve_ioports);
-	if (ret == 0)
+	if (ret == 0) {
 		ret = request_resource(&iomem_resource, &reserve_iomem);
+		if (ret)
+			release_resource(&reserve_ioports);
+	}
 
 	return ret;
 }


