Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbZKSURM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbZKSURM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 15:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbZKSURM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 15:17:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59607 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbZKSURL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 15:17:11 -0500
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Daney <ddaney@caviumnetworks.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Haley <aph@redhat.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
In-Reply-To: <1258661141.22249.962.camel@gandalf.stny.rr.com>
References: <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911190934070.2793@localhost.localdomain>
	 <1258653562.22249.682.camel@gandalf.stny.rr.com>
	 <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com>
	 <4B058CCD.8050605@redhat.com>
	 <alpine.LFD.2.00.0911191039470.2793@localhost.localdomain>
	 <alpine.LFD.2.00.0911191041471.2793@localhost.localdomain>
	 <alpine.LFD.2.00.0911191047350.2793@localhost.localdomain>
	 <4B05982B.6060200@caviumnetworks.com>
	 <1258658886.22249.874.camel@gandalf.stny.rr.com>
	 <20091119194625.GE4967@nowhere>
	 <1258661141.22249.962.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 19 Nov 2009 15:17:16 -0500
Message-Id: <1258661836.22249.995.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-19 at 15:05 -0500, Steven Rostedt wrote:

> Well, other archs use a register to store the return address. But it
> would also be easy to do (pseudo arch assembly):
> 
> 	<function>:
> 		mov lr, (%sp)
> 		add 8, %sp
> 		blr __fentry__

Should be bl __fentry__ for "branch and link".

> 		sub 8, %sp
> 		mov (%sp), lr
> 
> 
> That way the lr would have the current function, and the parent would
> still be at 8(%sp)

Actually, if we add a new profiler and can make our own specification, I
would say that the add and sub lines be the responsibility of
__fentry__. Then we would have:

	<function>:
		mov lr, (%sp)
		bl __fentry__
		mov (%sp), lr

If sp points to the current content, then replace (%sp) above with 
-8(%sp).  Then the implementation of a nop __fentry__ would simply be:

	__fentry__:
		blr

For anything more elaborate, __fentry__ would be responsible for all
adjustments.

-- Steve


