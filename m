Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbYHAQhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbYHAQhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 12:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYHAQhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 12:37:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38350 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbYHAQhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 12:37:39 -0400
Message-Id: <20080801162639.175407419@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 01 Aug 2008 12:26:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 0/2] ftrace: printk formatted recording
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I previously sent out a patch to add printk formatted recording to the ftrace
buffers.  Andrew Morton suggested to get rid of my hacked trace_cont structure
and do it properly with one structure at the top and two other structures
to handle the difference between the fields and the continuation entry.

That is to have a top entry:

struct trace_entry {
	char type;
	union {
		struct trace_field field;
		struct trace_cont  cont;
	};
};

instead of having a separate trace_cont that was outside the trace_entry
and would be typecasted when used. This would be a source of bugs with
later modifications of the ftrace code if a developer did not relize
the connection between trace_entry and trace_cont. Using this proper
method keeps the two tighly coupled for new developers to see.

Unfortunatly, doing it the proper way caused a large code change since
now all the users of trace_entry (and there are many) must now dereference
the field item.

The first patch just does the struct update and changes all the users
to do the dereferencing properly.

The second patch in this series adds the user of the trace_cont, which
is the ftrace_printk.

Note: I can no longer use the unspecified array size buf[] because gcc
complains about:

struct trace_cont {
	buf[];
};

I now use buf[sizeof(struct trace_field)]  which I think is a better solution
anyways.

-- Steve

