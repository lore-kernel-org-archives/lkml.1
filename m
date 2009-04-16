Return-Path: <linux-kernel-owner+w=401wt.eu-S1753781AbZDPCud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbZDPCud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 22:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbZDPCuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 22:50:24 -0400
Received: from gw.goop.org ([64.81.55.164]:57867 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbZDPCuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 22:50:23 -0400
Message-ID: <49E69CED.9050706@goop.org>
Date: Wed, 15 Apr 2009 19:50:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Problem with CREATE_TRACE_POINTS and recursion safety
References: <49E67D1D.8020704@goop.org> <alpine.DEB.2.00.0904152042350.4459@gandalf.stny.rr.com> <49E6847B.9000003@goop.org> <alpine.DEB.2.00.0904152201390.4459@gandalf.stny.rr.com> <20090416022305.GA22378@Krystal>
In-Reply-To: <20090416022305.GA22378@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Jeremy brings up an interesting point. Given that we might eventually
> include a few tracepoint header files in a given C file, but with the
> intent of only "creating" the tracepoint callbacks for few of these, the
> global "CREATE_TRACE_POINTS" flag makes little sense and seems like it
> will easily lead to link-time errors.
>   

Yes, that's what I'm seeing.

> Maybe we could consider requiring something like the following solution :
>
> In the .c file :
>
> #define CREATE_TRACE_POINTS
> #include <trace/subsysa.h>
> #undef CREATE_TRACE_POINTS
>
> #include <trace/subsysb.h>
>
> Where subsysa has its trace points callbacks created, but subsysb
> doesn't. This seems half-way understandable, at least.

But what if trace/subsysa.h includes some other headers to define some 
types it needs, which in turn ends up incidentally including 
trace/subsysc.h (either directly, or indirectly via any number of other 
headers?  Then it will end up instantiating tracepoints for subsysa and 
subsysc.  The only way to avoid it would be to impose an absolutely 
strict separation of type/constant definition headers from 
function/tracepoint ones.

    J
