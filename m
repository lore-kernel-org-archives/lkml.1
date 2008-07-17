Return-Path: <linux-kernel-owner+w=401wt.eu-S1760950AbYGQWDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760950AbYGQWDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbYGQWDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:03:11 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38585 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754770AbYGQWDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:03:09 -0400
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs
	(part1: use kprobe symbol_name/offset instead of address)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
In-Reply-To: <487FBB56.4070709@redhat.com>
References: <1216146802.3312.95.camel@localhost.localdomain>
	 <487E78ED.30804@redhat.com>
	 <1216249383.3358.69.camel@localhost.localdomain>
	 <487E8CE4.70105@redhat.com>
	 <1216259391.3358.85.camel@localhost.localdomain>
	 <1216304290.5515.11.camel@localhost.localdomain>
	 <1216313914.5515.25.camel@localhost.localdomain>
	 <487FBB56.4070709@redhat.com>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 17:03:06 -0500
Message-Id: <1216332186.5515.99.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-17 at 17:36 -0400, Masami Hiramatsu wrote:
> James Bottomley wrote:
> > On Thu, 2008-07-17 at 09:18 -0500, James Bottomley wrote:
> >> OK, thought about it.  There seem to be two possible solutions
> >>
> >>      1. Get systemtap always to offset from non-static functions.  This
> >>         will use the standard linker to ensure uniqueness (a module
> >>         qualifier will still need to be added to the struct kprobe for
> >>         lookup, since modules can duplicate unexported kernel symbols).
> >>      2. Add the filename as a discriminator for duplicate symbols in the
> >>         kallsyms program (would still need module qualifier).  This is
> >>         appealing because the path name would be printed in the kernel
> >>         trace to help with oops tracking
> >>
> >> This is where negotiations come in.  To me 2. looks to be better because
> >> it will help us with oops tracking.  On the other hand, it's usually
> >> pretty obvious from the stack trace context which files the duplicate
> >> symbols are actually in; what do other people think?
> > 
> > Just by way of illustration, this is systemtap fixed up according to
> > suggestion number 1.  You can see now using your test case that we get:
> > 
> > # probes
> > kernel.function("do_open@fs/block_dev.c:929") /* pc=<lookup_bdev+0x90> */ /* <- kernel.function("do_open") */
> > kernel.function("do_open@fs/nfsctl.c:24") /* pc=<sys_nfsservctl+0x6a> */ /* <- kernel.function("do_open") */
> > kernel.function("do_open@ipc/mqueue.c:642") /* pc=<sys_mq_unlink+0x130> */ /* <- kernel.function("do_open") */
> 
> Hi James,
> 
> Thank you for updating the patch.
> Unfortunately, I found another scenario; if someone make a module which
> has EXPORT_SYMBOL(do_open), it's a non-static function. but there are
> other static version do_open in kallsyms.
> Here, I tested it and got below;
> 
> $ stap --kelf -e 'probe module("test").function("do_open"){}' -p2
> # probes
> module("test").function("do_open@?") /* pc=<do_open+0x0> */ /* <- module("test").function("do_open") */
> 
> And I think similar issue will occur even if it is embedded in vmlinux.

Actually, no.  This is only a module problem ... it's triggered by the
fact that the module namespace is different from the kernel's global
namespace.  To get around this, I think the actual module (or null for
kernel) has to become an extra parameter to struct kprobe.

> By the way, can this patch solve the issue of -ffunction-sections?

Actually not entirely, no, if we go for only global symbols.  The
compiler is entitled to spit out a section even for a static function as
long as it has a real body.  If the module loader insterts stubs then
even an offset from a nearby function could end up being wrong

> Anyway, I think we still need solution no.2.

I'll cook up a patch and run it by lkml to try to gauge the reaction.

James


