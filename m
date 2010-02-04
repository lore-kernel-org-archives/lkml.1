Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab0BDEyB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 23:54:01 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58882 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757393Ab0BDEyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 23:54:00 -0500
Date: Thu, 4 Feb 2010 04:53:57 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] %pd - for printing dentry name
Message-ID: <20100204045357.GC30031@ZenIV.linux.org.uk>
References: <20100201222511.GA12882@ZenIV.linux.org.uk>
 <alpine.LFD.2.00.1002011431490.3664@localhost.localdomain>
 <20100201231847.GC12882@ZenIV.linux.org.uk>
 <20100202010653.GD12882@ZenIV.linux.org.uk>
 <m1k4uwfag1.fsf@fess.ebiederm.org>
 <20100202170157.GH12882@ZenIV.linux.org.uk>
 <m1y6jbo36v.fsf@fess.ebiederm.org>
 <20100203030419.GA30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100203030419.GA30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 03:04:19AM +0000, Al Viro wrote:
> On Tue, Feb 02, 2010 at 11:19:52AM -0800, Eric W. Biederman wrote:
> 
> > If we are going to take a lock this seems as sane as any.
> > 
> > Do we want to honor oops_in_progress aka bust_spinlocks here?
> > 
> > Perhaps just:
> > if (oops_in_progress)
> > 	return buf;
> > 
> > To guarantee we get the rest of a panic message out of the kernel.
> 
> Hmm...   There's another fun issue - we would want local_irq_disable() /
> local_irq_enable() in d_move_locked and local_irq_save/local_irq_restore()
> in dname_string(), AFAICT.
> 
> OK, here's what I've got from moving in that direction.  Folks, how does
> that one look to you?  I'm not too happy about explicit manipulations
> with irq flags in there, so any suggestions would be welcome.

Argh.  No, it's not at all better.  Moreover, even read_seqbegin variant
is b0rken if we ever do that under ->d_lock.

CPU1:A: grabs dentry->d_lock
CPU2:B: calls d_move_locked()
CPU2:B: grabs rename_lock
CPU2:B: spins on dentry->d_lock
CPU1:A: calls printk with %pd dentry
CPU1:A: spins waiting for rename_lock writer to release it

So much for that approach ;-/
