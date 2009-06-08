Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbZFHSvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbZFHSvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 14:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbZFHSvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 14:51:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46274 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbZFHSvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 14:51:15 -0400
Date: Mon, 8 Jun 2009 19:50:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hugh@veritas.com,
       tj@kernel.org, adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk,
       gregkh@suse.de, npiggin@suse.de, akpm@linux-foundation.org,
       hch@infradead.org
Subject: Re: [PATCH 0/23] File descriptor hot-unplug support v2
Message-ID: <20090608185041.GN8633@ZenIV.linux.org.uk>
References: <m1skkf761y.fsf@fess.ebiederm.org> <m1oct739xu.fsf@fess.ebiederm.org> <20090606080334.GA15204@ZenIV.linux.org.uk> <E1MDbLz-0003wm-Db@pomaz-ex.szeredi.hu> <20090608162913.GL8633@ZenIV.linux.org.uk> <E1MDhxh-0004nz-Qm@pomaz-ex.szeredi.hu> <20090608175018.GM8633@ZenIV.linux.org.uk> <alpine.LFD.2.01.0906081100000.6847@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906081100000.6847@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 11:01:51AM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 8 Jun 2009, Al Viro wrote:
> > 
> > Welcome to reality...
> > 
> > * bread() is non-interruptible
> > * so's copy_from_user()/copy_to_user()
> > * IO we are stuck upon _might_ be interruptible, but by sending a signal
> > to some other process
> 
> We can probably improve on these, though.
> 
> Like the copy_to/from_user thing. We might well be able to do that whole 
> "if it's a fatal signal, return early" thing.
> 
> So in the _general_ case - no, we probably can't fix things. But we could 
> likely at least improve in some common cases if we cared.

Sure, even though I'm not at all certain that copy_from_user() is that easy.
We can make locking current->mm in there interruptible, all right, but that's
only a part of the answer - even aside of the allocations, we'd need vma
->fault() interruptible as well, which leads to interruptible instances of
->readpage(), with all the fun _that_ would be.
