Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbZBEVNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbZBEVNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 16:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZBEVNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 16:13:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:23016 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbZBEVNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 16:13:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RvwS9ifUseOPg6sECnZ7XAAvkplz4gURHtFwMf03Xswt625DaWMMd+tP9Sv6OXJ3th
         VXUiOxv6zw9EJT/TmVVljhqe1s5LtGA6wfcxWwQdGJ2AN1WVkv3brT40gdLu9zfVJwlv
         CIk1V9opXbsS0hTM+7MqP1T8p9V5evxTbJKFo=
Date: Fri, 6 Feb 2009 00:19:34 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Shakesh Jain <shjain@akamai.com>, ShakeshJain@akamai.com,
       linux-kernel@vger.kernel.org, juhlenko@akamai.com
Subject: Re: [PATCH] sysctl: min-max range check is broken
Message-ID: <20090205211933.GA13312@x200.localdomain>
References: <20090204084022.GB14071@akamai.com> <20090205122941.17805ff1.akpm@linux-foundation.org> <m1zlh0txgj.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zlh0txgj.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 12:55:56PM -0800, Eric W. Biederman wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Wed, 4 Feb 2009 00:40:22 -0800
> > Shakesh Jain <shjain@akamai.com>, ShakeshJain@akamai.com wrote:
> >
> >> do_proc_dointvec_minmax_conv() which gets callled from
> >> proc_dointvec_minmax proc_handler doesn't increment the pointer to
> >> the 'min' (extra1) and 'max' (extra2) after each range check which
> >> results in doing the check against same set of min and max values.
> >> 
> >> This breaks the range checking for those sysctl's where you can
> >> write multiple values to /proc with each variable having its own range
> >> specification.
> 
> I just did a quick grep for .extra1 and I don't see anywhere we use
> the code as described.
> 
> >> It seems to be implemented for the sysctl() system call strategy in
> >> sysctl_intvec() where min and max are treated as arrays.
> 
> Yep.  There is an inconsistency here.  Given how sysctl is used and
> tested, and the fact I could not find where it appears that anyone is
> passing an array into min/max I would say that the proc version is
> correct and the sysctl version is wrong.
> 
> The untested patch below looks like it will fix the this.
> 
> I don't know if there are any cases where we use minmax with an array
> of integers but I don't see the point of using an array of minmax
> values at this point.

Multiple values, each one is bounded by it's own set of values.

> For the original sysctl design it may have made
> some sense.  New code should be one value per file.

So leave them alone.

> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -2916,9 +2916,9 @@ int sysctl_intvec(struct ctl_table *table,
>  			int value;
>  			if (get_user(value, vec + i))
>  				return -EFAULT;
> -			if (min && value < min[i])
> +			if (min && value < *min)
>  				return -EINVAL;
> -			if (max && value > max[i])
> +			if (max && value > *max)
>  				return -EINVAL;

Correct way is:

	min[i] <= val[i] <= max[i]

This is what sysctl_intvec() does.
