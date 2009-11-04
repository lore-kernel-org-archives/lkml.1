Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbZKDK3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbZKDK3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 05:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbZKDK3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 05:29:15 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:40487 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbZKDK3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 05:29:14 -0500
Message-ID: <4AF15771.8060204@gmail.com>
Date: Wed, 04 Nov 2009 11:29:05 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Amerigo Wang <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [Patch] net: fix incorrect counting in __scm_destroy()
References: <20091104100717.4785.57149.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104100717.4785.57149.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 04 Nov 2009 11:29:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang a écrit :
> It seems that in __scm_destroy() we forgot to decrease
> the ->count after fput(->fp[i]), this may cause some
> problem when we recursively call fput() again.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: David S. Miller <davem@davemloft.net>
> 
> ---
> diff --git a/net/core/scm.c b/net/core/scm.c
> index b7ba91b..fa53219 100644
> --- a/net/core/scm.c
> +++ b/net/core/scm.c
> @@ -120,8 +120,10 @@ void __scm_destroy(struct scm_cookie *scm)
>  				fpl = list_first_entry(&work_list, struct scm_fp_list, list);
>  
>  				list_del(&fpl->list);
> -				for (i=fpl->count-1; i>=0; i--)
> +				for (i = fpl->count-1; i >= 0; i--) {
>  					fput(fpl->fp[i]);
> +					fpl->count--;
> +				}
>  				kfree(fpl);
>  			}
>  

Hmm, your patch seems suspicious.

Are you fixing a real crash/bug, or is it something you discovered in a code review ?

Given we kfree(fpl) at the end of loop, we cannot recursively call __scm_destroy()
on same fpl, it would be a bug anyway ?

So you probably need something better, like testing fpl->list being not re-included
in current->scm_work_list before kfree() it 

