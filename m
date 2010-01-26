Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679Ab0AZTak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab0AZTak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 14:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087Ab0AZT3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 14:29:54 -0500
Received: from kroah.org ([198.145.64.141]:33616 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077Ab0AZT3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 14:29:05 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 11:16:24 2010
Message-Id: <20100126191624.789857266@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 11:14:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [08/11] USB: EHCI: fix handling of unusual interrupt intervals
In-Reply-To: <20100126191730.GA20872@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
@@ -748,9 +748,10 @@ qh_make (
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
@@ -773,6 +774,10 @@ qh_make (
 					usb_calc_bus_time (urb->dev->speed,
 					is_input, 0, max_packet (maxp)));
 			qh->period = urb->interval;
+			if (qh->period > ehci->periodic_size) {
+				qh->period = ehci->periodic_size;
+				urb->interval = qh->period;
+			}
 		}
 	}
 


