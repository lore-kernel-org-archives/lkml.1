Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbXD3Wry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbXD3Wry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 18:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbXD3Wry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 18:47:54 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:43683 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575AbXD3Wrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 18:47:53 -0400
Date: Mon, 30 Apr 2007 16:48:29 -0600
From: dann frazier <dannf@hp.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>, support@moxa.com.tw, dilinger@debian.org
Subject: old buffer overflow in moxa driver
Message-ID: <20070430224829.GI31283@krebs.dannf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hey,
  I noticed that the moxa input checking security bug described by
CVE-2005-0504 appears to remain unfixed upstream.
 
The issue is described here:
  http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2005-0504

Debian has been shipping the following patch from Andres Salomon. I
tried contacting the listed maintainer a few months ago but received
no response.

I've tested that this still applies to and compiles against 2.6.21.

Signed-off-by: dann frazier <dannf@hp.com>

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 7dbaee8..e0d35c2 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -1582,7 +1582,7 @@ copy:
 
 	if(copy_from_user(&dltmp, argp, sizeof(struct dl_str)))
 		return -EFAULT;
-	if(dltmp.cardno < 0 || dltmp.cardno >= MAX_BOARDS)
+	if(dltmp.cardno < 0 || dltmp.cardno >= MAX_BOARDS || dltmp.len < 0)
 		return -EINVAL;
 
 	switch(cmd)
@@ -2529,6 +2529,8 @@ static int moxaloadbios(int cardno, unsigned char __user *tmp, int len)
 	void __iomem *baseAddr;
 	int i;
 
+	if(len < 0 || len > sizeof(moxaBuff))
+		return -EINVAL;
 	if(copy_from_user(moxaBuff, tmp, len))
 		return -EFAULT;
 	baseAddr = moxa_boards[cardno].basemem;
@@ -2576,7 +2578,7 @@ static int moxaload320b(int cardno, unsigned char __user *tmp, int len)
 	void __iomem *baseAddr;
 	int i;
 
-	if(len > sizeof(moxaBuff))
+	if(len < 0 || len > sizeof(moxaBuff))
 		return -EINVAL;
 	if(copy_from_user(moxaBuff, tmp, len))
 		return -EFAULT;
@@ -2596,6 +2598,8 @@ static int moxaloadcode(int cardno, unsigned char __user *tmp, int len)
 	void __iomem *baseAddr, *ofsAddr;
 	int retval, port, i;
 
+	if(len < 0 || len > sizeof(moxaBuff))
+		return -EINVAL;
 	if(copy_from_user(moxaBuff, tmp, len))
 		return -EFAULT;
 	baseAddr = moxa_boards[cardno].basemem;

-- 
dann frazier
