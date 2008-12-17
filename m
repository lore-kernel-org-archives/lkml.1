Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760189AbYLQANb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189AbYLQANb (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbYLQAG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:06:56 -0500
Received: from kroah.org ([198.145.64.141]:41258 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759532AbYLQAF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:05:58 -0500
Date: Tue, 16 Dec 2008 16:04:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
        Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
        Chris Wedgwood <reviews@ml.cw.f00f.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Chuck Ebbert <cebbert@redhat.com>,
        Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
        Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Hartkopp <oliver@hartkopp.net>,
        Kurt Van Dijck <kurt.van.dijck@eia.be>,
        "David S. Miller" <davem@davemloft.net>
Subject: [patch 08/22] can: Fix CAN_(EFF|RTR)_FLAG handling in can_filter
Message-ID: <20081217000414.GI4504@kroah.com>
References: <20081216235704.347182084@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="can-fix-can__flag-handling-in-can_filter.patch"
In-Reply-To: <20081217000306.GA4504@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oliver Hartkopp <oliver@hartkopp.net>

commit d253eee20195b25e298bf162a6e72f14bf4803e5 upstream.

Due to a wrong safety check in af_can.c it was not possible to filter
for SFF frames with a specific CAN identifier without getting the
same selected CAN identifier from a received EFF frame also.

This fix has a minimum (but user visible) impact on the CAN filter
API and therefore the CAN version is set to a new date.

Indeed the 'old' API is still working as-is. But when now setting
CAN_(EFF|RTR)_FLAG in can_filter.can_mask you might get less traffic
than before - but still the stuff that you expected to get for your
defined filter ...

Thanks to Kurt Van Dijck for pointing at this issue and for the review.

Signed-off-by: Oliver Hartkopp <oliver@hartkopp.net>
Acked-by: Kurt Van Dijck <kurt.van.dijck@eia.be>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/can/core.h |    2 -
 net/can/af_can.c         |   63 +++++++++++++++++++++++++++++++++++------------
 net/can/bcm.c            |    7 ++---
 3 files changed, 53 insertions(+), 19 deletions(-)

--- a/include/linux/can/core.h
+++ b/include/linux/can/core.h
@@ -19,7 +19,7 @@
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 
-#define CAN_VERSION "20071116"
+#define CAN_VERSION "20081130"
 
 /* increment this number each time you change some user-space interface */
 #define CAN_ABI_VERSION "8"
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -319,23 +319,52 @@ static struct dev_rcv_lists *find_dev_rc
 	return n ? d : NULL;
 }
 
+/**
+ * find_rcv_list - determine optimal filterlist inside device filter struct
+ * @can_id: pointer to CAN identifier of a given can_filter
+ * @mask: pointer to CAN mask of a given can_filter
+ * @d: pointer to the device filter struct
+ *
+ * Description:
+ *  Returns the optimal filterlist to reduce the filter handling in the
+ *  receive path. This function is called by service functions that need
+ *  to register or unregister a can_filter in the filter lists.
+ *
+ *  A filter matches in general, when
+ *
+ *          <received_can_id> & mask == can_id & mask
+ *
+ *  so every bit set in the mask (even CAN_EFF_FLAG, CAN_RTR_FLAG) describe
+ *  relevant bits for the filter.
+ *
+ *  The filter can be inverted (CAN_INV_FILTER bit set in can_id) or it can
+ *  filter for error frames (CAN_ERR_FLAG bit set in mask). For error frames
+ *  there is a special filterlist and a special rx path filter handling.
+ *
+ * Return:
+ *  Pointer to optimal filterlist for the given can_id/mask pair.
+ *  Constistency checked mask.
+ *  Reduced can_id to have a preprocessed filter compare value.
+ */
 static struct hlist_head *find_rcv_list(canid_t *can_id, canid_t *mask,
 					struct dev_rcv_lists *d)
 {
 	canid_t inv = *can_id & CAN_INV_FILTER; /* save flag before masking */
 
-	/* filter error frames */
+	/* filter for error frames in extra filterlist */
 	if (*mask & CAN_ERR_FLAG) {
-		/* clear CAN_ERR_FLAG in list entry */
+		/* clear CAN_ERR_FLAG in filter entry */
 		*mask &= CAN_ERR_MASK;
 		return &d->rx[RX_ERR];
 	}
 
-	/* ensure valid values in can_mask */
-	if (*mask & CAN_EFF_FLAG)
-		*mask &= (CAN_EFF_MASK | CAN_EFF_FLAG | CAN_RTR_FLAG);
-	else
-		*mask &= (CAN_SFF_MASK | CAN_RTR_FLAG);
+	/* with cleared CAN_ERR_FLAG we have a simple mask/value filterpair */
+
+#define CAN_EFF_RTR_FLAGS (CAN_EFF_FLAG | CAN_RTR_FLAG)
+
+	/* ensure valid values in can_mask for 'SFF only' frame filtering */
+	if ((*mask & CAN_EFF_FLAG) && !(*can_id & CAN_EFF_FLAG))
+		*mask &= (CAN_SFF_MASK | CAN_EFF_RTR_FLAGS);
 
 	/* reduce condition testing at receive time */
 	*can_id &= *mask;
@@ -348,15 +377,19 @@ static struct hlist_head *find_rcv_list(
 	if (!(*mask))
 		return &d->rx[RX_ALL];
 
-	/* use extra filterset for the subscription of exactly *ONE* can_id */
-	if (*can_id & CAN_EFF_FLAG) {
-		if (*mask == (CAN_EFF_MASK | CAN_EFF_FLAG)) {
-			/* RFC: a use-case for hash-tables in the future? */
-			return &d->rx[RX_EFF];
+	/* extra filterlists for the subscription of a single non-RTR can_id */
+	if (((*mask & CAN_EFF_RTR_FLAGS) == CAN_EFF_RTR_FLAGS)
+	    && !(*can_id & CAN_RTR_FLAG)) {
+
+		if (*can_id & CAN_EFF_FLAG) {
+			if (*mask == (CAN_EFF_MASK | CAN_EFF_RTR_FLAGS)) {
+				/* RFC: a future use-case for hash-tables? */
+				return &d->rx[RX_EFF];
+			}
+		} else {
+			if (*mask == (CAN_SFF_MASK | CAN_EFF_RTR_FLAGS))
+				return &d->rx_sff[*can_id];
 		}
-	} else {
-		if (*mask == CAN_SFF_MASK)
-			return &d->rx_sff[*can_id];
 	}
 
 	/* default: filter via can_id/can_mask */
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -64,10 +64,11 @@
 #define BCM_CAN_DLC_MASK 0x0F /* clean private flags in can_dlc by masking */
 
 /* get best masking value for can_rx_register() for a given single can_id */
-#define REGMASK(id) ((id & CAN_RTR_FLAG) | ((id & CAN_EFF_FLAG) ? \
-			(CAN_EFF_MASK | CAN_EFF_FLAG) : CAN_SFF_MASK))
+#define REGMASK(id) ((id & CAN_EFF_FLAG) ? \
+		     (CAN_EFF_MASK | CAN_EFF_FLAG | CAN_RTR_FLAG) : \
+		     (CAN_SFF_MASK | CAN_EFF_FLAG | CAN_RTR_FLAG))
 
-#define CAN_BCM_VERSION "20080415"
+#define CAN_BCM_VERSION CAN_VERSION
 static __initdata const char banner[] = KERN_INFO
 	"can: broadcast manager protocol (rev " CAN_BCM_VERSION ")\n";
 

