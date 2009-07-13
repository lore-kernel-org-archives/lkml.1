Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbZGMDqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbZGMDqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 23:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbZGMDqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 23:46:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49459 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbZGMDqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 23:46:15 -0400
Message-ID: <4A5AAE02.7060106@cn.fujitsu.com>
Date: Mon, 13 Jul 2009 11:46:10 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ben Blum <bblum@google.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com, menage@google.com
Subject: Re: [PATCH 1/3] Adds a read-only "procs" file similar to "tasks"
 that	shows only unique tgids
References: <20090710230043.16778.29656.stgit@hastromil.mtv.corp.google.com> <20090710230154.16778.58053.stgit@hastromil.mtv.corp.google.com>
In-Reply-To: <20090710230154.16778.58053.stgit@hastromil.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Blum wrote:
> Adds a read-only "procs" file similar to "tasks" that shows only unique tgids
> 
> struct cgroup used to have a bunch of fields for keeping track of the pidlist
> for the tasks file. Those are now separated into a new struct cgroup_pidlist,
> of which two are had, one for procs and one for tasks. The way the seq_file
> operations are set up is changed so that just the pidlist struct gets passed
> around as the private data.
> 
> Interface example: suppose a process with tgid 1000 has additional threads
> with ids 1001 and 1002. The tasks file will show ids 1000, 1001, and 1002, and
> the procs file will only show id 1000.
> 

I think a better demonstration is:

  $ cat tasks
  1000
  1001
  1002

  $ cat procs
  1000

> Possible future functionality is making the procs file writable for purposes
> of adding all threads with the same tgid at once.
> 
> Signed-off-by: Ben Blum <bblum@google.com>
> 
> ---
> 
>  include/linux/cgroup.h |   22 ++--
>  kernel/cgroup.c        |  282 ++++++++++++++++++++++++++++++------------------
>  2 files changed, 190 insertions(+), 114 deletions(-)
...
> +/* is the size difference enough that we should re-allocate the array? */
> +#define PIDLIST_REALLOC_DIFFERENCE(old,new) ((old) - PAGE_SIZE >= (new))
> +static int pidlist_uniq(pid_t **p, int length)
> +{
> +	int src, dest = 1;
> +	pid_t *list = *p;
> +	pid_t *newlist;
> +
> +	/*
> +	 * we presume the 0th element is unique, so i starts at 1. trivial
> +	 * edge cases first; no work needs to be done for either
> +	 */
> +	if (length == 0 || length == 1)
> +		return length;
> +	/* src and dest walk down the list; dest counts unique elements */
> +	for (src = 1; src < length; src++) {
> +		/* find next unique element */
> +		while (list[src] == list[src-1]) {
> +			src++;
> +			if (src == length)
> +				break;

'goto' is better

> +		}
> +		if (src == length)
> +			break;
> +		/* dest always points to where the next unique element goes */
> +		list[dest] = list[src];
> +		dest++;
> +	}
> +	/*
> +	 * if the length difference is large enough, we want to allocate a
> +	 * smaller buffer to save memory. if this fails due to out of memory,
> +	 * we'll just stay with what we've got.
> +	 */
> +	if (PIDLIST_REALLOC_DIFFERENCE(length, dest)) {
> +		newlist = kmalloc(dest * sizeof(pid_t), GFP_KERNEL);

krealloc()

> +		if (newlist) {
> +			memcpy(newlist, list, dest * sizeof(pid_t));
> +			kfree(list);
> +			*p = newlist;
> +		}
> +	}
> +	return dest;
> +}
