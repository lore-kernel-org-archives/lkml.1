Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbZJGVYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbZJGVYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbZJGVYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:24:10 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:40920 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbZJGVYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:24:09 -0400
Subject: Re: [BUG] No ttyS0 - Strange udev 8250_pnp interaction
From: Kay Sievers <kay.sievers@vrfy.org>
To: Michael Guntsche <mike@it-loops.com>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-hotplug <linux-hotplug@vger.kernel.org>
In-Reply-To: <ac3eb2510910071353v3bbe5bc7lc41e184fbc1ff7ed@mail.gmail.com>
References: <20091007175403.GA335@trillian.comsick.at>
	 <9b2b86520910071246r393f2afvacaa4d8f544508a8@mail.gmail.com>
	 <ac3eb2510910071306r4ad6dc9btb7503bc3ab0ec815@mail.gmail.com>
	 <ac3eb2510910071312qe6ad45ep6c579a8393cc6b8e@mail.gmail.com>
	 <20091007203121.GA432@trillian.comsick.at>
	 <ac3eb2510910071353v3bbe5bc7lc41e184fbc1ff7ed@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Oct 2009 23:23:22 +0200
Message-Id: <1254950602.2307.1.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 22:53 +0200, Kay Sievers wrote:
> On Wed, Oct 7, 2009 at 22:31, Michael Guntsche <mike@it-loops.com> wrote:
> > add      /module/8250_pnp (module)
> > remove /devices/platform/serial8250/tty/ttyS0 (tty)
> > add      /devices/pnp0/00:05/tty/ttyS0 (tty)
> 
> That's pretty odd, that the loading of a module removes pre-existing
> devices created by other code, and creates new ones with the same name
> and major/minor.
> 
> As Alan mentioned, we could serialize events which carry the the same
> major/minor number, that should work around such behavior.

Michael, you mentioned trying the udev git version. Any chance to check
if that fixes it?

Thanks,
Kay

diff --git a/udev/udevd.c b/udev/udevd.c
index 62c6436..dfdbb4c 100644
--- a/udev/udevd.c
+++ b/udev/udevd.c
@@ -118,6 +118,8 @@ struct event {
 	const char *devpath;
 	size_t devpath_len;
 	const char *devpath_old;
+	dev_t devnum;
+	bool is_block;
 };
 
 static struct event *node_to_event(struct udev_list_node *node)
@@ -410,6 +412,8 @@ static void event_queue_insert(struct udev_device *dev)
 	event->devpath = udev_device_get_devpath(dev);
 	event->devpath_len = strlen(event->devpath);
 	event->devpath_old = udev_device_get_devpath_old(dev);
+	event->devnum = udev_device_get_devnum(dev);
+	event->is_block = (strcmp("block", udev_device_get_subsystem(dev)) == 0);
 
 	udev_queue_export_device_queued(udev_queue_export, dev);
 	info(event->udev, "seq %llu queued, '%s' '%s'\n", udev_device_get_seqnum(dev),
@@ -473,7 +477,7 @@ static int mem_size_mb(void)
 }
 
 /* lookup event for identical, parent, child device */
-static int devpath_busy(struct event *event)
+static bool is_devpath_busy(struct event *event)
 {
 	struct udev_list_node *loop;
 	size_t common;
@@ -488,18 +492,21 @@ static int devpath_busy(struct event *event)
 
 		/* event we checked earlier still exists, no need to check again */
 		if (loop_event->seqnum == event->delaying_seqnum)
-			return 2;
+			return true;
 
 		/* found ourself, no later event can block us */
 		if (loop_event->seqnum >= event->seqnum)
 			break;
 
+		/* check major/minor */
+		if (major(event->devnum) != 0 && event->devnum == loop_event->devnum && event->is_block == loop_event->is_block)
+			return true;
+
 		/* check our old name */
-		if (event->devpath_old != NULL)
-			if (strcmp(loop_event->devpath, event->devpath_old) == 0) {
-				event->delaying_seqnum = loop_event->seqnum;
-				return 3;
-			}
+		if (event->devpath_old != NULL && strcmp(loop_event->devpath, event->devpath_old) == 0) {
+			event->delaying_seqnum = loop_event->seqnum;
+			return true;
+		}
 
 		/* compare devpath */
 		common = MIN(loop_event->devpath_len, event->devpath_len);
@@ -511,26 +518,26 @@ static int devpath_busy(struct event *event)
 		/* identical device event found */
 		if (loop_event->devpath_len == event->devpath_len) {
 			event->delaying_seqnum = loop_event->seqnum;
-			return 4;
+			return true;
 		}
 
 		/* parent device event found */
 		if (event->devpath[common] == '/') {
 			event->delaying_seqnum = loop_event->seqnum;
-			return 5;
+			return true;
 		}
 
 		/* child device event found */
 		if (loop_event->devpath[common] == '/') {
 			event->delaying_seqnum = loop_event->seqnum;
-			return 6;
+			return true;
 		}
 
 		/* no matching device */
 		continue;
 	}
 
-	return 0;
+	return false;
 }
 
 static void events_start(struct udev *udev)
@@ -544,7 +551,7 @@ static void events_start(struct udev *udev)
 			continue;
 
 		/* do not start event if parent or child event is still running */
-		if (devpath_busy(event) != 0) {
+		if (is_devpath_busy(event)) {
 			dbg(udev, "delay seq %llu (%s)\n", event->seqnum, event->devpath);
 			continue;
 		}


