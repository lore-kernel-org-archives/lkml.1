Return-Path: <linux-kernel-owner+w=401wt.eu-S1767150AbXCIKeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767150AbXCIKeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 05:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993107AbXCIKeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 05:34:21 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:52175 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993105AbXCIKeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 05:34:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ryKvsqbtw8MNIHL3uxS4FIhBiq9UWdxbNxHPDUD6jf0JoEwPRu/EeI1NydkHymyyhDzQkW2AjcB1Lib4DvkroUsnS9tlghS3ggHkqlDVCmtBsg8/t5aTzLQ+qMyObLeFXsLbh2A7oEqxFUwlSpqqKV63xvI52nEH3tyDPUWiVX8=
Date: Fri, 9 Mar 2007 19:34:19 +0900
From: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH] devres: release resources on device_del()
Message-ID: <20070309103419.GB32687@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some platform devices are driven without driver attached, so managed
resources can be acquired without driver attached.  Make sure such
resources are released by calling devres_release_all() in
device_del().

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
This one fixes oops on pata_platform and pata_legacy unload.  libata
being the only user of devres at the moment.  I think this can go
through libata-dev#upstream.

 drivers/base/core.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index cf2a398..89ebe36 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -787,6 +787,13 @@ void device_del(struct device * dev)
 	device_remove_attrs(dev);
 	bus_remove_device(dev);
 
+	/*
+	 * Some platform devices are driven without driver attached
+	 * and managed resources may have been acquired.  Make sure
+	 * all resources are released.
+	 */
+	devres_release_all(dev);
+
 	/* Notify the platform of the removal, in case they
 	 * need to do anything...
 	 */
-- 
1.5.0.1

