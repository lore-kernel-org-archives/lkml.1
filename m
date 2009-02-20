Return-Path: <linux-kernel-owner+w=401wt.eu-S1760167AbZBTRP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167AbZBTRP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759281AbZBTRPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:15:30 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:56659 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759178AbZBTRP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:15:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkwFAC9znklMQWt2/2dsb2JhbACBbtMyhA8G
Date: Fri, 20 Feb 2009 12:15:26 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: ltt-dev@lists.casi.polymtl.ca, bert.wesarg@googlemail.com,
       bob@watson.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [[PATCH URCU formal]] Restructure urcu_updater() to more
	accurately reflect actual failure scenario.
Message-ID: <20090220171526.GG1179@Krystal>
References: <20090220015747.GA19488@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090220015747.GA19488@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:15:18 up 50 days, 17:13,  4 users,  load average: 0.57, 0.36,
	0.24
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> Restructure urcu_updater() to more accurately reflect actual failure
> scenario.
> 
> This allows an easier transformation to force failure -- simple #ifdef
> out the second counter flip out of urcu_updater()'s model of
> "current synchronize_rcu()".
> 

Merged, thanks !

Mathieu

> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  formal-model/urcu.spin |   41 +++++++++++++++++++++++++++++++----------
>  1 files changed, 31 insertions(+), 10 deletions(-)
> 
> diff --git a/formal-model/urcu.spin b/formal-model/urcu.spin
> index eea18e8..3e18457 100644
> --- a/formal-model/urcu.spin
> +++ b/formal-model/urcu.spin
> @@ -187,10 +187,38 @@ proctype urcu_reader()
>  
>  proctype urcu_updater()
>  {
> +	/* prior synchronize_rcu(), second counter flip. */
> +	need_mb = 1;
> +	do
> +	:: need_mb == 1 -> skip;
> +	:: need_mb == 0 -> break;
> +	od;
> +	urcu_gp_ctr = urcu_gp_ctr + RCU_GP_CTR_BIT;
> +	need_mb = 1;
> +	do
> +	:: need_mb == 1 -> skip;
> +	:: need_mb == 0 -> break;
> +	od;
> +	do
> +	:: 1 ->
> +		if
> +		:: (urcu_active_readers & RCU_GP_CTR_NEST_MASK) != 0 &&
> +		   (urcu_active_readers & ~RCU_GP_CTR_NEST_MASK) !=
> +		   (urcu_gp_ctr & ~RCU_GP_CTR_NEST_MASK) ->
> +			skip;
> +		:: else -> break;
> +		fi;
> +	od;
> +	need_mb = 1;
> +	do
> +	:: need_mb == 1 -> skip;
> +	:: need_mb == 0 -> break;
> +	od;
> +
>  	/* Removal statement, e.g., list_del_rcu(). */
>  	removed = 1;
>  
> -	/* synchronize_rcu(), first counter flip. */
> +	/* current synchronize_rcu(), first counter flip. */
>  	need_mb = 1;
>  	do
>  	:: need_mb == 1 -> skip;
> @@ -204,15 +232,13 @@ proctype urcu_updater()
>  	od;
>  	do
>  	:: 1 ->
> -		printf("urcu_gp_ctr=%x urcu_active_readers=%x\n", urcu_gp_ctr, urcu_active_readers);
> -		printf("urcu_gp_ctr&0x7f=%x urcu_active_readers&0x7f=%x\n", urcu_gp_ctr & ~RCU_GP_CTR_NEST_MASK, urcu_active_readers & ~RCU_GP_CTR_NEST_MASK);
>  		if
>  		:: (urcu_active_readers & RCU_GP_CTR_NEST_MASK) != 0 &&
>  		   (urcu_active_readers & ~RCU_GP_CTR_NEST_MASK) !=
>  		   (urcu_gp_ctr & ~RCU_GP_CTR_NEST_MASK) ->
>  			skip;
>  		:: else -> break;
> -		fi
> +		fi;
>  	od;
>  	need_mb = 1;
>  	do
> @@ -220,10 +246,7 @@ proctype urcu_updater()
>  	:: need_mb == 0 -> break;
>  	od;
>  
> -	/* Erroneous removal statement, e.g., list_del_rcu(). */
> -	/* removed = 1; */
> -
> -	/* synchronize_rcu(), second counter flip. */
> +	/* current synchronize_rcu(), second counter flip. */
>  	need_mb = 1;
>  	do
>  	:: need_mb == 1 -> skip;
> @@ -237,8 +260,6 @@ proctype urcu_updater()
>  	od;
>  	do
>  	:: 1 ->
> -		printf("urcu_gp_ctr=%x urcu_active_readers=%x\n", urcu_gp_ctr, urcu_active_readers);
> -		printf("urcu_gp_ctr&0x7f=%x urcu_active_readers&0x7f=%x\n", urcu_gp_ctr & ~RCU_GP_CTR_NEST_MASK, urcu_active_readers & ~RCU_GP_CTR_NEST_MASK);
>  		if
>  		:: (urcu_active_readers & RCU_GP_CTR_NEST_MASK) != 0 &&
>  		   (urcu_active_readers & ~RCU_GP_CTR_NEST_MASK) !=
> -- 
> 1.5.2.5
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
