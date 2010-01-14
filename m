Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603Ab0ANC4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab0ANC4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755418Ab0ANC4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:56:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44148 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab0ANC4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:56:10 -0500
X-Authority-Analysis: v=1.0 c=1 a=8vRYAHsiuOoA:10 a=Z4Rwk6OoAAAA:8 a=H8BD-4G5cqaoOcJhcMMA:9 a=w2Mq--WGVH8qvbLodFwA:7 a=emhoPOsd_nriwoC8ngHT2zziHjQA:4 a=jbrJJM5MRmoA:10 a=qFYjZxGMsCfYU_qv:21 a=EpceiR_GarCDvPD8:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC local_t removal V1 2/4] Replace local_t use in trace
 subsystem
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20100105220438.462143211@quilx.com>
References: <20100105220417.400092933@quilx.com>
	 <20100105220438.462143211@quilx.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 13 Jan 2010 21:56:07 -0500
Message-ID: <1263437767.28171.3844.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please Cc me on changes to the ring buffer.

On Tue, 2010-01-05 at 16:04 -0600, Christoph Lameter wrote:
> plain text document attachment (remove_local_t_ringbuffer_convert)
> Replace the local_t use with longs in the trace subsystem. The longs can then be
> updated with the required level of concurrency protection through cmpxchg_local()
> and add_local().
> 
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> 


> @@ -1741,7 +1741,7 @@ rb_reset_tail(struct ring_buffer_per_cpu
>  	 * must fill the old tail_page with padding.
>  	 */
>  	if (tail >= BUF_PAGE_SIZE) {
> -		local_sub(length, &tail_page->write);
> +		add_local(&tail_page->write, -length);

Can't you have a helper function or macro that does:

#define sub_local(local, val)	add_local(local, -(val))

>  		return;
>  	}
>  


>  static struct ring_buffer_event *
> @@ -1801,7 +1801,7 @@ rb_move_tail(struct ring_buffer_per_cpu 
>  	 * about it.
>  	 */
>  	if (unlikely(next_page == commit_page)) {
> -		local_inc(&cpu_buffer->commit_overrun);
> +		add_local(&cpu_buffer->commit_overrun, 1);

As well as a:

#define inc_local(local)	add_local(local, 1)

>  		goto out_reset;
>  	}
>  


>   again:
> -	commits = local_read(&cpu_buffer->commits);
> +	commits = cpu_buffer->commits;
>  	/* synchronize with interrupts */
>  	barrier();
> -	if (local_read(&cpu_buffer->committing) == 1)
> +	if (cpu_buffer->committing == 1)
>  		rb_set_commit_to_write(cpu_buffer);
>  
> -	local_dec(&cpu_buffer->committing);
> +	add_local(&cpu_buffer->committing, -1);

As well as a:

#define dec_local(local)	add_local(local, -1)


>  
>  	/* synchronize with interrupts */
>  	barrier();
> @@ -2059,9 +2059,9 @@ static void rb_end_commit(struct ring_bu
>  	 * updating of the commit page and the clearing of the
>  	 * committing counter.
>  	 */

The reason I ask for the above is because it sticks out much better. The
subtracting and inc/dec pairs I need to match. So I usually end up
scanning a matching "dec" for a "inc", or a matching "sub" for an "add",
but having "-1" to match "1" is not going to stand out, and I envision a
lot of stupid bugs happening because of this.

-- Steve


