Return-Path: <linux-kernel-owner+w=401wt.eu-S932184AbYB1W1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbYB1W1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 17:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbYB1W1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 17:27:09 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751170AbYB1W1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 17:27:08 -0500
Date: Thu, 28 Feb 2008 14:21:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Paul Menage" <menage@google.com>
Cc: containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       balbir@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, xemul@openvz.org,
       pj@sgi.com
Subject: Re: [RFC] Prefixing cgroup generic control filenames with "cgroup."
Message-Id: <20080228142100.2dce0e46.akpm@linux-foundation.org>
In-Reply-To: <6599ad830802281406t38e486d8g267df1873bc754c2@mail.gmail.com>
References: <6599ad830802281314s25c033d6tc021725ae28aef8d@mail.gmail.com>
	<20080228132142.4d4b1eef.akpm@linux-foundation.org>
	<6599ad830802281328q162d0585v3ac6b45a119a4a05@mail.gmail.com>
	<20080228134027.05b2aa87.akpm@linux-foundation.org>
	<6599ad830802281406t38e486d8g267df1873bc754c2@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008 14:06:30 -0800
"Paul Menage" <menage@google.com> wrote:

> On Thu, Feb 28, 2008 at 1:40 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> >  Maybe cgroups shouldn't be putting kernel-generated files in places where
> >  user-specified files appear?
> >
> 
> Well, that API (mixing control files and group directories in the same
> directory namespace) was inherited directly from cpusets.
> 
> It wouldn't be hard to throw that away and move all the user-created
> group directories into their own subdirectory, i.e. change the
> existing directory layout from something like:
> 
> /mnt/cgroup/
>     tasks
>     cpu.shares
>     memory.limit_in_bytes
>     memory.usage_in_bytes
>     user_created_groupname1/
>         tasks
>         cpu.shares
>         memory.limit_in_bytes
>         memory.usage_in_bytes
>     user_created_groupname2/
>         tasks
>         cpu.shares
>         memory.limit_in_bytes
>         memory.usage_in_bytes
> 
> to something like:
> 
> /mnt/cgroup/
>     tasks
>     cpu.shares
>     memory.limit_in_bytes
>     memory.usage_in_bytes
>     groups/
>         user_created_groupname1/
>             tasks
>             cpu.shares
>             memory.limit_in_bytes
>             memory.usage_in_bytes
>             groups/
>         user_created_groupname2/
>             tasks
>             cpu.shares
>             memory.limit_in_bytes
>             memory.usage_in_bytes
>             groups/

That looks nice.

> That would completely solve the namespace problem, at the cost of a
> little extra verbosity/inelegance for human users (I suspect
> programmatic users would prefer it), and lack of compatibility with
> 2.6.24. I'd also need to make the existing model a mount option so
> that we could keep compatibility with the cpusets filesystem API.

That doesn't.  It sounds like cpusets legacy has mucked us up here?

Could we do something like auto-prefixing user-created directories with a
fixed string so that there is no way in which the user can cause a
collision with kernel-created files?

I suppose that would break cpusets back-compatibility as well?  If so, we
could do the prefixing only for non-cpusets directories, but that's getting
a bit weird.

> >  (Am still thrashing around a bit here without an overview of the overall
> >  layout and naming).
> 
> Pretty much the same as cpusets, other than the additional
> kernel-generated files in each directory, as provided by the resource
> subsystems. So the same potential problem faced cpusets, but the fact
> that new cpuset features weren't being developed quickly meant the
> problem was less likely to actually bite people.

hm.  I guess that all the kernel-generated file names are known up-front
and that they are instantiated early, so if a user tried to create a cgroup
called "tasks", than that would just fail.

But, as you say, later addition of new kernel-created files might collide
with prior userspace installations.

So yet another option would be to promise to prefix all _future_
kernel-generated files with "kern_", and to change the implementation now
to reject any user-created files which start with "kern_".  hm.

