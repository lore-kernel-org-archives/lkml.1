Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbZF3MAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbZF3MAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 08:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbZF3L7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 07:59:54 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:39669 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbZF3L7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 07:59:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sclb8dGn5F70QKr4MWLJXoMPojbPh/rfpSltYNSRbtztustN1YESIGDZYbfJKQ27jZ
         lK/mOVg1yPOO38LR6+qzr4xkx784K0FCbE2Qs5whU+wWpOp49nRKDmNUe04n+GaPuRYE
         TvzlMgq8cJIguLepqid/QX1h7E+H6KojFkbr4=
Date: Tue, 30 Jun 2009 13:59:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: use hash table to simulate the sparse array
Message-ID: <20090630115949.GB5249@nowhere>
References: <4A3F2E38.7030604@cn.fujitsu.com> <4A49D12A.9040901@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A49D12A.9040901@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 04:47:38PM +0800, Lai Jiangshan wrote:
> Lai Jiangshan wrote:
> > 
> > Subject: [PATCH] tracing: rewrite trace_save_cmdline()
> > 
> > I found the sparse array map_pid_to_cmdline[PID_MAX_DEFAULT+1]
> > wastes too much memory, so I remove it.
> > 
> > The old FIFO algorithm is replaced with a new one:
> > Open address hash table with double hash + tick-LRU.
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > ---
> 
> This patch reduces the memory usage.(save 128K memory in kernel)
> But it's too complicated, and it changes the original algorithm.
> 
> This new patch does NOT change the original algorithm,
> but it uses a hash table to simulate the sparse array.
> 
> ---------------
> 
> Subject: [PATCH] tracing: use hash table to simulate the sparse array
> 
> I found the sparse array map_pid_to_cmdline[PID_MAX_DEFAULT+1]
> wastes too much memory, so I remove it.
> 
> A hash table is added to simulate the sparse array. And
> map_pid_to_cmdline and map_cmdline_to_pid become light functions.
> 
> map_pid_to_cmdline[pid] ==> map_pid_to_cmdline(pid)
> map_cmdline_to_pid[idx] ==> map_cmdline_to_pid(idx)
> 
> [Impact: save about 127k memory]
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 3aa0a0d..3526b9c 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -36,6 +36,7 @@
>  #include <linux/poll.h>
>  #include <linux/gfp.h>
>  #include <linux/fs.h>
> +#include <linux/hash.h>
>  
>  #include "trace.h"
>  #include "trace_output.h"
> @@ -648,10 +649,47 @@ void tracing_reset_current_online_cpus(void)
>  	tracing_reset_online_cpus(&global_trace);
>  }
>  
> -#define SAVED_CMDLINES 128
> +#define SAVED_CMDLINES_SHIFT 7
> +#define SAVED_CMDLINES (1 << 7)
>  #define NO_CMDLINE_MAP UINT_MAX
> -static unsigned map_pid_to_cmdline[PID_MAX_DEFAULT+1];
> -static unsigned map_cmdline_to_pid[SAVED_CMDLINES];
> +
> +struct cmdline_index {
> +	struct hlist_node node;
> +	unsigned int pid;
> +};
> +
> +struct hlist_head map_head[SAVED_CMDLINES];
> +struct cmdline_index indexes[SAVED_CMDLINES];
> +
> +static unsigned int map_pid_to_cmdline(unsigned int pid)
> +{
> +	struct cmdline_index *index;
> +	struct hlist_node *n;
> +	unsigned int hash = hash_32(pid, SAVED_CMDLINES_SHIFT);
> +
> +	hlist_for_each_entry(index, n, &map_head[hash], node) {
> +		if (index->pid == pid)
> +			return index - indexes;
> +	}
> +
> +	return NO_CMDLINE_MAP;
> +}
> +
> +static unsigned int map_cmdline_to_pid(unsigned int idx)
> +{
> +	return indexes[idx].pid;
> +}
> +
> +static void do_map_cmdline_index(unsigned int idx, unsigned int pid)
> +{
> +	unsigned int hash = hash_32(pid, SAVED_CMDLINES_SHIFT);
> +
> +	if (map_cmdline_to_pid(idx) != NO_CMDLINE_MAP)
> +		hlist_del(&indexes[idx].node);
> +	indexes[idx].pid = pid;
> +	hlist_add_head(&indexes[idx].node, &map_head[hash]);
> +}



