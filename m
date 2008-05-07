Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYEGAUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYEGAUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 20:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYEGAUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 20:20:23 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36101 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752738AbYEGAUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 20:20:22 -0400
Date: Tue, 6 May 2008 19:20:18 -0500
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>, menage@google.com
Cc: torvalds@linux-foundation.org, lizf@cn.fujitsu.com,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
       Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 125/311] Cpuset hardwall flag: switch cpusets to use the
 bulk cgroup_add_files() API
Message-Id: <20080506192018.26c1e3b7.pj@sgi.com>
In-Reply-To: <20080429053804.6d083a7f.akpm@linux-foundation.org>
References: <200804290800.m3T80QFs009131@imap1.linux-foundation.org>
	<6599ad830804290329heea3c5fu7395b1ef71a87881@mail.gmail.com>
	<20080429053804.6d083a7f.akpm@linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitri Sivanich, a colleague of mine, just reported to me an easily
reproduced BUG in Linus's current git tree, anytime one reads or writes
the new per-cpuset file "sched_relax_domain_level".  The guilty task
gets a SEGV and the kernel prints (if the command was called 'cat'
and its pid was 16766 ;):

    kernel BUG at kernel/cpuset.c:1448!
    cat[16766]: bugcheck! 0 [3]

The BUG comes from cpuset code that wasn't expecting that read or write
request at that point in the code.

The basic problem is that Seto-san's "sched_relax_domain_level" and
Paul M's conversion to the new style *_u64 cpuset file handlers were
occurring at the same time, with the result that the handlers for
the per-cpuset file "sched_relax_domain_level" were only partially
converted to the new style *_u64 cpuset file handlers.

The following provides more details, and presents a couple of questions
for Andrew or Paul Menage, at the end.

===

On April 29, Paul Menage observed that the cpuset patch for
'sched_relax_domain' got mangled -- it ended up using the
old style common file read/write routines, but having the
cases to handle it added to Paul M's new style *_u64 handlers.

Paul M proposed the following untested patch:
> --- cpuset-fix-2.6.25-mm1.orig/kernel/cpuset.c
> +++ cpuset-fix-2.6.25-mm1/kernel/cpuset.c
> @@ -1295,6 +1295,9 @@ static int cpuset_write_u64(
>                 retval = update_flag(CS_SPREAD_SLAB, cs, val);
>                 cs->mems_generation = cpuset_mems_generation++;
>                 break;
> +       case FILE_SCHED_RELAX_DOMAIN_LEVEL:
> +               retval = update_relax_domain_level(cs, val);
> +               break;
>         default:
>                 retval = -EINVAL;
>                 break;
> @@ -1396,6 +1399,8 @@ static u64 cpuset_read_u64(
>                 return is_spread_page(cs);
>         case FILE_SPREAD_SLAB:
>                 return is_spread_slab(cs);
> +       case FILE_SCHED_RELAX_DOMAIN_LEVEL:
> +               return cs->relax_domain_level;
>         default:
>                 BUG();
>         }

Andrew replied:
> OK, can we please proceeed with the thing as-is, send us any needed
> fixup later in the week?

I definitely agree with the above observations of Paul M.  I suspect
that the patch might be missing the lines needed to -remove- the
FILE_SCHED_RELAX_DOMAIN_LEVEL cases from the old style
cpuset_common_file_read and cpuset_common_file_write switches.

The kernel now at the top of Linus's git tree hits a BUG()
immediately, anytime you try to read or write these new
per-cpuset files "sched_relax_domain_level".

I tried looking in 2.6.25-rc1-mm1-mmotm (as of an hour ago),
and it -looks- like the fix is in the linux-next.patch there.

However:

 1) I can't get 2.6.25-rc1-mm1-mmotm to apply even close to
    either of 2.6.25 or 2.6.25-rc1.  Blows up on the first
    patch.

	==> akpm - what does todays 2.6.25-rc1-mm1-mmotm
	    apply to?

 2) I didn't see any replies from Paul M in response to
    Andrews above request to "send us any needed fixup later
    in the week".

	==> Paul M or akpm - Is this fixup in the pipeline?

    I guess it did from my reading of the linux-next.patch
    in 2.6.25-rc1-mm1-mmotm, but I'm not confident I'm
    reading that patch right.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
