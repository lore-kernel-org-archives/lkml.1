Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbXJ3TPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbXJ3TPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbXJ3TPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:15:20 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:59982 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbXJ3TPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:15:19 -0400
Message-ID: <472782C0.4000807@tiscali.nl>
Date: Tue, 30 Oct 2007 20:15:12 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kristof Provost <Kristof@provost-engineering.be>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] several returns before unlocking in lmc_ioctl
References: <471D4763.60604@tiscali.nl> <471D52C4.1050701@tiscali.nl> <20071030182832.GI32270@berith>
In-Reply-To: <20071030182832.GI32270@berith>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristof Provost wrote:
> On 2007-10-23 03:47:48 (+0200), Roel Kluin <12o3l@tiscali.nl> wrote:
>> I think we should keep the lmc_tracing. Use this patch instead.
>>
>> --
>>     Several returns before unlocking in lmc_ioctl
>>     
>>     Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
>> ---
>> diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.c
>> index 5ea8772..64eb578 100644
> <snip>
>> @@ -229,9 +234,10 @@ int lmc_ioctl (struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
>>          sc->lmc_xinfo.Magic1 = 0xDEADBEEF;
>>  
>>          if (copy_to_user(ifr->ifr_data, &sc->lmc_xinfo,
>> -                         sizeof (struct lmc_xinfo)))
>> -            return -EFAULT;
>> -        ret = 0;
>> +					sizeof(struct lmc_xinfo))) {
>> +		ret = -EFAULT;
>> +	else
>> +		ret = 0;
> I think you have an extra curly brace there. It breaks compile on my
> system.


You are right. thanks for notifying me and sorry for the trouble.
please revert my patch (b463d40cdc436a12799a60a1d6ff1941a70a5bb6)

and try instead:
--
Several returns before unlocking in lmc_ioctl

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.c
index 5ea8772..427226d 100644
--- a/drivers/net/wan/lmc/lmc_main.c
+++ b/drivers/net/wan/lmc/lmc_main.c
@@ -142,9 +142,10 @@ int lmc_ioctl (struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
          * To date internally, just copy this out to the user.
          */
     case LMCIOCGINFO: /*fold01*/
-        if (copy_to_user(ifr->ifr_data, &sc->ictl, sizeof (lmc_ctl_t)))
-            return -EFAULT;
-        ret = 0;
+	if (copy_to_user(ifr->ifr_data, &sc->ictl, sizeof(lmc_ctl_t)))
+		ret = -EFAULT;
+	else
+		ret = 0;
         break;
 
     case LMCIOCSINFO: /*fold01*/
@@ -159,8 +160,10 @@ int lmc_ioctl (struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
             break;
         }
 
-        if (copy_from_user(&ctl, ifr->ifr_data, sizeof (lmc_ctl_t)))
-            return -EFAULT;
+	if (copy_from_user(&ctl, ifr->ifr_data, sizeof(lmc_ctl_t))) {
+		ret = -EFAULT;
+		break;
+	}
 
         sc->lmc_media->set_status (sc, &ctl);
 
@@ -190,8 +193,10 @@ int lmc_ioctl (struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
 		break;
 	    }
 
-	    if (copy_from_user(&new_type, ifr->ifr_data, sizeof(u_int16_t)))
-                return -EFAULT;
+	    if (copy_from_user(&new_type, ifr->ifr_data, sizeof(u_int16_t))) {
+		ret = -EFAULT;
+		break;
+	    }
 
             
 	    if (new_type == old_type)
@@ -229,9 +234,10 @@ int lmc_ioctl (struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
         sc->lmc_xinfo.Magic1 = 0xDEADBEEF;
 
         if (copy_to_user(ifr->ifr_data, &sc->lmc_xinfo,
-                         sizeof (struct lmc_xinfo)))
-            return -EFAULT;
-        ret = 0;
+					sizeof(struct lmc_xinfo)))
+		ret = -EFAULT;
+	else
+		ret = 0;
 
         break;
 
@@ -262,9 +268,9 @@ int lmc_ioctl (struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
 
         if (copy_to_user(ifr->ifr_data, &sc->stats,
                          sizeof (struct lmc_statistics)))
-            return -EFAULT;
-
-        ret = 0;
+		ret = -EFAULT;
+	else
+		ret = 0;
         break;
 
     case LMCIOCCLEARLMCSTATS: /*fold01*/
@@ -292,8 +298,10 @@ int lmc_ioctl (struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
             break;
         }
 
-        if (copy_from_user(&ctl, ifr->ifr_data, sizeof (lmc_ctl_t)))
-            return -EFAULT;
+	if (copy_from_user(&ctl, ifr->ifr_data, sizeof(lmc_ctl_t))) {
+		ret = -EFAULT;
+		break;
+	}
         sc->lmc_media->set_circuit_type(sc, ctl.circuit_type);
         sc->ictl.circuit_type = ctl.circuit_type;
         ret = 0;
@@ -318,12 +326,15 @@ int lmc_ioctl (struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
 
 #ifdef DEBUG
     case LMCIOCDUMPEVENTLOG:
-        if (copy_to_user(ifr->ifr_data, &lmcEventLogIndex, sizeof (u32)))
-            return -EFAULT;
+	if (copy_to_user(ifr->ifr_data, &lmcEventLogIndex, sizeof(u32))) {
+		ret = -EFAULT;
+		break;
+	}
         if (copy_to_user(ifr->ifr_data + sizeof (u32), lmcEventLogBuf, sizeof (lmcEventLogBuf)))
-            return -EFAULT;
+		ret = -EFAULT;
+	else
+		ret = 0;
 
-        ret = 0;
         break;
 #endif /* end ifdef _DBG_EVENTLOG */
     case LMCIOCT1CONTROL: /*fold01*/
@@ -346,8 +357,10 @@ int lmc_ioctl (struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
              */
             netif_stop_queue(dev);
 
-            if (copy_from_user(&xc, ifr->ifr_data, sizeof (struct lmc_xilinx_control)))
-                return -EFAULT;
+	if (copy_from_user(&xc, ifr->ifr_data, sizeof(struct lmc_xilinx_control))) {
+		ret = -EFAULT;
+		break;
+	}
             switch(xc.command){
             case lmc_xilinx_reset: /*fold02*/
                 {


