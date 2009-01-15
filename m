Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbZAOUzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbZAOUzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932362AbZAOUDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:03:18 -0500
Received: from kroah.org ([198.145.64.141]:49876 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932192AbZAOUDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:03:08 -0500
Date: Thu, 15 Jan 2009 12:00:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Brian King <brking@linux.vnet.ibm.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 91/94] [SCSI] ibmvfc: Improve async event handling
Message-ID: <20090115200044.GM14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ibmvfc-improve-async-event-handling.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Brian King <brking@linux.vnet.ibm.com>

commit d2131b33c7e07c2905ee2f2321cc4dae1928c483 upstream.

While doing various error injection testing, such as cable
pulls and target moves, some issues were observed in handling
these events. This patch improves the way these events are handled
by increasing the delay waiting for the fabric to settle and also
changes the behavior of Link Up to break the CRQ to ensure everything
gets cleaned up properly on the VIOS.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/ibmvscsi/ibmvfc.c |   10 ++++++----
 drivers/scsi/ibmvscsi/ibmvfc.h |    2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2090,15 +2090,17 @@ static void ibmvfc_handle_async(struct i
 	case IBMVFC_AE_LINK_UP:
 	case IBMVFC_AE_RESUME:
 		vhost->events_to_log |= IBMVFC_AE_LINKUP;
-		ibmvfc_init_host(vhost, 1);
+		vhost->delay_init = 1;
+		__ibmvfc_reset_host(vhost);
 		break;
 	case IBMVFC_AE_SCN_FABRIC:
+	case IBMVFC_AE_SCN_DOMAIN:
 		vhost->events_to_log |= IBMVFC_AE_RSCN;
-		ibmvfc_init_host(vhost, 1);
+		vhost->delay_init = 1;
+		__ibmvfc_reset_host(vhost);
 		break;
 	case IBMVFC_AE_SCN_NPORT:
 	case IBMVFC_AE_SCN_GROUP:
-	case IBMVFC_AE_SCN_DOMAIN:
 		vhost->events_to_log |= IBMVFC_AE_RSCN;
 	case IBMVFC_AE_ELS_LOGO:
 	case IBMVFC_AE_ELS_PRLO:
@@ -3523,7 +3525,7 @@ static void ibmvfc_do_work(struct ibmvfc
 		if (vhost->delay_init) {
 			vhost->delay_init = 0;
 			spin_unlock_irqrestore(vhost->host->host_lock, flags);
-			ssleep(5);
+			ssleep(15);
 			return;
 		} else
 			vhost->job_step(vhost);
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -33,7 +33,7 @@
 #define IBMVFC_DRIVER_DATE		"(August 14, 2008)"
 
 #define IBMVFC_DEFAULT_TIMEOUT	15
-#define IBMVFC_INIT_TIMEOUT		30
+#define IBMVFC_INIT_TIMEOUT		120
 #define IBMVFC_MAX_REQUESTS_DEFAULT	100
 
 #define IBMVFC_DEBUG			0

