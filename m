Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbZKJLKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbZKJLKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 06:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842AbZKJLKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 06:10:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755802AbZKJLKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 06:10:34 -0500
Subject: Re: [Cluster-devel] Re: [PATCH] misc: use a proper range for minor
 number dynamic allocation
From: Steven Whitehouse <swhiteho@redhat.com>
To: David Teigland <teigland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, rubini@vision.unipv.it,
       cluster-devel@redhat.com, device@lanana.org
In-Reply-To: <20091109230311.GA820@redhat.com>
References: <1256340497-19320-1-git-send-email-cascardo@holoscopio.com>
	 <20091109132836.6cf7f559.akpm@linux-foundation.org>
	 <20091109230311.GA820@redhat.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 10 Nov 2009 11:10:08 +0000
Message-Id: <1257851408.6052.835.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2009-11-09 at 17:03 -0600, David Teigland wrote:
> On Mon, Nov 09, 2009 at 01:28:36PM -0800, Andrew Morton wrote:
> > On Fri, 23 Oct 2009 21:28:17 -0200
> > Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:
> > 
> > > The current dynamic allocation of minor number for misc devices has some
> > > drawbacks.
> > > 
> > > First of all, the range for dynamic numbers include some statically
> > > allocated numbers. It goes from 63 to 0, and we have numbers in the
> > > range from 1 to 15 already allocated. Although, it gives priority to the
> > > higher and not allocated numbers, we may end up in a situation where we
> > > must reject registering a driver which got a static number because a
> > > driver got its number with dynamic allocation. Considering fs/dlm/user.c
> > > allocates as many misc devices as lockspaces are created, and that we
> > > have more than 50 users around, it's not unreasonable to reach that
> > > situation.
> > 
> > What is this DLM behaviour of which you speak?  It sounds broken.
> 
> One for each userland lockspace, I know of three userland apps using dlm:
> 1. rgmanager which is at the end of its life
> 2. clvmd which is switching to a different lock manager
> 3. ocfs2 tools, where the userland portion is transient; it only exists
>    while the tool executes.
> 
> That said, it shouldn't be a problem to switch to a single device in the
> next version of the interface.
> 
> Dave
> 
As well as the per-userland lockspace misc devices there are also the
misc devices of which there are only one instance shared between all
lock spaces:

dlm_lock - Used for userland communication with posix locks
dlm-monitor - Used to only to check that dlm_controld is running (so far
as I can tell)
dlm-control - Used to create/remove userland dlm lockspaces

I also had a look at other methods used by the dlm to communicate with
userspace, and this is what I've come up with so far:

configfs - Used to set up lockspaces
debugfs - Used to get lock state information for debugging
netlink - Used only to notify lock timeouts to dlm_controld
sysfs - Used to implement a wait for a userland event (wait for write to
a sysfs file)
uevents - Used to trigger dlm_controld into performing an action which
          results in the write to sysfs mentioned above. This is
          netlink again, but with a layer over the top of it.

If a change to the misc devices is planned, I'm wondering if it would be
possible to merge some of the other functions into a single interface to
simplify things a bit. In particular the netlink interface looks dubious
to me since I think it should be doing a broadcast rather than the
rather strange (and possibly a security issue with any process able to
send messages to it and set their own pid so far as I can see). I have
to say that I didn't test that, but there is no obvious check for privs
that I can see in the dlm netlink code.

Steve.





