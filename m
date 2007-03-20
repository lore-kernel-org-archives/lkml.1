Return-Path: <linux-kernel-owner+w=401wt.eu-S1752008AbXCTWMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbXCTWMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 18:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbXCTWMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 18:12:17 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:47607 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbXCTWMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 18:12:14 -0400
Date: Tue, 20 Mar 2007 15:12:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: cpw@sgi.com (Cliff Wickman)
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] hotplug cpu: move tasks in empty cpusets to parent
Message-Id: <20070320151224.dac2f463.randy.dunlap@oracle.com>
In-Reply-To: <46003729.mailxHNJ1HHIE6@eag09.americas.sgi.com>
References: <46003729.mailxHNJ1HHIE6@eag09.americas.sgi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007 13:34:01 -0600 Cliff Wickman wrote:

> 
> From: Cliff Wickman <cpw@sgi.com>
> 
> This patch corrects a situation that occurs when one disables all the cpus
> in a cpuset.
> 
> At that point, any tasks in that cpuset are incorrectly moved (as I recall,
> they were move to a sibling cpuset).
> Such tasks should be move the parent of their current cpuset. Or if the
> parent cpuset has no cpus, to its parent, etc.
> 
> And the empty cpuset should be removed (if it is flagged notify_on_release).
> 
> This patch contains the added complexity of taking care not to do memory
> allocation while holding the cpusets callback_mutex. And it makes use of the
> "cpuset_release_agent" to do the cpuset removals.
> 
> It might be simpler to use a separate thread or workqueue. But such code
> has not yet been written.
> 
> Diffed against 2.6.20-rc6
> 
> Signed-off-by: Cliff Wickman <cpw@sgi.com>
> 
> ---
>  kernel/cpuset.c |  200 ++++++++++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 180 insertions(+), 20 deletions(-)
> 
> Index: morton.070205/kernel/cpuset.c
> ===================================================================
> --- morton.070205.orig/kernel/cpuset.c
> +++ morton.070205/kernel/cpuset.c

> @@ -2070,20 +2097,100 @@ out:
>   *
>   * Call with both manage_mutex and callback_mutex held.
>   *
> + * Takes tasklist_lock, and task_lock() for cpuset members that are
> + * moved to another cpuset.
> + *
>   * Recursive, on depth of cpuset subtree.
>   */
>  
> -static void guarantee_online_cpus_mems_in_subtree(const struct cpuset *cur)
> +static void remove_tasks_in_empty_cpusets_in_subtree(const struct cpuset *cur, struct list_head *empty_list, struct path_list_element **ple_array, int *ple_availp, int ple_count)

That line is way too long.  Source lines should fit in 80 columns unless
they contain (maybe) a printk string that would be ugly if split (e.g.).
This one should be like so (or some other readable variant):

static void remove_tasks_in_empty_cpusets_in_subtree(
				const struct cpuset *cur,
				struct list_head *empty_list,
				struct path_list_element **ple_array,
				int *ple_availp, int ple_count)

