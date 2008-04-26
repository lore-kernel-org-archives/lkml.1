Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbYDZFIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbYDZFIz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 01:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYDZFIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 01:08:45 -0400
Received: from ruslug.rutgers.edu ([165.230.139.146]:40796 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbYDZFIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 01:08:35 -0400
X-Greylist: delayed 1747 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Apr 2008 01:08:34 EDT
Date: Sat, 26 Apr 2008 00:39:27 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] prism54: prism54_get_encode() test below 0 on unsigned index
Message-ID: <20080426043927.GE4810@ruslug.rutgers.edu>
References: <480F9481.2040303@tiscali.nl> <1209056973.5224.0.camel@localhost.localdomain> <4811299A.7060407@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4811299A.7060407@tiscali.nl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 02:45:14AM +0200, Roel Kluin wrote:
> Dan Williams wrote:
> > On Wed, 2008-04-23 at 21:56 +0200, Roel Kluin wrote:
> 
> >> u32 index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
> > 
> > Probably should just change that to an 'int' instead of a u32.
> > 
> > Dan
> > 
> 
> Thanks, in that case use the patch below
> ---
> when left unsigned, the test 'if (index < 0)' will not work.
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
> index e5b3c28..8076ead 100644
> --- a/drivers/net/wireless/prism54/isl_ioctl.c
> +++ b/drivers/net/wireless/prism54/isl_ioctl.c
> @@ -1158,7 +1158,8 @@ prism54_get_encode(struct net_device *ndev, struct iw_request_info *info,
>  {
>  	islpci_private *priv = netdev_priv(ndev);
>  	struct obj_key *key;
> -	u32 devindex, index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
> +	u32 devindex;
> +	int index = (dwrq->flags & IW_ENCODE_INDEX) - 1;

The check for -1 seems silly lets just remove its use.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index 5b375b2..7e2d3b6 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -1158,7 +1158,7 @@ prism54_get_encode(struct net_device *ndev, struct iw_request_info *info,
 {
 	islpci_private *priv = netdev_priv(ndev);
 	struct obj_key *key;
-	u32 devindex, index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
+	u32 devindex, index = (dwrq->flags & IW_ENCODE_INDEX);
 	u32 authen = 0, invoke = 0, exunencrypt = 0;
 	int rvalue;
 	union oid_res_t r;
@@ -1186,7 +1186,7 @@ prism54_get_encode(struct net_device *ndev, struct iw_request_info *info,
 	rvalue |= mgt_get_request(priv, DOT11_OID_DEFKEYID, 0, NULL, &r);
 	devindex = r.u;
 	/* Now get the key, return it */
-	if (index == -1 || index > 3)
+	if (!index || index > 3)
 		/* no index provided, use the current one */
 		index = devindex;
 	rvalue |= mgt_get_request(priv, DOT11_OID_DEFKEYX, index, NULL, &r);
