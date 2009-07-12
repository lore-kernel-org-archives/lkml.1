Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbZGLN2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbZGLN2q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 09:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbZGLN2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 09:28:39 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:63268 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbZGLN2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 09:28:38 -0400
Message-ID: <4A59E502.1020008@codemonkey.ws>
Date: Sun, 12 Jul 2009 08:28:34 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       npiggin@suse.de, akpm@osdl.org, jeremy@goop.org,
       xen-devel@lists.xensource.com, tmem-devel@oss.oracle.com,
       alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org, kurt.hackel@oracle.com,
       Rusty Russell <rusty@rustcorp.com.au>, dave.mccracken@oracle.com,
       Marcelo Tosatti <mtosatti@redhat.com>, sunil.mushran@oracle.com,
       Avi Kivity <avi@redhat.com>, Schwidefsky <schwidefsky@de.ibm.com>,
       chris.mason@oracle.com, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 0/4] (Take 2): transcendent memory ("tmem") for Linux
References: <d693761e-2f2b-4d8c-ae4f-7f22479f6c0f@default>
In-Reply-To: <d693761e-2f2b-4d8c-ae4f-7f22479f6c0f@default>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Magenheimer wrote:
> Oops, sorry, I guess that was a bit inflammatory.  What I meant to
> say is that inferring resource utilization efficiency is a very
> hard problem and VMware (and I'm sure IBM too) has done a fine job
> with it; CMM2 explicitly provides some very useful information from
> within the OS to the hypervisor so that it doesn't have to infer
> that information; but tmem is trying to go a step further by making
> the cooperation between the OS and hypervisor more explicit
> and directly beneficial to the OS.
>   

KVM definitely falls into the camp of trying to minimize modification to 
the guest.

>> If there was one change to tmem that would make it more 
>> palatable, for 
>> me it would be changing the way pools are "allocated".  Instead of 
>> getting an opaque handle from the hypervisor, I would force 
>> the guest to 
>> allocate it's own memory and to tell the hypervisor that it's a tmem 
>> pool.
>>     
>
> An interesting idea but one of the nice advantages of tmem being
> completely external to the OS is that the tmem pool may be much
> larger than the total memory available to the OS.  As an extreme
> example, assume you have one 1GB guest on a physical machine that
> has 64GB physical RAM.  The guest now has 1GB of directly-addressable
> memory and 63GB of indirectly-addressable memory through tmem.
> That 63GB requires no page structs or other data structures in the
> guest.  And in the current (external) implementation, the size
> of each pool is constantly changing, sometimes dramatically so
> the guest would have to be prepared to handle this.  I also wonder
> if this would make shared-tmem-pools more difficult.
>
> I can see how it might be useful for KVM though.  Once the
> core API and all the hooks are in place, a KVM implementation of
> tmem could attempt something like this.
>   

It's the core API that is really the issue.  The semantics of tmem 
(external memory pool with copy interface) is really what is problematic.

The basic concept, notifying the VMM about memory that can be recreated 
by the guest to avoid the VMM having to swap before reclaim, is great 
and I'd love to see Linux support it in some way.

>> The big advantage of keeping the tmem pool part of the normal set of 
>> guest memory is that you don't introduce new challenges with 
>> respect to memory accounting.  Whether or not tmem is directly 
>> accessible from the guest, it is another memory resource.  I'm
>> certain that you'll want to do accounting of how much tmem is being
>> consumed by each guest
>>     
>
> Yes, the Xen implementation of tmem does accounting on a per-pool
> and a per-guest basis and exposes the data via a privileged
> "tmem control" hypercall.
>   

I was talking about accounting within the guest.  It's not just a matter 
of accounting within the mm, it's also about accounting in userspace.  A 
lot of software out there depends on getting detailed statistics from 
Linux about how much memory is in use in order to determine things like 
memory pressure.  If you introduce a new class of memory, you need a new 
class of statistics to expose to userspace and all those tools need 
updating.

Regards,

Anthony Liguori
