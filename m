Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbYIJFzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbYIJFzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 01:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYIJFzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 01:55:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbYIJFzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 01:55:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "Luming Yu" <luming.yu@gmail.com>
X-Fcc: ~/Mail/linus
Cc: "Petr Tesarik" <ptesarik@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
Subject: Re: [RFC PATCH] set TASK_TRACED before arch_ptrace code to fix a race
In-Reply-To: Luming Yu's message of  Tuesday, 9 September 2008 11:06:27 +0800 <3877989d0809082006v496bae4i1c0736f5d55e9b9f@mail.gmail.com>
References: <3877989d0805211947i54bacc7cv619541e9b40824fb@mail.gmail.com>
	<1211869515.29836.2.camel@elijah.suse.cz>
	<3877989d0806022304w35764b17p9d4c3c95eceae0f5@mail.gmail.com>
	<48450864.6080707@suse.cz>
	<48455619.6040608@suse.cz>
	<3877989d0806031916wf11bb2t3847aa630fb39e60@mail.gmail.com>
	<48465D5C.8000804@suse.cz>
	<3877989d0806041849vb903aaw221de929e2ab8cb9@mail.gmail.com>
	<1212664605.15747.16.camel@elijah.suse.cz>
	<20080627204954.34F8B154231@magilla.localdomain>
	<3877989d0809082006v496bae4i1c0736f5d55e9b9f@mail.gmail.com>
X-Shopping-List: (1) Gaelic Expectant putty impositions
   (2) River-toweling Ritz Cracker Crumbs
   (3) Inefficient sleeves
Message-Id: <20080910055504.9A2A41541FE@magilla.localdomain>
Date: Tue,  9 Sep 2008 22:55:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This subject line is quite far from what you're now addressing, btw.

I certainly wouldn't recommend that patch.  The interference between ptrace
uses of SIGTRAP and a program that blocks SIGTRAP is just a fact of life
with ptrace.  If you wanted to change the exec SIGTRAP to be more
consistent with other signals induced by debuggers (such as breakpoints and
single-step), you could just change send_sig to force_sig.  That unblocks
SIGTRAP and resets its handler when it's blocked.  Conversely, a tracer
program could use PTRACE_O_TRACEEXEC if it cared to deal with tracing a
process that blocks SIGTRAP.  (That uses ptrace_notify rather than any
actual signal that can be blocked.)

But, none of this goes to your actual problem at all AFAICT.  You've said
your actual problem with strace only arises on ia64.  The behavior of
ptrace'd exec, and the effect of a program blocking SIGTRAP, is exactly the
same across all machines.  Changing it does not explain your situation.
I'm in favor of understanding what is actually going on before changing
things.

If the SIGTRAP from exec is actually seen by strace on a different machine
like it's not on ia64, that suggests that something different happened
between the two.  In the case that doesn't exhibit the problem, either
SIGTRAP got unblocked by something before the exec, or userland (strace)
behaves differently so that it doesn't care about not seeing that SIGTRAP.


Thanks,
Roland
