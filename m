Return-Path: <linux-kernel-owner+w=401wt.eu-S1753613AbYJZLIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbYJZLIG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 07:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYJZLHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 07:07:55 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47774 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbYJZLHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 07:07:54 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 26 Oct 2008 12:02:03 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [Bug 11824][PATCH] ieee1394: raw1394: fix possible deadlock in
 multithreaded clients
To: linux1394-devel@lists.sourceforge.net
cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       Dan Dennedy <dan@dennedy.org>, Johannes Weiner <hannes@saeurebad.de>
In-Reply-To: <4902F41E.5070306@s5r6.in-berlin.de>
Message-ID: <tkrat.94e673551b87c230@s5r6.in-berlin.de>
References: <bug-11824-4803@http.bugzilla.kernel.org/>
 <4902F41E.5070306@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regression in 2.6.28-rc1:  When I added the new state_mutex which
prevents corruption of raw1394's internal state when accessed by
multithreaded client applications, the following possible though
highly unlikely deadlock slipped in:

Thread A:                  Thread B:
 - acquire mmap_sem         - raw1394_write() or raw1394_ioctl()
 - raw1394_mmap()           - acquire state_mutex
 - acquire state_mutex      - copy_to/from_user(), possible page fault:
                              acquire mmap_sem

The simplest fix is to use mutex_trylock() instead of mutex_lock() in
raw1394_mmap().  This changes the behavior under contention in a way
which is visible to userspace clients.  However, since multithreaded
access was entirely buggy before state_mutex was added and libraw1394's
documentation advised application programmers to use a handle only in a
single thread, this change in behaviour should not be an issue in
practice at all.

Since we have to use mutex_trylock() in raw1394_mmap() regardless
whether /dev/raw1394 was opened with O_NONBLOCK or not, we now use
mutex_trylock() unconditionally everywhere for state_mutex, just to have
consistent behavior.

Reported-by: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Background:  That new state_mutex went only in because raw1394_ioctl()
already head some weak protection by the Big Kernel Lock, which I
removed for the general reasons pro BKL removal (get better performance
with local locks; make the locking clearer, easier to debug, more
reliable).

 drivers/ieee1394/raw1394.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux/drivers/ieee1394/raw1394.c
===================================================================
--- linux.orig/drivers/ieee1394/raw1394.c
+++ linux/drivers/ieee1394/raw1394.c
@@ -2268,7 +2268,8 @@ static ssize_t raw1394_write(struct file
 		return -EFAULT;
 	}
 
-	mutex_lock(&fi->state_mutex);
+	if (!mutex_trylock(&fi->state_mutex))
+		return -EAGAIN;
 
 	switch (fi->state) {
 	case opened:
@@ -2548,7 +2549,8 @@ static int raw1394_mmap(struct file *fil
 	struct file_info *fi = file->private_data;
 	int ret;
 
-	mutex_lock(&fi->state_mutex);
+	if (!mutex_trylock(&fi->state_mutex))
+		return -EAGAIN;
 
 	if (fi->iso_state == RAW1394_ISO_INACTIVE)
 		ret = -EINVAL;
@@ -2669,7 +2671,8 @@ static long raw1394_ioctl(struct file *f
 		break;
 	}
 
-	mutex_lock(&fi->state_mutex);
+	if (!mutex_trylock(&fi->state_mutex))
+		return -EAGAIN;
 
 	switch (fi->iso_state) {
 	case RAW1394_ISO_INACTIVE:

-- 
Stefan Richter
-=====-==--- =-=- ==-=-
http://arcgraph.de/sr/

