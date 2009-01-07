Return-Path: <linux-kernel-owner+w=401wt.eu-S1759869AbZAGPWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759869AbZAGPWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758748AbZAGPWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:22:31 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:34564 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbZAGPW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:22:29 -0500
Date: Wed, 7 Jan 2009 20:52:08 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linville@tuxdriver.com, davem@davemloft.net,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Bob Copeland <me@bobcopeland.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ath5k: fix hw rate index condition
Message-ID: <20090107152208.GB4207@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <1231336282-22283-1-git-send-email-jirislaby@gmail.com> <1231338965-796-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231338965-796-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 03:36:05PM +0100, Jiri Slaby wrote:
> On 01/07/2009 02:51 PM, Jiri Slaby wrote:
> > Dhaval Giani wrote:
> >> I see this on current git. Not sure how to reproduce it, has happened on
> >> two random occasions. At both times, I was not connected to a wireless
> >> network, but to wired networks.
> >>
> >> ------------[ cut here ]------------
> >> WARNING: at net/mac80211/rx.c:2234 __ieee80211_rx+0x7f/0x559
> >> ...
> >> Call Trace:
> >>  [<f80d4192>] __ieee80211_rx+0x7f/0x559 [mac80211]
> >>  [<f80a19f4>] ath5k_tasklet_rx+0x4f7/0x53b [ath5k]
> >> ...
> > 
> > Hmm, maybe ath5k is culprit. Could you apply the attached patch and
> > use the kernel till the problem appears again?
> 
> I don't think this will print anything, the rate won't be 32, it's rather
> too high. Could you apply also the appended debug one?
> 

I will apply both the patches and try it out again. As I mentioned
earlier, I am not sure how to reproduce the WARN_ON. I will get back to
you in about a day or two.

> ---
>  net/mac80211/rx.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 7175ae8..5e17e57 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -2230,8 +2230,10 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
>  		 * MCS aware. */
>  		rate = &sband->bitrates[sband->n_bitrates - 1];
>  	} else {
> -		if (WARN_ON(status->rate_idx < 0 ||
> -			    status->rate_idx >= sband->n_bitrates))
> +		if (WARN(status->rate_idx < 0 ||
> +			    status->rate_idx >= sband->n_bitrates,
> +			    "RATE=%u, BAND=%x\n", status->rate_idx,
> +			    sband->n_bitrates))
>  			return;
>  		rate = &sband->bitrates[status->rate_idx];
>  	}
> -- 
> 1.6.0.6

-- 
regards,
Dhaval