If I understand well, you won't ever have more than one
entry per map_head[x]

So why are you using a hashlist that supports more than one
entry (the use of hlist_head op).

You could use a simple hashlist with only one entry on each
index to map the pid.

But the background idea of your patch looks good indeed.

Thanks.


> +
>  static char saved_cmdlines[SAVED_CMDLINES][TASK_COMM_LEN];
>  static int cmdline_idx;
>  static raw_spinlock_t trace_cmdline_lock = __RAW_SPIN_LOCK_UNLOCKED;
> @@ -661,8 +699,7 @@ static atomic_t trace_record_cmdline_disabled __read_mostly;
>  
>  static void trace_init_cmdlines(void)
>  {
> -	memset(&map_pid_to_cmdline, NO_CMDLINE_MAP, sizeof(map_pid_to_cmdline));
> -	memset(&map_cmdline_to_pid, NO_CMDLINE_MAP, sizeof(map_cmdline_to_pid));
> +	memset(&indexes, NO_CMDLINE_MAP, sizeof(indexes));
>  	cmdline_idx = 0;
>  }
>  
> @@ -754,9 +791,9 @@ void trace_stop_cmdline_recording(void);
>  
>  static void trace_save_cmdline(struct task_struct *tsk)
>  {
> -	unsigned pid, idx;
> +	unsigned int idx;
>  
> -	if (!tsk->pid || unlikely(tsk->pid > PID_MAX_DEFAULT))
> +	if (!tsk->pid)
>  		return;
>  
>  	/*
> @@ -768,22 +805,11 @@ static void trace_save_cmdline(struct task_struct *tsk)
>  	if (!__raw_spin_trylock(&trace_cmdline_lock))
>  		return;
>  
> -	idx = map_pid_to_cmdline[tsk->pid];
> +	idx = map_pid_to_cmdline(tsk->pid);
>  	if (idx == NO_CMDLINE_MAP) {
>  		idx = (cmdline_idx + 1) % SAVED_CMDLINES;
>  
> -		/*
> -		 * Check whether the cmdline buffer at idx has a pid
> -		 * mapped. We are going to overwrite that entry so we
> -		 * need to clear the map_pid_to_cmdline. Otherwise we
> -		 * would read the new comm for the old pid.
> -		 */
> -		pid = map_cmdline_to_pid[idx];
> -		if (pid != NO_CMDLINE_MAP)
> -			map_pid_to_cmdline[pid] = NO_CMDLINE_MAP;
> -
> -		map_cmdline_to_pid[idx] = tsk->pid;
> -		map_pid_to_cmdline[tsk->pid] = idx;
> +		do_map_cmdline_index(idx, tsk->pid);
>  
>  		cmdline_idx = idx;
>  	}
> @@ -802,14 +828,9 @@ void trace_find_cmdline(int pid, char comm[])
>  		return;
>  	}
>  
> -	if (pid > PID_MAX_DEFAULT) {
> -		strcpy(comm, "<...>");
> -		return;
> -	}
> -
>  	preempt_disable();
>  	__raw_spin_lock(&trace_cmdline_lock);
> -	map = map_pid_to_cmdline[pid];
> +	map = map_pid_to_cmdline(pid);
>  	if (map != NO_CMDLINE_MAP)
>  		strcpy(comm, saved_cmdlines[map]);
>  	else
> @@ -2458,7 +2479,7 @@ tracing_saved_cmdlines_read(struct file *file, char __user *ubuf,
>  	for (i = 0; i < SAVED_CMDLINES; i++) {
>  		int r;
>  
> -		pid = map_cmdline_to_pid[i];
> +		pid = map_cmdline_to_pid(i);
>  		if (pid == -1 || pid == NO_CMDLINE_MAP)
>  			continue;
>  
> 
> 
> 
> 
> 
> 

