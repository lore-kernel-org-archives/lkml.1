Return-Path: <linux-kernel-owner+w=401wt.eu-S1762946AbXLMHBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762946AbXLMHBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761292AbXLMG4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:56:07 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55107 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758911AbXLMG4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:56:04 -0500
Date: Wed, 12 Dec 2007 22:51:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, adlab@venustech.com.cn, kkeil@suse.de
Subject: [patch 13/60] I4L: fix isdn_ioctl memory overrun vulnerability
Message-ID: <20071213065137.GN6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i4l-fix-isdn_ioctl-memory-overrun-vulnerability.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Karsten Keil <kkeil@suse.de>

patch eafe1aa37e6ec2d56f14732b5240c4dd09f0613a in mainline.

Fix possible memory overrun issue in the isdn ioctl code.  Found by ADLAB
<adlab@venustech.com.cn>

Signed-off-by: Karsten Keil <kkeil@suse.de>
Cc: ADLAB <adlab@venustech.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/i4l/isdn_common.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -1515,6 +1515,7 @@ isdn_ioctl(struct inode *inode, struct f
 					if (copy_from_user(&iocts, argp,
 					     sizeof(isdn_ioctl_struct)))
 						return -EFAULT;
+					iocts.drvid[sizeof(iocts.drvid)-1] = 0;
 					if (strlen(iocts.drvid)) {
 						if ((p = strchr(iocts.drvid, ',')))
 							*p = 0;
@@ -1599,6 +1600,7 @@ isdn_ioctl(struct inode *inode, struct f
 					if (copy_from_user(&iocts, argp,
 					     sizeof(isdn_ioctl_struct)))
 						return -EFAULT;
+					iocts.drvid[sizeof(iocts.drvid)-1] = 0;
 					if (strlen(iocts.drvid)) {
 						drvidx = -1;
 						for (i = 0; i < ISDN_MAX_DRIVERS; i++)
@@ -1643,7 +1645,7 @@ isdn_ioctl(struct inode *inode, struct f
 					} else {
 						p = (char __user *) iocts.arg;
 						for (i = 0; i < 10; i++) {
-							sprintf(bname, "%s%s",
+							snprintf(bname, sizeof(bname), "%s%s",
 								strlen(dev->drv[drvidx]->msn2eaz[i]) ?
 								dev->drv[drvidx]->msn2eaz[i] : "_",
 								(i < 9) ? "," : "\0");
@@ -1673,6 +1675,7 @@ isdn_ioctl(struct inode *inode, struct f
 					char *p;
 					if (copy_from_user(&iocts, argp, sizeof(isdn_ioctl_struct)))
 						return -EFAULT;
+					iocts.drvid[sizeof(iocts.drvid)-1] = 0;
 					if (strlen(iocts.drvid)) {
 						if ((p = strchr(iocts.drvid, ',')))
 							*p = 0;

-- 
