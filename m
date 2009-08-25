Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbZHYHjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbZHYHjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 03:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbZHYHji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 03:39:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59820 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbZHYHjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 03:39:37 -0400
Message-ID: <4A93949B.2020404@cn.fujitsu.com>
Date: Tue, 25 Aug 2009 15:36:59 +0800
From: Wei Yongjun <yjwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Chunbo Luo <chunbo.luo@windriver.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sctp: fix the check for path failure detection
References: <1251106637-434-1-git-send-email-chunbo.luo@windriver.com>
In-Reply-To: <1251106637-434-1-git-send-email-chunbo.luo@windriver.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chunbo Luo wrote:
> The transport error count should be incremented when an outstanding
> HB is not acknowledged. And the path failure detection should be done
> before sending out the HB.
>   
> Signed-off-by: Chunbo Luo <chunbo.luo@windriver.com>
> ---
>  net/sctp/sm_sideeffect.c |    6 +++++-
>  net/sctp/sm_statefuns.c  |    8 ++++----
>  2 files changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> index 86426aa..fbdf4de 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -446,7 +446,11 @@ static void sctp_do_8_2_transport_strike(struct sctp_association *asoc,
>  	if (transport->state != SCTP_UNCONFIRMED)
>  		asoc->overall_error_count++;
>  
> -	if (transport->state != SCTP_INACTIVE &&
> +	/*
> +	 * The transport error count is incremented when an outstanding HB
> +	 * is not acknowledged. 
> +	 */
>   

T3-rtx timer expires also need to increment error count.

> +	if (transport->hb_sent && transport->state != SCTP_INACTIVE &&
>  	    (transport->error_count++ >= transport->pathmaxrxt)) {
>  		SCTP_DEBUG_PRINTK_IPADDR("transport_strike:association %p",
>  					 " transport IP: port:%d failed.\n",
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 7288192..7f77099 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -981,10 +981,6 @@ sctp_disposition_t sctp_sf_sendbeat_8_3(const struct sctp_endpoint *ep,
>  	 */
>  
>  	if (transport->param_flags & SPP_HB_ENABLE) {
> -		if (SCTP_DISPOSITION_NOMEM ==
> -				sctp_sf_heartbeat(ep, asoc, type, arg,
> -						  commands))
> -			return SCTP_DISPOSITION_NOMEM;
>  		/* Set transport error counter and association error counter
>  		 * when sending heartbeat.
>  		 */
> @@ -992,6 +988,10 @@ sctp_disposition_t sctp_sf_sendbeat_8_3(const struct sctp_endpoint *ep,
>  				SCTP_TRANSPORT(transport));
>  		sctp_add_cmd_sf(commands, SCTP_CMD_TRANSPORT_HB_SENT,
>  				SCTP_TRANSPORT(transport));
> +		if (SCTP_DISPOSITION_NOMEM ==
> +				sctp_sf_heartbeat(ep, asoc, type, arg,
> +						  commands))
> +			return SCTP_DISPOSITION_NOMEM;
>  	}
>  	sctp_add_cmd_sf(commands, SCTP_CMD_HB_TIMER_UPDATE,
>  			SCTP_TRANSPORT(transport));
>   

How about this one:

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 86426aa..fb723dd 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -447,7 +447,7 @@ static void sctp_do_8_2_transport_strike(struct sctp_association *asoc,
 		asoc->overall_error_count++;
 
 	if (transport->state != SCTP_INACTIVE &&
-	    (transport->error_count++ >= transport->pathmaxrxt)) {
+	    (transport->error_count >= transport->pathmaxrxt)) {
 		SCTP_DEBUG_PRINTK_IPADDR("transport_strike:association %p",
 					 " transport IP: port:%d failed.\n",
 					 asoc,
@@ -468,6 +468,7 @@ static void sctp_do_8_2_transport_strike(struct sctp_association *asoc,
 	 * that indicates that we have an outstanding HB.
 	 */
 	if (!is_hb || transport->hb_sent) {
+		transport->error_count++;
 		transport->last_rto = transport->rto;
 		transport->rto = min((transport->rto * 2), transport->asoc->rto_max);
 	}





