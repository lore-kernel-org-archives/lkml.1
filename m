Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab0BEKRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 05:17:05 -0500
Received: from mail.gmx.net ([213.165.64.20]:57642 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751005Ab0BEKRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 05:17:01 -0500
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1/Xn/J/9r7X+234FOI6tKgPELBvGLEx8MfVKm20uu
	P1uXOUMlpUMamx
From: Sven Joachim <svenjoac@gmx.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jamal Hadi Salim <hadi@cyberus.ca>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [46/74] net: restore ip source validation
References: <20100204171850.GA16539@kroah.com>
	<20100204171514.263483751@linux.site>
Date: Fri, 05 Feb 2010 11:16:56 +0100
In-Reply-To: <20100204171514.263483751@linux.site> (Greg KH's message of "Thu,
	04 Feb 2010 09:12:17 -0800")
Message-ID: <87pr4khtrb.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42999999999999999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-02-04 18:12 +0100, Greg KH wrote:

> 2.6.32-stable review patch.  If anyone has any objections, please let us know.

It's a bit hard to believe, but it is this patch which triggered the
boot-time crashes¹ that several people, including me, observed.
Reverting it avoids the kernel panic, and I'm running a kernel with the
other 73 patches applied right now.

Sven


¹ http://nelide.cz/downloads/2.6.32.8-crash.png

> ------------------
>
> From: Jamal Hadi Salim <hadi@cyberus.ca>
>
> [ Upstream commit 28f6aeea3f12d37bd258b2c0d5ba891bff4ec479 ]
>
> when using policy routing and the skb mark:
> there are cases where a back path validation requires us
> to use a different routing table for src ip validation than
> the one used for mapping ingress dst ip.
> One such a case is transparent proxying where we pretend to be
> the destination system and therefore the local table
> is used for incoming packets but possibly a main table would
> be used on outbound.
> Make the default behavior to allow the above and if users
> need to turn on the symmetry via sysctl src_valid_mark
>
> Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  include/linux/inetdevice.h |    1 +
>  include/linux/sysctl.h     |    1 +
>  net/ipv4/devinet.c         |    1 +
>  net/ipv4/fib_frontend.c    |    2 ++
>  4 files changed, 5 insertions(+)
>
> --- a/include/linux/inetdevice.h
> +++ b/include/linux/inetdevice.h
> @@ -83,6 +83,7 @@ static inline void ipv4_devconf_setall(s
>  #define IN_DEV_FORWARD(in_dev)		IN_DEV_CONF_GET((in_dev), FORWARDING)
>  #define IN_DEV_MFORWARD(in_dev)		IN_DEV_ANDCONF((in_dev), MC_FORWARDING)
>  #define IN_DEV_RPFILTER(in_dev)		IN_DEV_MAXCONF((in_dev), RP_FILTER)
> +#define IN_DEV_SRC_VMARK(in_dev)    	IN_DEV_ORCONF((in_dev), SRC_VMARK)
>  #define IN_DEV_SOURCE_ROUTE(in_dev)	IN_DEV_ANDCONF((in_dev), \
>  						       ACCEPT_SOURCE_ROUTE)
>  #define IN_DEV_BOOTP_RELAY(in_dev)	IN_DEV_ANDCONF((in_dev), BOOTP_RELAY)
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -490,6 +490,7 @@ enum
>  	NET_IPV4_CONF_PROMOTE_SECONDARIES=20,
>  	NET_IPV4_CONF_ARP_ACCEPT=21,
>  	NET_IPV4_CONF_ARP_NOTIFY=22,
> +	NET_IPV4_CONF_SRC_VMARK=24,
>  	__NET_IPV4_CONF_MAX
>  };
>  
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -1450,6 +1450,7 @@ static struct devinet_sysctl_table {
>  		DEVINET_SYSCTL_RW_ENTRY(SEND_REDIRECTS, "send_redirects"),
>  		DEVINET_SYSCTL_RW_ENTRY(ACCEPT_SOURCE_ROUTE,
>  					"accept_source_route"),
> +		DEVINET_SYSCTL_RW_ENTRY(SRC_VMARK, "src_valid_mark"),
>  		DEVINET_SYSCTL_RW_ENTRY(PROXY_ARP, "proxy_arp"),
>  		DEVINET_SYSCTL_RW_ENTRY(MEDIUM_ID, "medium_id"),
>  		DEVINET_SYSCTL_RW_ENTRY(BOOTP_RELAY, "bootp_relay"),
> --- a/net/ipv4/fib_frontend.c
> +++ b/net/ipv4/fib_frontend.c
> @@ -251,6 +251,8 @@ int fib_validate_source(__be32 src, __be
>  	if (in_dev) {
>  		no_addr = in_dev->ifa_list == NULL;
>  		rpf = IN_DEV_RPFILTER(in_dev);
> +		if (mark && !IN_DEV_SRC_VMARK(in_dev))
> +			fl.mark = 0;
>  	}
>  	rcu_read_unlock();
