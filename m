Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbYKPSHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbYKPSHZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbYKPSHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:07:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:11102 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbYKPSHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:07:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=cQuhL5UuRJvB+msmdzko8R3lmnfKxYeDACKFAeNTIC/tGAcICbXwl90FayJox04RlK
         vHYiOsDepr/u2Ur2F4zO1pecexRvxUgXbF0b/m7hQcD2671gqNmCoQ+NycftVI/jM5TD
         wE0JwCQ4H0lqnTDpChkLK4Kgz56qSFXl8yT4M=
Date: Sun, 16 Nov 2008 19:06:37 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/2] cdrom: reduce stack usage of mmc_ioctl_dvd_read_struct
Message-ID: <20081116180631.GD6282@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. kmalloc 192 bytes in dvd_read_bca (which is inlined into dvd_read_struct)
2. Pass struct packet_command to all dvd_read_* functions.

Checkstack output:
Before: mmc_ioctl_dvd_read_struct:         280
After:  mmc_ioctl_dvd_read_struct:         56

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/cdrom/cdrom.c |  139 +++++++++++++++++++++++++++----------------------
 1 files changed, 77 insertions(+), 62 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index eb6f6ad..7946653 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -1712,29 +1712,30 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 	return 0;
 }
 
-static int dvd_read_physical(struct cdrom_device_info *cdi, dvd_struct *s)
+static int dvd_read_physical(struct cdrom_device_info *cdi, dvd_struct *s,
+				struct packet_command *cgc)
 {
 	unsigned char buf[21], *base;
 	struct dvd_layer *layer;
-	struct packet_command cgc;
 	struct cdrom_device_ops *cdo = cdi->ops;
 	int ret, layer_num = s->physical.layer_num;
 
 	if (layer_num >= DVD_LAYERS)
 		return -EINVAL;
 
-	init_cdrom_command(&cgc, buf, sizeof(buf), CGC_DATA_READ);
-	cgc.cmd[0] = GPCMD_READ_DVD_STRUCTURE;
-	cgc.cmd[6] = layer_num;
-	cgc.cmd[7] = s->type;
-	cgc.cmd[9] = cgc.buflen & 0xff;
+	init_cdrom_command(cgc, buf, sizeof(buf), CGC_DATA_READ);
+	cgc->cmd[0] = GPCMD_READ_DVD_STRUCTURE;
+	cgc->cmd[6] = layer_num;
+	cgc->cmd[7] = s->type;
+	cgc->cmd[9] = cgc->buflen & 0xff;
 
 	/*
 	 * refrain from reporting errors on non-existing layers (mainly)
 	 */
-	cgc.quiet = 1;
+	cgc->quiet = 1;
 
-	if ((ret = cdo->generic_packet(cdi, &cgc)))
+	ret = cdo->generic_packet(cdi, cgc);
+	if (ret)
 		return ret;
 
 	base = &buf[4];
@@ -1762,21 +1763,22 @@ static int dvd_read_physical(struct cdrom_device_info *cdi, dvd_struct *s)
 	return 0;
 }
 
-static int dvd_read_copyright(struct cdrom_device_info *cdi, dvd_struct *s)
+static int dvd_read_copyright(struct cdrom_device_info *cdi, dvd_struct *s,
+				struct packet_command *cgc)
 {
 	int ret;
 	u_char buf[8];
-	struct packet_command cgc;
 	struct cdrom_device_ops *cdo = cdi->ops;
 
-	init_cdrom_command(&cgc, buf, sizeof(buf), CGC_DATA_READ);
-	cgc.cmd[0] = GPCMD_READ_DVD_STRUCTURE;
-	cgc.cmd[6] = s->copyright.layer_num;
-	cgc.cmd[7] = s->type;
-	cgc.cmd[8] = cgc.buflen >> 8;
-	cgc.cmd[9] = cgc.buflen & 0xff;
+	init_cdrom_command(cgc, buf, sizeof(buf), CGC_DATA_READ);
+	cgc->cmd[0] = GPCMD_READ_DVD_STRUCTURE;
+	cgc->cmd[6] = s->copyright.layer_num;
+	cgc->cmd[7] = s->type;
+	cgc->cmd[8] = cgc->buflen >> 8;
+	cgc->cmd[9] = cgc->buflen & 0xff;
 
-	if ((ret = cdo->generic_packet(cdi, &cgc)))
+	ret = cdo->generic_packet(cdi, cgc);
+	if (ret)
 		return ret;
 
 	s->copyright.cpst = buf[4];
@@ -1785,79 +1787,89 @@ static int dvd_read_copyright(struct cdrom_device_info *cdi, dvd_struct *s)
 	return 0;
 }
 
