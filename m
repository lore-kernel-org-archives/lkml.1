Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbYFVQbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbYFVQbT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 12:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYFVQbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 12:31:09 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49985 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbYFVQbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 12:31:07 -0400
Date: Sun, 22 Jun 2008 19:29:17 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: [2.6.26 patch] fix the request_firmware() dummy
Message-ID: <20080622162917.GB20122@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>

> the build (.config attached) failed, make ends with :
> ...
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      vmlinux
> drivers/built-in.o: In function `sas_request_addr':
> (.text+0x33bab): undefined reference to `request_firmware'
> drivers/built-in.o: In function `sas_request_addr':
> (.text+0x33c3f): undefined reference to `release_firmware'
> make: *** [vmlinux] Error 1

There's a slight fault in the stub logic.  It fails for FW_LOADER=m and
the user =y.

This should fix it.

This patch fixes the following 2.6.26-rc regression:
  http://bugzilla.kernel.org/show_bug.cgi?id=10730

Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

@James:
Please complain if you consider my forwarding of your patch 
inappropriate.

diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index 4d10c73..6c7eff2 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -13,7 +13,7 @@ struct firmware {
 
 struct device;
 
-#if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
+#if defined(CONFIG_FW_LOADER) || (defined(CONFIG_FW_LOADER_MODULE) && defined(MODULE))
 int request_firmware(const struct firmware **fw, const char *name,
 		     struct device *device);
 int request_firmware_nowait(


