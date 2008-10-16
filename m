Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbYJPPTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbYJPPTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 11:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbYJPPSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 11:18:55 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59323 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbYJPPSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 11:18:53 -0400
Date: Thu, 16 Oct 2008 08:10:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, serue@us.ibm.com,
       sds@tycho.nsa.gov, jmorris@namei.org, chrisw@sous-sol.org,
       dhowells@redhat.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, haradats@nttdata.co.jp,
       akpm@linux-foundation.org
Subject: Re: [TOMOYO #10 (linux-next) 7/8] File operation restriction part.
Message-ID: <20081016151003.GA6772@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081009042814.398846861@nttdata.co.jp> <20081009042922.939610141@nttdata.co.jp> <20081009164836.GA5480@us.ibm.com> <200810120909.GDF95392.SQOFFFHVtOMOJL@I-love.SAKURA.ne.jp> <20081015012916.GF6874@linux.vnet.ibm.com> <48F6BD8E.4050402@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F6BD8E.4050402@nttdata.co.jp>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 01:05:34PM +0900, Kentaro Takeda wrote:
> Paul E. McKenney wrote:
> > A few comments below -- some rcu_dereference()s are needed.
>
> This list doesn't use RCU since it is for Write-Once-Read-Many 
> situation (i.e. no-update and no-delete). TOMOYO Linux uses this list 
> for storing policy elements. Most of elements are allocated when the 
> kernel is loaded, and they are referred during lifetime of the kernel.
> 
> Since read_lock is not needed when referring this list, code of 
> TOMOYO keeps its simplicity. If TOMOYO used RCU or reader/writer lock,
> the code would be a jumble of read_lock and it would be almost 
> impossible to maintain and review the code... X-p This is the reason 
> why TOMOYO uses this WORM list.
> 
> Though size of policy increases with learning mode, the same 
> pathnames once learned will be reused. So memory usage of TOMOYO 
> doesn't increase infinitely; if still worried, we can set memory 
> quota.
> 
> > The general idea looks sound, at least as long as the lists remain
> > short.  Otherwise, the list scan in list1_add_tail_mb() will take
> > too long.
>
> Typically less than 100. The length of list won't matter since the 
> frequency of append is very low.

That sounds small enough to me.  If it becomes a problem some time in
the future, it will be easy for you to add a tail pointer or some such.

> Paul, would you review this list from the perspective of WORM list?

Hmmm...  I thought I was reviewing it from that perspective.  You never
delete anything from the list, so you don't need RCU.

But fair enough.  How about the following?

	#define worm_dereference()	rcu_dereference()
	#define worm_assign_pointer()	rcu_assign_pointer()

Then put worm_dereference() where I told you to put rcu_dereference()
and also put worm_assign_pointer() where I suggested using
rcu_assign_pointer().

You might not be using RCU, but keep in mind that RCU is primarily about
-removing- items from a data structure.  When you -insert- items into
a data structure that is being concurrently read, as you are doing, you
must solve all the same problems that RCU has to solve for list insertion.
Please see http://lkml.org/lkml/2008/2/2/255 for examples showing why
this is needed.  This posting does indeed use RCU terminology, but it is
focused only on insertion, and therefore exactly describes the situation
that you are in.

I am sure that you will get back to me with any questions or objections
that you might have after looking this over.  ;-)

							Thanx, Paul
