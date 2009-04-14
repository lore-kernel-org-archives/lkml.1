Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbZDNTAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbZDNTAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 15:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZDNTAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 15:00:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:6873 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbZDNTAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 15:00:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bJW61GS9i0b2y2WmG4kn36KolRr9El3PnimISlBLYeV0W+8vyudhP3phcs9zlwhw88
         3QI6a8fgHj0FzryIZ7aOjmKUMqncVvdpdpzkmSFputDESVpBPg7zWnMzZpRZ8m28DTRg
         6oUC6Rk+mbtYHYmfzxWMtugjEGMlRcDiYx/oo=
Date: Tue, 14 Apr 2009 23:00:32 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/30] cr: core stuff
Message-ID: <20090414190032.GA28267@x200.localdomain>
References: <20090410023539.GK27788@x200.localdomain> <49E41D7B.8030003@cs.columbia.edu> <20090414160003.GD27461@x200.localdomain> <49E4D3A9.6020100@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E4D3A9.6020100@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> The ability to streamline the checkpoint image IMHO is invaluable.
> >> It's the unix way (TM) of doing things; it makes the process pipe-able.
> >>
> >> You can do many nice things when the checkpoint can be streamed: you
> >> can compress, sign, encrypt etc on the fly without taking additional
> >> diskspace. You can transfer over the network (e.g. for migration),
> >> or store remotely without explicit file system support. You can easily
> >> transform the stream from one c/r version to another etc.
> >>
> >> This should be a design principle. In my experience I never hit a wall
> >> that forced me to "sacrifice" this decision.
> >>
> >>>   sacrifised (read: child can ptrace parent)
> >> Hmmm... if all tasks are created in user space, then this specific
> >> becomes a no-brainer !
> > 
> > No!
> 
> Actually yes :)
> 
> > 
> > A ptraces B. Container is checkpointed.
> > 
> > Kernel realizes ptrace is going on. A and B in theory can have any
> > realitionship.
> > 
> > Consequently, kernel doesn't know in which order to dump A and B.
> > 
> > And there is no such order:
> > *) A can be parent of B (you dump A, B),
> > *) A can be child of B (you want to dump B, A, but this conflicts with
> >    ->real_parent order)
> > *) A and B just tasks (any order).
> 
> Current code does not support ptrace() - which has a multitude
> if tidy-bits issues to solve during restart regardless.
> 
> However, creating tasks in userspace uses (and will uses) only
> "real" process relationships, not ptrace-relationships, when it
> comes to decide on the fork/clone order.
> 
> Technically, that can be done in checkpoint (dumping the task tree)
> or in restart-user-space (rearranging the data before fork/clone).
> 
> > 
> > I'm showing that whole issue can be avoided:
> 
> If the issue can be avoided, then why would you need to sacrifice
> the stream-ability of the checkpoint image ?
> 
> > *) all tasks are simply created regardless of who is parent of whom
> >    (see kernel_thread())
> > *) Every task_struct image among other things contains references to
> >    ->real_parent and ->parent.
> > *) After every task is created it's time to change references:
> > 	**) lookup who is ->real_parent, change ->real_parent _by hand_
> > 		not with some "correct clone(2)" order.
> > 	**) lookup who is ->parent, change ->parent.
> > 
> > You're probably escaping all of this with object numbers?
> 
> (Will be) escaping this by arranging to fork/clone in the proper order.

task_struct and reparenting is just an example.

There is another loop:

	struct user_struct => struct user_namespace => struct user_namespace::creator

Before actual dump each struct user_struct gets unique id (objref, whatever)
and simply dumped regardless of order.

Image of struct user_namespace contains id of creator user and dumped.

On restart:
	restart user_ns
	restart user
	lookup object by creator id
	if found, rewrite ->creator
	if not found, restore creator user, and rewrite ->creator.

So, yes, if object number is dumped on disk, you get streamability in
presence of loops.

Clever. Just needs a way to quickly lookup file position by object id.

BTW, this is why OpenVZ code have "section concept.
I hoped it won't be needed.
