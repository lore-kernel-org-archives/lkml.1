Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbZGLQWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbZGLQWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 12:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZGLQWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 12:22:11 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:26443 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbZGLQWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 12:22:10 -0400
MIME-Version: 1.0
Message-ID: <a09e4489-a755-46e7-a569-a0751e0fc39f@default>
Date: Sun, 12 Jul 2009 09:20:22 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       npiggin@suse.de, akpm@osdl.org, jeremy@goop.org,
       xen-devel@lists.xensource.com, tmem-devel@oss.oracle.com,
       alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org, kurt.hackel@oracle.com,
       Rusty Russell <rusty@rustcorp.com.au>, dave.mccracken@oracle.com,
       Marcelo Tosatti <mtosatti@redhat.com>, sunil.mushran@oracle.com,
       Avi Kivity <avi@redhat.com>, Schwidefsky <schwidefsky@de.ibm.com>,
       chris.mason@oracle.com, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: RE: [RFC PATCH 0/4] (Take 2): transcendent memory ("tmem") for Linux
In-Reply-To: <4A59E502.1020008@codemonkey.ws>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.2  (306040) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010205.4A5A0D7F.0094:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > that information; but tmem is trying to go a step further by making
> > the cooperation between the OS and hypervisor more explicit
> > and directly beneficial to the OS.
> 
> KVM definitely falls into the camp of trying to minimize 
> modification to the guest.

No argument there.  Well, maybe one :-) Yes, but KVM
also heavily encourages unmodified guests.  Tmem is
philosophically in favor of finding a balance between
things that work well with no changes to any OS (and
thus work just fine regardless of whether the OS is
running in a virtual environment or not), and things
that could work better if the OS is knowledgable that
it is running in a virtual environment.

For those that believe virtualization is a flash-in-
the-pan, no modifications to the OS is the right answer.
For those that believe it will be pervasive in the
future, finding the right balance is a critical step
in operating system evolution.

(Sorry for the Sunday morning evangelizing :-)

> >> If there was one change to tmem that would make it more 
> >> palatable, for 
> >> me it would be changing the way pools are "allocated".  Instead of 
> >> getting an opaque handle from the hypervisor, I would force 
> >> the guest to 
> >> allocate it's own memory and to tell the hypervisor that 
> it's a tmem 
> >> pool.
> >
> > I can see how it might be useful for KVM though.  Once the
> > core API and all the hooks are in place, a KVM implementation of
> > tmem could attempt something like this.
> 
> It's the core API that is really the issue.  The semantics of tmem 
> (external memory pool with copy interface) is really what is 
> problematic.
> The basic concept, notifying the VMM about memory that can be 
> recreated 
> by the guest to avoid the VMM having to swap before reclaim, is great 
> and I'd love to see Linux support it in some way.

Is it the tmem API or the precache/preswap API layered on
top of it that is problematic?  Both currently assume copying
but perhaps the precache/preswap API could, with minor
modifications, meet KVM's needs better?

> > Yes, the Xen implementation of tmem does accounting on a per-pool
> > and a per-guest basis and exposes the data via a privileged
> > "tmem control" hypercall.
> 
> I was talking about accounting within the guest.  It's not 
> just a matter 
> of accounting within the mm, it's also about accounting in 
> userspace.  A 
> lot of software out there depends on getting detailed statistics from 
> Linux about how much memory is in use in order to determine 
> things like 
> memory pressure.  If you introduce a new class of memory, you 
> need a new 
> class of statistics to expose to userspace and all those tools need 
> updating.

OK, I see.

Well, first, tmem's very name means memory that is "beyond the
range of normal perception".  This is certainly not the first class
of memory in use in data centers that can't be accounted at
process granularity.  I'm thinking disk array caches as the
primary example.  Also lots of tools that work great in a
non-virtualized OS are worthless or misleading in a virtual
environment.

Second, CPUs are getting much more complicated with massive
pipelines, many layers of caches each with different characteristics,
etc, and its getting increasingly impossible to accurately and
reproducibly measure performance at a very fine granularity.
One could only expect that other resources, such as memory,
would move in that direction.

