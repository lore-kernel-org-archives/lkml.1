Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbYD1EOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbYD1EOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 00:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbYD1EOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 00:14:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbYD1EN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 00:13:59 -0400
Subject: Re: [PATCH v2] prism54: prism54_get_encode() test below 0 on
	unsigned index
From: Dan Williams <dcbw@redhat.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Roel Kluin <12o3l@tiscali.nl>, linux-wireless@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080426043927.GE4810@ruslug.rutgers.edu>
References: <480F9481.2040303@tiscali.nl>
	 <1209056973.5224.0.camel@localhost.localdomain>
	 <4811299A.7060407@tiscali.nl>  <20080426043927.GE4810@ruslug.rutgers.edu>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 00:10:06 -0400
Message-Id: <1209355806.20940.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-04-26 at 00:39 -0400, Luis R. Rodriguez wrote:
> On Fri, Apr 25, 2008 at 02:45:14AM +0200, Roel Kluin wrote:
> > Dan Williams wrote:
> > > On Wed, 2008-04-23 at 21:56 +0200, Roel Kluin wrote:
> > 
> > >> u32 index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
> > > 
> > > Probably should just change that to an 'int' instead of a u32.
> > > 
> > > Dan
> > > 
> > 
> > Thanks, in that case use the patch below
> > ---
> > when left unsigned, the test 'if (index < 0)' will not work.
> > 
> > Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> > ---
> > diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
> > index e5b3c28..8076ead 100644
> > --- a/drivers/net/wireless/prism54/isl_ioctl.c
> > +++ b/drivers/net/wireless/prism54/isl_ioctl.c
> > @@ -1158,7 +1158,8 @@ prism54_get_encode(struct net_device *ndev, struct iw_request_info *info,
> >  {
> >  	islpci_private *priv = netdev_priv(ndev);
> >  	struct obj_key *key;
> > -	u32 devindex, index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
> > +	u32 devindex;
> > +	int index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
> 
> The check for -1 seems silly lets just remove its use.
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> 
> diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
> index 5b375b2..7e2d3b6 100644
> --- a/drivers/net/wireless/prism54/isl_ioctl.c
> +++ b/drivers/net/wireless/prism54/isl_ioctl.c
> @@ -1158,7 +1158,7 @@ prism54_get_encode(struct net_device *ndev, struct iw_request_info *info,
>  {
>  	islpci_private *priv = netdev_priv(ndev);
>  	struct obj_key *key;
> -	u32 devindex, index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
> +	u32 devindex, index = (dwrq->flags & IW_ENCODE_INDEX);
>  	u32 authen = 0, invoke = 0, exunencrypt = 0;
>  	int rvalue;
>  	union oid_res_t r;
> @@ -1186,7 +1186,7 @@ prism54_get_encode(struct net_device *ndev, struct iw_request_info *info,
>  	rvalue |= mgt_get_request(priv, DOT11_OID_DEFKEYID, 0, NULL, &r);
>  	devindex = r.u;
>  	/* Now get the key, return it */
> -	if (index == -1 || index > 3)
> +	if (!index || index > 3)
>  		/* no index provided, use the current one */
>  		index = devindex;
>  	rvalue |= mgt_get_request(priv, DOT11_OID_DEFKEYX, index, NULL, &r);

This won't allow you to select index 0 then.  Hence the reason why the
-1 is necessary, so you can distinguish 'no index specified' from 'use
index 0'.  There's probably a better way to do it, but I don't think
this patch will work.

Dan


