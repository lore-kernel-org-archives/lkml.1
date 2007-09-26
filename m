Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbXIZSDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbXIZSDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbXIZSDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:03:01 -0400
Received: from barikada.upol.cz ([158.194.242.200]:36274 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbXIZSC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:02:59 -0400
Date: Wed, 26 Sep 2007 20:18:43 +0200
To: "Bernhard Walle (in kexec list)" <kexec@lists.infradead.org>,
       akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [patch 1/7] Extended crashkernel command line
Message-ID: <20070926181843.GB24301@flower.upol.cz>
References: <20070925182257.900701776@strauss.suse.de> <20070925182258.175348676@strauss.suse.de> <E1IaHPU-00089b-Bc@flower> <20070926161602.GA26909@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926161602.GA26909@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wed, Sep 26, 2007 at 06:16:02PM +0200, Bernhard Walle (part two, see bottom):
> > memparse(), as a wrapper for somple_strtoll(), always have a return value
> > (zero by default).
> > <http://article.gmane.org/gmane.linux.kernel/583426>

Sorry for my typos, i should write `simple_strtoull()'. This function
(ULL from str) have always return value grater or equal to zero.

Thus,

> 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> 
> ---
>  kernel/kexec.c |   31 ++++++++++++++++++++++++-------
>  1 file changed, 24 insertions(+), 7 deletions(-)
> 
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1172,33 +1172,50 @@ static int __init parse_crashkernel_mem(
>  	do {
>  		unsigned long long start = 0, end = ULLONG_MAX;
>  		unsigned long long size = -1;

no need in assigning values here, unless you plan to use them in case
of `return -EINVAL', but i can not see that,

> +		char *tmp;
>  
>  		/* get the start of the range */
> -		start = memparse(cur, &cur);
> +		start = memparse(cur, &tmp);
> +		if (cur == tmp) {
> +			pr_warning("crashkernel: Memory value expected\n");
> +			return -EINVAL;
> +		}
> +		cur = tmp;
>  		if (*cur != '-') {
> -			printk(KERN_WARNING "crashkernel: '-' expected\n");
> +			pr_warning("crashkernel: '-' expected\n");
>  			return -EINVAL;
>  		}
>  		cur++;
>  
>  		/* if no ':' is here, than we read the end */
>  		if (*cur != ':') {
> -			end = memparse(cur, &cur);
> +			end = memparse(cur, &tmp);
> +			if (cur == tmp) {
> +				pr_warning("crashkernel: Memory "
> +						"value expected\n");
> +				return -EINVAL;
> +			}
> +			cur = tmp;
>  			if (end <= start) {
> -				printk(KERN_WARNING "crashkernel: end <= start\n");
> +				pr_warning("crashkernel: end <= start\n");
>  				return -EINVAL;
>  			}
>  		}
>  
>  		if (*cur != ':') {
> -			printk(KERN_WARNING "crashkernel: ':' expected\n");
> +			pr_warning("crashkernel: ':' expected\n");
>  			return -EINVAL;
>  		}
>  		cur++;
>  
> -		size = memparse(cur, &cur);
> +		size = memparse(cur, &tmp);
> +		if (cur == tmp) {
> +			pr_warning("Memory value expected\n");
> +			return -EINVAL;
> +		}
> +		cur = tmp;
>  		if (size < 0) {

`size' cannot be less that zero here (wonder, if it matters to have
userspace model of this parser and actually feed it with garbage input).

> -			printk(KERN_WARNING "crashkernel: invalid size\n");
> +			pr_warning("crashkernel: invalid size\n");
>  			return -EINVAL;
>  		}
>  


Wed, Sep 26, 2007 at 06:16:02PM +0200, Bernhard Walle (part one):
> Ok, that's fixed now, see patch below.
> 
> > And why not to make overall result reliable? This is kernel after all.
> > 
> > I.e. if there's valid `crashkernel=' option, but some parsing errors, why
> > not to apply some heuristics with warning in syslog, if user have some
> > conf, bootloader (random) errors, but feature still works?
> 
> I'm against guessing. The user has to specify a parameter which is
> right according to syntax.
> 
> However, I plan to make a patch that the kernel can detect a sensible
> offset automatically for i386 and x86_64 as it's done in ia64. Since
> both architectures have a relocatable kernel now, that makes perfectly
> sense. But that's another patch.

I was thinking about errors in YaST or typos in bootloader config, that
may appear sometimes. And kernel must tolerate this kind of userspace
input to be more reliable. But you know better, i just am waving hands.
____
("Mail-Followup-To:" respected)
