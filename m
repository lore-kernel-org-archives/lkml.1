Return-Path: <linux-kernel-owner+w=401wt.eu-S1766016AbYCSVYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766016AbYCSVYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759912AbYCSUAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:00:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48875 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbYCSUAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:00:24 -0400
Date: Wed, 19 Mar 2008 18:20:05 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/6] vfs: mountinfo stable peer group id
Message-ID: <20080319182005.GP10722@ZenIV.linux.org.uk>
References: <20080313212641.989467982@szeredi.hu> <20080313212735.741834181@szeredi.hu> <20080319114844.GK10722@ZenIV.linux.org.uk> <E1Jc1Ln-0003jm-Bt@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jc1Ln-0003jm-Bt@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 05:41:15PM +0100, Miklos Szeredi wrote:
> > > From: Miklos Szeredi <mszeredi@suse.cz>
> > Um?  Do you ever need to take it outside of vfsmount_lock?
> > 
> 
> Tried to think this through:
> 
> It's always called with namespace_sem, which is enough, no need for a
> new lock.  The bigger problem, is that it _is_ called with
> vfsmount_lock in one case, which is bad, since the allocation may
> sleep.

It is called with vfsmount_lock in *all* cases.  You've missed one
in umount_tree(), BTW; you won't block in that case, though.

> That is in do_change_type().  But do we really need to hold
> vfsmount_lock in that case?

Not the issue.

>  I think not, the propagation tree has no
> relevance outside namespace_sem, so that one should be sufficient.

Callers manipulate more than propagation tree.  Note that e.g.
umount_tree() changes all sorts of data structures, including ones
that are traversed without namespace_sem.

I _really_ don't like the idea of different locking rules for caller
of a function depending on the value of argument of that function.
They are complicated enough as it is.

Argh...  OK, I'll try to put something together tonight, after I get some
sleep - 31 hours of uptime _suck_ ;-/  BTW, on top of everything else,
the current variant plays interesting games with CL_PROPAGATION behaviour
and I really don't like the look of what it's doing there.  Later...