-static int dvd_read_disckey(struct cdrom_device_info *cdi, dvd_struct *s)
+static int dvd_read_disckey(struct cdrom_device_info *cdi, dvd_struct *s,
+				struct packet_command *cgc)
 {
 	int ret, size;
 	u_char *buf;
-	struct packet_command cgc;
 	struct cdrom_device_ops *cdo = cdi->ops;
 
 	size = sizeof(s->disckey.value) + 4;
 
-	if ((buf = kmalloc(size, GFP_KERNEL)) == NULL)
+	buf = kmalloc(size, GFP_KERNEL);
+	if (!buf)
 		return -ENOMEM;
 
-	init_cdrom_command(&cgc, buf, size, CGC_DATA_READ);
-	cgc.cmd[0] = GPCMD_READ_DVD_STRUCTURE;
-	cgc.cmd[7] = s->type;
-	cgc.cmd[8] = size >> 8;
-	cgc.cmd[9] = size & 0xff;
-	cgc.cmd[10] = s->disckey.agid << 6;
+	init_cdrom_command(cgc, buf, size, CGC_DATA_READ);
+	cgc->cmd[0] = GPCMD_READ_DVD_STRUCTURE;
+	cgc->cmd[7] = s->type;
+	cgc->cmd[8] = size >> 8;
+	cgc->cmd[9] = size & 0xff;
+	cgc->cmd[10] = s->disckey.agid << 6;
 
-	if (!(ret = cdo->generic_packet(cdi, &cgc)))
+	ret = cdo->generic_packet(cdi, cgc);
+	if (!ret)
 		memcpy(s->disckey.value, &buf[4], sizeof(s->disckey.value));
 
 	kfree(buf);
 	return ret;
 }
 
