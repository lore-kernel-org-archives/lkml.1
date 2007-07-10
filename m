Return-Path: <linux-kernel-owner+w=401wt.eu-S1764251AbXGJJrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764251AbXGJJrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760460AbXGJJrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:47:46 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:7531 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758084AbXGJJro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:47:44 -0400
Date: Tue, 10 Jul 2007 11:47:43 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: linux-fsdevel@vger.kernel.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       hirofumi@mail.parknet.co.jp
Subject: utimes() with vfat is problematic
Message-ID: <Pine.LNX.4.64.0707101142270.11053@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,



vfat does not know about ownership, hence the files are always owned by the
vfat mounter (or whatever the uid= option specified). Which brings 
a problem to userspace programs trying to utime() but which do not 
run as the same user as the vfat mounter, because:


fs/attr.c:53
	ret = -EPERM;
	[...]

	/* Check for setting the inode time. */
	if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET)) {
		if (current->fsuid != inode->i_uid && !capable(CAP_FOWNER))
                        goto error;
        }


To trigger the problem:
	# mount /somevfat -o umask=0,uid=root
	$ touch -d "2005-05-05" /somevfat/myfile

I am not sure how this could be dealt with besides passing -o quiet to 
mount.vfat. Any ideas?



	Jan
-- 
