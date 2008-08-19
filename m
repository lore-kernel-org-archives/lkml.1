Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbYHSAbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbYHSAbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbYHSAbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:31:39 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:41544 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbYHSAbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:31:38 -0400
Date: Tue, 19 Aug 2008 10:31:35 +1000
From: Simon Horman <horms@verge.net.au>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Sven Wegener <sven.wegener@stealer.net>
Subject: Re: [patch 20/60] ipvs: Fix possible deadlock in estimator code
Message-ID: <20080819003135.GA23626@verge.net.au>
References: <20080818191012.663450219@mini.kroah.org> <20080818191953.GR10350@suse.de> <20080818183230.966310219@mini.kroah.org> <20080818184310.GU29394@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818191953.GR10350@suse.de> <20080818184310.GU29394@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 11:43:10AM -0700, Greg KH wrote:
> 2.6.26-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Sven Wegener <sven.wegener@stealer.net>
> 
> commit 8ab19ea36c5c5340ff598e4d15fc084eb65671dc upstream
> 
> There is a slight chance for a deadlock in the estimator code. We can't call
> del_timer_sync() while holding our lock, as the timer might be active and
> spinning for the lock on another cpu. Work around this issue by using
> try_to_del_timer_sync() and releasing the lock. We could actually delete the
> timer outside of our lock, as the add and kill functions are only every called
> from userspace via [gs]etsockopt() and are serialized by a mutex, but better
> make this explicit.
> 
> Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
> Acked-by: Simon Horman <horms@verge.net.au>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  net/ipv4/ipvs/ip_vs_est.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> --- a/net/ipv4/ipvs/ip_vs_est.c
> +++ b/net/ipv4/ipvs/ip_vs_est.c
> @@ -172,8 +172,11 @@ void ip_vs_kill_estimator(struct ip_vs_s
>  		kfree(est);
>  		killed++;
>  	}
> -	if (killed && est_list == NULL)
> -		del_timer_sync(&est_timer);
> +	while (killed && !est_list && try_to_del_timer_sync(&est_timer) < 0) {
> +		write_unlock_bh(&est_lock);
> +		cpu_relax();
> +		write_lock_bh(&est_lock);
> +	}
>  	write_unlock_bh(&est_lock);
>  }
>  

Hi,

I am comfortable with this change for both 2.6.25-stable and 2.6.26-stable.

An arguably cleaner though more invasive fix, which will likely go
into 2.6.28 is to use init and cleanup fuctions for the estimators
as the empty case can actually only occur during the unload of IPVS.

See "ipvs: Create init functions for estimator code", which was posted by
Sven to netdev & lvs-devel, and is currently living in horms/lvs-2.6.git on
git.kernel.org.

