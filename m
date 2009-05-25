Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbZEYK3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbZEYK3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 06:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbZEYK2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 06:28:25 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:53596 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbZEYK2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 06:28:24 -0400
Date: Mon, 25 May 2009 12:28:20 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Michael Abbott <michael@araneidae.co.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Re: /proc/uptime idle counter remains at 0
Message-ID: <20090525122820.044e1e35@skybase>
In-Reply-To: <Pine.LNX.4.64.0905181421300.1088@venus.araneidae.co.uk>
References: <Pine.LNX.4.64.0905181421300.1088@venus.araneidae.co.uk>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009 14:23:03 +0100 (BST)
Michael Abbott <michael@araneidae.co.uk> wrote:

> diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
> index 0c10a0b..0f43395 100644
> --- a/fs/proc/uptime.c
> +++ b/fs/proc/uptime.c
> @@ -4,13 +4,19 @@
>  #include <linux/sched.h>
>  #include <linux/seq_file.h>
>  #include <linux/time.h>
> +#include <linux/kernel_stat.h>
>  #include <asm/cputime.h>
> 
>  static int uptime_proc_show(struct seq_file *m, void *v)
>  {
>  	struct timespec uptime;
>  	struct timespec idle;
> -	cputime_t idletime = cputime_add(init_task.utime, init_task.stime);
> +	int len, i;
> +	cputime_t idletime = 0;
> +
> +	for_each_possible_cpu(i) 
> +		idletime = cputime64_add(idletime, kstat_cpu(i).cpustat.idle);
> +	idletime = cputime64_to_clock_t(idletime);
> 
>  	do_posix_clock_monotonic_gettime(&uptime);
>  	monotonic_to_bootbased(&uptime);

I found another problem with this patch: why do you convert the
idletime from cputime_t to clock_t ? The call to cputime_to_timespec
takes a cputime_t and the conversion from cputime to clock_t returns a
value that is way to small on s390. After removing that line it works
for me but I wonder why you added it.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

