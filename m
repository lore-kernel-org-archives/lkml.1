Return-Path: <linux-kernel-owner+w=401wt.eu-S1760093AbZLOMJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093AbZLOMJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 07:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760081AbZLOMJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 07:09:22 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42222 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760080AbZLOMJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 07:09:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EG/PuBe2nMjdys2aLrVR8LA4qrMFhwWKDceuOJIjyem91BVO4sznW61VIy9CKW4G3/
         j9/8CDY/eOri6tN8I+GMpCxIg6OFYdFMWrbh2Sj4yxyYCYAKa9vcrmCA+7d/3vvkXS+X
         zG0jv+12Ijfl+67bg8OM/oij/UWxESGX0YzFg=
Date: Tue, 15 Dec 2009 13:09:15 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, shemminger@vyatta.com,
       paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Subject: Re: [tip:perf/diff] perf diff: Introduce tool to show performance
	difference
Message-ID: <20091215120913.GA5070@nowhere>
References: <1260828571-3613-3-git-send-email-acme@infradead.org> <tip-86a9eee047ba09a714c3b8e27c9df2bbf715393a@git.kernel.org> <20091215095214.GA749@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091215095214.GA749@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 10:52:14AM +0100, Ingo Molnar wrote:
> 
> 'perf diff' looks to be very useful!
> 
> I think we want to improve the default output some more:
> 
> For example there should be column names like for perf report:
> 
> # Overhead    Command                 Shared Object  Symbol
> # ........  .........  ............................  ......
> #
>     13.87%  hackbench  [kernel]                      [k] _raw_spin_lock
>      5.60%  hackbench  [kernel]                      [k] copy_user_generic_string
>      5.23%  hackbench  [kernel]                      [k] __cache_free
> 
> Secondly, here's the current output of two successive 'hackbench 10' run:
> 
>    1 +2381        +58         [kernel.kallsyms]   avc_has_perm_noaudit
>    2              -26         [kernel.kallsyms]   clear_page_c
>    3  +107        +29         [kernel.kallsyms]   _raw_spin_lock
>    4  +106        +23         [kernel.kallsyms]   _raw_spin_lock
>    5  +105        +22         [kernel.kallsyms]   _raw_spin_lock
>    6  +104        +21         [kernel.kallsyms]   _raw_spin_lock
>    7  +103        +20         [kernel.kallsyms]   _raw_spin_lock
>    8  +102        +20         [kernel.kallsyms]   _raw_spin_lock
>    9  +101        +19         [kernel.kallsyms]   _raw_spin_lock
>   10    -6        -28         [kernel.kallsyms]   selinux_task_wait
>   11   +99        +18         [kernel.kallsyms]   _raw_spin_lock
>   12   +98        +18         [kernel.kallsyms]   _raw_spin_lock
>   13   +97        +18         [kernel.kallsyms]   _raw_spin_lock
>   14   +96        +18         [kernel.kallsyms]   _raw_spin_lock
>   15  +220        +20         [kernel.kallsyms]   _raw_spin_lock_irqsave
>   16   +94        +17         [kernel.kallsyms]   _raw_spin_lock
>   17   +93        +17         [kernel.kallsyms]   _raw_spin_lock
>   18   +92        +16         [kernel.kallsyms]   _raw_spin_lock
>   19 +9648        +30         [kernel.kallsyms]   copy_page_c
>   20   +90        +15         [kernel.kallsyms]   _raw_spin_lock
>   21   +89        +15         [kernel.kallsyms]   _raw_spin_lock
> 
> beyond the missing column names, there's some other things visible too:
> 
>  - the symbol names are per pid, so they repeat all over again. I think we 
> want the default output to be like perf report's, i.e. PIDs get summarized 
> over commands.
> 
> Furthermore, i think -p should be enabled by default. Especially with a lot of 
> functions the +/- notation isnt very obvious at first sight.


Agreed, I think -p gives a better first glance about the global
state.

Also it would be nice to sort by default on deltas, probably
by abs(delta) even because the first purpose is to see what
has changed most.

And those who want better granularity could sort by asc or desc.

Oh, and I see the first column is useful to depict the
number of profiled sites that have varied, but dedicating
a whole column for that seems a bit too much. May be
that can be a default-off option? Or the number could
be output as a summary in the beggining?

Thanks.

