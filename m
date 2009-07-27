Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbZG0JZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbZG0JZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 05:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbZG0JZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 05:25:35 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:37961 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747AbZG0JZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 05:25:34 -0400
Message-ID: <4A6D7285.9080909@gmail.com>
Date: Mon, 27 Jul 2009 11:25:25 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Hannes Eder <heder@google.com>
CC: netdev@vger.kernel.org, lvs-users@linuxvirtualserver.org,
       malcolm@loadbalancer.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IPVS: logging sizeof(struct ip_vs_conn) on startup
References: <20090727090741.16509.35291.stgit@jazzy.zrh.corp.google.com>
In-Reply-To: <20090727090741.16509.35291.stgit@jazzy.zrh.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 27 Jul 2009 11:25:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Eder a écrit :
> No more guessing, how much memory is used by IPVS for a connection.
> 
> Signed-off-by: Hannes Eder <heder@google.com>
> ---
>  net/netfilter/ipvs/ip_vs_core.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index b021464..5b0997c 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -1475,7 +1475,8 @@ static int __init ip_vs_init(void)
>  		goto cleanup_conn;
>  	}
>  
> -	IP_VS_INFO("ipvs loaded.\n");
> +	IP_VS_INFO("ipvs loaded (using %Zd bytes/connection).\n",
> +	       sizeof(struct ip_vs_conn));
>  	return ret;
>  
>    cleanup_conn:

Well, ip_vs_conn_cache uses SLAB_HWCACHE_ALIGN, so this should be rounded up
to L1 cache size. Or add "at least" like in line 1080
of net/netfilter/ipvs/ip_vs_conn.c :

	IP_VS_DBG(0, "Each connection entry needs %Zd bytes at least\n",
		  sizeof(struct ip_vs_conn));

