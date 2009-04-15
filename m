Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbZDOGNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbZDOGNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZDOGNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:13:16 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:56723 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZDOGNP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:13:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LIaX/6smQYmgyTzJo/nFB4wjHmhYEMgArTad2Pq2kfWAFgaaYS+PoJaCsnFox44Amc
         pkSlxQT17Whv45fx90f4BbR93snZuGPYTyWT0SrOiSjfSB3ZmlM84Cft4JCoDktaXfUH
         70h1X27/rsWSAqmr6FLvcGj7VIFvmgR1dYIIc=
MIME-Version: 1.0
In-Reply-To: <20090415055839.GA12040@elte.hu>
References: <1239753659-11790-1-git-send-email-fweisbec@gmail.com>
	 <1239771791.32241.6.camel@localhost> <20090415055839.GA12040@elte.hu>
Date: Wed, 15 Apr 2009 09:13:12 +0300
X-Google-Sender-Auth: ff26ef2c161d9e28
Message-ID: <84144f020904142313m4da323fdj9a8becf3010c519c@mail.gmail.com>
Subject: Re: RFC: introduce struct ksymbol
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Joe Perches <joe@perches.com>, Sam Ravnborg <sam@ravnborg.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Wed, Apr 15, 2009 at 8:58 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> (Sam and Rusty Cc:-ed)
>
> * Joe Perches <joe@perches.com> wrote:
>
>> On Wed, 2009-04-15 at 02:00 +0200, Frederic Weisbecker wrote:
>> > arch/blackfin/kernel/traps.c:   symname = kallsyms_lookup(address, &symsize, &offset, &modname, namebuf);
>> > arch/powerpc/xmon/xmon.c:               name = kallsyms_lookup(pc, &size, &offset, NULL, tmpstr);
>> > arch/sh/kernel/cpu/sh5/unwind.c:        sym = kallsyms_lookup(pc, NULL, &offset, NULL, namebuf);
>> > arch/x86/kernel/ftrace.c:       kallsyms_lookup((unsigned long) syscall, NULL, NULL, NULL, str);
>> > kernel/kprobes.c:               sym = kallsyms_lookup((unsigned long)p->addr, NULL,
>> > kernel/lockdep.c:       return kallsyms_lookup((unsigned long)key, NULL, NULL, NULL, str);
>> > kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
>> > kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
>> > kernel/trace/ftrace.c:  kallsyms_lookup((unsigned long)rec->ops->func, NULL, NULL, NULL, str);
>> > kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
>> > kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
>> > kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, &modname, str);
>> > kernel/trace/ftrace.c:  kallsyms_lookup(*ptr, NULL, NULL, NULL, str);
>> > kernel/trace/trace_functions.c: kallsyms_lookup(ip, NULL, NULL, NULL, str);
>> > kernel/trace/trace_output.c:    kallsyms_lookup(address, NULL, NULL, NULL, str);
>>
>> Perhaps a conversion from
>>
>> "char str[KSYM_SYMBOL_LEN]"
>> to
>> "struct ksymbol sym"?
>>
>> could be useful.
>>
>> There are a few places that use a hard coded length of 128
>> instead of KSYM_SYMBOL_LENGTH that are also converted.
>>
>> Compile tested only
>
> Why not 'struct ksym'? That name is unused right now, it is shorter
> and just as descriptive.
>
> Regarding the change... dunno. Sam, Rusty - what do you think?
>
> Downsides would be loss of awareness of stack footprint impact. A
> plain struct is easy to slap on, and it's not immediately visible
> that it carries 128 bytes of weight. It might also be confusing in
> terms of the nature of the interface - whether it's a pointery
> object or not.
>
> Prior use:
>
>        char str[KSYM_SYMBOL_LEN];
>
>        kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
>
> New use:
>
>        struct ksym sym;
>
>        kallsyms_lookup(rec->ip, NULL, NULL, NULL, &sym);
>
> Dunno.

The change makes sense to me. Passing a raw char pointer down the
call-chain is a buffer overflow waiting to happen and as a matter of
fact, we've had bugs in this area before. See commit
9c24624727f6d6c460e45762a408ca5f5b9b8ef2 ("KSYM_SYMBOL_LEN fixes") for
an example.

                                      Pekka
