Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbYHOWPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbYHOWPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 18:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbYHOWPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 18:15:34 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40636 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbYHOWPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 18:15:33 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 16 Aug 2008 00:15:16 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [RFC patch 3/3] ieee1394: raw1394: make write() thread-safe
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.39c930f50f011685@s5r6.in-berlin.de>
Message-ID: <tkrat.96c860da86743cd5@s5r6.in-berlin.de>
References: <tkrat.0df9cff587ba5fed@s5r6.in-berlin.de>
 <tkrat.39c930f50f011685@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Application programs should use a libraw1394 handle only in a single
thread.  The raw1394 driver was apparently relying on this, because it
did nothing to protect its fi->state variable from corruption due to
concurrent accesses.

We now serialize the fi->state accesses.  This affects the write() path.
We re-use the state_mutex which was introduced to protect fi->iso_state
accesses in the ioctl() path.  These paths and accesses are independent
of each other, hence separate mutexes could be used.  But I don't see
much benefit in that.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/raw1394.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/drivers/ieee1394/raw1394.c
===================================================================
--- linux.orig/drivers/ieee1394/raw1394.c
+++ linux/drivers/ieee1394/raw1394.c
@@ -2268,6 +2268,8 @@ static ssize_t raw1394_write(struct file
 		return -EFAULT;
 	}
 
+	mutex_lock(&fi->state_mutex);
+
 	switch (fi->state) {
 	case opened:
 		retval = state_opened(fi, req);
@@ -2282,6 +2284,8 @@ static ssize_t raw1394_write(struct file
 		break;
 	}
 
+	mutex_unlock(&fi->state_mutex);
+
 	if (retval < 0) {
 		free_pending_request(req);
 	} else {

-- 
Stefan Richter
-=====-==--- =--- =----
http://arcgraph.de/sr/

