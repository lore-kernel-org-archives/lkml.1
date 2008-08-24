Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbYHXUt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbYHXUt0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 16:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYHXUtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 16:49:18 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:46965 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbYHXUtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 16:49:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=MaGTcOjj8jHH+R/5tAU0D0ZwU5611XPnfUcJ/r0m9K0ydZmgZbwBjH7VHlktew3G6Z
         VPEFdpaXuQrbC7nFik5/KVMLti0zWENSZKdieg/7IeLPl10SFrv1CCs7nvxxqnVcHaL0
         naQit4hhaFfd2zq6P4s7NevxcNJ0tWHl5zHp8=
Message-ID: <7b9198260808241349v45c4d5ffjd908c7ffe34286a1@mail.gmail.com>
Date: Sun, 24 Aug 2008 21:49:15 +0100
From: "Tom Spink" <tspink@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>, "Jeff Dike" <jdike@addtoit.com>
Subject: UML Reboot Panic
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When using UML with a UML block device, and issuing a reboot, I was
getting a kernel panic on the next kernel startup because UML was
unable to open the file mapped to the UBD.  I think this is because
the file is not closed when the UBD is released, and the following
patch appears to resolve this issue.  I'm not sure if it's the right
fix, as I may have missed something, but it works for me.

-- Tom

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index b58fb89..946a171 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -802,6 +802,7 @@ static void ubd_device_release(struct device *dev)
        struct ubd *ubd_dev = dev->driver_data;

        blk_cleanup_queue(ubd_dev->queue);
+       os_close_file(ubd_dev->fd);
        *ubd_dev = ((struct ubd) DEFAULT_UBD);
 }
