Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbYDRWK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbYDRWK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 18:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbYDRWKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 18:10:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886AbYDRWKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 18:10:16 -0400
Date: Fri, 18 Apr 2008 15:09:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>, Jason Wessel <jason.wessel@windriver.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kgdb: core
Message-Id: <20080418150930.476ea7aa.akpm@linux-foundation.org>
In-Reply-To: <200804181741.m3IHfTeC012089@hera.kernel.org>
References: <200804181741.m3IHfTeC012089@hera.kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 17:41:29 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=dc7d552705215ac50a0617fcf51bb9c736255b8e
> Commit:     dc7d552705215ac50a0617fcf51bb9c736255b8e
> Parent:     c33fa9f5609e918824446ef9a75319d4a802f1f4
> Author:     Jason Wessel <jason.wessel@windriver.com>
> AuthorDate: Thu Apr 17 20:05:37 2008 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu Apr 17 20:05:37 2008 +0200
> 
>     kgdb: core
>     
>     kgdb core code. Handles the protocol and the arch details.
>     
>     [ mingo@elte.hu: heavily modified, simplified and cleaned up. ]
>     [ xemul@openvz.org: use find_task_by_pid_ns ]
>     
> ...
>
> +
> +/*
> + *	kgdb_skipexception - Bail out of KGDB when we've been triggered.
> + *	@exception: Exception vector number
> + *	@regs: Current &struct pt_regs.
> + *
> + *	On some architectures we need to skip a breakpoint exception when
> + *	it occurs after a breakpoint has been removed.
> + */
> +extern int kgdb_skipexception(int exception, struct pt_regs *regs);

Please just nuke all the interface comments in the header files.  They
duplicate the kernedoc comments at the definition site and we don't want to
have to update both versions whenever we change something.

> +/*
> + * Functions each KGDB-supporting architecture must provide:
> + */
> +
> +/*
> + *	kgdb_arch_init - Perform any architecture specific initalization.
> + *
> + *	This function will handle the initalization of any architecture
> + *	specific callbacks.
> + */
> +extern int kgdb_arch_init(void);

Well, these are trickier because there is an implementation of this
function within each architecture.  So I think that in this case it _does_
make sense to document the function in a common place, and the only common
place is this header file.

So please

a) make this a kerneldoc comment and

b) remove the kerneldoc at the definition site(s).

(alternative: teach the kerneldoc system to go fishing in the various arch
directories to find the appropriate documentation, but I don't know enough
about kerneldoc to be able say anything about that).

> +
> +/*
> + * struct kgdb_arch - Describe architecture specific values.
> + * @gdb_bpt_instr: The instruction to trigger a breakpoint.
> + * @flags: Flags for the breakpoint, currently just %KGDB_HW_BREAKPOINT.
> + * @set_breakpoint: Allow an architecture to specify how to set a software
> + * breakpoint.
> + * @remove_breakpoint: Allow an architecture to specify how to remove a
> + * software breakpoint.
> + * @set_hw_breakpoint: Allow an architecture to specify how to set a hardware
> + * breakpoint.
> + * @remove_hw_breakpoint: Allow an architecture to specify how to remove a
> + * hardware breakpoint.
> + * @remove_all_hw_break: Allow an architecture to specify how to remove all
> + * hardware breakpoints.
> + * @correct_hw_break: Allow an architecture to specify how to correct the
> + * hardware debug registers.
> + */

This should become a kernedoc comment, as this is the only place we can
document it.  So please add the leading /**

> +struct kgdb_arch {
> +	unsigned char		gdb_bpt_instr[BREAK_INSTR_SIZE];
> +	unsigned long		flags;
> +
> +	int	(*set_breakpoint)(unsigned long, char *);
> +	int	(*remove_breakpoint)(unsigned long, char *);
> +	int	(*set_hw_breakpoint)(unsigned long, int, enum kgdb_bptype);
> +	int	(*remove_hw_breakpoint)(unsigned long, int, enum kgdb_bptype);
> +	void	(*remove_all_hw_break)(void);
> +	void	(*correct_hw_break)(void);
> +};
> +
> +/*
> + * struct kgdb_io - Describe the interface for an I/O driver to talk with KGDB.
> + * @name: Name of the I/O driver.
> + * @read_char: Pointer to a function that will return one char.
> + * @write_char: Pointer to a function that will write one char.
> + * @flush: Pointer to a function that will flush any pending writes.
> + * @init: Pointer to a function that will initialize the device.
> + * @pre_exception: Pointer to a function that will do any prep work for
> + * the I/O driver.
> + * @post_exception: Pointer to a function that will do any cleanup work
> + * for the I/O driver.
> + */

ditto

> +struct kgdb_io {
> +	const char		*name;
> +	int			(*read_char) (void);
> +	void			(*write_char) (u8);
> +	void			(*flush) (void);
> +	int			(*init) (void);
> +	void			(*pre_exception) (void);
> +	void			(*post_exception) (void);
> +};
>
> ...
>
> +static struct debuggerinfo_struct {
> +	void			*debuggerinfo;
> +	struct task_struct	*task;
> +} kgdb_info[NR_CPUS];

We're slowly trying to weed out dependencies on NR_CPUS: switching to
num_online_cpus, num_possible_cpus, etc.  This one takes us backwards.

Fixable?

> +static atomic_t			passive_cpu_wait[NR_CPUS];
> +static atomic_t			cpu_in_kgdb[NR_CPUS];

etc.

> +static char			remcom_in_buffer[BUFMAX];
> +static char			remcom_out_buffer[BUFMAX];

Surprisingly, kgdb appears to be the only part of the kernel which is using
BUFMAX.  But as a kernel-wide identifier, it isn't a very well-chosen one.

> +
> +/*
> + * GDB remote protocol parser:
> + */
> +
> +static const char	hexchars[] = "0123456789abcdef";
> +
> +static int hex(char ch)
> +{
> +	if ((ch >= 'a') && (ch <= 'f'))
> +		return ch - 'a' + 10;
> +	if ((ch >= '0') && (ch <= '9'))
> +		return ch - '0';
> +	if ((ch >= 'A') && (ch <= 'F'))
> +		return ch - 'A' + 10;
> +	return -1;
> +}

How many are we up to now?

akpm:/usr/src/linux-2.6.25> grep -ri '"0123456789abcdef"' . | wc -l
40

lol.



Nice-looking code - kgb has improved rather a lot.  I'm glad we finally got
it in.  Maybe one day I'll get to use it again :(

