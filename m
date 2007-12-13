Return-Path: <linux-kernel-owner+w=401wt.eu-S1760208AbXLMGlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208AbXLMGlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:41:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758807AbXLMGhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:37:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56283 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbXLMGhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:37:15 -0500
Date: Wed, 12 Dec 2007 22:34:29 -0800
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
Subject: [patch 10/36] I4L: fix isdn_ioctl memory overrun vulnerability
Message-ID: <20071213063429.GK25301@kroah.com>
References: <20071213062511.265908583@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i4l-fix-isdn_ioctl-memory-overrun-vulnerability.patch"
In-Reply-To: <20071213063308.GA25301@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.22-stable review patch.  If anyone has any objections, please let us
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
@@ -1514,6 +1514,7 @@ isdn_ioctl(struct inode *inode, struct f
 					if (copy_from_user(&iocts, argp,
 					     sizeof(isdn_ioctl_struct)))
 						return -EFAULT;
+					iocts.drvid[sizeof(iocts.drvid)-1] = 0;
 					if (strlen(iocts.drvid)) {
 						if ((p = strchr(iocts.drvid, ',')))
 							*p = 0;
@@ -1598,6 +1599,7 @@ isdn_ioctl(struct inode *inode, struct f
 					if (copy_from_user(&iocts, argp,
 					     sizeof(isdn_ioctl_struct)))
 						return -EFAULT;
+					iocts.drvid[sizeof(iocts.drvid)-1] = 0;
 					if (strlen(iocts.drvid)) {
 						drvidx = -1;
 						for (i = 0; i < ISDN_MAX_DRIVERS; i++)
@@ -1642,7 +1644,7 @@ isdn_ioctl(struct inode *inode, struct f
 					} else {
 						p = (char __user *) iocts.arg;
 						for (i = 0; i < 10; i++) {
-							sprintf(bname, "%s%s",
+							snprintf(bname, sizeof(bname), "%s%s",
 								strlen(dev->drv[drvidx]->msn2eaz[i]) ?
 								dev->drv[drvidx]->msn2eaz[i] : "_",
 								(i < 9) ? "," : "\0");
@@ -1672,6 +1674,7 @@ isdn_ioctl(struct inode *inode, struct f
 					char *p;
 					if (copy_from_user(&iocts, argp, sizeof(isdn_ioctl_struct)))
 						return -EFAULT;
+					iocts.drvid[sizeof(iocts.drvid)-1] = 0;
 					if (strlen(iocts.drvid)) {
 						if ((p = strchr(iocts.drvid, ',')))
 							*p = 0;

-- 
