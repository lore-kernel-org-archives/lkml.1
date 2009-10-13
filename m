Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbZJMVOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbZJMVOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 17:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761181AbZJMVOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 17:14:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34845 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761169AbZJMVOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 17:14:45 -0400
Subject: Re: [PATCH 1/5] [PATCH 1/5] function-graph/x86: replace unbalanced
 ret with jmp
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
In-Reply-To: <20091013210208.GB5135@nowhere>
References: <20091013203349.814936710@goodmis.org>
	 <20091013203425.042034383@goodmis.org>  <20091013210208.GB5135@nowhere>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 13 Oct 2009 17:12:46 -0400
Message-Id: <1255468366.7113.2403.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 23:02 +0200, Frederic Weisbecker wrote:
> On Tue, Oct 13, 2009 at 04:33:50PM -0400, Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > The function graph tracer replaces the return address with a hook to
> > trace the exit of the function call. This hook will finish by returning
> > to the real location the function should return to.
> > 
> > But the current implementation uses a ret to jump to the real return
> > location. This causes a imbalance between calls and ret. That is
> > the original function does a call, the ret goes to the handler
> > and then the handler does a ret without a matching call.
> > 
> > Although the function graph tracer itself still breaks the branch
> > predictor by replacing the original ret, by using a second ret and
> > causing an imbalance, it breaks the predictor even more.
> 
> 
> 
> I have troubles to understand by it breaks the predictor, especially
> since there is not conditional branch in return_to_handler.
> But still I don't understand why a ret would break more the branch
> prediction than a jmp.

Calls are branch prediction jumps. Which associates the "ret" with the
call. As it approaches the ret, it starts to receive the code after the
call.

But this is stack order. Every call should hit one ret. But with the
original code, we break this stack. We have one call and two rets. Which
means that the branch prediction will also get messed up with the
previous stored call.

-- Steve


