Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090Ab0AWAZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab0AWAZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:25:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317Ab0AWASy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:18:54 -0500
Received: from kroah.org ([198.145.64.141]:35060 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab0AWASv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:18:51 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jan 22 16:11:11 2010
Message-Id: <20100123001111.887606828@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 16:09:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [13/29] USB: EHCI: fix handling of unusual interrupt intervals
In-Reply-To: <20100123001145.GA7391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 1b9a38bfa6e664ff02511314f5586d711c83cc91 upstream.

This patch (as1320) fixes two problems related to interrupt-URB
scheduling in ehci-hcd.

	URBs with an interval of 2 or 4 microframes aren't handled.
	For the time being, the patch reduces to interval to 1 uframe.

	URBs are constrained to have an interval no larger than 1024
	frames by usb_submit_urb().  But some EHCI controllers allow
	use of a schedule as short as 256 frames; for these
	controllers we may have to decrease the interval to the
	actual schedule length.

The second problem isn't very significant since few devices expose
interrupt endpoints with an interval larger than 256 frames.  But the
first problem is critical; it will prevent the kernel from working
with devices having interrupt intervals of 2 or 4 uframes.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Glynn Farrow <farrowg@sg.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-q.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -827,9 +827,10 @@ qh_make (
 				 * But interval 1 scheduling is simpler, and
 				 * includes high bandwidth.
 				 */
-				dbg ("intr period %d uframes, NYET!",
-						urb->interval);
-				goto done;
+				urb->interval = 1;
+			} else if (qh->period > ehci->periodic_size) {
+				qh->period = ehci->periodic_size;
+				urb->interval = qh->period << 3;
 			}
 		} else {
 			int		think_time;
@@ -852,6 +853,10 @@ qh_make (
 					usb_calc_bus_time (urb->dev->speed,
 					is_input, 0, max_packet (maxp)));
 			qh->period = urb->interval;
+			if (qh->period > ehci->periodic_size) {
+				qh->period = ehci->periodic_size;
+				urb->interval = qh->period;
+			}
 		}
 	}
 


