Return-Path: <linux-kernel-owner+w=401wt.eu-S932380AbZHUSS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380AbZHUSS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 14:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbZHUSS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 14:18:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57994 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666AbZHUSS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 14:18:27 -0400
Date: Fri, 21 Aug 2009 14:18:23 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: ioctls vs syscalls once again
Message-ID: <20090821181823.GA29918@infradead.org>
References: <20090816004705.GA7347@infradead.org> <20090819203916.GA25296@elte.hu> <20090820010552.GA22107@infradead.org> <20090821124638.GC10263@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821124638.GC10263@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[chaged the subject and droped the cc list down as this is not about
 discard support anymore]

On Fri, Aug 21, 2009 at 02:46:38PM +0200, Ingo Molnar wrote:
> > ioctl is per defintion a multiplexer.
> 
> Yes, and? There's two variants of multiplexing:
> 
>   - multiplex something rather straightforward and related
>   - multiplex unrelated fields, data, structures
> 
> I consider the second one 'ugly', the first one 'ok-ish'. YMMV.

Exactly.  And ioctl is per defintion the latter.  sys_ioctl is a way
to give drivers (and in Linux filesystem, too) a way to implement their
own syscall table extension for file descritors they control.  While
there might be a few "ok-ish" or "nice" ioctl handlers most of them
are ugly.  That's why people don't like them too much, btw :)

> I'd like to understand the technical basis of your critisism and i'd 
> like to address any deficiencies of the perfcounters code. You said 
> you dont like the ioctl solution we have, but that you'd like a 
> separate syscall even less.

I really don't like any ioctl solution very much.  But sometimes it's
the lesser of the evils, often by a bug margin.

> Perfcounters are a kernel-wide concept, encompassing 100% of all 
> Linux installations, not just some special hardware.

That doesn't really matter.  The tty code is also used by 100% of the
Linux installation, and still it implements the tty controls as ioctls.

Generally having system calls that don't operate on file descriptor
genericly (that doesn't mean implemented everywhere, but beeing a
generic concept dispatched through file operations) is pretty ugly.
We have a lot of them anyway, e.g. the socket system calls, eventfd,
inotify.  They don't really buy us anything over ioctls, but they
are accepted.  So if you design a clean system call working on
perfcounters file descriptor no one could have hard objection (as in
actually saying no).  But if you really just do another stupid
muliplexer just go for ioctl instead of reinventing the dispatching
and multiplexing.

