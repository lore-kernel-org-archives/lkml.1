Return-Path: <linux-kernel-owner+w=401wt.eu-S1030455AbXCLP6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030455AbXCLP6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 11:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030468AbXCLP6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 11:58:34 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49786 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030455AbXCLP6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 11:58:33 -0400
Date: Mon, 12 Mar 2007 10:56:43 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Paul Menage <menage@google.com>, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, sam@vilain.net, dev@sw.ru, xemul@sw.ru,
       pj@sgi.com, ebiederm@xmission.com, winget@google.com,
       containers@lists.osdl.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070312155643.GA12893@sergelap.austin.ibm.com>
References: <20070301133543.GK15509@in.ibm.com> <6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com> <20070307173031.GC2336@in.ibm.com> <20070307174346.GA19521@sergelap.austin.ibm.com> <20070307180055.GC17151@in.ibm.com> <20070307205846.GB7010@sergelap.austin.ibm.com> <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com> <20070309163430.GN6504@in.ibm.com> <6599ad830703091409s3d233829gb8f0afbfd2883b15@mail.gmail.com> <20070312150756.GB24742@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312150756.GB24742@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Srivatsa Vaddagiri (vatsa@in.ibm.com):
> On Fri, Mar 09, 2007 at 02:09:35PM -0800, Paul Menage wrote:
> > > 3. This next leads me to think that 'tasks' file in each directory doesnt make
> > >    sense for containers. In fact it can lend itself to error situations (by
> > >    administrator/script mistake) when some tasks of a container are in one
> > >    resource class while others are in a different class.
> > >
> > >         Instead, from a containers pov, it may be usefull to write
> > >         a 'container id' (if such a thing exists) into the tasks file
> > >         which will move all the tasks of the container into
> > >         the new resource class. This is the same requirement we
> > >         discussed long back of moving all threads of a process into new
> > >         resource class.
> > 
> > I think you need to give a more concrete example and use case of what
> > you're trying to propose here. I don't really see what advantage
> > you're getting.
> 
> Ok, this is what I had in mind:
> 
> 
> 	mount -t container -o ns /dev/namespace
> 	mount -t container -o cpu /dev/cpu
> 
> Lets we have the namespaces/resource-groups created as under:
> 
> 	/dev/namespace
> 		    |-- prof
> 		    |	 |- tasks <- (T1, T2)
> 		    |    |- container_id <- 1 (doesnt exist today perhaps)
> 		    |
> 		    |-- student
> 		    |    |- tasks <- (T3, T4)
> 		    |    |- container_id <- 2 (doesnt exist today perhaps)
> 
> 	/dev/cpu
> 	       |-- prof
> 	       |    |-- tasks
> 	       |    |-- cpu_limit (40%)
> 	       |
> 	       |-- student
> 	       |    |-- tasks
> 	       |    |-- cpu_limit (20%)
> 	       |
> 	       |
> 
> 
> Is it possible to create the above structure in container patches? 
> /me thinks so.
> 
> If so, then accidentally someone can do this:
> 
> 	echo T1 > /dev/cpu/prof/tasks
> 	echo T2 > /dev/cpu/student/tasks
> 
> with the result that tasks of the same container are now in different
> resource classes.

What's wrong with that?

> Thats why in case of containers I felt we shldnt allow individual tasks
> to be cat'ed to tasks file. 
> 
> Or rather, it may be nice to say :
> 
> 	echo "cid 2" > /dev/cpu/prof/tasks 
> 
> and have all tasks belonging to container id 2 move to the new resource
> group.

Adding that feature sounds fine, but don't go stopping me from putting
T1 into /dev/cpu/prof/tasks and T2 into /dev/cpu/student/tasks just
because you have your own notion of what each task is supposed to be.
Just because they're in the same namespaces doesn't mean they should get
the same resource allocations.  If you want to add that kind of policy,
well, it should be policy - user-definable.

-serge
