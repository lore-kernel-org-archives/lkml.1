Return-Path: <linux-kernel-owner+w=401wt.eu-S1760427AbZAOVtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760427AbZAOVtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbZAOVtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 16:49:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539AbZAOVtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 16:49:35 -0500
Date: Thu, 15 Jan 2009 13:48:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: cpumask: make cpumask.h eat its own dogfood.
Message-Id: <20090115134857.456a931e.akpm@linux-foundation.org>
In-Reply-To: <200901032108.n03L8QiP005724@hera.kernel.org>
References: <200901032108.n03L8QiP005724@hera.kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Jan 2009 21:08:26 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ae7a47e72e1a0b5e2b46d1596bc2c22942a73023
> Commit:     ae7a47e72e1a0b5e2b46d1596bc2c22942a73023
> Parent:     b3199c025d1646e25e7d1d640dd605db251dccf8
> Author:     Rusty Russell <rusty@rustcorp.com.au>
> AuthorDate: Tue Dec 30 09:05:15 2008 +1030
> Committer:  Rusty Russell <rusty@rustcorp.com.au>
> CommitDate: Tue Dec 30 09:05:15 2008 +1030
> 
>     cpumask: make cpumask.h eat its own dogfood.
>     
>     Changes:
>     1) cpumask_t to struct cpumask,
>     2) cpus_weight_nr to cpumask_weight,
>     3) cpu_isset to cpumask_test_cpu,
>     4) ->bits to cpumask_bits()
>     5) cpu_*_map to cpu_*_mask.
>     6) for_each_cpu_mask_nr to for_each_cpu

I can't find this commit (by this title) on linux-kernel to reply to. 
Please try real hard to prevent this from occurring?

> -#define num_online_cpus()	cpus_weight_nr(cpu_online_map)
> -#define num_possible_cpus()	cpus_weight_nr(cpu_possible_map)
> -#define num_present_cpus()	cpus_weight_nr(cpu_present_map)
> -#define cpu_online(cpu)		cpu_isset((cpu), cpu_online_map)
> -#define cpu_possible(cpu)	cpu_isset((cpu), cpu_possible_map)
> -#define cpu_present(cpu)	cpu_isset((cpu), cpu_present_map)
> -#define cpu_active(cpu)		cpu_isset((cpu), cpu_active_map)
> +#define num_online_cpus()	cpumask_weight(cpu_online_mask)
> +#define num_possible_cpus()	cpumask_weight(cpu_possible_mask)
> +#define num_present_cpus()	cpumask_weight(cpu_present_mask)
> +#define cpu_online(cpu)		cpumask_test_cpu((cpu), cpu_online_mask)
> +#define cpu_possible(cpu)	cpumask_test_cpu((cpu), cpu_possible_mask)
> +#define cpu_present(cpu)	cpumask_test_cpu((cpu), cpu_present_mask)
> +#define cpu_active(cpu)		cpumask_test_cpu((cpu), cpu_active_mask)

These alterations secretly changed the return type of these macros from
"int" to "unsigned int".

This has caused a couple of compile-time warnings from min() and max().
Hopefully there won't be any more serious fallout.

I think it's a _good_ change - there's no logical reason for these
macros to return negative numbers.  But I suspect it was an accidental
change.

But everything is now all screwed up.  cpumask_weight() and friends
return `unsigned int', but cpus_weight() and bitmap_weight() return
`int'.

