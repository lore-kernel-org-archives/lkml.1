Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbYKZDhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbYKZDhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 22:37:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbYKZDgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 22:36:53 -0500
Received: from sous-sol.org ([216.99.217.87]:39460 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752348AbYKZDgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 22:36:52 -0500
Date: Tue, 25 Nov 2008 19:36:10 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: jbarnes@virtuousgeek.org
Cc: greg@kroah.com, khali@linux-fr.org, miltonm@bga.com,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, allen.m.kay@intel.com, jun.nakajima@intel.com
Subject: [PATCH 1/2] PCI: allow pci driver to support only dynids
Message-ID: <20081126033610.GB19881@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit b41d6cf38e27 (PCI: Check dynids driver_data value for validity)
requires all drivers to include an id table to try and match
driver_data.  Before validating driver_data check driver has an id
table.

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Milton Miller <miltonm@bga.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/pci/pci-driver.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index b4cdd69..0a5edbe 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -48,7 +48,7 @@ store_new_id(struct device_driver *driver, const char *buf, size_t count)
 		subdevice=PCI_ANY_ID, class=0, class_mask=0;
 	unsigned long driver_data=0;
 	int fields=0;
-	int retval;
+	int retval=0;
 
 	fields = sscanf(buf, "%x %x %x %x %x %x %lx",
 			&vendor, &device, &subvendor, &subdevice,
@@ -58,16 +58,18 @@ store_new_id(struct device_driver *driver, const char *buf, size_t count)
 
 	/* Only accept driver_data values that match an existing id_table
 	   entry */
-	retval = -EINVAL;
-	while (ids->vendor || ids->subvendor || ids->class_mask) {
-		if (driver_data == ids->driver_data) {
-			retval = 0;
-			break;
+	if (ids) {
+		retval = -EINVAL;
+		while (ids->vendor || ids->subvendor || ids->class_mask) {
+			if (driver_data == ids->driver_data) {
+				retval = 0;
+				break;
+			}
+			ids++;
 		}
-		ids++;
+		if (retval)	/* No match */
+			return retval;
 	}
-	if (retval)	/* No match */
-		return retval;
 
 	dynid = kzalloc(sizeof(*dynid), GFP_KERNEL);
 	if (!dynid)
-- 
1.6.0.3

