Return-Path: <linux-kernel-owner+w=401wt.eu-S1757574AbYCQJjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbYCQJjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 05:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbYCQJhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 05:37:48 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:42594 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754022AbYCQJh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 05:37:28 -0400
From: =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] drivers/net/tokenring/3c359.c: Use time_* macros
Date: Mon, 17 Mar 2008 11:36:30 +0200
Message-Id: <1205746593-24820-8-git-send-email-caglar@pardus.org.tr>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1205746593-24820-7-git-send-email-caglar@pardus.org.tr>
References: <>
 <1205746593-24820-1-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-2-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-3-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-4-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-5-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-6-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-7-git-send-email-caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions time_before, time_before_eq, time_after, and time_after_eq are more robust for comparing jiffies against other values.

So following patch implements usage of the time_after() macro, defined at linux/jiffies.h, which deals with wrapping correctly

Cc: netdev@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
---
 drivers/net/tokenring/3c359.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/tokenring/3c359.c b/drivers/net/tokenring/3c359.c
index 44a06f8..88fe955 100644
--- a/drivers/net/tokenring/3c359.c
+++ b/drivers/net/tokenring/3c359.c
@@ -42,6 +42,7 @@
 
 #define XL_DEBUG 0
 
+#include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -408,7 +409,7 @@ static int xl_hw_reset(struct net_device *dev)
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(jiffies-t > 40*HZ) {
+		if(time_after(jiffies, t + 40 * HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL  card not responding to global reset.\n", dev->name);
 			return -ENODEV;
 		}
@@ -519,7 +520,7 @@ static int xl_hw_reset(struct net_device *dev)
 	t=jiffies;
 	while ( !(readw(xl_mmio + MMIO_INTSTATUS_AUTO) & INTSTAT_SRB) ) { 
 		schedule();		
-		if(jiffies-t > 15*HZ) {
+		if(time_after(jiffies, t + 15 * HZ)) {
 			printk(KERN_ERR "3COM 3C359 Velocity XL  card not responding.\n");
 			return -ENODEV; 
 		}
@@ -790,7 +791,7 @@ static int xl_open_hw(struct net_device *dev)
 	t=jiffies;
 	while (! (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_SRB)) { 
 		schedule();		
-		if(jiffies-t > 40*HZ) {
+		if(time_after(jiffies, t + 40 * HZ)) {
 			printk(KERN_ERR "3COM 3C359 Velocity XL  card not responding.\n");
 			break ; 
 		}
@@ -1003,7 +1004,7 @@ static void xl_reset(struct net_device *dev)
 
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
-		if(jiffies-t > 40*HZ) {
+		if(time_after(jiffies, t + 40 * HZ)) {
 			printk(KERN_ERR "3COM 3C359 Velocity XL  card not responding.\n");
 			break ; 
 		}
@@ -1270,7 +1271,7 @@ static int xl_close(struct net_device *dev)
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(jiffies-t > 10*HZ) {
+		if(time_after(jiffies, t + 10 * HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-DNSTALL not responding.\n", dev->name);
 			break ; 
 		}
@@ -1279,7 +1280,7 @@ static int xl_close(struct net_device *dev)
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(jiffies-t > 10*HZ) {
+		if(time_after(jiffies, t + 10 * HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-DNDISABLE not responding.\n", dev->name);
 			break ;
 		}
@@ -1288,7 +1289,7 @@ static int xl_close(struct net_device *dev)
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(jiffies-t > 10*HZ) {
+		if(time_after(jiffies, t + 10 * HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-UPSTALL not responding.\n", dev->name);
 			break ; 
 		}
@@ -1305,7 +1306,7 @@ static int xl_close(struct net_device *dev)
 	t=jiffies;
 	while (!(readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_SRB)) { 
 		schedule();		
-		if(jiffies-t > 10*HZ) {
+		if(time_after(jiffies, t + 10 * HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-CLOSENIC not responding.\n", dev->name);
 			break ; 
 		}
@@ -1334,7 +1335,7 @@ static int xl_close(struct net_device *dev)
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(jiffies-t > 10*HZ) {
+		if(time_after(jiffies, t + 10 * HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-UPRESET not responding.\n", dev->name);
 			break ; 
 		}
@@ -1343,7 +1344,7 @@ static int xl_close(struct net_device *dev)
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(jiffies-t > 10*HZ) {
+		if(time_after(jiffies, t + 10 * HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-DNRESET not responding.\n", dev->name);
 			break ; 
 		}
-- 
1.5.4.3

