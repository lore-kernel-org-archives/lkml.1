Return-Path: <linux-kernel-owner+w=401wt.eu-S1759966AbYHIAzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbYHIAzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 20:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbYHIAy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 20:54:58 -0400
Received: from n28.bullet.mail.mud.yahoo.com ([68.142.206.223]:39758 "HELO
	n28.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751874AbYHIAy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 20:54:57 -0400
X-Yahoo-Newman-Id: 834847.73401.bm@omp418.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:X-Enigmail-Version:Content-Type:Content-Transfer-Encoding;
  b=vOGyOxAuwddECl0LJi46OPEpQWUZsNcNnrc5i/iALPfPgW75TReiDOdj0IdhIwtCmTCV/rLX+tah6t+E91QVSqkT5yXYVjU/WbO5BspuPIBRagaw/kGdDw1n2oqa30BOrMvH96UkmNopxVMurNNZ2kJeSUYoAWXuOH5U21urYBQ=  ;
X-YMail-OSG: RHaH6JcVM1ldZ6smeP3HyK7MWvYIMNmX.kseI7.xZZUQf1r7Vc5xMeWSzcH4v.QqjpLiSIN8lAKHDocBe97rGNXw_XHjxgZQFfgV5DpFeTjIZDn4xR3Hj.hfxGZWauGJMSI-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <489CEADE.4030905@yahoo.de>
Date: Sat, 09 Aug 2008 02:54:54 +0200
From: Christian Franke <cfchris6@yahoo.de>
User-Agent: Thunderbird 2.0.0.16 (X11/20080730)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc2] block: loop device partition support
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Franke <cfchris6@yahoo.de>

By default, partition support of loop devices is disabled and there seems to be 
no way to turn it on without changing code, if loop is not compiled as module.
This patch introduces CONFIG_BLK_DEV_LOOP_MAXPART to make partition support 
configurable via Kconfig. It keeps that feature disabled by default for not 
breaking backward compatibility.

Signed-off-by: Christian Franke <cfchris6@yahoo.de>
---
--- linux-2.6/drivers/block/Kconfig
+++ linux-2.6-loop/drivers/block/Kconfig
@@ -248,6 +248,23 @@ config BLK_DEV_LOOP

  	  Most users will answer N here.

+config BLK_DEV_LOOP_MAXPART
+	int "Maximum number of partitions per loop device"
+	default "0"
+	depends on BLK_DEV_LOOP
+	---help---
+	  Loop device partition support is disabled by default. If max_part
+	  is non-zero, partition support for loop devices is enabled for up to
+	  max_part partitions.
+
+	  Note: If you compile loop as module, you can also pass max_part as
+	        parameter when loading it.
+
+	  Warning: non-zero values break compatibility with applications which
+	           access the loop devices via major and minor number.
+
+	  Most users will answer 0 here.
+
  config BLK_DEV_CRYPTOLOOP
  	tristate "Cryptoloop Support"
  	select CRYPTO
--- linux-2.6/drivers/block/loop.c
+++ linux-2.6-loop/drivers/block/loop.c
@@ -82,7 +82,7 @@
  static LIST_HEAD(loop_devices);
  static DEFINE_MUTEX(loop_devices_mutex);

-static int max_part;
+static int max_part = CONFIG_BLK_DEV_LOOP_MAXPART;
  static int part_shift;

  /*

