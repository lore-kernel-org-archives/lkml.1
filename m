Return-Path: <linux-kernel-owner+w=401wt.eu-S1761339AbXHCMjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761339AbXHCMjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 08:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbXHCMjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 08:39:18 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53818 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbXHCMjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 08:39:17 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Keith Owens <kaos@ocs.com.au>
Cc: vgoyal@in.ibm.com, Takenori Nagano <t-nagano@ah.jp.nec.com>,
       k-miyoshi@cb.jp.nec.com, Bernhard Walle <bwalle@suse.de>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Handling kernel stack overflows
References: <31700.1186113953@kao2.melbourne.sgi.com>
Date: Fri, 03 Aug 2007 06:36:23 -0600
In-Reply-To: <31700.1186113953@kao2.melbourne.sgi.com> (Keith Owens's message
	of "Fri, 03 Aug 2007 14:05:53 +1000")
Message-ID: <m11wekn6bc.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Well we currently keep a struct thread_info on the stack
which while not as bad as task_struct has it's own uses
and implications which may limit what you are trying
to do.

That said a function like:

int call_on_new_stack(int (*continuation)(void *), void *closure)
{
	struct task_struct *tsk;
	struct thread_info *ti;

	if (plenty_of_stack_space())
		return continuation(closure);

	tsk = current();
	ti = alloc_thread_info(tsk);
	if (!ti)
		return -ENOMEM;

	setup_extra_thread_info(tsk, ti, continuation, closure);
	schedule();
}

Might make sense.  Last I heard the block layer and xfs seemed
to have largely solved their problems with running short on stack
space, so I don't know if it is necessary but it certainly sounds
relatively simple and interesting.

Running short on stack space is a recurring theme so a function that
allows us to have a little more when we really need it and be able to
switch even x86_64 to 4K stacks would be interesting.

I'm not quite certain where we could insert calls to call_on_new_stack,
but it looks simple enough that it is worth coding up and playing
with.  If the results are good it could be worth merging.

Eric
