Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab0CATDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:03:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab0CATDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:03:50 -0500
Date: Mon, 1 Mar 2010 21:03:41 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, avi@redhat.com,
       mtosatti@redhat.com
Subject: Re: use of setjmp/longjmp in x86 emulator.
Message-ID: <20100301190341.GD12867@redhat.com>
References: <20100301091819.GD16909@redhat.com>
 <4B8BE7C1.40000@redhat.com>
 <20100301174724.GA12867@redhat.com>
 <4B8C09F5.9070506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8C09F5.9070506@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 08:39:49AM -1000, Zachary Amsden wrote:
> On 03/01/2010 07:47 AM, Gleb Natapov wrote:
> >On Mon, Mar 01, 2010 at 06:13:53AM -1000, Zachary Amsden wrote:
> >
> >>... you are broken.  This case can be made very much more complex
> >>and hard to reason about by using local variables which are reset by
> >>the longjmp.
> >>
> >>Further, it requires use of the volatile keyword to interact
> >>properly with logic involving more than one variable, and thus, by
> >>definition is impossible to use in the kernel, which does not
> >>implement the volatile keyword.  :)
> >volatile is a language keyword how it can be not implemented by the
> >kernel? And why volatile is needed to implement longjmp?
> 
> Local variables which are not volatile are "undefined" after a
> longjmp.  Thus setjmp() return value is the only valid rvalue
> otherwise.
> 
That is nothing special. This is how setjmp/longjmp works. If a
nonvolatile automatic variable local to the function in which
setjmp is called is changed between the setjmp and longjmp calls,
its state is indeterminate after the longjmp.

In practice return value from setjmp is all I need.

> As I said, the kernel does not implement the volatile keyword :)
> (i.e. its use is heavily discouraged to the point one can consider
> it not implemented)
> 
> >>Instead, for this case, use the fact that there is an
> >>architecturally designed finite number of exceptions that can be
> >>processed simultaneously.  This means if you queue exceptions to a
> >>pending list of control-flow interrupting events to be processed, as
> >>long as the queue is appropriately sized, you will never overflow
> >>this queue and never require dynamic allocation.  Further, you can
> >>then naturally follow the exception priority rules at the top-level
> >>of the emulator and never need to pass back complex exception
> >>structures, merely a simple return value which indicates whether to
> >>return to top-level control logic or continue with instruction
> >>emulation.  I believe using this style of programming will make your
> >>need for setjmp/longjmp go away.
> >>
> >Of course it is possible to use return values instead. This is what code
> >does currently and this is completely unrelated to exception queue
> >depth. Code will be much simpler if we will be able to bail out from the
> >depth of emulator immediately if exception condition is met or exit to
> >userspace is required instead of passing the condition up the call
> >chain.
> 
> Anything that can generate exceptions is going to need logic to
> handle error cases anyway... the depth can not be that bad.
> Especially if you structure it so as to optimize for tail calling.
> 
Tail call is not what usually happens. Usually emulation goes like this:
 if (check some conditions) {
	queue exception A
        return exception queued
 }
 if (check other conditions) {
	queue exception B
        return exception queued
 }
 do some emulation
 try to read guest memory
 if (read failed) {
    queue exception C
    return exception queued
 }
 if (read needs exit to userspace for device emulation)
    return please go out and retrieve me the data

 continue emulation
 try to write guest memory
 if (write failed) {
    queue exception C
    return exception queued
 }
 if (write needs exit to userspace for device emulation)
    return please go out and process the data

 emulate some more.

 return emulation done

--
			Gleb.
