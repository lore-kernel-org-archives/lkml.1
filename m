Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbYG2EWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbYG2EWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 00:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbYG2EWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 00:22:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:38436 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750955AbYG2EWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 00:22:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+wS1FmdUWwW1k6W8IgN4QNPNYECyqUeKL2WjD0iU
	X8oqdFBRO0ItIp
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
	00000002
From: Mike Galbraith <efault@gmx.de>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       suresh.b.siddha@intel.com, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20080728222643.GA6339@slug>
References: <20080725095317.GA12636@skywalker>  <20080728222643.GA6339@slug>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 06:22:15 +0200
Message-Id: <1217305335.5553.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 00:26 +0200, Frederik Deweerdt wrote:
> Hello  Aneesh,
> 
> On Fri, Jul 25, 2008 at 03:23:17PM +0530, Aneesh Kumar K.V wrote:
> > [  163.378265] BUG: unable to handle kernel NULL pointer dereference at 00000002
> > [  163.378276] IP: [<c0124933>] sched_power_savings_store+0x13/0x70
> 
> Does the attached patch solve the problem?

Patch seems to have missed the boat for rc1 too.

> 
> Regards,
> Frederik
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 0047bd9..090b397 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -7643,34 +7643,30 @@ static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
>  }
>  
>  #ifdef CONFIG_SCHED_MC
> -static ssize_t sched_mc_power_savings_show(struct sys_device *dev,
> -				struct sysdev_attribute *attr, char *page)
> +static ssize_t sched_mc_power_savings_show(struct sysdev_class *cls, char *page)
>  {
>  	return sprintf(page, "%u\n", sched_mc_power_savings);
>  }
> -static ssize_t sched_mc_power_savings_store(struct sys_device *dev,
> -					    struct sysdev_attribute *attr,
> +static ssize_t sched_mc_power_savings_store(struct sysdev_class *cls,
>  					    const char *buf, size_t count)
>  {
>  	return sched_power_savings_store(buf, count, 0);
>  }
> -static SYSDEV_ATTR(sched_mc_power_savings, 0644, sched_mc_power_savings_show,
> +static SYSDEV_CLASS_ATTR(sched_mc_power_savings, 0644, sched_mc_power_savings_show,
>  		   sched_mc_power_savings_store);
>  #endif
>  
>  #ifdef CONFIG_SCHED_SMT
> -static ssize_t sched_smt_power_savings_show(struct sys_device *dev,
> -				struct sysdev_attribute *attr, char *page)
> +static ssize_t sched_smt_power_savings_show(struct sysdev_class *cls, char *page)
>  {
>  	return sprintf(page, "%u\n", sched_smt_power_savings);
>  }
> -static ssize_t sched_smt_power_savings_store(struct sys_device *dev,
> -					     struct sysdev_attribute *attr,
> +static ssize_t sched_smt_power_savings_store(struct sysdev_class *cls,
>  					     const char *buf, size_t count)
>  {
>  	return sched_power_savings_store(buf, count, 1);
>  }
> -static SYSDEV_ATTR(sched_smt_power_savings, 0644, sched_smt_power_savings_show,
> +static SYSDEV_CLASS_ATTR(sched_smt_power_savings, 0644, sched_smt_power_savings_show,
>  		   sched_smt_power_savings_store);
>  #endif
>  
> @@ -7680,13 +7676,13 @@ int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
>  
>  #ifdef CONFIG_SCHED_SMT
>  	if (smt_capable())
> -		err = sysfs_create_file(&cls->kset.kobj,
> -					&attr_sched_smt_power_savings.attr);
> +		err = sysdev_class_create_file(cls,
> +					       &attr_sched_smt_power_savings);
>  #endif
>  #ifdef CONFIG_SCHED_MC
>  	if (!err && mc_capable())
> -		err = sysfs_create_file(&cls->kset.kobj,
> -					&attr_sched_mc_power_savings.attr);
> +		err = sysdev_class_create_file(cls,
> +					       &attr_sched_mc_power_savings);
>  #endif
>  	return err;
>  }


