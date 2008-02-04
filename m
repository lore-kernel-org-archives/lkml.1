Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYBDSUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYBDSUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 13:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbYBDSUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 13:20:40 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:27169 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbYBDSUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 13:20:39 -0500
Subject: Re: [2.6.24-rc8-mm1][regression?] numactl --interleave=all doesn't
	works on memoryless node.
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Paul Jackson <pj@sgi.com>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20080202180536.F494.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080202165054.F491.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080202090914.GA27723@one.firstfloor.org>
	 <20080202180536.F494.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Mon, 04 Feb 2008 13:20:42 -0500
Message-Id: <1202149243.5028.61.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-02-02 at 18:37 +0900, KOSAKI Motohiro wrote:
> Hi Andi,
> 
> > > 3. 2.6.24-rc8-mm1 set_mempolicy(2) behavior
> > >    3.1 check nodesubset(nodemask argument, node_states[N_HIGH_MEMORY])
> > >        in mpol_check_policy()
> > > 
> > > 	-> check failed when memmoryless node exist.
> > >            (i.e. node_states[N_HIGH_MEMORY] of my machine is 0xc)
> > > 
> > > 4. RHEL5.1 set_mempolicy(2) behavior
> > >    4.1 check nodesubset(nodemask argument, node_online_map)
> > >        in mpol_check_policy().
> > > 
> > > 	-> check success.
> > > 
> > > I don't know wrong either kernel or libnuma.
> > 
> > When the kernel behaviour changes and breaks user space then the kernel
> > is usually wrong. Cc'ed Lee S. who maintains the kernel code now.

The memoryless nodes patch series changed a lot of things, so just
reverting this one area [mpol_check_policy()] probably won't restore the
prior behavior.  A fully populated node mask is not necessarily a proper
subset of node_online_map().  And contextualize_policy() also requires
the mask to be a subset of mems_allowed which also defaults to nodes
with memory.

I don't know how Mel Gorman's "two zonelist" series, which is still
awaiting a window into the -mm tree, affects this behavior.  Those
patches will certainly be affected by whatever we decide here.

I don't know the current state of Paul's rework of cpusets and
mems_allowed.  That probably resolves this issue, if he still plans on
allowing a fully populated mask to indicate interleaving over all
allowed nodes.

I have a patch that takes a different approach to "interleave=all" that
doesn't solve Paul's and David's requirements.  I also have patches to
libnuma and numactl that work with my patches, but I saw no sense in
posting them unless my kernel patches got some traction.  If interested,
you can find them at:

 http://free.linux.hp.com/~lts/Patches/Numactl/



 
> 
> may be yes, may be no.
> 
> I have 1 simple question. 
> Why do libnuma generate bitpattern of all bit on instead
> check /sys/devices/system/node/has_high_memory nor 
> check /sys/devices/system/node/online?
> 
> Do you know it?

In addition to Andi's answer about simplicity, libnuma and numactl
predate the sysfs node masks.  There was no way to query what the valid
set of nodes would be, but the kernel allowed a fully populated map.  We
broke that with the memoryless nodes rework.

> 
> and I made simple patch that has_high_memory exposed however CONFIG_HIGHMEM disabled.
> if CONFIG_HIGHMEM disabled, the has_high_memory file show 
> the same as the has_normal_memory.
> may be, userland process should check has_high_memory file.
> 
> but, I am not confident.


Regarding the patch itself:  If others have no problems with displaying
a "has_high_memory" node mask for systems w/o HIGH_MEM configured, I can
live with it.  

The current upstream kernel [2.6.24] supports a MPOL_MEMS_ALLOWED flag
to get_mempolicy() to return the nodes allowed in the caller's cpuset.
My numactl patches, mentioned above, support this.

However, as Andi says, we really can't break application behavior.  All
applications that use mempolicy don't necessarily use libnuma APIs.  So,
a fully populated interleave node mask should be allowed and should
probably mean "all allowed nodes with memory". 

I think we'd still need to reduce the interleave policy mask to nodes
with memory when it's installed or find another way to skip memoryless
nodes when interleaving, else we don't get even distribution of
interleaved pages over the nodes that do have memory.  This is one of
the memoryless nodes fixes.  I THINK this is one of the areas that Paul
and David are investigating.

Christoph, Mel, Paul:  any suggestions for a [relatively quick] fix that
doesn't break the memoryless nodes work and doesn't violate cpuset
constraints?



> Thanks.
> 
> 
> - kosaki
> 
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> ---
>  drivers/base/node.c |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> Index: b/drivers/base/node.c
> ===================================================================
> --- a/drivers/base/node.c       2008-02-02 17:52:32.000000000 +0900
> +++ b/drivers/base/node.c       2008-02-02 18:32:38.000000000 +0900
> @@ -276,7 +276,6 @@ static SYSDEV_CLASS_ATTR(has_normal_memo
>                                                                         NULL);
>  static SYSDEV_CLASS_ATTR(has_cpu, 0444, print_nodes_has_cpu, NULL);
> 
> -#ifdef CONFIG_HIGHMEM
>  static ssize_t print_nodes_has_high_memory(struct sysdev_class *class,
>                                                  char *buf)
>  {
> @@ -285,15 +284,11 @@ static ssize_t print_nodes_has_high_memo
> 
>  static SYSDEV_CLASS_ATTR(has_high_memory, 0444, print_nodes_has_high_memory,
>                                                                          NULL);
> -#endif
> -
>  struct sysdev_class_attribute *node_state_attr[] = {
>         &attr_possible,
>         &attr_online,
>         &attr_has_normal_memory,
> -#ifdef CONFIG_HIGHMEM
>         &attr_has_high_memory,
> -#endif
>         &attr_has_cpu,
>  };
> 
> @@ -302,7 +297,7 @@ static int node_states_init(void)
>         int i;
>         int err = 0;
> 
> -       for (i = 0;  i < NR_NODE_STATES; i++) {
> +       for (i = 0;  i < ARRAY_SIZE(node_state_attr); i++) {
>                 int ret;
>                 ret = sysdev_class_create_file(&node_class, node_state_attr[i]);
>                 if (!err)
> 

