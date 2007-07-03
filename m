Return-Path: <linux-kernel-owner+w=401wt.eu-S1758777AbXGCKwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbXGCKwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 06:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbXGCKv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 06:51:56 -0400
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:49828 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbXGCKvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 06:51:55 -0400
Subject: Re: [EXT4 set 3][PATCH 1/1] ext4 nanosecond timestamp
From: Kalpak Shah <kalpak@clusterfs.com>
To: cmm@us.ibm.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
In-Reply-To: <1183275416.4010.125.camel@localhost.localdomain>
References: <1183275416.4010.125.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 03 Jul 2007 15:58:26 +0530
Message-Id: <1183458506.4102.5.camel@garfield.linsyssoft.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SystemSpamProbe: GOOD 0.0006662 650f71ebac8952bbe9935771b951d0de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-01 at 03:36 -0400, Mingming Cao wrote:
> +
> +#define EXT4_INODE_GET_XTIME(xtime, inode, raw_inode)			       \
> +do {									       \
> +	(inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);	       \
> +	if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))     \
> +		ext4_decode_extra_time(&(inode)->xtime,			       \
> +				       raw_inode->xtime ## _extra);	       \
> +} while (0)
> +
> +#define EXT4_EINODE_GET_XTIME(xtime, einode, raw_inode)			       \
> +do {									       \
> +	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))		       \
> +		(einode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);      \
> +	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))	       \
> +		ext4_decode_extra_time(&(einode)->xtime,		       \
> +				       raw_inode->xtime ## _extra);	       \
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

