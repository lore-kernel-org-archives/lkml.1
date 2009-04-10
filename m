Return-Path: <linux-kernel-owner+w=401wt.eu-S1757704AbZDJPbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704AbZDJPbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 11:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbZDJPbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 11:31:32 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:47568 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZDJPbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 11:31:31 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: tom.leiming@gmail.com
Cc: kay.sievers@vrfy.org, greg@kroah.com, cornelia.huck@de.ibm.com,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com
Subject: Re: [PATCH] driver core: check bus->match without holding device lock(v2)
References: <1232551667-4829-1-git-send-email-tom.leiming@gmail.com>
X-Yow: I always liked FLAG DAY!!
Date: Fri, 10 Apr 2009 17:31:24 +0200
In-Reply-To: <1232551667-4829-1-git-send-email-tom.leiming@gmail.com> (tom
	leiming's message of "Wed, 21 Jan 2009 23:27:47 +0800")
Message-ID: <m2fxggle43.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tom.leiming@gmail.com writes:

> +static inline int driver_match_device(struct device_driver *drv,
> +				      struct device *dev)
> +{
> +	return drv->bus->match && drv->bus->match(dev, drv);
> +}

This logic is wrong.  !(a && !b) <=> !a || b, not a && b

A bus that does not have a match function now never matches, whereas
previously it would always match.  This breaks aoa-soundbus.

Andreas.
---
driver core: Fix logic in driver_match_device

A bus that does not have a match function always matches.  This fixes
49b420a13ff9 ("driver core: check bus->match without holding device
lock").

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
---
 drivers/base/base.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index ddc9749..087e911 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -115,7 +115,7 @@ extern int driver_probe_device(struct device_driver *drv, struct device *dev);
 static inline int driver_match_device(struct device_driver *drv,
 				      struct device *dev)
 {
-	return drv->bus->match && drv->bus->match(dev, drv);
+	return !drv->bus->match || drv->bus->match(dev, drv);
 }
 
 extern void sysdev_shutdown(void);

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
