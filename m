Return-Path: <linux-kernel-owner+w=401wt.eu-S933937AbXHVXyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937AbXHVXyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 19:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932325AbXHVXyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 19:54:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46111 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762874AbXHVXyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 19:54:14 -0400
Date: Wed, 22 Aug 2007 16:53:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       kgdb-bugreport@lists.sourceforge.net, amitkale@linsyssoft.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [Kgdb-bugreport] 2.6.23-rc3-mm1: kgdb build failure on powerpc
Message-Id: <20070822165318.b82da13c.akpm@linux-foundation.org>
In-Reply-To: <46CCBC3C.7010307@windriver.com>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<200708222104.29432.m.kozlowski@tuxland.pl>
	<20070822124743.fc316963.akpm@linux-foundation.org>
	<46CCBC3C.7010307@windriver.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 17:44:12 -0500
Jason Wessel <jason.wessel@windriver.com> wrote:

> Perhaps there is a cleaner way to do the same thing and avoid the 
> cmpxchg all together.  I used the attached patch to eliminate the 
> cmpxchg operation.
> 
> 
> Jason.
> 
> 
> [kgdb_enter_atomic.patch  text/plain (2.0KB)]
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> 
> ---
>  kernel/kgdb.c |   18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> --- a/kernel/kgdb.c
> +++ b/kernel/kgdb.c
> @@ -121,6 +121,7 @@ struct task_struct *kgdb_usethread, *kgd
>  
>  int debugger_step;
>  atomic_t debugger_active;
> +static atomic_t kgdb_sync = ATOMIC_INIT(-1);
>  
>  /* Our I/O buffers. */
>  static char remcom_in_buffer[BUFMAX];
> @@ -638,8 +639,14 @@ static void kgdb_wait(struct pt_regs *re
>  	kgdb_info[processor].task = current;
>  	atomic_set(&procindebug[processor], 1);
>  
> +	/* The master processor must be active to enter here, but this is
> +	 * gaurd in case the master processor had not been selected if
> +	 * this was an entry via nmi.
> +	 */
> +	while (!atomic_read(&debugger_active));

eek.  We're in the process of hunting down and eliminating exactly this
construct.  There have been cases where the compiler cached the
atomic_read() result in a register, turning the above into an infinite
loop.

Plus we should never add power-burners like that into the kernel anyway. 
That loop should have a cpu_relax() in it.  Which will also fix the
compiler problem described above.

Thirdly, please always add a newline when coding statements like that:

	while (expr())
		;


