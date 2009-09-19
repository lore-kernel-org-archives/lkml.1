Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbZISIMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbZISIMO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 04:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbZISIMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 04:12:12 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:61048 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbZISIMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 04:12:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F1OcrCZEBCTX1eIrpNx6TGzEr2wQp22gFKYlAXpocI2DSao59t0/4j/8Gcqs4rYU2n
         qpalj1RCsirF840Fd3VanivtLO8dd/DC871uik4O+m9wrbPbGuKtEenGw/AmHQxowF7r
         VOwxieEV9OopCucWZAADSueZ3q8W+wIbpIUCM=
Date: Sat, 19 Sep 2009 10:12:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/2] tracing: Move syscalls metadata handling from arch
	to core
Message-ID: <20090919081208.GD5226@nowhere>
References: <1253338757-5918-1-git-send-email-fweisbec@gmail.com> <1253338757-5918-2-git-send-email-fweisbec@gmail.com> <20090919074816.GA4783@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090919074816.GA4783@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 19, 2009 at 09:48:16AM +0200, Heiko Carstens wrote:
> On Sat, Sep 19, 2009 at 07:39:16AM +0200, Frederic Weisbecker wrote:
> > Most of the syscalls metadata processing is done from arch.
> > But these operations are mostly generic accross archs. Especially now
> > that we have a common variable name that expresses the number of
> > syscalls supported by an arch: NR_syscalls, the only remaining bits
> > that need to reside in arch is the syscall nr to addr translation.
> 
> That won't work in its current form, since there is a small difference
> between x86 and s390:
> 
> > diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
> > index 57bdcb1..7c5752c 100644
> > --- a/arch/s390/kernel/ftrace.c
> > +++ b/arch/s390/kernel/ftrace.c
> > -static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
> > -{
> > -	struct syscall_metadata *start;
> > -	struct syscall_metadata *stop;
> > -	char str[KSYM_SYMBOL_LEN];
> > -
> > -	start = (struct syscall_metadata *)__start_syscalls_metadata;
> > -	stop = (struct syscall_metadata *)__stop_syscalls_metadata;
> > -	kallsyms_lookup(syscall, NULL, NULL, NULL, str);
> > -
> > -	for ( ; start < stop; start++) {
> > -		if (start->name && !strcmp(start->name + 3, str + 3))
>                                            ^^^^^^^^^^^^^^^^^^^^^^^^



Oh, I thought it was to zap the "sys" prefix comparison.



> > diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> > index 9dbb527..4adb867 100644
> > --- a/arch/x86/kernel/ftrace.c
> > +++ b/arch/x86/kernel/ftrace.c
> > -static struct syscall_metadata *find_syscall_meta(unsigned long *syscall)
> > -{
> > -	struct syscall_metadata *start;
> > -	struct syscall_metadata *stop;
> > -	char str[KSYM_SYMBOL_LEN];
> > -
> > -
> > -	start = (struct syscall_metadata *)__start_syscalls_metadata;
> > -	stop = (struct syscall_metadata *)__stop_syscalls_metadata;
> > -	kallsyms_lookup((unsigned long) syscall, NULL, NULL, NULL, str);
> > -
> > -	for ( ; start < stop; start++) {
> > -		if (start->name && !strcmp(start->name, str))
>                                            ^^^^^^^^^^^^^^^^
> > -			return start;
> > -	}
> > -	return NULL;
> 
> The reason for the "+ 3 " is that architectures with syscall wrappers have
> alias function names which also show up in kallsysms:
> 
> 000000000001c788 t show_cpuinfo
> 000000000001c9e0 T SyS_s390_personality
> 000000000001c9e0 T sys_s390_personality
> 000000000001ca48 T SyS_s390_newuname
> 000000000001ca48 T sys_s390_newuname
> 000000000001cac8 T SyS_ipc
> 000000000001cac8 T sys_ipc
> 000000000001cd00 T SyS_s390_old_mmap
> 000000000001cd00 T sys_s390_old_mmap
> 000000000001ce68 T SyS_mmap2
> 000000000001ce68 T sys_mmap2
> 000000000001cfc4 t FixPerRegisters
> 
> So kallsyms_lookup(...) would currently always return a string that starts
> with "SyS" instead of "sys". Since the metadata syscall names start with
> "sys" there is no match.
> If you could change the generic version so it also contains a "+ 3" it
> should work for all architectures.
> Might be worth a comment that I didn't add back then :)



Ah ok. So the fix is easy.
Thanks for the tip!


> Hmm... maybe it's even possible to throw out the "SyS" variants out of
> the kallsyms table and only keep the alias names?
> That would shrink the kernel image a bit.


Yeah, unless someone finds strong reasons to keep them.

Thanks!

