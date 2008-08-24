Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbYHXT7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbYHXT7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 15:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYHXT7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 15:59:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41910 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbYHXT7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 15:59:11 -0400
Date: Sun, 24 Aug 2008 20:59:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
Message-ID: <20080824195908.GQ28946@ZenIV.linux.org.uk>
References: <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <20080812181057.GR28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121316570.3462@nehalem.linux-foundation.org> <20080812203808.GV28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121351570.3462@nehalem.linux-foundation.org> <20080813000433.GZ28946@ZenIV.linux.org.uk> <20080815050613.GJ4422@cs.cmu.edu> <alpine.LFD.1.10.0808150940110.3324@nehalem.linux-foundation.org> <20080824101014.GN28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808241017580.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808241017580.3363@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 10:20:52AM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 24 Aug 2008, Al Viro wrote:
> > 
> > One obvious note: that'll break old_readdir() on coda.  There you need to
> > change the existing check (you need to check buf.result, then ignore error
> > unless buf.result ended up 0).
> 
> Hmm? old_readdir() was the only one that I didn't change, because it 
> didn't need changing. It already ignores the return value of 
> "vfs_readdir()" entirely if it is positive or zero, and takes it from 
> buf.result.
> 
> So old_readdir() literally doesn't care at all (and never has) whether a 
> ->readdir() function returns zero or a positive number. So changing coda 
> readdir() it to return zero _instead_ of a positive number makes 
> absolutely zero difference: old_readdir() will do the same thing 
> regardless.
> 
> What am I missing?

The fact that coda_readdir() will _not_ be returning 0 with your change
when called with the arguments old_readdir() gives it?  You'll get ret
from filldir, i.e. what you'll normally see will be -EINVAL in case of
fillonedir as callback.

The normal sequence for old_readdir() is
	* call fillonedir on the current entry
	* have it bump ->result from 0 to 1 and return 0
	* advance f_pos to the next entry
	* call fillonedir for it
	* have it see ->result != 0 and immediately bail out with -EINVAL
	* seeing a negative from the callback, foo_readdir does *not* advance
f_pos this time and returns 0 (or at least something non-negative)
	* old_readdir() sees non-negative from vfs_readdir() and returns
buf->result (i.e. 1)

Now you've got vfs_readdir() returning -EINVAL in that scenario.  See why
old_readdir() needs an update too?  It doesn't have the "OK, we'd already
called its filldir, so bugger whatever had happened afterwards" logics -
and it'll need it now.
