Return-Path: <linux-kernel-owner+w=401wt.eu-S966409AbXFGWGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966409AbXFGWGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966284AbXFGWBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:01:19 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43897 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966356AbXFGWBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:01:15 -0400
Date: Thu, 7 Jun 2007 15:01:13 -0700
From: Paul Jackson <pj@sgi.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: serue@us.ibm.com, vatsa@in.ibm.com, ckrm-tech@lists.sourceforge.net,
       balbir@in.ibm.com, rohitseth@google.com, haveblue@us.ibm.com,
       xemul@sw.ru, dev@sw.ru, containers@lists.osdl.org, devel@openvz.org,
       ebiederm@xmission.com, mbligh@google.com, cpw@sgi.com,
       menage@google.com, svaidy@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [ckrm-tech] [PATCH 00/10] Containers(V10): Generic Process
 Containers
Message-Id: <20070607150113.f020d8f8.pj@sgi.com>
In-Reply-To: <20070607201723.GA17011@sergelap.austin.ibm.com>
References: <20070604123151.4db007a6.pj@sgi.com>
	<6599ad830706041330q1802ebf2n2bac63f706a73a50@mail.gmail.com>
	<20070604204131.GB19409@sergelap.austin.ibm.com>
	<20070604140533.65e25286.pj@sgi.com>
	<20070606223952.GB5626@sergelap.austin.ibm.com>
	<20070606154347.a155630b.pj@sgi.com>
	<20070607000559.GA19529@sergelap.austin.ibm.com>
	<20070606174609.bfa01446.pj@sgi.com>
	<20070607180158.GA936@sergelap.austin.ibm.com>
	<20070607122121.24fe6ff4.pj@sgi.com>
	<20070607201723.GA17011@sergelap.austin.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > The set of people using exclusive cpusets is roughly some subset of
> > those running multiple, cpuset isolated, non-cooperating jobs on big
> > iron, usually with the aid of a batch scheduler.
> 
> Unfortunately I would imagine these users to be very intereseted in
> providing checkpoint/restart/migrate functionality.

Yup - such customers are very interested in checkpoint, restart, and
migrate functionality.

> Surely if the admin wants to give cpus 5-6 exclusively to /cpusets/set0/set4
> later, those cpus can just be taken away from set3?

Yeah - that works, so far as I know (which isn't all that far ..')

But both:
 1) that (using whatever cpus are still available) and
 2) my other idea, of not allowing any cloning of cpusets with
    exclusive siblings at all,

looked a little ugly to me.

For example, such customers as above would not appreciate having their
checkpoint/restart/migrate fail in any case where there weren't spare
non-exclusive cpus, which for users of the exclusive flag, is often the
more common case.

My rule of thumb when doing ugly stuff is to constrain it as best
I can -- minimize what it allows.  This led me to prefer (2) above
over (1) above.

Perhaps there's a better way to think of this ...  When we clone
like this for checkpoint/restart/migrate functionality, perhaps
we are not really starting up a new, separate, competing job that
should have its resources isolated and separated from the original.

Perhaps instead we are firing up a convenient alter-ego of the
original job, which will be co-operatively using the same resources
by default.  If that's the normal case, then it seems wrong to
force the clone onto disjoint CPUs, or fail for lack thereof.

So perhaps we should refine the meaning of 'exclusive', from:
 - no overlapping siblings
to:
 - no overlapping siblings other than clones of ones self.

Then default to cloning right on the same CPU resources as the
original, possibly with both original and clone marked exclusive.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
