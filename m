Return-Path: <linux-kernel-owner+w=401wt.eu-S1760084AbZBTRPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084AbZBTRPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756562AbZBTRP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:15:26 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:56652 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754480AbZBTRPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:15:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkwFAC9znklMQWt2/2dsb2JhbACBbtMyhA8G
Date: Fri, 20 Feb 2009 12:15:16 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: ltt-dev@lists.casi.polymtl.ca, bert.wesarg@googlemail.com,
       bob@watson.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH URCU formal] Remove spurious read-side infinite loops.
Message-ID: <20090220171516.GF1179@Krystal>
References: <20090220015653.GA19434@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090220015653.GA19434@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:15:07 up 50 days, 17:13,  4 users,  load average: 0.58, 0.35,
	0.23
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> Remove spurious read-side infinite loops from urcu_reader() model.
> 

Merged, thanks !

Mathieu

> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  formal-model/urcu.spin |   21 +++++++++++++++++----
>  1 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/formal-model/urcu.spin b/formal-model/urcu.spin
> index 611464b..eea18e8 100644
> --- a/formal-model/urcu.spin
> +++ b/formal-model/urcu.spin
> @@ -27,6 +27,10 @@ bit free = 0;     /* Has RCU reclamation happened, e.g., kfree()? */
>  bit need_mb = 0;  /* =1 says need reader mb, =0 for reader response. */
>  byte reader_progress[4];
>  		  /* Count of read-side statement executions. */
> +bit reader_done = 0;
> +		  /* =0 says reader still running, =1 says done. */
> +bit updater_done = 0;
> +		  /* =0 says updater still running, =1 says done. */
>  
>  /* urcu definitions and variables, taken straight from the algorithm. */
>  
> @@ -50,7 +54,7 @@ proctype urcu_reader()
>  	do
>  	:: need_mb == 1 ->
>  		need_mb = 0;
> -	:: 1 -> skip;
> +	:: !updater_done -> skip;
>  	:: 1 -> break;
>  	od;
>  
> @@ -92,7 +96,7 @@ proctype urcu_reader()
>  				    reader_progress[2] +
>  				    reader_progress[3] == 0) && need_mb == 1 ->
>  					need_mb = 0;
> -				:: 1 -> skip;
> +				:: !updater_done -> skip;
>  				:: 1 -> break;
>  				od;
>  				urcu_active_readers = tmp;
> @@ -150,7 +154,7 @@ proctype urcu_reader()
>  			do
>  			:: need_mb == 1 ->
>  				need_mb = 0;
> -			:: 1 -> skip;
> +			:: !updater_done -> skip;
>  			:: 1 -> break;
>  			od;
>  		:: else -> skip;
> @@ -167,11 +171,14 @@ proctype urcu_reader()
>  	od;
>  	assert((tmp_free == 0) || (tmp_removed == 1));
>  
> +	/* Reader has completed. */
> +	reader_done = 1;
> +
>  	/* Process any late-arriving memory-barrier requests. */
>  	do
>  	:: need_mb == 1 ->
>  		need_mb = 0;
> -	:: 1 -> skip;
> +	:: !updater_done -> skip;
>  	:: 1 -> break;
>  	od;
>  }
> @@ -248,6 +255,12 @@ proctype urcu_updater()
>  
>  	/* free-up step, e.g., kfree(). */
>  	free = 1;
> +
> +	/*
> +	 * Signal updater done, ending any otherwise-infinite loops
> +	 * in the reading process.
> +	 */
> +	updater_done = 1;
>  }
>  
>  /*
> -- 
> 1.5.2.5
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
