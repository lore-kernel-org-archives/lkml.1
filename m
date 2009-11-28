Return-Path: <linux-kernel-owner+w=401wt.eu-S1751622AbZK1OAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbZK1OAS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 09:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZK1OAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 09:00:17 -0500
Received: from www.tglx.de ([62.245.132.106]:40302 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbZK1OAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 09:00:16 -0500
Date: Sat, 28 Nov 2009 15:00:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-sh@vger.kernel.org, johnstul@us.ibm.com, lethal@linux-sh.org
Subject: Re: [PATCH 02/02] clocksource: Start CMT at clocksource resume
In-Reply-To: <20091125081255.25416.85126.sendpatchset@rxone.opensource.se>
Message-ID: <alpine.LFD.2.00.0911281457560.24119@localhost.localdomain>
References: <20091125081235.25416.32481.sendpatchset@rxone.opensource.se> <20091125081255.25416.85126.sendpatchset@rxone.opensource.se>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Nov 2009, Magnus Damm wrote:

> From: Magnus Damm <damm@opensource.se>
> 
> Add code to start the CMT timer on clocksource resume.
> 
> This makes sure the timer is started during sysdev_resume().
> Without this patch the clocksource may be read as suspended,
> this after sysdev resume but before platform device resume.

Hmm, don't you have the same situation on suspend ?

platform device suspend stops the clock, but the generic code expects
it to be running until sysdev shutdown.

Another thing is that you now run both, the sysdev and the platform
resume. Is that by design or accident ?

Thanks,

	tglx

> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  drivers/clocksource/sh_cmt.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> --- 0001/drivers/clocksource/sh_cmt.c
> +++ work/drivers/clocksource/sh_cmt.c	2009-11-25 16:02:52.000000000 +0900
> @@ -432,6 +432,13 @@ static void sh_cmt_clocksource_disable(s
>  	sh_cmt_stop(cs_to_sh_cmt(cs), FLAG_CLOCKSOURCE);
>  }
>  
> +static void sh_cmt_clocksource_resume(struct clocksource *cs)
> +{
> +	struct sh_cmt_priv *p = cs_to_sh_cmt(cs);
> +
> +	sh_cmt_start(p, FLAG_CLOCKSOURCE);
> +}
> +
>  static int sh_cmt_register_clocksource(struct sh_cmt_priv *p,
>  				       char *name, unsigned long rating)
>  {
> @@ -442,6 +449,7 @@ static int sh_cmt_register_clocksource(s
>  	cs->read = sh_cmt_clocksource_read;
>  	cs->enable = sh_cmt_clocksource_enable;
>  	cs->disable = sh_cmt_clocksource_disable;
> +	cs->resume = sh_cmt_clocksource_resume;
>  	cs->mask = CLOCKSOURCE_MASK(sizeof(unsigned long) * 8);
>  	cs->flags = CLOCK_SOURCE_IS_CONTINUOUS;
>  	pr_info("sh_cmt: %s used as clock source\n", cs->name);
> 
