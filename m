Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbZEAMnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbZEAMnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 08:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbZEAMn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 08:43:29 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:62203 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932AbZEAMn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 08:43:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=S1lDima0DLJPqB7l8uQt8MsbBeJiSoB2k8tClJU4XIDykGs9LKHwVEo/EIg6N6UY14
         wWwLXMzbWSn+TXLQfzrS56z9Z3I1dE268xlsEECbf+lh9zx3h3XiHILyFd0D1O1VDnfe
         aYFlklk1h+3r+LPqPp7d2QTikLQbOomyOgpvY=
Date: Fri, 1 May 2009 14:43:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] tracing: export stats of ring buffers to userspace
Message-ID: <20090501124317.GA6011@nowhere>
References: <20090501022210.851418183@goodmis.org> <20090501022402.302620162@goodmis.org> <20090501030848.GA19883@nowhere> <alpine.DEB.2.00.0904302313120.20374@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904302313120.20374@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 11:23:52PM -0400, Steven Rostedt wrote:
> 
> On Fri, 1 May 2009, Frederic Weisbecker wrote:
> 
> > On Thu, Apr 30, 2009 at 10:22:12PM -0400, Steven Rostedt wrote:
> > > From: Steven Rostedt <srostedt@redhat.com>
> > > 
> > > This patch adds stats to the ftrace ring buffers:
> > > 
> > >  # cat /debugfs/tracing/per_cpu/cpu0/stats
> > >  entries: 42360
> > >  overrun: 30509326
> > >  commit overrun: 0
> > >  nmi dropped: 0
> > > 
> > > Where entries are the total number of data entries in the buffer.
> > > 
> > > overrun is the number of entries not consumed and were overwritten by
> > > the writer.
> > > 
> > > commit overrun is the number of entries dropped due to nested writers
> > > wrapping the buffer before the initial writer finished the commit.
> > 
> > 
> > I feel a bit confused with this one.
> > How such a thing can happen? The write page and the commit page
> > are not the same. So is that because we can have (ring-buffer inspires
> > all of us to try ascii-art):
> > 
> > 
> >           Write page                      Commit page (which becomes new write page) 
> > ------------------------------------ -----------------
> >             |           |          | |               |
> >   Writer 1  | Writer 2  | Writer n | | Writer n + 1  | .....
> >   reserved  | reserved  | reserved | | reserved      |
> > -----------------------------------  ----------------
> >     |                                             ^
> >     |                                             |
> >     ---------------- Was supposed to commit here--|
> >  
> > 
> > I know this is silly, my picture seem to show a data copy whereas
> > the ring buffer deals with page pointers.
> > But the commit page on the ring buffer is a mistery for me.
> > Just because you haven't drawn in in ascii in your comments :)
> > 
> 
> I have a bunch of ascii art that explains all this in my documentation 
> that details the lockless version.
> 
> The commit page is the page that holds the last full commit.
> 
>  ring_buffer_unlock_commit()
> 
> On ring_buffer_lock_reserve() we reserve some data after the last commit.
> 
>             commit
>                |
>                V
>     +---+    +---+    +---+    +---+
> <---|   |--->|   |--->|   |--->|   |--->
> --->|   |<---|   |<---|   |<---|   |<---
>     +---+    +---+    +---+    +---+
>                ^
>                |
>              tail (writer)
> 
> We do not disable interrupts (or softirqs) between 
> ring_buffer_lock_reserve and ring_buffer_unlock_commit. If we get 
> preempted by an interrupt or softirq, and it writes to the ring buffer, it 
> will move the tail, but not the commit. Only the outer most writer (non 
> nested) can do that:
> 
>             commit     
>                |
>                V
>     +---+    +---+    +---+    +---+
> <---|   |--->|   |--->|   |--->|   |--->
> --->|   |<---|   |<---|   |<---|   |<---
>     +---+    +---+    +---+    +---+
>                         ^
>                         |
>                       tail (writer)



Aah, now I understand what does rb_set_commit_to_write()


 
> 
> But lets say we are running the function graph tracer along with the event 
> tracer. And to save space, we shrunk the ring buffer down to a few pages. 
> (more than 2)  We are writing an event and get preempted by an interrupt 
> followed by several softirqs, and these softirqs perform a lot of 
> functions. It can push the tail all around the buffer:
> 
>             commit
>                |
>                V
>     +---+    +---+    +---+    +---+
> <---|   |--->|   |--->|   |--->|   |--->
> --->|   |<---|   |<---|   |<---|   |<---
>     +---+    +---+    +---+    +---+
>       ^
>       |
>     tail (writer)
> 
> 
> This happens before we even finish the original write. But the tail can 
> not push the commit forward, because when we fall out of this stack of 
> writers, that original writer is in the process of writing into the ring 
> buffer. Thus we need to drop any more entries that want to push the tail 
> pointer onto the commit pointer.
> 
> Thus, when this happens we record it with commit_overrun.
> 
> -- Steve


Ok thanks for these explanations!

I hope your lockless ring buffer will be posted soon (any news about
the patent?) :-)


