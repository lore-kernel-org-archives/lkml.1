Return-Path: <linux-kernel-owner+w=401wt.eu-S1752916AbZDOJJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbZDOJJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 05:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbZDOJI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 05:08:56 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:47108 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbZDOJIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 05:08:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pveXJ/sSWZb2Q7WJhavAgHVk9lK2qlGA7dufW68pmfsa8RMp0sFvuyXPCHFRNYG21j
         NPRm6e2g5+1OtU/OuIG5STwTsbEMGrefI2Hu3q8oqb9l5+O0+Pi7ZO4ix1I1/iKLvN3Q
         nvBrGxKRSo6PAoatHziS1A5pRP0f+5yRMb9Ic=
Date: Wed, 15 Apr 2009 13:38:26 +0430
From: Ali Gholami Rudi <ali@rudi.ir>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
       Mike Travis <travis@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mm-commits@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Dave Jones <davej@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: mmotm 2009-04-10-02-21 uploaded - forkbombed by work_for_cpu
Message-ID: <20090415090826.GA2808@lilem.mirepesht>
References: <200904100922.n3A9MOIV013828@imap1.linux-foundation.org> <4609.1239456126@turing-police.cc.vt.edu> <alpine.LFD.2.00.0904130847500.4583@localhost.localdomain> <20090413171853.GA4601@elte.hu> <20090413102749.4ca3a217.akpm@linux-foundation.org> <20090415081534.GA2894@lilem.mirepesht> <20090415013456.cf5ce205.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415013456.cf5ce205.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-04-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:
> >       [ Made it use smp_call_function_many() instead of looping over cpu's
> >         with smp_call_function_single()    - Linus ]
> 
> <stares suspiciously at smp_call_function_many()>
> 
>  * smp_call_function_many(): Run a function on a set of other CPUs.
> 
> "other".  It refuses to call the function on *this* CPU.  Tricky.
> 
> Does this fix it up?
> 
> --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c~a
> +++ a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> @@ -204,7 +204,10 @@ static void drv_read(struct drv_cmd *cmd
>  
>  static void drv_write(struct drv_cmd *cmd)
>  {
> -	smp_call_function_many(cmd->mask, do_drv_write, cmd, 1);
> +	unsigned cpu;
> +
> +	for_each_cpu(cpu, cmd->mask)
> +		smp_call_function_single(cpu, do_drv_write, cmd, 1);	
>  }
>  
>  static u32 get_cur_val(const struct cpumask *mask)
> _

Yes, it does fix it.

Thanks,
Ali
