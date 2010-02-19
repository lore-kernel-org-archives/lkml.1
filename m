Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab0BSRAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:00:48 -0500
Received: from kroah.org ([198.145.64.141]:57550 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741Ab0BSRAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:38 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:42 2010
Message-Id: <20100219163241.855102408@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Francesco Lavra <francescolavra@interfree.it>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [40/93] V4L/DVB: dvb-core: fix initialization of feeds list in demux filter
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Francesco Lavra <francescolavra@interfree.it>

commit 691c9ae099b9bcb5c27125af00a4a90120977458 upstream.

A DVB demultiplexer device can be used to set up either a PES filter or
a section filter. In the former case, the ts field of the feed union of
struct dmxdev_filter is used, in the latter case the sec field of the
same union is used.
The ts field is a struct list_head, and is currently initialized in the
open() method of the demux device. When for a given demuxer a section
filter is set up, the sec field is played with, thus if a PES filter
needs to be set up after that the ts field will be corrupted, causing a
kernel oops.
This fix moves the list head initialization to
dvb_dmxdev_pes_filter_set(), so that the ts field is properly
initialized every time a PES filter is set up.

Signed-off-by: Francesco Lavra <francescolavra@interfree.it>
Reviewed-by: Andy Walls <awalls@radix.net>
Tested-by: hermann pitton <hermann-pitton@arcor.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/dvb-core/dmxdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/dvb/dvb-core/dmxdev.c
+++ b/drivers/media/dvb/dvb-core/dmxdev.c
@@ -761,7 +761,6 @@ static int dvb_demux_open(struct inode *
 	dvb_ringbuffer_init(&dmxdevfilter->buffer, NULL, 8192);
 	dmxdevfilter->type = DMXDEV_TYPE_NONE;
 	dvb_dmxdev_filter_state_set(dmxdevfilter, DMXDEV_STATE_ALLOCATED);
-	INIT_LIST_HEAD(&dmxdevfilter->feed.ts);
 	init_timer(&dmxdevfilter->timer);
 
 	dvbdev->users++;
@@ -887,6 +886,7 @@ static int dvb_dmxdev_pes_filter_set(str
 	dmxdevfilter->type = DMXDEV_TYPE_PES;
 	memcpy(&dmxdevfilter->params, params,
 	       sizeof(struct dmx_pes_filter_params));
+	INIT_LIST_HEAD(&dmxdevfilter->feed.ts);
 
 	dvb_dmxdev_filter_state_set(dmxdevfilter, DMXDEV_STATE_SET);
 


