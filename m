Return-Path: <linux-kernel-owner+w=401wt.eu-S1759496AbYGQOS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759496AbYGQOS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 10:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbYGQOSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 10:18:18 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54811 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755604AbYGQOSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 10:18:17 -0400
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs
	(part1: use kprobe symbol_name/offset instead of address)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
In-Reply-To: <1216259391.3358.85.camel@localhost.localdomain>
References: <1216146802.3312.95.camel@localhost.localdomain>
	 <487E78ED.30804@redhat.com>
	 <1216249383.3358.69.camel@localhost.localdomain>
	 <487E8CE4.70105@redhat.com>
	 <1216259391.3358.85.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 09:18:10 -0500
Message-Id: <1216304290.5515.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-16 at 20:49 -0500, James Bottomley wrote:
> On Wed, 2008-07-16 at 20:05 -0400, Masami Hiramatsu wrote:
> > Hmm, here is what I got with your patch;
> > $ stap --kelf -e 'probe kernel.function("do_open"){}' -p2
> > # probes
> > kernel.function("do_open@arch/x86/kernel/apm_32.c:1557") /* pc=<do_open+0x0> */ /* <- kernel.function("do_open") */
> > kernel.function("do_open@fs/block_dev.c:928") /* pc=<do_open+0x0> */ /* <- kernel.function("do_open") */
> > kernel.function("do_open@fs/nfsctl.c:24") /* pc=<sys_nfsservctl+0x55> */ /* <- kernel.function("do_open") */
> > kernel.function("do_open@ipc/mqueue.c:630") /* pc=<do_open+0x0> */ /* <- kernel.function("do_open") */
> > 
> > Without your patch;
> > $ stap -e 'probe kernel.function("do_open"){}' -p2
> > # probes
> > kernel.function("do_open@arch/x86/kernel/apm_32.c:1557") /* pc=0x10382 */ /* <- kernel.function("do_open") */
> > kernel.function("do_open@fs/block_dev.c:928") /* pc=0xa0750 */ /* <- kernel.function("do_open") */
> > kernel.function("do_open@fs/nfsctl.c:24") /* pc=0xa6411 */ /* <- kernel.function("do_open") */
> > kernel.function("do_open@ipc/mqueue.c:630") /* pc=0xc55a6 */ /* <- kernel.function("do_open") */
> > 
> > Obviously, the 3rd "do_open" is fully inlined, so it can be
> > correctly handled by kprobes, because it has different
> > symbol(sys_nfsservctl). However, other "do_open" have
> > same symbol(do_open). these will be put on same
> > address (at the first symbol on kallsyms list).
> > 
> > So, we need a bridge for the gap of function addresses
> > between kallsyms and dwarf.
> 
> You mean this particular problem:
> 
> hobholes:/home/jejb/git/BUILD-2.6# grep do_open /proc/kallsyms 
> c01af160 t do_open
> c01d5d40 t do_open
> 
> It's certainly a material defect in the current API.  I'll think about
> it and see if I can come up with a solution.

OK, thought about it.  There seem to be two possible solutions

     1. Get systemtap always to offset from non-static functions.  This
        will use the standard linker to ensure uniqueness (a module
        qualifier will still need to be added to the struct kprobe for
        lookup, since modules can duplicate unexported kernel symbols).
     2. Add the filename as a discriminator for duplicate symbols in the
        kallsyms program (would still need module qualifier).  This is
        appealing because the path name would be printed in the kernel
        trace to help with oops tracking

This is where negotiations come in.  To me 2. looks to be better because
it will help us with oops tracking.  On the other hand, it's usually
pretty obvious from the stack trace context which files the duplicate
symbols are actually in; what do other people think?

James


