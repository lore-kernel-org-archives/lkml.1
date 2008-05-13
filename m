Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbYEMCaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbYEMCaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 22:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757051AbYEMCaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 22:30:03 -0400
Received: from smtp-out.google.com ([216.239.33.17]:48336 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972AbYEMCaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 22:30:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Rdelfh/F1Dqo0oWmRA/DicCNoJ4qcGrbR8EdHUKnmRF5WD2MmmMaIdm/MuvkdwRn0
	/qBnzfCFmZfsotZpedcVQ==
Message-ID: <6599ad830805121929q6746d6b3ye96196e567bc0150@mail.gmail.com>
Date: Mon, 12 May 2008 19:29:49 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] cpuset: limit the input of cpuset.sched_relax_domain_level
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Paul Jackson" <pj@sgi.com>,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4828FC85.7020400@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4828FC85.7020400@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 7:27 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> We allow the inputs to be [-1 ... SD_LV_MAX), and return -EINVAL
>  for inputs outside this range.
>
>  Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>


>  ---
>   Documentation/cpusets.txt |    2 +-
>   kernel/cpuset.c           |    4 ++--
>   kernel/sched.c            |    7 ++++++-
>   3 files changed, 9 insertions(+), 4 deletions(-)
>
>  diff --git a/Documentation/cpusets.txt b/Documentation/cpusets.txt
>  index fb7b361..9066ce7 100644
>  --- a/Documentation/cpusets.txt
>  +++ b/Documentation/cpusets.txt
>  @@ -542,7 +542,7 @@ otherwise initial value -1 that indicates the cpuset has no request.
>     2  : search cores in a package.
>     3  : search cpus in a node [= system wide on non-NUMA system]
>   ( 4  : search nodes in a chunk of node [on NUMA system] )
>  - ( 5~ : search system wide [on NUMA system])
>  + ( 5  : search system wide [on NUMA system] )
>
>   This file is per-cpuset and affect the sched domain where the cpuset
>   belongs to.  Therefore if the flag 'sched_load_balance' of a cpuset
>  diff --git a/kernel/cpuset.c b/kernel/cpuset.c
>  index 86ea9e3..c192213 100644
>  --- a/kernel/cpuset.c
>  +++ b/kernel/cpuset.c
>  @@ -1033,8 +1033,8 @@ int current_cpuset_is_being_rebound(void)
>
>   static int update_relax_domain_level(struct cpuset *cs, s64 val)
>   {
>  -       if ((int)val < 0)
>  -               val = -1;
>  +       if (val < -1 || val >= SD_LV_MAX)
>  +               return -EINVAL;
>
>         if (val != cs->relax_domain_level) {
>                 cs->relax_domain_level = val;
>  diff --git a/kernel/sched.c b/kernel/sched.c
>  index 8841a91..24d499e 100644
>  --- a/kernel/sched.c
>  +++ b/kernel/sched.c
>  @@ -7219,7 +7219,12 @@ static int default_relax_domain_level = -1;
>
>   static int __init setup_relax_domain_level(char *str)
>   {
>  -       default_relax_domain_level = simple_strtoul(str, NULL, 0);
>  +       unsigned long val;
>  +
>  +       val = simple_strtoul(str, NULL, 0);
>  +       if (val < SD_LV_MAX)
>  +               default_relax_domain_level = val;
>  +
>         return 1;
>   }
>   __setup("relax_domain_level=", setup_relax_domain_level);
>  --
>  1.5.4.rc3
>
