Return-Path: <linux-kernel-owner+w=401wt.eu-S1762122AbZFNPpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762122AbZFNPpi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 11:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZFNPpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 11:45:31 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:20624 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbZFNPpb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 11:45:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=V/ABFZEQE2MG7hmGIekssz0G+s3aITkvlOJqn9dbAhKUsGpg0AZ3V8nYmrqBhIzUQG
         naJ8ZRMtLy+6Jmv/J8OgcqFZ4qOlEuc2h/I2INzRxvTQqrpupnZD/MYVNy8+Z042SYfY
         EWIOJ8ELByNOYrT9MGLz1D75ue9hTUF4jI4qg=
MIME-Version: 1.0
In-Reply-To: <1244992206.31584.59.camel@falcon>
References: <1244623722-6325-2-git-send-email-vapier@gentoo.org> 
	<1244667129-27630-1-git-send-email-vapier@gentoo.org> <1244992206.31584.59.camel@falcon>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 14 Jun 2009 11:45:13 -0400
Message-ID: <8bd0f97a0906140845o73c4c9d6r40c2e1132a46fa6a@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2] ftrace: document basic ftracer/ftracer graph needs
To: wuzhangjin@gmail.com
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 11:10, Wu Zhangjin wrote:
> On Wed, 2009-06-10 at 16:52 -0400, Mike Frysinger wrote:
>> +The arguments to prepare_ftrace_return are slightly different than what are
>> +passed to ftrace_trace_function.  The second argument "selfpc" is the same,
>> +but the first argument should be a pointer to the "frompc".  Typically this is
>> +located on the stack.  This allows the function to hijack the return address
>> +temporarily to have it point to the arch-specific function return_to_handler.
>> +That function will simply call the common ftrace_return_to_handler function and
>> +that will return the original return address with which, you can return to the
>> +original call site.
>> ...
>> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
>> +void ftrace_graph_caller(void)
>> +{
>> +     /* save all state needed by the ABI */
>> +
>> +     unsigned long *frompc = &...;
>> +     unsigned long selfpc = <return address> - MCOUNT_INSN_SIZE;
>> +     prepare_ftrace_return(frompc, selfpc);
>> +
>> +     /* restore all state needed by the ABI */
>> +}
>> +#endif
>> +
>> +For information on how to implement prepare_ftrace_return(), simply look at
>> +the x86 version.  The only architecture-specific piece in it is the setup of
>> +the fault recovery table (the asm(...) code).  The rest should be the same
>> +across architectures.
>> +
>
> and the fault recovery table is not needed.

i dont have one for the Blackfin port, but that's more because there
is no fault recovery support in the Blackfin port ;)

> In reality, the prepare_ftrace_return() can have the same arguments as
> ftrace_trace_function()
> ...
> as i know, prepare_ftrace_return() is used to check whether the calling
> function expect to trace, if yes, return the 'hook' function
> &return_to_handler, otherwise, return back to the parent_ip directly.
> so, here, i think there is no need to transfer the data via address, but
> just using the same arguments like ftrace_trace_function does.

hmm, that would make the implementation simpler, but i dont think you
could do that if you implemented the fault handler.  i cant really
speak as to the requirement of the fault handler as i dont really know
what/how it works -- i can only guess at they arent used in any way
for Blackfin systems.

> unsigned long
> prepare_ftrace_return(unsgined long ip, unsigned long parent_ip)
> {
>    [...]
>    if (ftrace_push_return_trace(parent_ip, ip, &trace.depth) == -EBUSY)
>        return parent_ip;
>
>    if (ftrace_graph_entry(&trace))
>        return (unsigned long)&return_to_handler;
>
>    [...]
>
>    return parent_ip;
> }
>
> if using the above method, the fault recovery table is not needed again.

and it would allow us to move this code into the common ftrace
framework for people who dont do fault handlers.

> am i wrong? if this method is okay, so, this document should not only
> refer to the x86's implementation detail, but focus on the basic
> principle of prepare_ftrace_return().

ppc also uses the same method as x86 which is why i wrote it that way.
-mike
