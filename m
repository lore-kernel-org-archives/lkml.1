Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbYKFOu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbYKFOu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 09:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbYKFOuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 09:50:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35329 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbYKFOuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 09:50:15 -0500
Subject: Re: [PATCH] ftrace: add an fsync tracer
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
In-Reply-To: <20081106063108.02b4813d@infradead.org>
References: <20081105094902.27ec4b39@infradead.org>
	 <1225976138.7803.4485.camel@twins> <20081106060624.58a0f967@infradead.org>
	 <1225981141.7803.4577.camel@twins>  <20081106063108.02b4813d@infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 06 Nov 2008 15:50:52 +0100
Message-Id: <1225983052.7803.4623.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-06 at 06:31 -0800, Arjan van de Ven wrote:
> On Thu, 06 Nov 2008 15:19:01 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > > a syscall tracer will exactly not tell you which file(name) was
> > > being fsync()'d which was the whole point.
> > 
> > It will tell you the process and the fd, and when you have those two
> > its a simple step to find the actual file.
> 
> actually process+fd is absolutely useless; the typical useage is
> 
> fd = open(file)
> write(fd, <> )
> fsync(fd);
> close(fd);
> 
> by the time userland gets the data the fd is closed. And heck, even the
> program may have exited.
> Really, the fd number is only useful for the program itself, not for
> any outside part, and especially, later in time.

The syscall tracer will also have told you about that open.

Anyway, do_fsync() doesn't catch all sync actions (although I suspect it
catches most). We still have the mythical sync_file_range() that Andrew
still wants a real program to use.

And then there are things like sync and umount that do syncs too. But I
suspect you might not be interested in those.

> > 
> > > LatencyTOP already KNOWS that fsync is the problem. What it doesn't
> > > know is which file is being fsync()d.
> > > 
> > > fsync is a problem when used incorrectly, not just for ext3 but also
> > > due to barriers. That's why it's important to be able to find who
> > > calls it when it impacts interactive performance.
> > 
> > Which suggests you want a tracer that gives more information about who
> > generates barriers, not specifically fsync().
> 
> that would be a fine second tracer. because the filesystem part of it
> is also expensive, and you can diss ext3 all you want, it is reality
> for 99% of the people...

Lets hope btrfs will fix that quickly. fsync() causing latencies for
anyone else besides tasks interested in that file is utterly
unacceptable.

> (and I suspect that at the barrier level it'll be really hard to get to
> a filename)

I suspect you might be right, but that's not a reason not to try ;-)
