Return-Path: <linux-kernel-owner+w=401wt.eu-S1765385AbXGLOtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765385AbXGLOtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 10:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbXGLOtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 10:49:33 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50042 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087AbXGLOtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 10:49:32 -0400
Date: Thu, 12 Jul 2007 07:49:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, akpm@linux-foundation.org
Subject: Re: [PATCH] Immunize rcu_dereference() against crazy compiler writers
Message-ID: <20070712144930.GA11980@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070712010058.GA30869@linux.vnet.ibm.com> <p73hco9yb14.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73hco9yb14.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 04:03:19PM +0200, Andi Kleen wrote:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> 
> > Turns out that compiler writers are a bit more aggressive about optimizing
> > than one might expect.  This patch prevents a number of such optimizations
> > from messing up rcu_deference().  This is not merely a theoretical
> > problem, as evidenced by the rmb() in mce_log().
> 
> Don't think that's an improvement. rmb() at least is known to work
> reliable to prevent such reordering. Memory barriers are well
> documented in the gcc documentation. Who knows about volatile?  The
> volatile semantics have been traditionally unclear and shakey.
> The C standard doesn't make much guarantees and i don't think 
> gcc does either.

Hello, Andi!

The rcu_dereference() primitive does not need many guarantees, and
the ones that it does need are well within those specified in the
C standard.

As I understand it, the compiler is not permitted to move volatile
accesses past "sequence points".  Sequence points include ends of
expression statements; control expressions in "if", "switch", "while",
and "do" statements; each of the three control expressions in the
"for" statement; return statement expressions; and initializers.

See http://www.open-std.org/jtc1/sc22/wg14/www/C99RationaleV5.10.pdf
(PDF page 24, virtual page 18) or any of a number of C texts.

So if gcc adheres to C99, the fetch implied by the new version of
rcu_dereference() in mce_log() must be emitted at the beginning
of the outermost "for (;;)" loop.

Now it might be that mce_log() also needs the rmb() in order to force the
-CPU- to actually -execute- the fetch in order -- and if that is the case,
I will happy to update the patch to leave the rmb() but to update the
comment, which currently only talks about the compiler messing things up:

	"The rmb forces the compiler to reload next in each interation"

However, my quick look through the code convinced me that if
rcu_dereference() was guaranteed to force the compiler to emit the load at
the top of the loop, that reorderings by the CPU were harmless given the
other barriers in that function.  But I might well have missed something.

> If anything you might want to embedd rmb(); in a statement expression
> in rcu_deference instead.

No way am I putting an rmb() or even an smp_rmb(), into rcu_dereference()!!!

							Thanx, Paul
