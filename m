Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbXLXPdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbXLXPdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 10:33:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbXLXPdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 10:33:38 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:44352 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbXLXPdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 10:33:37 -0500
Date: Tue, 25 Dec 2007 00:34:17 +0900 (JST)
Message-Id: <20071225.003417.07490528.yoshfuji@linux-ipv6.org>
To: julia@diku.dk
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 20/38] drivers/net: Use time_before, time_before_eq,
 etc.
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <Pine.LNX.4.64.0712241539340.23999@ask.diku.dk>
References: <Pine.LNX.4.64.0712241539340.23999@ask.diku.dk>
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <Pine.LNX.4.64.0712241539340.23999@ask.diku.dk> (at Mon, 24 Dec 2007 15:40:06 +0100 (CET)), Julia Lawall <julia@diku.dk> says:

> diff -r -u -p a/drivers/net/cassini.c b/drivers/net/cassini.c
> --- a/drivers/net/cassini.c	2007-10-22 11:25:14.000000000 +0200
> +++ b/drivers/net/cassini.c	2007-12-23 20:38:34.000000000 +0100
> @@ -91,6 +91,7 @@
>  #include <linux/ip.h>
>  #include <linux/tcp.h>
>  #include <linux/mutex.h>
> +#include <linux/jiffies.h>
>  
>  #include <net/checksum.h>
>  
> @@ -4141,8 +4142,9 @@ static void cas_link_timer(unsigned long
>  
>  	if (link_transition_timeout != 0 &&
>  	    cp->link_transition_jiffies_valid &&
> -	    ((jiffies - cp->link_transition_jiffies) >
> -	      (link_transition_timeout))) {
> +	    (time_after(jiffies,
> +			cp->link_transition_jiffies +
> +			(link_transition_timeout)))) {
>  		/* One-second counter so link-down workaround doesn't
>  		 * cause resets to occur so fast as to fool the switch
>  		 * into thinking the link is down.
> diff -r -u -p a/drivers/net/cs89x0.c b/drivers/net/cs89x0.c
> --- a/drivers/net/cs89x0.c	2007-10-22 11:25:14.000000000 +0200
> +++ b/drivers/net/cs89x0.c	2007-12-23 20:38:54.000000000 +0100
> @@ -450,7 +451,7 @@ wait_eeprom_ready(struct net_device *dev
>  	   just in case EEPROM is ready when SI_BUSY in the
>  	   PP_SelfST is clear */
>  	while(readreg(dev, PP_SelfST) & SI_BUSY)
> -		if (jiffies - timeout >= 40)
> +		if (time_before_eq(jiffies, timeout + 40))
>  			return -1;
>  	return 0;
>  }

time_after_eq().

> @@ -1181,10 +1183,10 @@ send_test_pkt(struct net_device *dev)
:

>  			break;
> -	if (jiffies - timenow >= 5)
> +	if (time_before_eq(jiffies, timenow + 5))
>  		return 0;	/* this shouldn't happen */
>  
>  	/* Write the contents of the packet */

time_after_eq()

> diff -r -u -p a/drivers/net/e1000/e1000_ethtool.c b/drivers/net/e1000/e1000_ethtool.c
> --- a/drivers/net/e1000/e1000_ethtool.c	2007-12-09 09:35:19.000000000 +0100
> +++ b/drivers/net/e1000/e1000_ethtool.c	2007-12-23 20:30:39.000000000 +0100
> @@ -1537,12 +1537,12 @@ e1000_run_loopback_test(struct e1000_ada
:
>  			break;
>  		}
> -		if (jiffies >= (time + 2)) {
> +		if (time_before_eq(jiffies, time + 2)) {
>  			ret_val = 14; /* error code for time out error */
>  			break;
>  		}

ditto.

--yoshfuji
