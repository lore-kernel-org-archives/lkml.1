Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbZHYNwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbZHYNwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 09:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbZHYNwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 09:52:34 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58101 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbZHYNwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 09:52:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WKI5nDEDAX+wLRjygut/AogU/LqtFcn6D3kLvwXVNQTqhtXQcivW1MaFJjEwofU6ke
         6SOGLdPoJihWBPf5o9buagW1lBAyN3EujdtNf8y2DYoOOW1iBwrEWsphfADtUodz0qIh
         D87q7T0i7oWIu9xGFeL1ah7doNGo5wUtk0TpE=
Date: Tue, 25 Aug 2009 15:52:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 00/12] add syscall tracepoints V3 - s390 arch update
Message-ID: <20090825135228.GD6114@nowhere>
References: <cover.1249932670.git.jbaron@redhat.com> <20090825123111.GD4639@cetus.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825123111.GD4639@cetus.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 02:31:11PM +0200, Hendrik Brueckner wrote:
> Hi,
> 
> I looked at your recent syscall tracepoint patches and I have few
> more s390 arch updates.
> 
> This patch includes s390 arch updates for:
> - tracing: Map syscall name to number (syscall_name_to_nr())
> - tracing: Call arch_init_ftrace_syscalls at boot
> - tracing: add support traceopint ids (set_syscall_{enter,exit}_id())
> 
> The patch already uses "NR_syscalls" instead of FTRACE_SYSCALL_MAX.
> 
> The patch is based on today's linux-next (20090825).
> Since few of your patches already include s390 changes,
> I would appreciate if you could add the patch to your patch set.
> 
> If you have any remarks, please let me know. 
>   
> Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>


Looks good at a first glance.



> ---
>  arch/s390/include/asm/ftrace.h |    4 ++++
>  arch/s390/kernel/ftrace.c      |   36 +++++++++++++++++++++++++++---------
>  2 files changed, 31 insertions(+), 9 deletions(-)
> 
> --- a/arch/s390/kernel/ftrace.c
> +++ b/arch/s390/kernel/ftrace.c
> @@ -220,6 +220,29 @@ struct syscall_metadata *syscall_nr_to_m
>  	return syscalls_metadata[nr];
>  }
>  
> +int syscall_name_to_nr(char *name)
> +{
> +	int i;
> +
> +	if (!syscalls_metadata)
> +		return -1;
> +	for (i = 0; i < NR_syscalls; i++)
> +		if (syscalls_metadata[i])
> +			if (!strcmp(syscalls_metadata[i]->name, name))
> +				return i;
> +	return -1;
> +}
> +void set_syscall_enter_id(int num, int id)
> +{
> +	syscalls_metadata[num]->enter_id = id;
> +}
> +
> +void set_syscall_exit_id(int num, int id)
> +{
> +	syscalls_metadata[num]->exit_id = id;
> +}



The three helpers above seem very common between archs, I guess
we can move them to the core: kernel/trace/trace_syscalls.c


>  static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
>  {
>  	struct syscall_metadata *start;
> @@ -237,24 +260,19 @@ static struct syscall_metadata *find_sys
>  	return NULL;
>  }
>  
> -void arch_init_ftrace_syscalls(void)
> +static int __init arch_init_ftrace_syscalls(void)
>  {
>  	struct syscall_metadata *meta;
>  	int i;
> -	static atomic_t refs;
> -
> -	if (atomic_inc_return(&refs) != 1)
> -		goto out;
>  	syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) * NR_syscalls,
>  				    GFP_KERNEL);
>  	if (!syscalls_metadata)
> -		goto out;
> +		return -ENOMEM;
>  	for (i = 0; i < NR_syscalls; i++) {
>  		meta = find_syscall_meta((unsigned long)sys_call_table[i]);
>  		syscalls_metadata[i] = meta;
>  	}
> -	return;
> -out:
> -	atomic_dec(&refs);
> +	return 0;
>  }
> +arch_initcall(arch_init_ftrace_syscalls);
>  #endif



We can even probably move most of this code to the core, expect the tiny parts
that rely on the arch syscall table.

BTW, perhaps a silly question: would it be hard to have a generic syscall table
common to every archs?

Thanks,
Frederic.

