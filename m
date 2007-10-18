Return-Path: <linux-kernel-owner+w=401wt.eu-S1763683AbXJRRbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763683AbXJRRbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 13:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757214AbXJRRbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 13:31:06 -0400
Received: from sceptre.pobox.com ([207.106.133.20]:55100 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477AbXJRRbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 13:31:04 -0400
Date: Thu, 18 Oct 2007 12:30:54 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Rusty Russel <rusty@rustcorp.com.au>,
       Dipankar Sarma <dipankar@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@us.ibm.com>
Subject: Re: [RFC PATCH 2/4] Rename lock_cpu_hotplug to get_online_cpus
Message-ID: <20071018173054.GF6773@localdomain>
References: <20071016103308.GA9907@in.ibm.com> <20071016103506.GB16570@in.ibm.com> <20071017161308.GD6773@localdomain> <20071018075702.GB15281@in.ibm.com> <20071018082221.GE6773@localdomain> <20071018085959.GC15281@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018085959.GC15281@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gautham R Shenoy wrote:
> On Thu, Oct 18, 2007 at 03:22:21AM -0500, Nathan Lynch wrote:
> > Gautham R Shenoy wrote:
> > > Hi Nathan, 
> > > > Hi Gautham-
> > > > 
> > > > Gautham R Shenoy wrote:
> > > > > Replace all lock_cpu_hotplug/unlock_cpu_hotplug from the kernel and use 
> > > > > get_online_cpus and put_online_cpus instead as it highlights
> > > > > the refcount semantics in these operations.
> > > > 
> > > > Something other than "get_online_cpus", please?  lock_cpu_hotplug()
> > > > protects cpu_present_map as well as cpu_online_map.  For example, some
> > > > of the powerpc code modified in this patch is made a bit less clear
> > > > because it is manipulating cpu_present_map, not cpu_online_map.
> > > 
> > > A quick look at the code, and I am wondering why is lock_cpu_hotplug()
> > > used there in the first place. It doesn't look like we require any 
> > > protection against cpus coming up/ going down in the code below, 
> > > since the cpu-hotplug operation doesn't affect the cpu_present_map. 
> > 
> > The locking is necessary.  Changes to cpu_online_map and
> > cpu_present_map must be serialized; otherwise you could end up trying
> > to online a cpu as it is being removed (i.e. cleared from
> > cpu_present_map).  Online operations must check that a cpu is present
> > before bringing it up (kernel/cpu.c):
> 
> Fair enough! 
> 
> But we are not protecting the cpu_present_map here using
> lock_cpu_hotplug(), now are we?

Yes, we are.  In addition to the above, updates to cpu_present_map
have to be serialized.  pseries_add_processor can be summed up as
"find the first N unset bits in cpu_present_map and set them".  That's
not an atomic operation, so some kind of mutual exclusion is needed.


> The lock_cpu_hotplug() here, ensures that no cpu-hotplug operations
> occur in parallel with a processor add or a processor remove. 

That's one important effect, but not the only one (see above).


> IOW, we're still ensuring that the cpu_online_map doesn't change 
> while we're changing the cpu_present_map. So I don't see why the name
> get_online_cpus() should be a problem here.

The naming is a problem IMO for two reasons:

- lock_cpu_hotplug() protects cpu_present_map as well as
  cpu_online_map (sigh, I see that Documentation/cpu-hotplug.txt
  disagrees with me, but my statement holds for powerpc, at least).

- get_online_cpus() implies reference count semantics (as stated in
  the changelog) but AFAICT it really has a reference count
  implementation with read-write locking semantics.

Hmm, I think there's another problem here.  With your changes, code
which relies on the mutual exclusion behavior of lock_cpu_hotplug()
(such as pseries_add/remove_processor) will now be able to run
concurrently.  Probably those functions should use
cpu_hotplug_begin/end instead.
