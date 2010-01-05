Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955Ab0AEAwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab0AEAwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628Ab0AEAvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:51:51 -0500
Received: from kroah.org ([198.145.64.141]:34178 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205Ab0AEAfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:01 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Julia Lawall <julia@diku.dk>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 27/97] drivers/net/usb: Correct code taking the size of a pointer
Date: Mon,  4 Jan 2010 16:32:40 -0800
Message-Id: <1262651630-7354-27-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

commit 6057912d7baad31be9819518674ffad349a065b1 upstream.

sizeof(dev->dev_addr) is the size of a pointer.  A few lines above, the
size of this field is obtained using netdev->addr_len for a call to memcpy,
so do the same here.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression *x;
expression f;
type T;
@@

*f(...,(T)x,...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/usb/rtl8150.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index b091e20..f14d225 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -324,7 +324,7 @@ static int rtl8150_set_mac_address(struct net_device *netdev, void *p)
 		dbg("%02X:", netdev->dev_addr[i]);
 	dbg("%02X\n", netdev->dev_addr[i]);
 	/* Set the IDR registers. */
-	set_registers(dev, IDR, sizeof(netdev->dev_addr), netdev->dev_addr);
+	set_registers(dev, IDR, netdev->addr_len, netdev->dev_addr);
 #ifdef EEPROM_WRITE
 	{
 	u8 cr;
-- 
1.6.6

