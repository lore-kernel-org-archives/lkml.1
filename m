Return-Path: <linux-kernel-owner+w=401wt.eu-S1751788AbZJAEua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbZJAEua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 00:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbZJAEu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 00:50:29 -0400
Received: from ozlabs.org ([203.10.76.45]:53548 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbZJAEu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 00:50:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19140.13582.223629.56214@cargo.ozlabs.ibm.com>
Date: Thu, 1 Oct 2009 14:50:22 +1000
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Possible bug in ftrace_profile_enable_event
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was looking through kernel/trace/trace_event_profile.c and I saw
this code:

static int ftrace_profile_enable_event(struct ftrace_event_call *event)
{
	char *buf;
	int ret = -ENOMEM;

	if (atomic_inc_return(&event->profile_count))
		return 0;

	if (!total_profile_count++) {
		buf = (char *)alloc_percpu(profile_buf_t);
		if (!buf)
			goto fail_buf;

		rcu_assign_pointer(trace_profile_buf, buf);

		buf = (char *)alloc_percpu(profile_buf_t);
		if (!buf)
			goto fail_buf_nmi;

		rcu_assign_pointer(trace_profile_buf_nmi, buf);
	}

	ret = event->profile_enable();
	if (!ret)
		return 0;

	kfree(trace_profile_buf_nmi);
fail_buf_nmi:
	kfree(trace_profile_buf);
fail_buf:
	total_profile_count--;

...

So we only allocate trace_profile_buf and trace_profile_buf_nmi if
total_profile_count was zero on entry, but if we get an error returned
from event->profile_enable(), we free them both unconditionally,
regardless of the value of total_profile_count.  That seems wrong.  Is
there a subtle reason why that is the right thing to do?

(Also, is kfree the appropriate counterpart to alloc_percpu?)

Paul.
