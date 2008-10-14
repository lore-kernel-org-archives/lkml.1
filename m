Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbYJNMDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbYJNMDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 08:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbYJNMDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 08:03:13 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:9164 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbYJNMDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 08:03:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ILM4htLGBEjvieG4BhmqF/dZM0RPpZlf2SvLXne/Mnpch/Re5sG92p8uDIpKdzMErS
         HfEvTGYKipZ4QHoS9IgFLoyOci4Ne+vkRvgq0GTkpSJ8wsTRiaxDIVaYkDHAlNBXOsJW
         cOl/0ddHrE1SwIuOY4atNbutsYKRrvZdPg2pc=
Date: Tue, 14 Oct 2008 16:06:05 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Sven Wegener <sven.wegener@stealer.net>
Cc: David Miller <davem@davemloft.net>, davej@redhat.com,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: sparc64 allmodconfig build failure...
Message-ID: <20081014120605.GB23213@x200.localdomain>
References: <20081013.230251.215237620.davem@davemloft.net> <alpine.LNX.2.00.0810140945060.13897@titan.stealer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0810140945060.13897@titan.stealer.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 10:30:20AM +0200, Sven Wegener wrote:
> On Mon, 13 Oct 2008, David Miller wrote:
> 
> > sparc64 allmodconfig started failing to build recently:
> > 
> >   MODPOST 1946 modules
> > ERROR: "cpufreq_gov_performance" [arch/sparc64/kernel/us3_cpufreq.ko] undefined!
> > 
> > It seems to be caused by the following commit:
> > 
> > commit c4d14bc0bb5d13e316890651ae4518b764c3344c
> > Author: Sven Wegener <sven.wegener@stealer.net>
> > Date:   Sat Sep 20 16:50:08 2008 +0200
> > 
> >     [CPUFREQ] Don't export governors for default governor
> >     
> >     We don't need to export the governors for use as the default governor,
> >     because the default governor will be built-in anyway and we can access
> >     the symbol directly.
> 
> Uhm, we could resolve this dependency with the patch below. Although we 
> might as well revert the above commit or introduce an exported function 
> that sets the default governor on a policy.
> 
> Subject: [CPUFREQ] Fix build failure on sparc64
> 
> Commit c4d14bc0bb5d13e316890651ae4518b764c3344c ("[CPUFREQ] Don't export 
> governors for default governor") caused a build failure, because there are 
> several architectures that have cpufreq code that can be built as a 
> module, but the code also requires access to the default governor. Export 
> the default governor so that it can be accessed by these module.

> --- a/drivers/cpufreq/cpufreq_conservative.c
> +++ b/drivers/cpufreq/cpufreq_conservative.c
> @@ -576,7 +576,9 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>  	return 0;
>  }
>  
> -#ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
> +#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
> +EXPORT_SYMBOL(cpufreq_gov_conservative);
> +#else
>  static
>  #endif

This is ugly, ugly.
