Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494Ab0AEW5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab0AEW5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926Ab0AEW5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:57:13 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:41477 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755283Ab0AEW5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:57:12 -0500
Date: Tue, 5 Jan 2010 17:57:10 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC local_t removal V1 2/4] Replace local_t use in trace
	subsystem
Message-ID: <20100105225710.GC32584@Krystal>
References: <20100105220417.400092933@quilx.com> <20100105220438.462143211@quilx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100105220438.462143211@quilx.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:49:13 up 20 days,  7:07,  5 users,  load average: 0.01, 0.26,
	0.26
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux-foundation.org) wrote:
> Replace the local_t use with longs in the trace subsystem. The longs can then be
> updated with the required level of concurrency protection through cmpxchg_local()
> and add_local().
> 
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> 
> ---
>  kernel/trace/ring_buffer.c           |  150 +++++++++++++++++------------------
>  kernel/trace/ring_buffer_benchmark.c |    5 -
>  kernel/trace/trace_branch.c          |    1 
>  3 files changed, 77 insertions(+), 79 deletions(-)
> 
> Index: linux-2.6/kernel/trace/ring_buffer.c
> ===================================================================
> --- linux-2.6.orig/kernel/trace/ring_buffer.c	2010-01-05 15:35:35.000000000 -0600
> +++ linux-2.6/kernel/trace/ring_buffer.c	2010-01-05 15:36:07.000000000 -0600
> @@ -20,7 +20,7 @@
>  #include <linux/cpu.h>
>  #include <linux/fs.h>
>  
> -#include <asm/local.h>
> +#include <asm/add-local.h>
>  #include "trace.h"
>  
>  /*
> @@ -312,7 +312,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_data
>  
>  struct buffer_data_page {
>  	u64		 time_stamp;	/* page time stamp */
> -	local_t		 commit;	/* write committed index */
> +	long		 commit;	/* write committed index */
>  	unsigned char	 data[];	/* data of buffer page */
>  };
>  
> @@ -326,9 +326,9 @@ struct buffer_data_page {
>   */
>  struct buffer_page {
>  	struct list_head list;		/* list of buffer pages */
> -	local_t		 write;		/* index for next write */
> +	long		 write;		/* index for next write */
>  	unsigned	 read;		/* index for next read */
> -	local_t		 entries;	/* entries on this page */
> +	long		 entries;	/* entries on this page */
>  	struct buffer_data_page *page;	/* Actual data page */
>  };
>  
> @@ -349,7 +349,7 @@ struct buffer_page {
>  
>  static void rb_init_page(struct buffer_data_page *bpage)
>  {
> -	local_set(&bpage->commit, 0);
> +	bpage->commit = 0;

This is incorrect. You are turning a "volatile" write into a
non-volatile write, which can be turned into multiple writes by the
compiler and therefore expose inconsistent state to interrupt handlers.

>  }
>  
>  /**
> @@ -360,7 +360,7 @@ static void rb_init_page(struct buffer_d
>   */
>  size_t ring_buffer_page_len(void *page)
>  {
> -	return local_read(&((struct buffer_data_page *)page)->commit)
> +	return ((struct buffer_data_page *)page)->commit
>  		+ BUF_PAGE_HDR_SIZE;
>  }
>  
> @@ -431,11 +431,11 @@ struct ring_buffer_per_cpu {
>  	struct buffer_page		*tail_page;	/* write to tail */
>  	struct buffer_page		*commit_page;	/* committed pages */
>  	struct buffer_page		*reader_page;
> -	local_t				commit_overrun;
> -	local_t				overrun;
> -	local_t				entries;
> -	local_t				committing;
> -	local_t				commits;
> +	long				commit_overrun;
> +	long				overrun;
> +	long				entries;
> +	long				committing;
> +	long				commits;
>  	unsigned long			read;
>  	u64				write_stamp;
>  	u64				read_stamp;
> @@ -824,8 +824,8 @@ static int rb_tail_page_update(struct ri
>  	 *
>  	 * We add a counter to the write field to denote this.
>  	 */
> -	old_write = local_add_return(RB_WRITE_INTCNT, &next_page->write);
> -	old_entries = local_add_return(RB_WRITE_INTCNT, &next_page->entries);
> +	old_write = add_return_local(&next_page->write, RB_WRITE_INTCNT);
> +	old_entries = add_return_local(&next_page->entries, RB_WRITE_INTCNT);
>  
>  	/*
>  	 * Just make sure we have seen our old_write and synchronize
> @@ -853,15 +853,15 @@ static int rb_tail_page_update(struct ri
>  		 * cmpxchg to only update if an interrupt did not already
>  		 * do it for us. If the cmpxchg fails, we don't care.
>  		 */
> -		(void)local_cmpxchg(&next_page->write, old_write, val);
> -		(void)local_cmpxchg(&next_page->entries, old_entries, eval);
> +		(void)cmpxchg_local(&next_page->write, old_write, val);
> +		(void)cmpxchg_local(&next_page->entries, old_entries, eval);
>  
>  		/*
>  		 * No need to worry about races with clearing out the commit.
>  		 * it only can increment when a commit takes place. But that
>  		 * only happens in the outer most nested commit.
>  		 */
> -		local_set(&next_page->page->commit, 0);
> +		next_page->page->commit = 0;
>  
>  		old_tail = cmpxchg(&cpu_buffer->tail_page,
>  				   tail_page, next_page);
> @@ -1394,17 +1394,17 @@ rb_iter_head_event(struct ring_buffer_it
>  
>  static inline unsigned long rb_page_write(struct buffer_page *bpage)
>  {
> -	return local_read(&bpage->write) & RB_WRITE_MASK;
> +	return bpage->write & RB_WRITE_MASK;

Same problem here: missing volatile for read. Same applies thorough the
patch.

>  }
>  
>  static inline unsigned rb_page_commit(struct buffer_page *bpage)
>  {
> -	return local_read(&bpage->page->commit);
> +	return bpage->page->commit;
>  }
>  
>  static inline unsigned long rb_page_entries(struct buffer_page *bpage)
>  {
> -	return local_read(&bpage->entries) & RB_WRITE_MASK;
> +	return bpage->entries & RB_WRITE_MASK;
>  }
>  
>  /* Size is determined by what has been commited */
> @@ -1463,8 +1463,8 @@ rb_set_commit_to_write(struct ring_buffe
>  		if (RB_WARN_ON(cpu_buffer,
>  			       rb_is_reader_page(cpu_buffer->tail_page)))
>  			return;
> -		local_set(&cpu_buffer->commit_page->page->commit,
> -			  rb_page_write(cpu_buffer->commit_page));
> +		cpu_buffer->commit_page->page->commit =
> +			  rb_page_write(cpu_buffer->commit_page);
>  		rb_inc_page(cpu_buffer, &cpu_buffer->commit_page);
>  		cpu_buffer->write_stamp =
>  			cpu_buffer->commit_page->page->time_stamp;
> @@ -1474,10 +1474,10 @@ rb_set_commit_to_write(struct ring_buffe
>  	while (rb_commit_index(cpu_buffer) !=
>  	       rb_page_write(cpu_buffer->commit_page)) {
>  
> -		local_set(&cpu_buffer->commit_page->page->commit,
> -			  rb_page_write(cpu_buffer->commit_page));
> +		cpu_buffer->commit_page->page->commit =
> +			  rb_page_write(cpu_buffer->commit_page);
>  		RB_WARN_ON(cpu_buffer,
> -			   local_read(&cpu_buffer->commit_page->page->commit) &
> +			   cpu_buffer->commit_page->page->commit &
>  			   ~RB_WRITE_MASK);
>  		barrier();
>  	}
> @@ -1600,7 +1600,7 @@ rb_handle_head_page(struct ring_buffer_p
>  		 * it is our responsibility to update
>  		 * the counters.
>  		 */
> -		local_add(entries, &cpu_buffer->overrun);
> +		add_local(&cpu_buffer->overrun, entries);
>  
>  		/*
>  		 * The entries will be zeroed out when we move the
> @@ -1741,7 +1741,7 @@ rb_reset_tail(struct ring_buffer_per_cpu
>  	 * must fill the old tail_page with padding.
>  	 */
>  	if (tail >= BUF_PAGE_SIZE) {
> -		local_sub(length, &tail_page->write);
> +		add_local(&tail_page->write, -length);

[...]

If we can have inc/dec/sub already, that would be good, rather than
going with add -val. This would ensure that we don't do too much
ping-pong with the code using these primitives.

In the end, the fact that the missing volatile access bug crept up as
part of this patch makes me think that keeping local_t was doing a fine
encapsulation job. However, if we really want to go down the path of
removing this encapsulation, then we should:

- make sure that _all_ variable accesses are encapsulated, even
  read_local and set_local.
- put all this API into a single header per architecture, easy for
  people to find and understand, rather than multiple headers sprinkled
  all over the place.
- document that accessing the variables without the API violates the
  consistency guarantees.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
