Return-Path: <linux-kernel-owner+w=401wt.eu-S1751945AbZHPMeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbZHPMeG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 08:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbZHPMeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 08:34:06 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:36297 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbZHPMeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 08:34:05 -0400
Message-ID: <4A87FCAC.5070705@gmail.com>
Date: Sun, 16 Aug 2009 14:33:48 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Michael Spang <mspang@csclub.uwaterloo.ca>
CC: "David S. Miller" <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] Revert netlink ABI change to gnet_stats_basic
References: <1250002683-28554-1-git-send-email-mspang@csclub.uwaterloo.ca>
In-Reply-To: <1250002683-28554-1-git-send-email-mspang@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sun, 16 Aug 2009 14:34:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Spang a écrit :
> In 5e140dfc1fe87eae27846f193086724806b33c7d "net: reorder struct Qdisc
> for better SMP performance" the definition of struct gnet_stats_basic
> changed incompatibly, and as copies of this struct may be shipped to
> userland via netlink. This reverts back to the old ABI.

So userland expects to get exactly 16 bytes instead of 12 ?

iproute2 has no problem :

void print_tcstats2_attr(FILE *fp, struct rtattr *rta, char *prefix, struct rtattr **xstats)
{
        SPRINT_BUF(b1);
        struct rtattr *tbs[TCA_STATS_MAX + 1];

        parse_rtattr_nested(tbs, TCA_STATS_MAX, rta);

        if (tbs[TCA_STATS_BASIC]) {
                struct gnet_stats_basic bs = {0};
                memcpy(&bs, RTA_DATA(tbs[TCA_STATS_BASIC]), MIN(RTA_PAYLOAD(tbs[TCA_STATS_BASIC]), sizeof(bs)));
                fprintf(fp, "%sSent %llu bytes %u pkt",
                        prefix, (unsigned long long) bs.bytes, bs.packets);
        }


What exactly broke after patch was pushed ?

It would be better to fix gnet_stats_copy_basic() if necessary...


> 
> Signed-off-by: Michael Spang <mspang@csclub.uwaterloo.ca>
> ---
>  include/linux/gen_stats.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/gen_stats.h b/include/linux/gen_stats.h
> index 0ffa41d..13f4e74 100644
> --- a/include/linux/gen_stats.h
> +++ b/include/linux/gen_stats.h
> @@ -22,7 +22,7 @@ struct gnet_stats_basic
>  {
>  	__u64	bytes;
>  	__u32	packets;
> -} __attribute__ ((packed));
> +};
>  
>  /**
>   * struct gnet_stats_rate_est - rate estimator

