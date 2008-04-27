Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbYD0Mc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbYD0Mc2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 08:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756919AbYD0McV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 08:32:21 -0400
Received: from mail08a.verio.de ([213.198.55.73]:13376 "HELO mail08a.verio.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755676AbYD0McU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 08:32:20 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Apr 2008 08:32:19 EDT
Message-Id: <6.1.1.1.2.20080427141058.045c43f0@192.168.6.12>
X-Mailer: QUALCOMM Windows Eudora Version 6.1.1.1
Date: Sun, 27 Apr 2008 14:25:16 +0200
To: linux-kernel@vger.kernel.org
From: Roger While <simrw@sim-basis.de>
Subject: Re: [PATCH v2] prism54: prism54_get_encode() test below 0 on
  unsigned index
Cc: mcgrof@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
X-AntiVirus: checked by AntiVir MailGuard (Version: 8.0.0.18; AVE: 8.1.0.35; VDF: 7.0.3.216)
X-SIMBasis-MailScanner-Information: Please contact the ISP for more information
X-SIMBasis-MailScanner: Found to be clean
X-SIMBasis-MailScanner-SpamCheck: not spam (whitelisted),
	SpamAssassin (score=-5.899, required 5, autolearn=not spam,
	ALL_TRUSTED -3.30, BAYES_00 -2.60)
X-SIMBasis-MailScanner-From: simrw@sim-basis.de
X-Spam: [F=0.0100000000; S=0.010(2008040101); MH=0.500(2008040918)]
X-MAIL-FROM: <simrw@sim-basis.de>
X-SOURCE-IP: [213.198.55.139]
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis Rodriguez wrote :

>The check for -1 seems silly lets just remove its use.
>
>Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>
>diff --git a/drivers/net/wireless/prism54/isl_ioctl.c 
>b/drivers/net/wireless/prism54/isl_ioctl.c
>index 5b375b2..7e2d3b6 100644
>--- a/drivers/net/wireless/prism54/isl_ioctl.c
>+++ b/drivers/net/wireless/prism54/isl_ioctl.c
>@@ -1158,7 +1158,7 @@ prism54_get_encode(struct net_device *ndev, struct 
>iw_request_info *info,
>  {
>         islpci_private *priv = netdev_priv(ndev);
>         struct obj_key *key;
>-       u32 devindex, index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
>+       u32 devindex, index = (dwrq->flags & IW_ENCODE_INDEX);
>         u32 authen = 0, invoke = 0, exunencrypt = 0;
>         int rvalue;
>         union oid_res_t r;
>@@ -1186,7 +1186,7 @@ prism54_get_encode(struct net_device *ndev, struct 
>iw_request_info *info,
>         rvalue |= mgt_get_request(priv, DOT11_OID_DEFKEYID, 0, NULL, &r);
>         devindex = r.u;
>         /* Now get the key, return it */
>-       if (index == -1 || index > 3)
>+       if (!index || index > 3)
>                 /* no index provided, use the current one */
>                 index = devindex;
>         rvalue |= mgt_get_request(priv, DOT11_OID_DEFKEYX, index, NULL, &r);

This does not look right to me. Should this not be -
  if (!index || index > 4)
    ....
  else
   index -= 1;
(Or alternatively pass index -1 to mgt_get_request)

Also 5 lines further on we have -
         /* return the used key index */
         dwrq->flags |= devindex + 1;
which looks suspect.

Roger While 

