Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbYCaRYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbYCaRYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 13:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbYCaRYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 13:24:42 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:5348 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbYCaRYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 13:24:41 -0400
Message-ID: <36ca99e90803311024h6aeb89beyd72f73c3763c0a9c@mail.gmail.com>
Date: Mon, 31 Mar 2008 19:24:40 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 2/2] x86: modify show_shared_cpu_map in intel_cacheinfo
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Paul Jackson" <pj@sgi.com>
In-Reply-To: <47F112BD.4050801@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080327231654.284673000@polaris-admin.engr.sgi.com>
	 <20080327231654.599276000@polaris-admin.engr.sgi.com>
	 <36ca99e90803280201i708ce9b7y293a2c68e733f088@mail.gmail.com>
	 <47ED0343.1070708@sgi.com>
	 <36ca99e90803280754p1fbedbccp366366f0240fe5cc@mail.gmail.com>
	 <47ED36B9.6000508@sgi.com>
	 <36ca99e90803290159v33ab43cbu5acd4bc2b0cd0262@mail.gmail.com>
	 <47F112BD.4050801@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 6:35 PM, Mike Travis <travis@sgi.com> wrote:
> Bert Wesarg wrote:
>  > On Fri, Mar 28, 2008 at 7:19 PM, Mike Travis <travis@sgi.com> wrote:
>  >>  > Aren't the most cpumaps (like cpu/cpu*/topology/*_siblings or
>  >>  > node/node*/cpumap) bitmasks?
>  >>
>  >>  I did an informal survey and you are right, the majority of references do use
>  >>  cpumask_scnprintf instead of cpulist_scnprintf.  Maybe the later function was
>  >>  added later?
>  >>
>  >>  To me though, it would seem that:
>  >>
>  >>  240-255
>  >>
>  >>  is more readable than:
>  >>
>  >>  00000000,00000000,00000000,00000000,00000000,00000000,00000000,0000ffff
>  >>
>  >>  And as I mentioned, bitmask_parselist() [libbitmask(3)] does parse the output.
>  > But libbitmask has a bitmask_parsehex() too. (but thanks for the
>  > pointer to this code).
>  >
>  > Anyway, your above example is wrong, the most significant bits comes first:
>  >
>  > ffff0000,00000000,00000000,00000000,00000000,00000000,00000000,00000000
>  >
>  > This makes it not more readable, but I think readability isn't in this
>  > case of that much importance.
>
>  The original problem was how to avoid allocating a large stack space to display
>  cpu ids.  By using cpulist_scnprintf, it accomplishes this without, what I think
>  is too much pain.  If it's really that much of a problem, I will rework this patch.
>  But the length of the line with 4096 cpus will be 1152 bytes  Is this really
>  better?
I ask myself, why is there a temporary buffer allocation in the first
place? In the end it is copied unbounded into the provided buf
argument. Sure your list is mostly shorter than a hex mask, but you
can also not be sure that it fit into the provided buffer. So you can
also use cpumask_scnprintf directly with the buf argument, and provide
a good known upper bound for the size (ie.
cpumask_scnprintf_len(nr_cpu_ids)).

>
>
>  >
>  > I further think, this problem could be easily solved, if NR_CPUS and
>  > possibly your nr_cpus_ids is somehow exported to user space.
>  >
>  > With this information, the user is not surprised to see more that 1024
>  > bits (=CPU_SETSIZE, which is currently the glibc constant for the
>  > sched_{set,get}affinity() API). Also the glibc has the new variable
>  > cpu_set_t size API (since 2.7).
>
>  Yes, thanks.  That is being dealt with in another task.
Can you keep me up to date. Thanks.

Bert
>
>  Thanks,
>  Mike
>
