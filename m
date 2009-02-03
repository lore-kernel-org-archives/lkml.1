Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbZBCPcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbZBCPcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 10:32:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZBCPbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 10:31:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59498 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbZBCPbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 10:31:53 -0500
Date: Tue, 3 Feb 2009 16:31:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
Message-ID: <20090203153139.GI29046@elte.hu>
References: <49883CD7.2060602@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49883CD7.2060602@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:

> From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
> 
> Enable the use of GCC's coverage testing tool gcov [1] with the Linux
> kernel. gcov may be useful for:
> 
>  * debugging (has this code been reached at all?)
>  * test improvement (how do I change my test to cover these lines?)
>  * minimizing kernel configurations (do I need this option if the
>    associated code is never run?)
> 
> The profiling patch incorporates the following changes:
> 
>  * change kbuild to include profiling flags
>  * provide functions needed by profiling code
>  * present profiling data as files in debugfs
> 
> Note that on some architectures, enabling gcc's profiling option
> "-fprofile-arcs" for the entire kernel may trigger compile/link/
> run-time problems, some of which are caused by toolchain bugs and
> others which require adjustment of architecture code.
> 
> For this reason profiling the entire kernel is initially restricted
> to those architectures for which it is known to work without changes.
> This restriction can be lifted once an architecture has been tested
> and found compatible with gcc's profiling. Profiling of single files
> or directories is still available on all platforms (see config help
> text).
> 
> 
> [1] http://gcc.gnu.org/onlinedocs/gcc/Gcov.html
> 
> Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
> ---
> 
>  Documentation/gcov.txt              |  246 ++++++++++++++
>  Documentation/kernel-parameters.txt |    7 
>  Makefile                            |   11 
>  arch/Kconfig                        |    1 
>  init/main.c                         |    8 
>  kernel/Makefile                     |    1 
>  kernel/gcov/Kconfig                 |   48 ++
>  kernel/gcov/Makefile                |    3 
>  kernel/gcov/base.c                  |  145 ++++++++
>  kernel/gcov/fs.c                    |  620 ++++++++++++++++++++++++++++++++++++
>  kernel/gcov/gcc_3_4.c               |  419 ++++++++++++++++++++++++
>  kernel/gcov/gcov.h                  |  128 +++++++
>  scripts/Makefile.lib                |    9 
>  13 files changed, 1641 insertions(+), 5 deletions(-)

Nice tool - with one general observation: i'd really prefer if this was 
properly integrated with ftrace.

In particular the per object file controls are nice - those might be useful 
to seed ftrace filters as well.

So there's good synergy possible and we should reach that synergy before 
this goes upstream instead of putting it into a separate debugfs position 
with incompatible flags and concepts. Especially since user-space tools will 
pick up the gcov data so this gets hardcoded compatibility-wise very quickly 
and changing it after the fact will be harder.

Yes, it's more work and it means extending both the ftrace code and the gcov 
code - but it's very much worth it.

	Ingo
