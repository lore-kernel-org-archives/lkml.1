Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbYHODA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbYHODA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 23:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbYHODAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 23:00:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40083 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbYHODAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 23:00:49 -0400
Message-Id: <20080815024716.480118113@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 14 Aug 2008 22:47:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, srostedt@redhat.com
Subject: [PATCH 0/3] ftrace: handle kernel code remove
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dynamic ftrace feature keeps a table of all the places that call
mcount to either disable them (replacing them with nops) or to enable
them (calling some trace function).

This table of functions is also displayed to the user interface to let
users enable or disable specific functions. This allows users to only
trace some functions within the kernel.

When a module or init sections are removed, the pointers to their locations
still exist in this table.  To protect against faults and writing over
other text, fault handling and code comparing is done. When the code is
update, the code being replaced is calculated and compared to the actual
text that is being replaced, if the code does not match what is expected
to be there, the change is not made.

There is a very small chance that the wrong text (or perhaps a data section)
could match the call to mcount and an inappropriate modification could
be made.

This patch series adds ftrace_release, to allow a module to remove the
pointers to the mcount callers in the module from this table.

Also, __init has "notrace" added to it so that text in the init section
are not traced. The trace currently can not be enabled until after
init anyway, so this should not be a problem.

-- Steve

