Return-Path: <linux-kernel-owner+w=401wt.eu-S932261AbZHMUJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbZHMUJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932125AbZHMT7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:38 -0400
Received: from kroah.org ([198.145.64.141]:41712 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755954AbZHMT7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:31 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:28 2009
Message-Id: <20090813195128.242130683@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tom Peng <tom_peng@usish.com>, Jack Wang <jack_wang@usish.com>,
       Lindar Liu <lindar_liu@usish.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 25/74] SCSI: libsas: reuse the original port when hotplugging phys in wide ports
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=libsas-reuse-the-original-port-when-hotplugging-phys-in-wide-ports.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tom Peng <tom_peng@usish.com>

commit 5381837f125cc62ad703fbcdfcd7566fc81fd404 upstream.

There's a hotplug problem in the way libsas allocates ports: it loops over the
available ports first trying to add to an existing for a wide port and
otherwise allocating the next free port.  This scheme only works if the port
array is packed from zero, which fails if a port gets hot unplugged and the
array becomes sparse.  In that case, a new port is formed even if there's a
wide port it should be part of.  Fix this by creating two loops over all the
ports:  the first to see if the phy should be part of a wide port and the
second to form a new port in an empty port slot.

Signed-off-by: Tom Peng <tom_peng@usish.com>
Signed-off-by: Jack Wang <jack_wang@usish.com>
Signed-off-by: Lindar Liu <lindar_liu@usish.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/libsas/sas_port.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -56,7 +56,7 @@ static void sas_form_port(struct asd_sas
 		}
 	}
 
-	/* find a port */
+	/* see if the phy should be part of a wide port */
 	spin_lock_irqsave(&sas_ha->phy_port_lock, flags);
 	for (i = 0; i < sas_ha->num_phys; i++) {
 		port = sas_ha->sas_port[i];
@@ -69,12 +69,23 @@ static void sas_form_port(struct asd_sas
 			SAS_DPRINTK("phy%d matched wide port%d\n", phy->id,
 				    port->id);
 			break;
-		} else if (*(u64 *) port->sas_addr == 0 && port->num_phys==0) {
-			memcpy(port->sas_addr, phy->sas_addr, SAS_ADDR_SIZE);
-			break;
 		}
 		spin_unlock(&port->phy_list_lock);
 	}
+	/* The phy does not match any existing port, create a new one */
+	if (i == sas_ha->num_phys) {
+		for (i = 0; i < sas_ha->num_phys; i++) {
+			port = sas_ha->sas_port[i];
+			spin_lock(&port->phy_list_lock);
+			if (*(u64 *)port->sas_addr == 0
+				&& port->num_phys == 0) {
+				memcpy(port->sas_addr, phy->sas_addr,
+					SAS_ADDR_SIZE);
+				break;
+			}
+			spin_unlock(&port->phy_list_lock);
+		}
+	}
 
 	if (i >= sas_ha->num_phys) {
 		printk(KERN_NOTICE "%s: couldn't find a free port, bug?\n",


