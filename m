Return-Path: <linux-kernel-owner+w=401wt.eu-S1759800AbZFLXvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759800AbZFLXvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 19:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbZFLXvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 19:51:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40070
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751604AbZFLXvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 19:51:06 -0400
Date: Fri, 12 Jun 2009 16:51:08 -0700 (PDT)
Message-Id: <20090612.165108.110857018.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, mchan@broadcom.com,
       James.Bottomley@HansenPartnership.com, torvalds@linux-foundation.org
Subject: Re: -git tree build failure in drivers/net/cnic.c: undefined
 reference to `ip6_route_output'
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A32A1E4.8080708@oracle.com>
References: <20090612184343.GA11900@elte.hu>
	<4A32A1E4.8080708@oracle.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Fri, 12 Jun 2009 11:43:48 -0700

> Ingo Molnar wrote:
>> today's -git fails to build with ipv6 disabled (x86):
>> 
>>   drivers/built-in.o: In function `cnic_get_v6_route':
>>   cnic.c:(.text+0x104c42): undefined reference to `ip6_route_output'
>> 
>> introduced by this new driver:
>> 
>>   a463696: [SCSI] cnic: Add new Broadcom CNIC driver.
> 
> I just posted a patch for this to netdev and it was acked by its maintainer.
> Patch is below.

I was hoping the scsi folks, or Linus directly, would pick this up.

But I can take it in too if it slips through the cracks.

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix cnic build for case of CONFIG_INET=n.
> Fix cnic build for case of CONFIG_IPV6=m and CONFIG_CNIC=y.
> 
> Fixes these build errors:
> 
> cnic.c:(.text+0x236a1d): undefined reference to `ip_route_output_key'
> cnic.c:(.text+0x15a8e8): undefined reference to `ip6_route_output'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/net/cnic.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> --- linux-next-20090612.orig/drivers/net/cnic.c
> +++ linux-next-20090612/drivers/net/cnic.c
> @@ -1454,6 +1454,7 @@ static inline u16 cnic_get_vlan(struct n
>  static int cnic_get_v4_route(struct sockaddr_in *dst_addr,
>  			     struct dst_entry **dst)
>  {
> +#if defined(CONFIG_INET)
>  	struct flowi fl;
>  	int err;
>  	struct rtable *rt;
> @@ -1465,12 +1466,15 @@ static int cnic_get_v4_route(struct sock
>  	if (!err)
>  		*dst = &rt->u.dst;
>  	return err;
> +#else
> +	return -ENETUNREACH;
> +#endif
>  }
>  
>  static int cnic_get_v6_route(struct sockaddr_in6 *dst_addr,
>  			     struct dst_entry **dst)
>  {
> -#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
> +#if defined(CONFIG_IPV6) || (defined(CONFIG_IPV6_MODULE) && defined(MODULE))
>  	struct flowi fl;
>  
>  	memset(&fl, 0, sizeof(fl));
> @@ -1550,7 +1554,7 @@ static int cnic_get_route(struct cnic_so
>  	clear_bit(SK_F_IPV6, &csk->flags);
>  
>  	if (is_v6) {
> -#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
> +#if defined(CONFIG_IPV6) || (defined(CONFIG_IPV6_MODULE) && defined(MODULE))
>  		set_bit(SK_F_IPV6, &csk->flags);
>  		err = cnic_get_v6_route(&saddr->remote.v6, &dst);
>  		if (err)
