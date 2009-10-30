Return-Path: <linux-kernel-owner+w=401wt.eu-S933033AbZJ3Wy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033AbZJ3Wy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 18:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933000AbZJ3Wy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 18:54:27 -0400
Received: from kroah.org ([198.145.64.141]:38961 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932995AbZJ3Wy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 18:54:26 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Stas Sergeev <stsp@aknet.ru>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/9] Driver core: fix driver_register() return value
Date: Fri, 30 Oct 2009 15:54:20 -0700
Message-Id: <1256943268-12164-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <20091030220930.GA11297@kroah.com>
References: <20091030220930.GA11297@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stas Sergeev <stsp@aknet.ru>

In this patch:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=16dc42e018c2868211b4928f20a957c0c216126c
the check was added for another driver to already claim the same device
on the same bus. But the returned error code was wrong: to modprobe, the
-EEXIST means that _this_ driver is already installed. It therefore
doesn't produce the needed error message when _another_ driver is trying
to register for the same device.  Returning -EBUSY fixes the problem.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/driver.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index ed2ebd3..f367885 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -236,7 +236,7 @@ int driver_register(struct device_driver *drv)
 		put_driver(other);
 		printk(KERN_ERR "Error: Driver '%s' is already registered, "
 			"aborting...\n", drv->name);
-		return -EEXIST;
+		return -EBUSY;
 	}
 
 	ret = bus_add_driver(drv);
-- 
1.6.4.2

