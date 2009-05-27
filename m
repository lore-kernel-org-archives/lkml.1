Return-Path: <linux-kernel-owner+w=401wt.eu-S1760599AbZE0I5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760599AbZE0I5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 04:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbZE0I4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 04:56:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790AbZE0I4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 04:56:52 -0400
Date: Wed, 27 May 2009 01:56:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: paul@mad-scientist.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6.27.24] Kernel coredump to a pipe is failing
Message-Id: <20090527015647.325b892f.akpm@linux-foundation.org>
In-Reply-To: <20090527085237.GV846@one.firstfloor.org>
References: <878wkjobbm.fsf@basil.nowhere.org>
	<20090526160017.98fc62e4.akpm@linux-foundation.org>
	<20090526231428.GK846@one.firstfloor.org>
	<20090526162821.02e11d5b.akpm@linux-foundation.org>
	<20090526234109.GL846@one.firstfloor.org>
	<20090526164532.6c780234.akpm@linux-foundation.org>
	<20090527001104.GN846@one.firstfloor.org>
	<20090526172935.fad52c49.akpm@linux-foundation.org>
	<20090527073136.GT846@one.firstfloor.org>
	<20090527004525.1d70c134.akpm@linux-foundation.org>
	<20090527085237.GV846@one.firstfloor.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009 10:52:38 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> > Hey, don't look at me - blame Brian Kernighan or George Bush or
> > someone.
> 
> Heh.
> 
> What I meant is: if it makes sense to retry the kernel should do that
> on its own. It has better information about the circumstances anyways.
> And it would make sense to put all such logic into a single place
> instead of all programs.
> 
> If it doesn't we shouldn't try to force that to user space. That would be similar
> to signal handling without SA_RESTART which I think nearly everyone agrees was one
> of the worst APIs in Unix ever.
> 
> In most cases (e.g. out of memory) it likely doesn't make much sense to
> retry anyways.
> 
> So short write always means error.
> 
> 
> > > And the same applies to in-kernel users really.
> > 
> > We could delete a rather nice amount of tricky VFS code if we were to
> > make this assumption.  But of course we daren't do that.
> 
> What do you mean?

There's code all over the VFS IO paths which correctly recognises,
handles and propagates short reads and writes.

Actually, by far the most common case here is that the short read/write
will be followed by a -ENOSPC or -EFAULT or whatever, so forget I said
that ;)

> > 
> > And as long as we're attempting to correctly handle partial writes all
> > over the kernel, it's a bit dopey to deliberately avoid doing this at one
> > particular codesite.
> > 
> > I bet glibc handles partial writes...
> 
> I just spent some time nagivating through the glibc stdio me^wmaze 
> and I don't see any retry loops.

Perhaps it's usually propagated back, dunno.

> Also even if it did there would be lots of other users
> (google codesearch has >23 million hits for "write")
> 
> > > a lot of things start failing.
> > 
> > The kernel should only fail if it has no other option.
> 
> Typically short write means no other option.

typically != always.  It would certainly be peculiar behaviour and
perhaps it was specified that way mainly on behalf of UART drivers and
such, dunno.

