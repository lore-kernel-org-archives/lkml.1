Return-Path: <linux-kernel-owner+w=401wt.eu-S934622AbYEUMif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934622AbYEUMif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 08:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764368AbYEUMi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 08:38:26 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57826 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763453AbYEUMiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 08:38:25 -0400
Date: Wed, 21 May 2008 07:38:02 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Shi Weihua <shiwh@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, morgan@kernel.org,
       linux-security-module@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, serue@us.ibm.com,
       jmorris@namei.org
Subject: Re: [PATCH] capabilities: fix sys_prctl() returned uninitialized
	value
Message-ID: <20080521123802.GB7715@sergelap.austin.ibm.com>
References: <4833ED6D.8030606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4833ED6D.8030606@cn.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Shi Weihua (shiwh@cn.fujitsu.com):
> When we test kernel by the latest LTP(20080430) on ia64,
> the following failure occured:
> -------------------------------------
> prctl01     1  PASS  :  Test Passed
> prctl01     0  WARN  :  prctl() returned 2048 errno = 0 : Success
> prctl01     1  PASS  :  Test Passed
> prctl01     2  FAIL  :  Test Failed
> -------------------------------------
> 
> We found commit 3898b1b4ebff8dcfbcf1807e0661585e06c9a91c
> causes this failure by git-bisect.
> And, we found *rc_p has not been initialized if switch-default 
> of the function cap_task_prctl()(security/commoncap.c). When *rc_p
> uninitialized, sys_prctl() will return a wrong value.
> 
> Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com> 
> ---
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 5edabc7..a4b28c8 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -649,6 +649,7 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
> 
>  	default:
>  		/* No functionality available - continue with default */
> +		*rc_p = 0;
>  		return 0;
>  	}

No, this case here means that the capability module is not taking
responsibility for this call.  So it should not be setting rc_p.

So you'll want to find another path in kernel/sys.c:sys_prctl()
where error doesn't get set.  Do you know what 'i' was in prctl01
at the time of failure?

For instance, I notice that PR_SET_DUMPABLE doesn't set the value
of error if arg2 is valid.  Also PR_SET_NAME and PR_GET_NAME
don't set error.

-serge
