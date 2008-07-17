Return-Path: <linux-kernel-owner+w=401wt.eu-S1760186AbYGQAHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186AbYGQAHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 20:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYGQAHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 20:07:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbYGQAHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 20:07:42 -0400
Message-ID: <487E8CE4.70105@redhat.com>
Date: Wed, 16 Jul 2008 20:05:56 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs
 (part1: use kprobe symbol_name/offset instead of address)
References: <1216146802.3312.95.camel@localhost.localdomain>	 <487E78ED.30804@redhat.com> <1216249383.3358.69.camel@localhost.localdomain>
In-Reply-To: <1216249383.3358.69.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Wed, 2008-07-16 at 18:40 -0400, Masami Hiramatsu wrote:
>> James Bottomley wrote:
>>> One of the big nasties of systemtap is the way it tries to embed
>>> virtually the entirety of the kernel symbol table in the probe modules
>>> it constructs.  This is highly undesirable because it represents a
>>> subversion of the kernel API to gain access to unexported symbols.  At
>>> least for kprobes, the correct way to do this is to specify the probe
>>> point by symbol and offset.
>>>
>>> This patch converts systemtap to use the correct kprobe
>>> symbol_name/offset pair to identify the probe location.
>> Hi James,
>>
>> I think your suggestion is a good step. Of course, it might
>> have to solve some issues.
>>
>> Unfortunately, current kprobe's symbol_name interface is not
>> so clever. For example, if you specify a static function
>> which is defined at several places in the kernel(ex. do_open),
>> it always pick up the first one in kallsyms, even if systemtap
>> can find all of those functions.
>> (you can find many duplicated symbols in /proc/kallsyms)
> 
> Right, but realistically only functions which have a strict existence
> (i.e. those for whom an address could be taken) can be used; functions
> which are fully inlined (as in have no separate existence) can't.
> That's why the patch finds the closest function with an address to match
> on.

Sure, inlined functions are embedded in a caller function, so the
closest function is the correct owner.

However, I meant local-scope functions can have same name if
they are defined in different scope. And even though, both of
them are shown in kallsyms. This mean, you can see the functions
which have real different existence but have same symbol.

Would you mean systemtap should not probe those name-conflicted
functions?

>> So, we might better improve kallsyms to treat this case
>> and find what is a better way to specify symbols and addresses.
> 
> Well, both the dwarf and the kallsyms know which are the functions that
> have a real existence, so the tool can work it out.  It has a real
> meaning too because the chosen symbol must be the parent routine of all
> the nested inlines.

Hmm, here is what I got with your patch;
$ stap --kelf -e 'probe kernel.function("do_open"){}' -p2
# probes
kernel.function("do_open@arch/x86/kernel/apm_32.c:1557") /* pc=<do_open+0x0> */ /* <- kernel.function("do_open") */
kernel.function("do_open@fs/block_dev.c:928") /* pc=<do_open+0x0> */ /* <- kernel.function("do_open") */
kernel.function("do_open@fs/nfsctl.c:24") /* pc=<sys_nfsservctl+0x55> */ /* <- kernel.function("do_open") */
kernel.function("do_open@ipc/mqueue.c:630") /* pc=<do_open+0x0> */ /* <- kernel.function("do_open") */

Without your patch;
$ stap -e 'probe kernel.function("do_open"){}' -p2
# probes
kernel.function("do_open@arch/x86/kernel/apm_32.c:1557") /* pc=0x10382 */ /* <- kernel.function("do_open") */
kernel.function("do_open@fs/block_dev.c:928") /* pc=0xa0750 */ /* <- kernel.function("do_open") */
kernel.function("do_open@fs/nfsctl.c:24") /* pc=0xa6411 */ /* <- kernel.function("do_open") */
kernel.function("do_open@ipc/mqueue.c:630") /* pc=0xc55a6 */ /* <- kernel.function("do_open") */

Obviously, the 3rd "do_open" is fully inlined, so it can be
correctly handled by kprobes, because it has different
symbol(sys_nfsservctl). However, other "do_open" have
same symbol(do_open). these will be put on same
address (at the first symbol on kallsyms list).

So, we need a bridge for the gap of function addresses
between kallsyms and dwarf.

[...]
>> Could we provide a separated GPL'd interface to access named global
>> symbols which is based on kallsyms?
> 
> Yes, I think so ... it's just a case of working out what and how; but to
> do that we need a consumer of the interface.

I agree with you, we need to change both of systemtap and kernel.

Thank you,

> 
> James
> 
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

