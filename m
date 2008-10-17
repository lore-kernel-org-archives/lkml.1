Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYJQLik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYJQLik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 07:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbYJQLic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 07:38:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:17754 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbYJQLib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 07:38:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iXt1KwgcsNkbJtCvVxruJphiP0yKGBHsc2U6SCsDTV/R6TQn0mAe0MjttnqNUGA1T3
         eiTJ8CzCqxGtVBftA/IWXcmToQiK4frBTfdmtzD7G/6TjIcmDBlw/KaUBojskh1CxQ5q
         LlPJxmrT99IYjAl83YsM8LbPSIDJv/o+AnbuA=
Date: Fri, 17 Oct 2008 15:41:32 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/proc: fix /proc/cpuinfo cpu offline bug
Message-ID: <20081017114132.GA18994@x200.localdomain>
References: <48F852FD.7070108@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F852FD.7070108@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 04:55:25PM +0800, Lai Jiangshan wrote:
> In my test, I found that if a cpu has been offline,
> the next cpus may not be shown in the /proc/cpuinfo.
> 
> trivially reproduce this bug:
> 
> 1) add these lines in the end of show_cpuinfo()
> 	if (m->size - m->count - 20 > 0)
> 		seq_printf(m, "%*s", (int)(m->size - m->count - 20), "show bug\n");

What is it?

Can you just show wrong /proc/cpuinfo ?

Can someone with at least 4-way box please do so?

> 3) offline cpu#1
> 4) cat /proc/cpuinfo
>    cpu#2 and cpu#3 .... cannot be shown in /proc/cpuinfo

> --- a/arch/x86/kernel/cpu/proc.c
> +++ b/arch/x86/kernel/cpu/proc.c
> @@ -160,14 +160,16 @@ static void *c_start(struct seq_file *m, loff_t *pos)
>  {
>  	if (*pos == 0)	/* just in case, cpu 0 is not the first */
>  		*pos = first_cpu(cpu_online_map);
> -	if ((*pos) < nr_cpu_ids && cpu_online(*pos))
> +	else
> +		*pos = next_cpu_nr(*pos - 1, cpu_online_map);
> +	if ((*pos) < nr_cpu_ids)
>  		return &cpu_data(*pos);
>  	return NULL;
>  }
>  
>  static void *c_next(struct seq_file *m, void *v, loff_t *pos)
>  {
> -	*pos = next_cpu(*pos, cpu_online_map);
> +	(*pos)++;
>  	return c_start(m, pos);
>  }
