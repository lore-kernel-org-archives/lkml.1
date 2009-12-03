Return-Path: <linux-kernel-owner+w=401wt.eu-S1755666AbZLCDBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbZLCDBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 22:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbZLCDBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 22:01:32 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51641 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbZLCDBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 22:01:31 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 3 Dec 2009 11:58:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Nick Piggin <npiggin@suse.de>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 22/24] HWPOISON: add memory cgroup filter
Message-Id: <20091203115840.45f73bd3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091203024739.GB17716@localhost>
References: <20091202031231.735876003@intel.com>
	<20091202043046.519053333@intel.com>
	<20091202124446.GA18989@one.firstfloor.org>
	<20091202125842.GA13277@localhost>
	<20091203105229.afb0efc4.kamezawa.hiroyu@jp.fujitsu.com>
	<20091203021915.GA13587@localhost>
	<20091203112822.ecee5bf5.kamezawa.hiroyu@jp.fujitsu.com>
	<20091203024739.GB17716@localhost>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Dec 2009 10:47:39 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> On Thu, Dec 03, 2009 at 10:28:22AM +0800, KAMEZAWA Hiroyuki wrote:
> Ah please forgive my memcg ignorance..  Then how about bring back the
> old css_id() based scheme (old patch follows)?
> 
maybe enough. but please take care of the fact that css is can be "reused"
once freed.


> > If you have more patches to be usable the function above,
> > I recommend you to post this with some real-use patches, in step by step.
> 
> Do you mean user space test case? Here is a simple one:
> 
>         #!/bin/sh
> 
>         TEST_PROG=usemem
>         TEST_PARM="-m 100 -s 100"
> 
>         test -d /cgroup/hwpoison && rmdir /cgroup/hwpoison
>         mkdir /cgroup/hwpoison
> 
>         $TEST_PROG $TEST_PARM &
>         echo `pidof $TEST_PROG` > /cgroup/hwpoison/tasks
> 
>         memcg_id=$(</cgroup/hwpoison/memory.id)
>         echo $memcg_id > /debug/hwpoison/corrupt-filter-memcg
> 
>         ./corrupt-all-pfn
> 
Ah, this is nice to be put into changelog or some documentation.


> > patch 19,20 is ok for me.
> 
> Thanks,
> Fengguang
> ---
> memcg: show memory.id in cgroupfs
> 
> The hwpoison test suite need to selectively inject hwpoison to some
> targeted task pages, and must not kill important system processes
> such as init.
> 
> The memory cgroup serves this purpose well. We can put the target
> processes under the control of a memory cgroup, tell the hwpoison
> injection code the id of that memory cgroup so that it will only
> poison pages associated with it.
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

No objections from me. please use "id" check. or adds new flag to
struct mem_cgroup, as you like.

The style I prefer is
==
 struct mem_cgroup {
  ....
  bool hwpoison_test_enabled;
 };

+#ifdef CONFIG_HWPOISON_INJECT /* for now, only user is hwpoison testing */
+	{
+		.name = "hwpoison_test_enable",
+		.read_u64 = ....
+	},
+#endif

and.
	mem = try_get_mem_cgroup_from_page(p);
	if (mem_cgroup_is_under_poison_test(mem))
		ret = true;
	mem_cgroup_put(mem);	/* calls css_put() */

Maybe not difficult. and this is an usual way. But it's ok if you don't want to
scannter HWPOISON things to other function's files. This is test operation.

So, "including real use case and patches" is only my request, for this time.

Thanks,
-Kame


> ---
>  mm/memcontrol.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> --- linux-mm.orig/mm/memcontrol.c	2009-09-07 16:01:02.000000000 +0800
> +++ linux-mm/mm/memcontrol.c	2009-09-11 18:20:55.000000000 +0800
> @@ -2510,6 +2510,13 @@ mem_cgroup_get_recursive_idx_stat(struct
>  	*val = d.val;
>  }
>  
> +#ifdef CONFIG_HWPOISON_INJECT
> +static u64 mem_cgroup_id_read(struct cgroup *cont, struct cftype *cft)
> +{
> +	return css_id(cgroup_subsys_state(cont, mem_cgroup_subsys_id));
> +}
> +#endif
> +
>  static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
>  {
>  	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
> @@ -2841,6 +2848,12 @@ static int mem_cgroup_swappiness_write(s
>  
>  
>  static struct cftype mem_cgroup_files[] = {
> +#ifdef CONFIG_HWPOISON_INJECT /* for now, only user is hwpoison testing */
> +	{
> +		.name = "id",
> +		.read_u64 = mem_cgroup_id_read,
> +	},
> +#endif
>  	{
>  		.name = "usage_in_bytes",
>  		.private = MEMFILE_PRIVATE(_MEM, RES_USAGE),
> 