-static int dvd_read_bca(struct cdrom_device_info *cdi, dvd_struct *s)
+static int dvd_read_bca(struct cdrom_device_info *cdi, dvd_struct *s,
+			struct packet_command *cgc)
 {
-	int ret;
-	u_char buf[4 + 188];
-	struct packet_command cgc;
+	int ret, size = 4 + 188;
+	u_char *buf;
 	struct cdrom_device_ops *cdo = cdi->ops;
 
-	init_cdrom_command(&cgc, buf, sizeof(buf), CGC_DATA_READ);
-	cgc.cmd[0] = GPCMD_READ_DVD_STRUCTURE;
-	cgc.cmd[7] = s->type;
-	cgc.cmd[9] = cgc.buflen & 0xff;
+	buf = kmalloc(size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
-	if ((ret = cdo->generic_packet(cdi, &cgc)))
-		return ret;
+	init_cdrom_command(cgc, buf, size, CGC_DATA_READ);
+	cgc->cmd[0] = GPCMD_READ_DVD_STRUCTURE;
+	cgc->cmd[7] = s->type;
+	cgc->cmd[9] = cgc->buflen & 0xff;
+
+	ret = cdo->generic_packet(cdi, cgc);
+	if (ret)
+		goto out;
 
 	s->bca.len = buf[0] << 8 | buf[1];
 	if (s->bca.len < 12 || s->bca.len > 188) {
 		cdinfo(CD_WARNING, "Received invalid BCA length (%d)\n", s->bca.len);
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}
 	memcpy(s->bca.value, &buf[4], s->bca.len);
-
-	return 0;
+	ret = 0;
+out:
+	kfree(buf);
+	return ret;
 }
 
-static int dvd_read_manufact(struct cdrom_device_info *cdi, dvd_struct *s)
+static int dvd_read_manufact(struct cdrom_device_info *cdi, dvd_struct *s,
+				struct packet_command *cgc)
 {
 	int ret = 0, size;
 	u_char *buf;
-	struct packet_command cgc;
 	struct cdrom_device_ops *cdo = cdi->ops;
 
 	size = sizeof(s->manufact.value) + 4;
 
-	if ((buf = kmalloc(size, GFP_KERNEL)) == NULL)
+	buf = kmalloc(size, GFP_KERNEL);
+	if (!buf)
 		return -ENOMEM;
 
-	init_cdrom_command(&cgc, buf, size, CGC_DATA_READ);
-	cgc.cmd[0] = GPCMD_READ_DVD_STRUCTURE;
-	cgc.cmd[7] = s->type;
-	cgc.cmd[8] = size >> 8;
-	cgc.cmd[9] = size & 0xff;
+	init_cdrom_command(cgc, buf, size, CGC_DATA_READ);
+	cgc->cmd[0] = GPCMD_READ_DVD_STRUCTURE;
+	cgc->cmd[7] = s->type;
+	cgc->cmd[8] = size >> 8;
+	cgc->cmd[9] = size & 0xff;
 
-	if ((ret = cdo->generic_packet(cdi, &cgc))) {
-		kfree(buf);
-		return ret;
-	}
+	ret = cdo->generic_packet(cdi, cgc);
+	if (ret)
+		goto out;
 
 	s->manufact.len = buf[0] << 8 | buf[1];
 	if (s->manufact.len < 0 || s->manufact.len > 2048) {
@@ -1868,27 +1880,29 @@ static int dvd_read_manufact(struct cdrom_device_info *cdi, dvd_struct *s)
 		memcpy(s->manufact.value, &buf[4], s->manufact.len);
 	}
 
+out:
 	kfree(buf);
 	return ret;
 }
 
-static int dvd_read_struct(struct cdrom_device_info *cdi, dvd_struct *s)
+static int dvd_read_struct(struct cdrom_device_info *cdi, dvd_struct *s,
+				struct packet_command *cgc)
 {
 	switch (s->type) {
 	case DVD_STRUCT_PHYSICAL:
-		return dvd_read_physical(cdi, s);
+		return dvd_read_physical(cdi, s, cgc);
 
 	case DVD_STRUCT_COPYRIGHT:
-		return dvd_read_copyright(cdi, s);
+		return dvd_read_copyright(cdi, s, cgc);
 
 	case DVD_STRUCT_DISCKEY:
-		return dvd_read_disckey(cdi, s);
+		return dvd_read_disckey(cdi, s, cgc);
 
 	case DVD_STRUCT_BCA:
-		return dvd_read_bca(cdi, s);
+		return dvd_read_bca(cdi, s, cgc);
 
 	case DVD_STRUCT_MANUFACT:
-		return dvd_read_manufact(cdi, s);
+		return dvd_read_manufact(cdi, s, cgc);
 		
 	default:
 		cdinfo(CD_WARNING, ": Invalid DVD structure read requested (%d)\n",
@@ -3023,7 +3037,8 @@ static noinline int mmc_ioctl_cdrom_pause_resume(struct cdrom_device_info *cdi,
 }
 
 static noinline int mmc_ioctl_dvd_read_struct(struct cdrom_device_info *cdi,
-						void __user *arg)
+						void __user *arg,
+						struct packet_command *cgc)
 {
 	int ret;
 	dvd_struct *s;
@@ -3042,7 +3057,7 @@ static noinline int mmc_ioctl_dvd_read_struct(struct cdrom_device_info *cdi,
 		return -EFAULT;
 	}
 
-	ret = dvd_read_struct(cdi, s);
+	ret = dvd_read_struct(cdi, s, cgc);
 	if (ret)
 		goto out;
 
@@ -3128,7 +3143,7 @@ static int mmc_ioctl(struct cdrom_device_info *cdi, unsigned int cmd,
 	case CDROMRESUME:
 		return mmc_ioctl_cdrom_pause_resume(cdi, &cgc, cmd);
 	case DVD_READ_STRUCT:
-		return mmc_ioctl_dvd_read_struct(cdi, userptr);
+		return mmc_ioctl_dvd_read_struct(cdi, userptr, &cgc);
 	case DVD_AUTH:
 		return mmc_ioctl_dvd_auth(cdi, userptr);
 	case CDROM_NEXT_WRITABLE:
-- 
1.5.6.4

