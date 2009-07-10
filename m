Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbZGJPZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbZGJPZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 11:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbZGJPZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 11:25:07 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:23341 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289AbZGJPZE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 11:25:04 -0400
MIME-Version: 1.0
Message-ID: <d693761e-2f2b-4d8c-ae4f-7f22479f6c0f@default>
Date: Fri, 10 Jul 2009 08:23:07 -0700 (PDT)
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
In-Reply-To: <4A567E3B.90609@codemonkey.ws>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.2  (306040) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010205.4A575D11.0157:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > But IMHO this is a corollary of the fundamental difference.  CMM2's
> > is more the "VMware" approach which is that OS's should never have
> > to be modified to run in a virtual environment.  (Oh, but maybe
> > modified just slightly to make the hypervisor a little less
> > clueless about the OS's resource utilization.)
> 
> While I always enjoy a good holy war, I'd like to avoid one 
> here because 
> I want to stay on the topic at hand.

Oops, sorry, I guess that was a bit inflammatory.  What I meant to
say is that inferring resource utilization efficiency is a very
hard problem and VMware (and I'm sure IBM too) has done a fine job
with it; CMM2 explicitly provides some very useful information from
within the OS to the hypervisor so that it doesn't have to infer
that information; but tmem is trying to go a step further by making
the cooperation between the OS and hypervisor more explicit
and directly beneficial to the OS.

> If there was one change to tmem that would make it more 
> palatable, for 
> me it would be changing the way pools are "allocated".  Instead of 
> getting an opaque handle from the hypervisor, I would force 
> the guest to 
> allocate it's own memory and to tell the hypervisor that it's a tmem 
> pool.

An interesting idea but one of the nice advantages of tmem being
completely external to the OS is that the tmem pool may be much
larger than the total memory available to the OS.  As an extreme
example, assume you have one 1GB guest on a physical machine that
has 64GB physical RAM.  The guest now has 1GB of directly-addressable
memory and 63GB of indirectly-addressable memory through tmem.
That 63GB requires no page structs or other data structures in the
guest.  And in the current (external) implementation, the size
of each pool is constantly changing, sometimes dramatically so
the guest would have to be prepared to handle this.  I also wonder
if this would make shared-tmem-pools more difficult.

I can see how it might be useful for KVM though.  Once the
core API and all the hooks are in place, a KVM implementation of
tmem could attempt something like this.

> The big advantage of keeping the tmem pool part of the normal set of 
> guest memory is that you don't introduce new challenges with 
> respect to memory accounting.  Whether or not tmem is directly 
> accessible from the guest, it is another memory resource.  I'm
> certain that you'll want to do accounting of how much tmem is being
> consumed by each guest

Yes, the Xen implementation of tmem does accounting on a per-pool
and a per-guest basis and exposes the data via a privileged
"tmem control" hypercall.

> and I strongly suspect that you'll want to do tmem accounting on a 
> per-process 
> basis.  I also suspect that doing tmem limiting for things 
> like cgroups would be desirable.

This can be done now if each process or cgroup creates a different
tmem pool.  The proposed patch doesn't do this, but it certainly
seems possible.

Dan
