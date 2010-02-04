Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458Ab0BDU4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:56:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932488Ab0BDUz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:55:59 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Lu, Hongjiu" <hongjiu.lu@intel.com>,
       "Lachner, Peter" <peter.lachner@intel.com>
Subject: Re: [patch] x86: ptrace and core-dump extensions for xstate
In-Reply-To: Suresh Siddha's message of  Thursday, 4 February 2010 12:28:49 -0800 <1265315329.2768.167.camel@sbs-t61.sc.intel.com>
References: <1265076025.2802.194.camel@sbs-t61.sc.intel.com>
	<20100203230817.E6529AA@magilla.sf.frob.com>
	<1265315329.2768.167.camel@sbs-t61.sc.intel.com>
Emacs: featuring the world's first municipal garbage collector!
Message-Id: <20100204205543.E1D11E7@magilla.sf.frob.com>
Date: Thu,  4 Feb 2010 12:55:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sure. Let's come to the agreement on the ABI changes and then I can
> split the patches accordingly.

The main point of splitting the patch is that the two new ABI components
are quite separate and the former need not wait for the latter.  There is
no real question about the regset format, so (with fixes) you can send the
first patch now and we'll all sign off on it.  Only the ptrace addition
really remains to be hashed out.

> > There are some obvious typos in that comment.  Please fix those up.
> 
> Can you please elaborate?

Just proofread it.  I really did mean "obvious typos", i.e. spelling,
whitespace, punctuation, nothing more.

> This issue is not new and gets handled in the same way as for existing
> fxsave/fxrstor, as they don't specify page alignment restrictions.

I didn't suggest it was new.  I was looking for some confirmation that
there is in fact no permanent (i.e. compile-time) size limit.

> Ok. I would like to enforce that "addr == xstate_size", so that we don't
> have to complicate the kernel implementation in trying to interpret what
> state the user knows based on the size passed by the user etc. 

I don't think this is the right way to think about it.  The regset code
does not need to do anything different at all.  There will in future be
other callers of the regset hooks, that's what the whole interface is there
for.  Regardless of whether modification is full or partial, you just
enforce the various bitmasks on the resultant buffer as you already do, and
that's all there is to it.  If userland stores partial contents with a
bogus format, that's its problem.  It's just like the program itself had
used xrstor in user mode with the same bogus buffer contents.

> User should use cpuid to get the size of the xstate buffer supported by
> the OS and processor.

They can if they want.  But they can also just use a smaller size that
corresponds to the bitmasks they set in the buffer they pass in.

> Kernel can check and throw an error with out silently corrupting the user
> who is not following the requirements.

ptrace is simply giving you a way to edit the buffer passed to xrstor.  You
can put garbage there via ptrace just like you can put garbage there with a
direct xrstor instruction in user mode.  This is no different from all
other ptrace register access, and there is no reason to enforce anything
special about it.

> We probably have to extend regset infrastructure to track which NT_*
> types are part of PTRACE_[GET|SET]REGSET and which are not.

I don't understand what you mean.  The point of the generic requests is
that they apply to any user_regset you want.  user_regset does not need
anything new.

> Also, I am not sure if pushing the ptrace interpretation of the user
> pointer into the regset routines is a good idea. 

I don't understand what you mean here at all.  I did not suggest anything
that affects what the regset routines themselves do in any way at all.

It is an unacceptably bad idea to have any new ptrace interfaces for regset
access that do anything different than exactly let you get/set all or part
of a regset exactly as the arch's user_regset provides it.


Thanks,
Roland