> +{
> +	int npids, ple_used=0;
> +	struct cpuset *c, *parent;
> +	struct path_list_element *ple;
> +
> +	/* If a cpuset's mems or cpus are empty, move its tasks to its parent */
> +	list_for_each_entry(c, &cur->children, sibling) {
> +		remove_tasks_in_empty_cpusets_in_subtree(c, empty_list,
> +					ple_array, ple_availp, ple_count);
> +		/*
> +		 * If it has no online cpus or no online mems, move its tasks
> +		 * to its next-highest non-empty parent and remove it.
> +		 * Remove it even if it has children, as its children are a
> +		 * subset of cpus and nodes, so they are empty too.
> +		 * The removal is conditional on whether it is
> +		 * notify-on-release.
> +		 */
> +		if (cpus_empty(c->cpus_allowed) ||
> +		   nodes_empty(c->mems_allowed)) {
> +			char *path = NULL;
> +			/*
> +			 * Find its next-highest non-empty parent, (top cpuset
> +			 * has online cpus, so can't be empty).
> +			 */
> +			parent = c->parent;
> +			while (parent && cpus_empty(parent->cpus_allowed))
> +				parent = parent->parent;
> +			npids = atomic_read(&c->count);
> +			/* c->count is the number of tasks using the cpuset */
> +			if (npids)
> +				/* move member tasks to the parent cpuset */
> +				move_member_tasks_to_cpuset(c, parent);
> +
> +			/*
> +			 * sanity check that we're not over-running
> +			 * the array
> +			 */
> +			if (++ple_used > ple_count)
> +				return;
> +			ple = ple_array[(*ple_availp)++];
> +			path = (char *)ple + sizeof(struct path_list_element);
> +			if (cpuset_path(c, path,
> +				PAGE_SIZE-sizeof(struct path_list_element)) < 0)
> +				path = NULL;
> +			if (path != NULL) {
> +				/*
> +				 * add path to list of cpusets to remove
> +				 * (list includes cpusets that are not
> +				 *  notify-on-release)
> +				 */
> +				ple->path = path;
> +				ple->cs = c;
> +				/*
> +				 * since we're walking "up" the tree, list
> +				 * any empty cpusets we find on the tail of
> +				 * the list (later==higher; start with lower)
> +				 */
> +				list_add_tail(&ple->list, empty_list);
> +			}
> +		}
> +	}
> +}
> +
> +/*
> + * Walk the specified cpuset subtree and remove any offline cpus from
> + * each cpuset.
> + *
> + * Count the number of empty cpusets.
> + *
> + * Call with both manage_mutex and callback_mutex held so
> + * that this function can modify cpus_allowed and mems_allowed.
> + *
> + * Recursive, on depth of cpuset subtree.

Recursive with what limit/bound?
at least realistically if not in source code.

and will that be reasonable 5 years from now,
without causing stack overflow?

Not that this function uses lots of stack, but I didn't track
down the call tree to get here.

> + */
> +
> +static void remove_offlines_count_emptys(const struct cpuset *cur, int *count)
>  {
>  	struct cpuset *c;
>  
> -	/* Each of our child cpusets mems must be online */
>  	list_for_each_entry(c, &cur->children, sibling) {
> -		guarantee_online_cpus_mems_in_subtree(c);
> -		if (!cpus_empty(c->cpus_allowed))
> -			guarantee_online_cpus(c, &c->cpus_allowed);
> -		if (!nodes_empty(c->mems_allowed))
> -			guarantee_online_mems(c, &c->mems_allowed);
> +		remove_offlines_count_emptys(c, count);
> +		/* Remove offline cpus and mems from this cpuset. */
> +		cpus_and(c->cpus_allowed, c->cpus_allowed, cpu_online_map);
> +		nodes_and(c->mems_allowed, c->mems_allowed, node_online_map);
> +		if (cpus_empty(c->cpus_allowed) ||
> +		   nodes_empty(c->mems_allowed))
> +			(*count)++;
>  	}
>  }
>  
> @@ -2095,7 +2202,7 @@ static void guarantee_online_cpus_mems_i
>   * To ensure that we don't remove a CPU or node from the top cpuset
>   * that is currently in use by a child cpuset (which would violate
>   * the rule that cpusets must be subsets of their parent), we first
> - * call the recursive routine guarantee_online_cpus_mems_in_subtree().
> + * call the recursive routine remove_tasks_in_empty_cpusets_in_subtree().
>   *
>   * Since there are two callers of this routine, one for CPU hotplug
>   * events and one for memory node hotplug events, we could have coded
> @@ -2105,15 +2212,68 @@ static void guarantee_online_cpus_mems_i
>  
>  static void common_cpu_mem_hotplug_unplug(void)
>  {
> +	int i, empty_count=0, ple_avail=0;
> +	struct list_head empty_cpuset_list;
> +	struct path_list_element *ple, **ple_array=NULL;
> +
>  	mutex_lock(&manage_mutex);
> -	mutex_lock(&callback_mutex);
>  
> -	guarantee_online_cpus_mems_in_subtree(&top_cpuset);
> +	mutex_lock(&callback_mutex);
>  	top_cpuset.cpus_allowed = cpu_online_map;
>  	top_cpuset.mems_allowed = node_online_map;
> -
> +	remove_offlines_count_emptys(&top_cpuset, &empty_count);
>  	mutex_unlock(&callback_mutex);
> +
> +	if (empty_count) {
> +		/*
> +		 * allocate the control structures needed for a list of
> +		 * cpuset paths to free. (allocation must be done without
> +		 * holding callback_mutex)
> +		 */
> +		ple_array = (struct path_list_element **)kmalloc

cast not needed?

> +		   (empty_count*sizeof(struct empty_cpuset_list *), GFP_KERNEL);
> +		if (!ple_array)
> +			return;
> +		for (i=0; i<empty_count; i++) {

Spaces:		for (i = 0; i < empty_count; i++) {

> +			ple = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +			/*
> +			 * the space for the path itself immediately follows
> +			 * the path_list_element structure (we have a full page)
> +			 */
> +			if (!ple)
> +				return;
> +			ple_array[i]= ple;
> +		}
> +		INIT_LIST_HEAD(&empty_cpuset_list);
> +
> +		mutex_lock(&callback_mutex);
> +		remove_tasks_in_empty_cpusets_in_subtree(&top_cpuset,
> +			&empty_cpuset_list, ple_array, &ple_avail, empty_count);
> +		mutex_unlock(&callback_mutex);
> +	}
> +
>  	mutex_unlock(&manage_mutex);
> +
> +	if (empty_count) {
> +		/*
> +		 * Free each cpuset on the list.
> +		 * (but only if it is notify-on-release)
> +		 */
> +		list_for_each_entry(ple, &empty_cpuset_list, list) {
> +			if (notify_on_release(ple->cs))
> +				cpuset_release_agent(ple->path, 0);
> +				/*
> +				 * 0: don't ask cpuset_release_agent to
> +				 *    release the path
> +				 */

Don't explain function parameters unless they are tricky.

> +		}
> +		/* remove the control structures */
> +		for (i=0; i<empty_count; i++) {

spacing

> +			kfree(ple_array[i]);
> +		}
> +		kfree(ple_array);
> +	}
> +	return;
>  }
>  
>  /*
> @@ -2259,7 +2419,7 @@ void cpuset_exit(struct task_struct *tsk
>  		if (atomic_dec_and_test(&cs->count))
>  			check_for_release(cs, &pathbuf);
>  		mutex_unlock(&manage_mutex);
> -		cpuset_release_agent(pathbuf);
> +		cpuset_release_agent(pathbuf, 1);
>  	} else {
>  		atomic_dec(&cs->count);
>  	}

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
