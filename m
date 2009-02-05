Return-Path: <linux-kernel-owner+w=401wt.eu-S1759751AbZBEUa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759751AbZBEUa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbZBEUaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:30:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754142AbZBEUaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:30:14 -0500
Date: Thu, 5 Feb 2009 12:29:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakesh Jain <shjain@akamai.com>, ShakeshJain@akamai.com
Cc: linux-kernel@vger.kernel.org, juhlenko@akamai.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] sysctl: min-max range check is broken
Message-Id: <20090205122941.17805ff1.akpm@linux-foundation.org>
In-Reply-To: <20090204084022.GB14071@akamai.com>
References: <20090204084022.GB14071@akamai.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009 00:40:22 -0800
Shakesh Jain <shjain@akamai.com>, ShakeshJain@akamai.com wrote:

> do_proc_dointvec_minmax_conv() which gets callled from
> proc_dointvec_minmax proc_handler doesn't increment the pointer to
> the 'min' (extra1) and 'max' (extra2) after each range check which
> results in doing the check against same set of min and max values.
> 
> This breaks the range checking for those sysctl's where you can
> write multiple values to /proc with each variable having its own range
> specification.
> 
> It seems to be implemented for the sysctl() system call strategy in
> sysctl_intvec() where min and max are treated as arrays.
> 
> Signed-off-by: Shakesh Jain <shjain@akamai.com>
> ---
>  kernel/sysctl.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> ========================================================================
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 368d163..50bffcd 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -2377,8 +2377,8 @@ static int do_proc_dointvec_minmax_conv(int *negp, unsigned long *lvalp,
>  	struct do_proc_dointvec_minmax_conv_param *param = data;
>  	if (write) {
>  		int val = *negp ? -*lvalp : *lvalp;
> -		if ((param->min && *param->min > val) ||
> -		    (param->max && *param->max < val))
> +		if ((param->min && *(param->min++) > val) ||
> +		    (param->max && *(param->max++) < val))
>  			return -EINVAL;
>  		*valp = val;
>  	} else {

Scary code.

It will unconditionally increment param->min.

But it will only increment param->max if the (*param->min > val) test
succeeded.

Is this really the intended and correct behaviour?  It seems odd.

Even if it _is_ correct, can the code be rearranged to be less scary?
