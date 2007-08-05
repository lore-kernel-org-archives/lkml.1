Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbXHEC0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbXHEC0Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 22:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbXHEC0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 22:26:15 -0400
Received: from mail.ocs.com.au ([203.34.248.175]:16406 "EHLO mail.ocs.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbXHEC0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 22:26:14 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
From: Keith Owens <kaos@ocs.com.au>
To: ebiederm@xmission.com (Eric W. Biederman)
cc: vgoyal@in.ibm.com, Takenori Nagano <t-nagano@ah.jp.nec.com>,
       k-miyoshi@cb.jp.nec.com, Bernhard Walle <bwalle@suse.de>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Handling kernel stack overflows 
In-reply-to: Your message of "Fri, 03 Aug 2007 06:36:23 CST."
             <m11wekn6bc.fsf@ebiederm.dsl.xmission.com> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sun, 05 Aug 2007 12:25:11 +1000
Message-ID: <32465.1186280711@ocs10w.ocs.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman (on Fri, 03 Aug 2007 06:36:23 -0600) wrote:
>
>Well we currently keep a struct thread_info on the stack
>which while not as bad as task_struct has it's own uses
>and implications which may limit what you are trying
>to do.

Not an issue.  We already copy struct thread_info when switching stacks
on i386 with 4K stacks.  x86_64 always has multiple stacks, but uses
thread_info in the first stack, even on a stack switch.

>That said a function like:
>
>int call_on_new_stack(int (*continuation)(void *), void *closure)
>{
>	struct task_struct *tsk;
>	struct thread_info *ti;
>
>	if (plenty_of_stack_space())
>		return continuation(closure);
>
>	tsk = current();
>	ti = alloc_thread_info(tsk);
>	if (!ti)
>		return -ENOMEM;
>
>	setup_extra_thread_info(tsk, ti, continuation, closure);
>	schedule();
>}
>
>Might make sense.  Last I heard the block layer and xfs seemed
>to have largely solved their problems with running short on stack
>space, so I don't know if it is necessary but it certainly sounds
>relatively simple and interesting.

Solved for simple configurations.  But when you start nesting
flesystems, especially if a network filesystem is involved, then the
small amounts of stack used by each subsystem add up fast.

>Running short on stack space is a recurring theme so a function that
>allows us to have a little more when we really need it and be able to
>switch even x86_64 to 4K stacks would be interesting.

4K stacks on x86_64 are not a real option.  If i386 needs 4K then
x86_64 needs twice as much just to handle the doubling of pointers and
saved arguments.

>I'm not quite certain where we could insert calls to call_on_new_stack,

It has to be at a point that can return an error.  The best place is at
the start of the block and VFS layers, if those layers can detect that
they are about to do a nested call.  For example, crypto over loopback
over ext3 over NFS over software raid over SCSI.  The loopback, ext3
and NFS layers are nested filesystems calls, crypto is not.  The SCSI
layer is a nested block layer call, software raid is not.  So loopback,
ext3, NFS and SCSI would switch to a new stack if necessary.

>but it looks simple enough that it is worth coding up and playing
>with.

I have just resigned and will be taking a long break away from
computers.  Feel free to play with the idea, otherwise I will look at
it again sometime in October.

