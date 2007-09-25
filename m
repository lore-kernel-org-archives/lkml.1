Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbXIYOra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbXIYOra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 10:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbXIYOrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 10:47:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64677 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbXIYOrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 10:47:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 3/5] ibmebus: Add device creation and bus probing based on of_device
Date: Tue, 25 Sep 2007 16:39:05 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070831.706792)
Cc: Joachim Fenkes <fenkes@de.ibm.com>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>, Thomas Klein <tklein@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       Paul Mackerras <pmac@au1.ibm.com>, Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200709251410.29780.fenkes@de.ibm.com> <200709251412.27896.fenkes@de.ibm.com>
In-Reply-To: <200709251412.27896.fenkes@de.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709251639.06414.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/o0JKS+BMQcQQPEM9A2RJg+qoK6ozeE4RG0LO
 2Sz1OGE9ChO8whI4BvaE8umh7aURMSBkbezY3aFxrmv3uphK4W
 zTmGM5DX48uMeCSHTcU3g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 September 2007, Joachim Fenkes wrote:
> The devtree root is now searched for devices matching a built-in whitelist
> during boot, so these devices appear on the bus from the beginning. It is
> still possible to manually add/remove devices to/from the bus by using the
> probe/remove sysfs interface. Also, when a device driver registers itself,
> the devtree is matched against its matchlist.
> 
> Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
> ---
>  arch/powerpc/kernel/ibmebus.c |   97 ++++++++++++++++++++++++++++++++++-------
>  1 files changed, 81 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
> index cc80f84..c506e0d 100644
> --- a/arch/powerpc/kernel/ibmebus.c
> +++ b/arch/powerpc/kernel/ibmebus.c
> @@ -51,6 +51,15 @@ static struct device ibmebus_bus_device = { /* fake "parent" device */
>  
>  struct bus_type ibmebus_bus_type;
>  
> +/* These devices will automatically be added to the bus during init */
> +static struct of_device_id builtin_matches[] = {
> +	{ .name = "lhca" },
> +	{ .compatible = "IBM,lhca" },
> +	{ .name = "lhea" },
> +	{ .compatible = "IBM,lhea" },
> +	{},
> +};
> +

Hmm, do you have devices that only have the matching name property
but not the compatible property? If not, I'd suggest only looking
for compatible, so you have less chance of false positives.

> +static int ibmebus_create_device(struct device_node *dn)
> +{
> +	struct of_device *dev;
> +	int ret;
> +
> +	dev = of_device_alloc(dn, NULL, &ibmebus_bus_device);
> +	if (!dev)
> +		return -ENOMEM;
> +
> +	dev->dev.bus = &ibmebus_bus_type;
> +	dev->dev.archdata.dma_ops = &ibmebus_dma_ops;
> +
> +	ret = of_device_register(dev);
> +	if (ret) {
> +		of_device_free(dev);
> +		return ret;
> +	}
> +
> +	return 0;
> +}

nice!

> @@ -219,9 +276,9 @@ static ssize_t ibmebus_store_probe(struct bus_type *bus,
>  	}
>  
>  	if ((dn = of_find_node_by_path(path))) {
> -/*		dev = ibmebus_register_device_node(dn); */
> +		rc = ibmebus_create_device(dn);
>  		of_node_put(dn);
> -		rc = IS_ERR(dev) ? PTR_ERR(dev) : count;
> +		rc = rc ? rc : count;

the last line looks a bit silly. Maybe instead do

		rc = ibmebus_create_device(dn);
  		of_node_put(dn);
	}

	kfree(path);
	if (rc)
		return rc;
	return count;
}
