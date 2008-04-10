Return-Path: <linux-kernel-owner+w=401wt.eu-S1759052AbYDJRiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052AbYDJRiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 13:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756765AbYDJRii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 13:38:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756735AbYDJRih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 13:38:37 -0400
Date: Thu, 10 Apr 2008 10:36:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Jan Beulich <jbeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>,
       pinskia@gcc.gnu.org
Subject: Re: [PATCH] pop previous section in alternative.c
In-Reply-To: <47FE493C.2010709@zytor.com>
Message-ID: <alpine.LFD.1.00.0804101031421.3143@woody.linux-foundation.org>
References: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com> <Pine.LNX.4.58.0804091906040.31970@gandalf.stny.rr.com> <47FD5D42.5000603@zytor.com> <87wsn6m6zt.fsf@basil.nowhere.org> <20080410094637.GW17915@shadowen.org> <Pine.LNX.4.58.0804101007510.5673@gandalf.stny.rr.com>
 <20080410144114.GH10019@one.firstfloor.org> <alpine.LFD.1.00.0804100741430.3143@woody.linux-foundation.org> <20080410150544.GI10019@one.firstfloor.org> <alpine.LFD.1.00.0804100811400.3143@woody.linux-foundation.org> <47FE3B24.4020301@zytor.com>
 <Pine.LNX.4.58.0804101219170.7952@gandalf.stny.rr.com> <47FE493C.2010709@zytor.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Apr 2008, H. Peter Anvin wrote:

> Steven Rostedt wrote:
> > 
> > Looking at the output below, shows that testing .sections in between
> > #APP and #NO_APP would in fact catch this bug.
> > 
> 
> Of course, The Right Thing[TM] would be for gcc to emit .pushsection ...
> .popsection around #APP ... #NO_APP.

No, that would not help anything. It would still be open to bugs in the 
asm, ie if there was a unpaired "pushsection" there, making gcc emit the 
section directives around it would just cause a _different_ bug.

So I don't think gcc does the wrong thing per se. It was clearly a bug in 
our inline asm, and the blame is solidly on us. 

Obviously, it would have been really nice if something like the assembler 
had caught it with some simple sanity-test (ie I think the .size thing 
would be a good sanity check _regardless_), so in that sense it's our bug 
that might have been avoided with soem sanity testing, but on the other 
hand, I can well understand that gas didn't do it - since it would matter 
only for totally buggy code that was never emitted by the compiler.

Gas historically used to not do any sanity-checking what-so-ever, and was 
very much meant to be just for compiler output (which is why #APP exists 
in the first place - to mark places that aren't pure compiler input). It's 
actually improved immensely in that area and now is useful as a 
traditional human-usable assembler with lots of support like macros etc.

			Linus
