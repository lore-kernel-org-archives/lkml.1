Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbXKSTwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbXKSTwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 14:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbXKSTwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 14:52:06 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:37455 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbXKSTwE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 14:52:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:reply-to:organization:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:sender;
        b=XpCh9mJZFRLMcii0djB5qpMum9Yt1e2VwxZxMdhbmgJwEcgSpvVURKjdfHbEkNs/x0MNDFrRogO0htE16V+7ZL9vz55EuiCmV5XlJqnAQxaBiwRRaS3kwQhJSqzeBBc9n6EpgdFrw+IhLZwDdNUSQWkGPeQ76HnRSrL3BU0TaC8=
From: David <david@livux.com>
Reply-To: david@livux.com
Organization: LiVux
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3, v2.6.23.8,v2.6.22.13, v2.6.21.7
Date: Mon, 19 Nov 2007 20:51:43 +0100
User-Agent: KMail/1.9.7
References: <200711191925.12072.david@livux.com> <20071119185759.GA12117@elte.hu>
In-Reply-To: <20071119185759.GA12117@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711192051.44095.david@livux.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Lunes, 19 de Noviembre de 2007, Ingo Molnar escribió:
> * David <david@livux.com> wrote:
> > Hi Ingo,
> >
> > Thnx a lot for theses backports...
> >
> > Ran into this while compiling a 2.6.23.8 with CFS v24
> >
> > Compiling with CONFIG_FAIR_GROUP_SCHED disabled :
> >
> > kernel/sysctl.c:305: error: 'sysctl_sched_min_bal_int_shares' undeclared
> > here (not in a function) kernel/sysctl.c:313: error:
> > 'sysctl_sched_max_bal_int_shares' undeclared here (not in a function)
> >
> > I made that patch to make it compile.
>
> thanks - i've applied your fix and have re-uploaded under the same
> filenames - so if anyone hits this problem it can be fixed by
> re-downloading the same patch again. Find below the current set of -v24
> build fixlets.
>
> 	Ingo
>
> --- linux.orig/kernel/sysctl.c
> +++ linux/kernel/sysctl.c
> @@ -309,6 +309,7 @@ static struct ctl_table kern_table[] = {
>  		.mode		= 644,
>  		.proc_handler	= &proc_dointvec,
>  	},
> +#ifdef CONFIG_FAIR_GROUP_SCHED
>  	{
>  		.ctl_name	= CTL_UNNUMBERED,
>  		.procname	= "sched_min_bal_int_shares",
> @@ -326,6 +327,7 @@ static struct ctl_table kern_table[] = {
>  		.proc_handler	= &proc_dointvec,
>  	},
>  #endif
> +#endif
>  	{
>  		.ctl_name	= CTL_UNNUMBERED,
>  		.procname	= "sched_compat_yield",
> --- linux.orig/include/linux/sched.h
> +++ linux/include/linux/sched.h
> @@ -10,7 +10,7 @@
>  #define COMPAT_REGISTER_SYSCTL
>
>  /* backporting helper macro: */
> -#define cpu_sibling_map(cpu) per_cpu(cpu_sibling_map, cpu)
> +#define cpu_sibling_map(cpu) cpu_sibling_map[cpu]
>
>  /*
>   * cloning flags:

I have removed all other patches, and applied only cfs v24 above 2.6.23.8, and 
the compiler ran into (with CONFIG_FAIR_GROUP_SCHED enabled):

 CC      kernel/sched.o
kernel/sched.c: In function 'rebalance_shares':
kernel/sched.c:7021: error: dereferencing pointer to incomplete type
kernel/sched.c: In function 'load_balance_monitor':
kernel/sched.c:7107: error: 'ndoms_cur' undeclared (first use in this 
function)
kernel/sched.c:7107: error: (Each undeclared identifier is reported only once
kernel/sched.c:7107: error: for each function it appears in.)
kernel/sched.c:7108: error: 'doms_cur' undeclared (first use in this function)
kernel/sched.c:7114: error: 'struct rq' has no member named 'sd'
kernel/sched.c:7114: warning: type defaults to 'int' in declaration 
of '_________p1'
kernel/sched.c:7114: error: 'struct rq' has no member named 'sd'
kernel/sched.c:7114: warning: assignment makes pointer from integer without a 
cast
kernel/sched.c:7114: error: dereferencing pointer to incomplete type
kernel/sched.c:7115: error: dereferencing pointer to incomplete type
kernel/sched.c:7115: error: 'SD_LOAD_BALANCE' undeclared (first use in this 
function)
kernel/sched.c:7108: warning: unused variable 'cpumap'
make[1]: *** [kernel/sched.o] Error 1

I can send my config if needed

-- 
David Rodríguez García
Director Técnico
LiVux I+D S.L.
