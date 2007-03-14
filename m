Return-Path: <linux-kernel-owner+w=401wt.eu-S1030844AbXCNNgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030844AbXCNNgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 09:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbXCNNgC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 09:36:02 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46190 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbXCNNf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 09:35:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH 58/59] sysctl: Reimplement the sysctl proc support
References: <m1ac0jc4no.fsf@ebiederm.dsl.xmission.com>
	<11689657073389-git-send-email-ebiederm@xmission.com>
	<20070314103832.GA16104@elte.hu>
	<b6fcc0a0703140348o18a4b24fye3dcbad593cf83a5@mail.gmail.com>
	<20070314122453.GA5775@elte.hu>
Date: Wed, 14 Mar 2007 07:34:30 -0600
In-Reply-To: <20070314122453.GA5775@elte.hu> (Ingo Molnar's message of "Wed,
	14 Mar 2007 13:24:53 +0100")
Message-ID: <m1ejnsq789.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
>> On 3/14/07, Ingo Molnar <mingo@elte.hu> wrote:
>> > #define PROCNAME_PML    "sys/kernel/preempt_max_latency"
>> >
>> > static __init int latency_fs_init(void)
>> > {
>> >         struct proc_dir_entry *entry;
>> >
>> >         if (!(entry = create_proc_entry(PROCNAME_PML, 0644, NULL)))
>> >                 printk("latency_fs_init(): can't create %s\n",
>> >PROCNAME_PML);
>> >
>> > with your change that broke because beyond /proc/sys/ there are no 
>> > real proc entries anymore, there's no de->subdir directory for 
>> > xlate_proc_name() to find. While the latency tracer isnt upstream, 
>> > this change in semantics does not seem to be intended (the changelog 
>> > is certainly silent about it).
>> 
>> Use register_sysctl_table() for sysctls.
>
> yes - i just wanted to point out the incompatibility and subtle breakage 
> that this change caused. I'll now have to convert the current code over 
> to sysctl_table, which isnt that hard but not trivial either, and i 
> certainly could make use that time for other purposes.

Sorry, for the inconvenience.

However it has always been a bug for anything under /proc/sys to not
be a sysctl.   It's not subtle breakage but subtle enforcement of the
existing rules.

The fact that code that now tries to break the rules fails I see as an
unanticipated bonus, because it means someone won't have to  go back
through and fix it after the code has been merged.

As far as I can tell it was really only out of tree code that suffered
from the misconception that /proc/sys was for something other than
sysctls.  The only case I recall fixing in the kernel was the mount
point for binfmt_misc and that was just directories, and easy to
convert.

This is the second time someone with out of tree code has asked me
about it though.   It may be worth adding a test to create_proc_entry
that says "you silly person you need to use sysctls to create an entry
under /proc/sys"

Eric
