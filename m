Return-Path: <linux-kernel-owner+w=401wt.eu-S1759474AbXGCKkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474AbXGCKkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 06:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756734AbXGCKkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 06:40:37 -0400
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:37381 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329AbXGCKkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 06:40:36 -0400
X-Greylist: delayed 766 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jul 2007 06:40:36 EDT
Subject: Re: [EXT4 set 3][PATCH 1/1] ext4 nanosecond timestamp
From: Kalpak Shah <kalpak@clusterfs.com>
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mingming Cao <cmm@us.ibm.com>
In-Reply-To: <1183275416.4010.125.camel@localhost.localdomain>
References: <1183275416.4010.125.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 03 Jul 2007 16:11:15 +0530
Message-Id: <1183459275.4102.6.camel@garfield.linsyssoft.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SystemSpamProbe: GOOD 0.0001384 c75befa7267205d4cdb113f3fb55015c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-01 at 03:36 -0400, Mingming Cao wrote:
> +
> +#define EXT4_INODE_GET_XTIME(xtime, inode, raw_inode)                               \
> +do {                                                                        \
> +     (inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);               \
> +     if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))     \
> +             ext4_decode_extra_time(&(inode)->xtime,                        \
> +                                    raw_inode->xtime ## _extra);            \
> +} while (0)
> +
> +#define EXT4_EINODE_GET_XTIME(xtime, einode, raw_inode)                             \
> +do {                                                                        \
> +     if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))                      \
> +             (einode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);      \
> +     if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))            \
> +             ext4_decode_extra_time(&(einode)->xtime,                       \
> +                                    raw_inode->xtime ## _extra);            \
> +} while (0)
> +

This nanosecond patch seems to be missing the fix below which is required for http://bugzilla.kernel.org/show_bug.cgi?id=5079

If the timestamp is set to before epoch i.e. a negative timestamp then the file may have its date set into the future on 64-bit systems. So when the timestamp is read it must be cast as signed.

Index: linux-2.6.21/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.21.orig/include/linux/ext4_fs.h
+++ linux-2.6.21/include/linux/ext4_fs.h
@@ -390,7 +390,7 @@ do {                                                                               \

 #define EXT4_INODE_GET_XTIME(xtime, inode, raw_inode)                         \
 do {                                                                          \
-       (inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);               \
+       (inode)->xtime.tv_sec = (signed)le32_to_cpu((raw_inode)->xtime);       \
        if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))     \
                ext4_decode_extra_time(&(inode)->xtime,                        \
                                       raw_inode->xtime ## _extra);            \
@@ -399,7 +399,8 @@ do {                                                                               \
 #define EXT4_EINODE_GET_XTIME(xtime, einode, raw_inode)                               \
 do {                                                                          \
        if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))                      \
-               (einode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);      \
+               (einode)->xtime.tv_sec =                                       \
+                               (signed)le32_to_cpu((raw_inode)->xtime);       \
        if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))            \
                ext4_decode_extra_time(&(einode)->xtime,                       \
                                       raw_inode->xtime ## _extra);            \


Thanks,
Kalpak.


