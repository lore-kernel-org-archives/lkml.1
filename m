Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbZDMX56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbZDMX56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 19:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbZDMX5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 19:57:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752342AbZDMX5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 19:57:48 -0400
Date: Mon, 13 Apr 2009 16:50:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Valdis.Kletnieks@vt.edu,
       Mike Travis <travis@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mm-commits@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Dave Jones <davej@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: mmotm 2009-04-10-02-21 uploaded - forkbombed by work_for_cpu
In-Reply-To: <20090413102749.4ca3a217.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0904131648290.26713@localhost.localdomain>
References: <200904100922.n3A9MOIV013828@imap1.linux-foundation.org> <4609.1239456126@turing-police.cc.vt.edu> <alpine.LFD.2.00.0904130847500.4583@localhost.localdomain> <20090413171853.GA4601@elte.hu> <20090413102749.4ca3a217.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



So I applied this (commit 01599fca6758d2cd133e78f87426fc851c9ea725: 
"cpufreq: use smp_call_function_[single|many]() in acpi-cpufreq.c"), but 
just realized - because of a compiler warning - that this looks 
suspicious:

On Mon, 13 Apr 2009, Andrew Morton wrote:
> @@ -283,7 +280,7 @@ static unsigned int get_measured_perf(st
>  	unsigned int perf_percent;
>  	unsigned int retval;
>  
> -	if (!work_on_cpu(cpu, read_measured_perf_ctrs, &readin))
> +	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &cur, 1))
>  		return 0;
>  
>  	cur.aperf.whole = readin.aperf.whole -

How and why did that "read_measured_perf_ctrs, &readin" become 
"read_measured_perf_ctrs, &cur" when the work_on_cpu() was converted to 
"smp_call_function_single()"?

Looks like a bug. But such an odd one that I wonder whether there was some 
thought behind it? Andrew? 

		Linus


