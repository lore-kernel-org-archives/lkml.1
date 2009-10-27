Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbZJ0RYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbZJ0RYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 13:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbZJ0RYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 13:24:43 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60353 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906AbZJ0RYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 13:24:43 -0400
To: Andi Kleen <andi@firstfloor.org>
Cc: john stultz <johnstul@us.ibm.com>, Arjan van de Ven <arjan@infradead.org>,
       Darren Hart <dvhltc@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Mike Fulton <fultonm@ca.ibm.com>
MIME-Version: 1.0
Subject: Fw: [RFC][PATCH] Add prctl to set sibling thread names
X-Mailer: Lotus Notes Release 7.0 HF242 April 21, 2006
From: Sean Foley <Sean_Foley@ca.ibm.com>
Message-ID: <OF813E29C8.8173912E-ON8525765C.005F2372-8525765C.005FA100@ca.ibm.com>
Date: Tue, 27 Oct 2009 13:24:33 -0400
X-MIMETrack: Serialize by Router on D25ML01/25/M/IBM(Release 8.0.1|February 07, 2008) at
 10/27/2009 13:24:46,
	Serialize complete at 10/27/2009 13:24:46
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

I can provide some details about a more specific use-case that arises from 
the java language and runtime environment.

In the java world, a given thread can be renamed at any time by any other 
thread, by calling a method on the receiver object that represents the 
thread.  This will give the thread a new name in java, and we'd like to 
make this work with Linux thread naming as well, so that the java thread 
names are visible from the various O/S utilities such as ps.

Using the existing prctl mechanism, java threads can assign their own 
names to themselves when they are started.  However, more generally, at 
any other time, in order to make the existing java thread name method call 
(callable by any thread in the java virtual machine) do the additional 
work of renaming the same thread in Linux, the process requires several 
steps:
1. The naming thread must asynchronously provide a notification to the 
named thread that a name change has occurred, and must store the name in a 
shared location
2. The named thread must be granted CPU time by the Linux scheduler
3. The named thread must poll for the notication, and must apply any 
assigned name change prior to doing what it would normally be doing

Some undesirable drawbacks of this include the async communication, the 
delay waiting for the named thread to get CPU time for the name change to 
occur, the polling activity in the named thread, and the delay in the 
named thread changing its own name prior to resuming its normal activity

Using the Java API, thread name changes can be completed without the 
involvement of the thread being named.  As John has described, java 
programmers can choose to have a single thread assign names to all others. 
  Programmers may choose to rename threads even when the threads being 
named are not being granted any CPU time.  Programmers may choose to 
rename threads in an ad-hoc manner.  We'd like to extend this naming 
activity to the Linux naming functionality without the drawbacks listed 
above.

Regards,
Sean Foley
J9 Real-Time Java Ottawa Technical Lead
Sean_Foley@ca.ibm.com (613)356-5012

john stultz <johnstul@us.ibm.com> wrote on 10/26/2009 07:56:20 PM:

> On Sat, 2009-10-24 at 05:54 +0200, Andi Kleen wrote:
> > On Wed, Oct 21, 2009 at 07:48:22PM -0700, Arjan van de Ven wrote:
> > > On Thu, 22 Oct 2009 02:49:19 +0200
> > > Andi Kleen <andi@firstfloor.org> wrote:
> > > 
> > > > > you're pretty much the first now who touches ->comm from
> > > > > not-the-thread-itself.... are you sure that is safe?
> > > > 
> > > > It's not, there is no locking. On the other hand nothing should 
crash,
> > > > just users might see half rewritten data.
> > > 
> > > .. with strings this is tricky though.. if the new string is longer
> > > than the old one the terminating zero might just be missed etc.
> > 
> > Good point.
> > He needs to first set the last byte to zero to avoid that.
> > But better probably to do a proper lock on all readers. Or not add
> > this feature at all (does it have a strong use case?)
> 
> Thread naming is really helpful for debugging a large multi-threaded
> application. But currently it requires the threads to name themselves. 
> 
> In some applications there may be a dispatch thread that spawns off the
> siblings, and it has more context for naming the threads then the
> threads do themselves.
> 
> So in that case, currently in order to have named threads, the
> application's dispatch thread assigns names, and the threads have to
> occasionally poll to see if they need to name themselves to something.
> 
> So they can get it to work, but its ugly and a big pain. Other OSes
> support pthread_set_name_np() functionality, which makes things easy for
> them, so they've requested to see if Linux can't do something similar.
> 
> thanks
> -john
> 

