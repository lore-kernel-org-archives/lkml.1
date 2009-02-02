Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbZBBCY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbZBBCY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 21:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZBBCYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 21:24:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:22114 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbZBBCYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 21:24:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m8gyikI/5bA39XQWz5Ww2/DJQ7tXjBurtT+j1+t0UYzEdnfbT0F7GQSuqXgaBWK+N8
         09N0a0+Loq5GqoMYLV9iDgsQqXv5MAyeVnFWHCp2jKkkNmULFLV1Pz179Kb23+w2jC/y
         T95WUB+/EWwuFpvlY1RzQyjy2XsEKLJ+34wkM=
Date: Mon, 2 Feb 2009 03:24:15 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
Message-ID: <20090202022414.GA5006@nowhere>
References: <20090127001708.GA4815@nowhere> <20090126163015.7f879b18@infradead.org> <20090131180347.GC5884@nowhere> <20090131101502.7ce8e7af@infradead.org> <20090131182843.GD5884@nowhere> <1233524261.18767.60.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233524261.18767.60.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 08:37:41AM +1100, Benjamin Herrenschmidt wrote:
> 
> > I don't know, most of those I've looked on are not documented about the reason
> > for a private workqueue. I guess most of them can use the usual kevent.
> 
> The main problem with kevent is that it gets clogged up.


I don't think so. Here is a snapshot of the workqueue tracer in my
box currently:

# CPU  INSERTED  EXECUTED   NAME
# |      |         |          |

  1      0          0       hda0/1
  1    589        589       reiserfs/1
  1      0          0       scsi_tgtd/1
  1      0          0       aio/1
  1      0          0       ata/1
  1    378        378       kblockd/1
  1      0          0       kintegrityd/1
  1      2          2       work_on_cpu/1
  1   8706       8706       events/1

  0  19994      19994       cqueue
  0      0          0       hda0/0
  0    501        501       reiserfs/0
  0      0          0       scsi_tgtd/0
  0      0          0       aio/0
  0      0          0       ata_aux
  0      0          0       ata/0
  0      4          4       kacpi_notify
  0     22         22       kacpid
  0    379        379       kblockd/0
  0      0          0       kintegrityd/0
  0   1056       1056       khelper
  0     15         15       work_on_cpu/0
  0   9367       9367       events/0
  0      0          0       cpuset

And the result of uptime:

 02:51:40 up  2:22,  6 users,  load average: 0.22, 0.34, 0.59

So I have a total of 18073 works sent and performed by kevent for
10300 seconds.

An average of a bit less than 2 works on kevents per seconds is not about something
clogged, especially since we are talking about small jobs, usually those which play
the role of bottom halves and would have fit in a tasklet/softirq by the past.

Now if you look at the other workqueues.
Most of them don't do anything (more likely I don't do anything with them).

Khelper can't be replaced since it performs slow works which may wait for userspace
processes completion although I'm not sure it's still useful after the boot.

cqueue is usually inactive but I raised a good number of events artificially on it, I
just sent a patch to create its workqueue only when needed.

And for the others, I don't know yet.

 
> That's were thread pools kick in ... tried using Dave Howells slow
> work ?


I think it can be useful, as an example the kpsmoused workqueue receive rare
and slow works of mouse resynchronisation.
I wanted to convert it into a slow work created only on the fly.

But..I don't find it. I've seen some patches about it but it doesn't seem
to be merged.
So I tried something else for kpsmoused: turn it into a thread created on the fly.

But I think these slow works could be useful for such things.


> Cheers,
> Ben.
> 
> 

