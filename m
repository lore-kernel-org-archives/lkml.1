Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbZKSU2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbZKSU2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 15:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbZKSU2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 15:28:43 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:21479 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbZKSU2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 15:28:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HkTKr/qkWHcvstGqqtYvssBWHNLUoO+zJkArBlGgWhmLaegnJbMC6SZ4xM20sXxxLX
         gFzVTWxAK8bOKdIJ/PplFexHUfbz4YRGkmSw0DJnxVdAjSuTpv1T49CiW/rRT/Cv+zeb
         YanJfr81Dk19sQzUoCnmne7W8IVSj5szvu5KY=
Date: Thu, 19 Nov 2009 21:28:48 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
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
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
Message-ID: <20091119202845.GH4967@nowhere>
References: <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com> <4B058CCD.8050605@redhat.com> <alpine.LFD.2.00.0911191039470.2793@localhost.localdomain> <alpine.LFD.2.00.0911191041471.2793@localhost.localdomain> <alpine.LFD.2.00.0911191047350.2793@localhost.localdomain> <4B05982B.6060200@caviumnetworks.com> <1258658886.22249.874.camel@gandalf.stny.rr.com> <20091119194625.GE4967@nowhere> <1258661141.22249.962.camel@gandalf.stny.rr.com> <1258661836.22249.995.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258661836.22249.995.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 03:17:16PM -0500, Steven Rostedt wrote:
> On Thu, 2009-11-19 at 15:05 -0500, Steven Rostedt wrote:
> 
> > Well, other archs use a register to store the return address. But it
> > would also be easy to do (pseudo arch assembly):
> > 
> > 	<function>:
> > 		mov lr, (%sp)
> > 		add 8, %sp
> > 		blr __fentry__
> 
> Should be bl __fentry__ for "branch and link".
> 
> > 		sub 8, %sp
> > 		mov (%sp), lr
> > 
> > 
> > That way the lr would have the current function, and the parent would
> > still be at 8(%sp)
> 
> Actually, if we add a new profiler and can make our own specification, I
> would say that the add and sub lines be the responsibility of
> __fentry__. Then we would have:
> 
> 	<function>:
> 		mov lr, (%sp)
> 		bl __fentry__
> 		mov (%sp), lr
> 
> If sp points to the current content, then replace (%sp) above with 
> -8(%sp).  Then the implementation of a nop __fentry__ would simply be:
> 
> 	__fentry__:
> 		blr


Good point!

 
> For anything more elaborate, __fentry__ would be responsible for all
> adjustments.


Yep. The more we control it from __fentry__, the less we fall
down into unexpected surprises.

