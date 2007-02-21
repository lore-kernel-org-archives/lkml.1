Return-Path: <linux-kernel-owner+w=401wt.eu-S1423127AbXBUVGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423127AbXBUVGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423118AbXBUVGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:06:16 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:46101 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423124AbXBUVGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:06:12 -0500
Date: Wed, 21 Feb 2007 13:06:06 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, ego@in.ibm.com, akpm@osdl.org,
       paulmck@us.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: freezer problems
Message-ID: <20070221210606.GH7063@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <200702201929.03776.rjw@sisk.pl> <20070221181404.GC7063@linux.vnet.ibm.com> <200702211913.41883.rjw@sisk.pl> <20070221200314.GA91@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221200314.GA91@tv-sign.ru>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 11:03:14PM +0300, Oleg Nesterov wrote:
> On 02/21, Rafael J. Wysocki wrote:
> >
> > On Wednesday, 21 February 2007 19:14, Paul E. McKenney wrote:
> > > On Tue, Feb 20, 2007 at 07:29:01PM +0100, Rafael J. Wysocki wrote:
> > > > On Tuesday, 20 February 2007 01:32, Rafael J. Wysocki wrote:
> > > > > On Tuesday, 20 February 2007 01:12, Oleg Nesterov wrote:
> > > > > Hm.  In the case discussed above we have a task that's right before calling
> > > > > frozen_process(), so we can't thaw it, because it's not frozen.  It will be
> > > > > frozen just in a while, but try_to_freeze_tasks() and thaw_tasks() have no
> > > > > way to check this.
> > > > > 
> > > > > I think to close this race the refrigerator should check TIF_FREEZE and set
> > > > > PF_FROZEN _and_ reset TIF_FREEZE under a lock
> 
> I personally think this is good. Not only this allows us to close the race,
> I think we can do more.
> 
> >                                                      that would also have to be
> > > > > taken by try_to_freeze_tasks() in the beginning of the error path.  This will
> > > > > ensure that all tasks either freeze themselves before the error path in
> > > > > try_to_freeze_tasks() is executed, or remain unfrozen.
> 
> How about take this lock in thaw_tasks() instead/too ?
> 
> Currently we need a separate loop in thaw_tasks() to handle PF_FREEZER_SKIP. This
> means that PF_FREEZER_SKIP is not so generic: thaw_tasks() can't tolerate if such
> a task was woken in between. What if we change thaw_process() to clear TIF_FREEZE ?
> 
> Note also that we can use task_lock() instead of global refrigerator_lock. This
> means that thaw_process() should take it too, probably this is slowdown, but I
> think not too much because thaw_process() is going to write to p->flags anyway.
> In this case thaw_process() works perfectly as cancel_freezing_and_thaw() and
> can be used to fix exec/coredump in future.

This sounds much better than a a global lock to me!  ;-)

							Thanx, Paul
