Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab0CARrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:47:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab0CARrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 12:47:47 -0500
Date: Mon, 1 Mar 2010 19:47:24 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, avi@redhat.com,
       mtosatti@redhat.com
Subject: Re: use of setjmp/longjmp in x86 emulator.
Message-ID: <20100301174724.GA12867@redhat.com>
References: <20100301091819.GD16909@redhat.com>
 <4B8BE7C1.40000@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8BE7C1.40000@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 06:13:53AM -1000, Zachary Amsden wrote:
> On 02/28/2010 11:18 PM, Gleb Natapov wrote:
> >I am looking at improving KVM x86 emulator. Current code does not
> >handle some special cases correctly (code execution from ROM, ins/outs
> >to/from MMIO) and many exception conditions during instruction emulation
> >are not handled correctly. There is a lot of code in emulator that is
> >there only for exception propagation. Using setjmp/longjmp will be very
> >beneficial here as exception condition during instruction execution
> >maps very naturally to setjmp/longjmp, so my question is what about
> >adding setjmp/longjmp implementation to the kernel, or alternatively,
> >if there is a fear that it can be abused, add it locally to emulator.c?
> >Note that instruction emulation is always done in process context.
> 
> I'm all for radical ideas, but from a pragmatic point of view, you
> shouldn't use longjmp in the kernel.  Seriously bad things are
> happening with it; it leaves local variables undefined, doesn't undo
> global state changes.
> 
> So if you:
> 
> spin_lock(&s->lock);
> if (!s->active)
>     longjmp(buf, -1);
> 
How is this different from goto that skips unlock? But in general I
agree with you and that is why I propose to implement local version of
setjmp/longjmp just for use inside emulator.c. The are no locks inside
this file, not even memory allocations only pure instruction emulation.

> ... you are broken.  This case can be made very much more complex
> and hard to reason about by using local variables which are reset by
> the longjmp.
> 
> Further, it requires use of the volatile keyword to interact
> properly with logic involving more than one variable, and thus, by
> definition is impossible to use in the kernel, which does not
> implement the volatile keyword.  :)
volatile is a language keyword how it can be not implemented by the
kernel? And why volatile is needed to implement longjmp?

> 
> Instead, for this case, use the fact that there is an
> architecturally designed finite number of exceptions that can be
> processed simultaneously.  This means if you queue exceptions to a
> pending list of control-flow interrupting events to be processed, as
> long as the queue is appropriately sized, you will never overflow
> this queue and never require dynamic allocation.  Further, you can
> then naturally follow the exception priority rules at the top-level
> of the emulator and never need to pass back complex exception
> structures, merely a simple return value which indicates whether to
> return to top-level control logic or continue with instruction
> emulation.  I believe using this style of programming will make your
> need for setjmp/longjmp go away.
> 
Of course it is possible to use return values instead. This is what code
does currently and this is completely unrelated to exception queue
depth. Code will be much simpler if we will be able to bail out from the
depth of emulator immediately if exception condition is met or exit to
userspace is required instead of passing the condition up the call
chain.

--
			Gleb.
