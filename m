Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbZIRT6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbZIRT6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbZIRT6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:58:07 -0400
Received: from smtp-out.google.com ([216.239.45.13]:8715 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbZIRT6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:58:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=eEdOPody8XEgcbIOM543bWfCPbVmdn443dIIxGxb2qTlJAwaYCKCduk4DEYcYEYdl
	cZkh/q8500wS4n23JDUJw==
Date: Fri, 18 Sep 2009 12:58:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric Paris <eparis@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Greg KH <greg@kroah.com>,
       linux-hotplug@vger.kernel.org
Subject: Re: kernel panic - not syncing: out of memory and no killable
 processes
In-Reply-To: <1253285923.30531.17.camel@dhcp231-106.rdu.redhat.com>
Message-ID: <alpine.DEB.1.00.0909181246410.27556@chino.kir.corp.google.com>
References: <1253158603.5213.204.camel@dhcp231-106.rdu.redhat.com> <1253191435.5213.209.camel@dhcp231-106.rdu.redhat.com> <alpine.DEB.1.00.0909171326340.31112@chino.kir.corp.google.com> <1253219756.5213.348.camel@dhcp231-106.rdu.redhat.com>
 <1253221309.5213.350.camel@dhcp231-106.rdu.redhat.com> <1253222149.5213.352.camel@dhcp231-106.rdu.redhat.com> <alpine.DEB.1.00.0909171417020.19006@chino.kir.corp.google.com> <1253223119.5213.359.camel@dhcp231-106.rdu.redhat.com>
 <alpine.DEB.1.00.0909171446230.22063@chino.kir.corp.google.com> <1253285923.30531.17.camel@dhcp231-106.rdu.redhat.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009, Eric Paris wrote:

> > Isolating udevd down to an interactivity scheduling change isn't _that_ 
> > bizarre.  I think the setting of UDEVD_PRIORITY is already mostly 
> > arbitrary anyway and it'll allow 192 children on your 512M machine by 
> > default unless you changed UDEVD_MAX_CHILDS for uid 0.
> > 
> > The default timeout for idle workers is 3 seconds, which may just happen 
> > to be long enough to panic your machine because of low memory.  If that's 
> > the case, I don't believe that it's a scheduler issue but rather a root 
> > abuse of setting all udevd threads to be OOM_DISABLE.
> > 
> > What is your udevd --version?  The latest is udev-146 released last month.
> 
> 145
> 
> Let me try and clone the vm some I don't break my reproducer.  I'll see
> if adding more memory fixes it.  Doesn't look like Fedora has built a
> -146 yet, I'll see if I can get one of those as well.
> 
> udev bug, configuration issue, whatever, or not, it's a regression that
> I used to be able to boot and updating my kernel leaves me unable to
> boot.  I think we all agree when 512M of memory isn't enough to boot to
> runlevel 3 we've got a problem   :)
> 

I totally agree, and my hypothesis is that the idle child workers are not 
being killed in time that they quickly accumulate approaching 
UDEVD_MAX_CHILDS and when the oom killer is called because of a write to 
shared memory, it can't kill any of these threads either since udevd sets 
them all to OOM_DISABLE and everything else is an unkillable kthread.

Bisecting that to a scheduler change would suggest that each udevd thread 
isn't returning from its poll() timeout fast enough; there's essentially a 
street race between udevd killing its own threads off because the poll 
timeout was exceeded and all your memory being used up and the machine 
panicking.  The scheduling change seems to have affected the speed of the 
former.

UDEVD_MAX_CHILDS defaults to 192 on your 512M machine unless overridden by 
an environment variable of the same name, so you may find it helpful to 
reduce this to a saner value.  I'd suggest a value lower than the number 
of udevd threads that were shown in your latest oom killer dump.

If that turns out to fix the issue for you, perhaps max_childs needs to be 
calculated in a slightly more conservative way in the userspace package 
since all threads come with the prerequisite of being OOM_DISABLE.
