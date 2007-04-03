Return-Path: <linux-kernel-owner+w=401wt.eu-S2992518AbXDDAY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992518AbXDDAY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 20:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030361AbXDDAY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 20:24:57 -0400
Received: from as3.cineca.com ([130.186.84.211]:52005 "EHLO as3.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030357AbXDDAY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 20:24:56 -0400
X-Greylist: delayed 6594 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Apr 2007 20:24:56 EDT
Message-ID: <4612D68D.9090103@cineca.it>
From: Andrea Righi <a.righi@cineca.it>
Reply-To: a.righi@cineca.it
Organization: CINECA
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix for depca driver
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Date: Wed,  4 Apr 2007 00:34:59 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

the following patch fixes a kernel bug in depca_platform_probe().

We don't use a dynamic pointer for pldev->dev.platform_data, so it seems
that the correct way to proceed if platform_device_add(pldev) fails is
to explicitly set the pldev->dev.platform_data pointer to NULL, before
calling the platform_device_put(pldev), or it will be kfree'ed by
platform_device_release().

-Andrea

---
 drivers/net/depca.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/depca.c b/drivers/net/depca.c
index 5113eef..f3807aa 100644
--- a/drivers/net/depca.c
+++ b/drivers/net/depca.c
@@ -1491,8 +1491,9 @@ static void __init depca_platform_probe
                depca_io_ports[i].device = pldev;

                if (platform_device_add(pldev)) {
-                       platform_device_put(pldev);
                        depca_io_ports[i].device = NULL;
+                       pldev->dev.platform_data = NULL;
+                       platform_device_put(pldev);
                        continue;
                }

