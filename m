Return-Path: <linux-kernel-owner+w=401wt.eu-S1754494AbZI3NiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbZI3NiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 09:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZI3NiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 09:38:18 -0400
Received: from smtp-out.google.com ([216.239.45.13]:40883 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbZI3NiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 09:38:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	references:in-reply-to:content-type:
	content-transfer-encoding:x-system-of-record;
	b=S3ePbJ4ERei97iFDM1hdGGW8Z9fjBK6B61c2FhLSxzPv/90s3DaUvj/DTTJXouqJy
	jC9VeHCSs1sg+1Ps4cemQ==
Message-ID: <4AC35F44.60707@google.com>
Date: Wed, 30 Sep 2009 15:38:12 +0200
From: Hannes Eder <heder@google.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Wensong Zhang <wensong@linux-vs.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH] ipvs: Add boundary check on ioctl arguments
References: <20090930131109.2b3f71b8@infradead.org>
In-Reply-To: <20090930131109.2b3f71b8@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc: +Simon Horman]

Arjan van de Ven wrote:
 > From 761a182f96b3707e1fee44e1079ba227e48745d1 Mon Sep 17 00:00:00 2001
 > From: Arjan van de Ven <arjan@linux.intel.com>
 > Date: Wed, 30 Sep 2009 13:05:51 +0200
 > Subject: [PATCH] ipvs: Add boundary check on ioctl arguments
 >
 > The ipvs code has a nifty system for doing the size of ioctl command copies;
 > it defines an array with values into which it indexes the cmd to find the
 > right length.
 >
 > Unfortunately, the ipvs code forgot to check if the cmd was in the range
 > that the array provides, allowing for an index outside of the array,
 > which then gives a "garbage" result into the length, which then gets
 > used for copying into a stack buffer.
 >
 > Fix this by adding sanity checks on these as well as the copy size.
 >
 > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
 > ---
 >  net/netfilter/ipvs/ip_vs_ctl.c |   14 +++++++++++++-
 >  1 files changed, 13 insertions(+), 1 deletions(-)
 >
 > diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
 > index ac624e5..3c52796 100644
 > --- a/net/netfilter/ipvs/ip_vs_ctl.c
 > +++ b/net/netfilter/ipvs/ip_vs_ctl.c
 > @@ -2077,6 +2077,10 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user 
*user, unsigned int len)
 >  	if (!capable(CAP_NET_ADMIN))
 >  		return -EPERM;
 >
 > +	if (cmd < IP_VS_BASE_CTL || cmd > IP_VS_SO_SET_MAX + 1)
 > +		return -EINVAL;
 > +	if (len < 0 || len >  MAX_ARG_LEN)
 > +		return -EINVAL;
 >  	if (len != set_arglen[SET_CMDID(cmd)]) {
 >  		pr_err("set_ctl: len %u != %u\n",
 >  		       len, set_arglen[SET_CMDID(cmd)]);
 > @@ -2353,17 +2357,25 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd, void __user 
*user, int *len)
 >  {
 >  	unsigned char arg[128];

can MAX_ARG_LEN be used here?

 >  	int ret = 0;
 > +	unsigned int copylen;
 >
 >  	if (!capable(CAP_NET_ADMIN))
 >  		return -EPERM;
 >
 > +	if (cmd < IP_VS_BASE_CTL || cmd > IP_VS_SO_GET_MAX + 1)
 > +		return -EINVAL;
 > +
 >  	if (*len < get_arglen[GET_CMDID(cmd)]) {
 >  		pr_err("get_ctl: len %u < %u\n",
 >  		       *len, get_arglen[GET_CMDID(cmd)]);
 >  		return -EINVAL;
 >  	}
 >
 > -	if (copy_from_user(arg, user, get_arglen[GET_CMDID(cmd)]) != 0)
 > +	copylen = get_arglen[GET_CMDID(cmd)];
 > +	if (copylen > 128)

I think it's better to use 'copylen > sizeof(arg)' here.

 > +		return -EINVAL;
 > +
 > +	if (copy_from_user(arg, user, copylen) != 0)
 >  		return -EFAULT;
 >
 >  	if (mutex_lock_interruptible(&__ip_vs_mutex))

