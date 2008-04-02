Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbYDBJNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbYDBJNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 05:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYDBJNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 05:13:13 -0400
Received: from n8.bullet.re3.yahoo.com ([68.142.237.93]:22833 "HELO
	n8.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751785AbYDBJNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 05:13:12 -0400
X-Yahoo-Newman-Id: 572031.47663.bm@omp103.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fpBhN0OTCMo76+wHHFqGH6hT+WQ5a6VQRsb67bNaWpBmyi9Q1MRme7XRD5D/AE4c4gbZ0sJt1kaQS3hxB2oM8eXuB6j8UmacmxJxjqgbVQKgljzdh0r6pORHb2UPuINs/ve/2yp5kWscq9sOVfR1n+EsspqMP2alMAxyjod3QaM=  ;
X-YMail-OSG: IL2hepoVM1mGTVSNIHXo8z9cAMqrHBusdjLYluRL7f6AuDSVljv6KdQphvfDGpFryMl_vF0.1g--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: GFP_ATOMIC page allocation failures.
Date: Wed, 2 Apr 2008 20:12:58 +1100
User-Agent: KMail/1.9.5
Cc: Chris Snook <csnook@redhat.com>, Dave Jones <davej@codemonkey.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <20080401235609.GA6947@codemonkey.org.uk> <47F32789.2070703@redhat.com> <20080402005646.f8df1c1b.akpm@linux-foundation.org>
In-Reply-To: <20080402005646.f8df1c1b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804022012.58760.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 April 2008 18:56, Andrew Morton wrote:

> > Limiting this to once per boot should suffice for debugging purposes.
> > Even if you manage to concoct a bug that always survives the first
> > failure, you should be able to take the hint when you keep seeing this
> > in dmesg.
>
> The appropriate thing to do here is to convert known-good drivers (such as
> e1000[e]) to use __GFP_NOWARN.
>
> Unfortunately netdev_alloc_skb() went and assumed GFP_ATOMIC, but I guess
> we can dive below the covers and use __netdev_alloc_skb():

It's still actually nice to know how often it is happening even for
these known good sites because too much can indicate a problem and
that you could actually bring performance up by tuning some things.

So I think that the messages should stay, and they should print out
some header to say that it is only a warning and if not happening
too often then it is not a problem, and if it is continually
happening then please try X or Y or post a message to lkml...


>
>
>
> From: Andrew Morton <akpm@linux-foundation.org>
>
> We get rather a lot of reports of page allocation warnings coming out of
> e1000.  But this driver is know to handle them properly so let's suppress
> them.
>
> Cc: Auke Kok <auke-jan.h.kok@intel.com>
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: Jeff Garzik <jeff@garzik.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  drivers/net/e1000/e1000.h      |    4 ++++
>  drivers/net/e1000/e1000_main.c |   10 +++++-----
>  2 files changed, 9 insertions(+), 5 deletions(-)
>
> diff -puN
> drivers/net/e1000/e1000_main.c~e1000-suppress-page-allocation-failure-warni
>ngs drivers/net/e1000/e1000_main.c ---
> a/drivers/net/e1000/e1000_main.c~e1000-suppress-page-allocation-failure-war
>nings +++ a/drivers/net/e1000/e1000_main.c
> @@ -4296,7 +4296,7 @@ e1000_clean_rx_irq(struct e1000_adapter
>  		 * of reassembly being done in the stack */
>  		if (length < copybreak) {
>  			struct sk_buff *new_skb =
> -			    netdev_alloc_skb(netdev, length + NET_IP_ALIGN);
> +			    e1000_alloc_skb(netdev, length + NET_IP_ALIGN);
>  			if (new_skb) {
>  				skb_reserve(new_skb, NET_IP_ALIGN);
>  				skb_copy_to_linear_data_offset(new_skb,
> @@ -4585,7 +4585,7 @@ e1000_alloc_rx_buffers(struct e1000_adap
>  			goto map_skb;
>  		}
>
> -		skb = netdev_alloc_skb(netdev, bufsz);
> +		skb = e1000_alloc_skb(netdev, bufsz);
>  		if (unlikely(!skb)) {
>  			/* Better luck next round */
>  			adapter->alloc_rx_buff_failed++;
> @@ -4598,7 +4598,7 @@ e1000_alloc_rx_buffers(struct e1000_adap
>  			DPRINTK(RX_ERR, ERR, "skb align check failed: %u bytes "
>  					     "at %p\n", bufsz, skb->data);
>  			/* Try again, without freeing the previous */
> -			skb = netdev_alloc_skb(netdev, bufsz);
> +			skb = e1000_alloc_skb(netdev, bufsz);
>  			/* Failed allocation, critical failure */
>  			if (!skb) {
>  				dev_kfree_skb(oldskb);
> @@ -4720,8 +4720,8 @@ e1000_alloc_rx_buffers_ps(struct e1000_a
>  				rx_desc->read.buffer_addr[j+1] = ~cpu_to_le64(0);
>  		}
>
> -		skb = netdev_alloc_skb(netdev,
> -		                       adapter->rx_ps_bsize0 + NET_IP_ALIGN);
> +		skb = e1000_alloc_skb(netdev,
> +					adapter->rx_ps_bsize0 + NET_IP_ALIGN);
>
>  		if (unlikely(!skb)) {
>  			adapter->alloc_rx_buff_failed++;
> diff -puN
> drivers/net/e1000/e1000.h~e1000-suppress-page-allocation-failure-warnings
> drivers/net/e1000/e1000.h ---
> a/drivers/net/e1000/e1000.h~e1000-suppress-page-allocation-failure-warnings
> +++ a/drivers/net/e1000/e1000.h
> @@ -358,5 +358,9 @@ extern void e1000_power_up_phy(struct e1
>  extern void e1000_set_ethtool_ops(struct net_device *netdev);
>  extern void e1000_check_options(struct e1000_adapter *adapter);
>
> +static inline void *e1000_alloc_skb(struct net_device *dev, unsigned int
> length) +{
> +	return __netdev_alloc_skb(dev, length, GFP_ATOMIC|__GFP_NOWARN);
> +}
>
>  #endif /* _E1000_H_ */
> _

