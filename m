Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbXJaHlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbXJaHlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 03:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbXJaHlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 03:41:08 -0400
Received: from mail.suse.de ([195.135.220.2]:37522 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbXJaHlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 03:41:07 -0400
Date: Wed, 31 Oct 2007 08:41:06 +0100
From: Nick Piggin <npiggin@suse.de>
To: David Miller <davem@davemloft.net>
Cc: duaneg@dghda.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23 regression: accessing invalid mmap'ed memory from gdb causes unkillable spinning
Message-ID: <20071031074106.GE12189@wotan.suse.de>
References: <e9e943910710301745u429b14fj6c5a66fcbf6b0efa@mail.gmail.com> <20071031064221.GC12189@wotan.suse.de> <20071030.235600.254712083.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030.235600.254712083.davem@davemloft.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 11:56:00PM -0700, David Miller wrote:
> From: Nick Piggin <npiggin@suse.de>
> Date: Wed, 31 Oct 2007 07:42:21 +0100
> 
> > Sysrq+T fails to show the stack trace of a running task. Presumably this
> > is to avoid a garbled stack, however it can often be useful, and besides
> > there is no guarantee that the task won't start running in the middle of
> > show_stack(). If there are any correctness issues, then the archietcture
> > would have to take further steps to ensure the task is not running.
> > 
> > Signed-off-by: Nick Piggin <npiggin@suse.de>
> 
> This is useful.
> 
> Even more useful would be a show_regs() on the cpu where running tasks
> are running.  If not a full show_regs() at least a program counter.

Yes, that's something I've needed as well. And I doubt that we're
very unusual among kernel developers in this regard ;)
 

> That's usually what you're trying to debug and we provide nearly no
> way to handle: some task is stuck in a loop in kernel mode and you
> need to know exactly where that is.
> 
> This is pretty easy to do on sparc64.  In fact I can capture remote
> cpu registers even when that CPU's interrupts are disabled.  I suppose
> other arches could do a NMI'ish register capture like this as well.
> 
> I have a few bug reports that I can't make more progress on because I
> currently can't ask users to do something to fetch the registers on
> the seemingly hung processor.  This is why I'm harping on this so
> much :-)
> 
> Anyways, my core suggestion is to add a hook here so platforms can
> do the remote register fetch if they want.

You could possibly even do a generic "best effort" kind of thing with
regular IPIs, that will timeout and continue if some CPUs don't handle
them, and should be pretty easy to get working with existing smp_call_
function stuff. Not exactly clean, but it would be better than nothing.

