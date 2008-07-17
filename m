Return-Path: <linux-kernel-owner+w=401wt.eu-S933456AbYGQVic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456AbYGQVic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933350AbYGQViL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:38:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932942AbYGQViJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:38:09 -0400
Message-ID: <487FBB56.4070709@redhat.com>
Date: Thu, 17 Jul 2008 17:36:22 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs
 (part1: use kprobe symbol_name/offset instead of address)
References: <1216146802.3312.95.camel@localhost.localdomain>	 <487E78ED.30804@redhat.com>	 <1216249383.3358.69.camel@localhost.localdomain>	 <487E8CE4.70105@redhat.com>	 <1216259391.3358.85.camel@localhost.localdomain>	 <1216304290.5515.11.camel@localhost.localdomain> <1216313914.5515.25.camel@localhost.localdomain>
In-Reply-To: <1216313914.5515.25.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Thu, 2008-07-17 at 09:18 -0500, James Bottomley wrote:
>> OK, thought about it.  There seem to be two possible solutions
>>
>>      1. Get systemtap always to offset from non-static functions.  This
>>         will use the standard linker to ensure uniqueness (a module
>>         qualifier will still need to be added to the struct kprobe for
>>         lookup, since modules can duplicate unexported kernel symbols).
>>      2. Add the filename as a discriminator for duplicate symbols in the
>>         kallsyms program (would still need module qualifier).  This is
>>         appealing because the path name would be printed in the kernel
>>         trace to help with oops tracking
>>
>> This is where negotiations come in.  To me 2. looks to be better because
>> it will help us with oops tracking.  On the other hand, it's usually
>> pretty obvious from the stack trace context which files the duplicate
>> symbols are actually in; what do other people think?
> 
> Just by way of illustration, this is systemtap fixed up according to
> suggestion number 1.  You can see now using your test case that we get:
> 
> # probes
> kernel.function("do_open@fs/block_dev.c:929") /* pc=<lookup_bdev+0x90> */ /* <- kernel.function("do_open") */
> kernel.function("do_open@fs/nfsctl.c:24") /* pc=<sys_nfsservctl+0x6a> */ /* <- kernel.function("do_open") */
> kernel.function("do_open@ipc/mqueue.c:642") /* pc=<sys_mq_unlink+0x130> */ /* <- kernel.function("do_open") */

Hi James,

Thank you for updating the patch.
Unfortunately, I found another scenario; if someone make a module which
has EXPORT_SYMBOL(do_open), it's a non-static function. but there are
other static version do_open in kallsyms.
Here, I tested it and got below;

$ stap --kelf -e 'probe module("test").function("do_open"){}' -p2
# probes
module("test").function("do_open@?") /* pc=<do_open+0x0> */ /* <- module("test").function("do_open") */

And I think similar issue will occur even if it is embedded in vmlinux.

By the way, can this patch solve the issue of -ffunction-sections?

Anyway, I think we still need solution no.2.


Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

