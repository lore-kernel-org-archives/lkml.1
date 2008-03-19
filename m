Return-Path: <linux-kernel-owner+w=401wt.eu-S1762521AbYCTAQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762521AbYCTAQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938472AbYCSXfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:35:17 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50604 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938466AbYCSXfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:35:14 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080319182005.GP10722@ZenIV.linux.org.uk> (message from Al Viro
	on Wed, 19 Mar 2008 18:20:05 +0000)
Subject: Re: [patch 3/6] vfs: mountinfo stable peer group id
References: <20080313212641.989467982@szeredi.hu> <20080313212735.741834181@szeredi.hu> <20080319114844.GK10722@ZenIV.linux.org.uk> <E1Jc1Ln-0003jm-Bt@pomaz-ex.szeredi.hu> <20080319182005.GP10722@ZenIV.linux.org.uk>
Message-Id: <E1Jc3Ad-0004Xu-58@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 19 Mar 2008 19:37:51 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > From: Miklos Szeredi <mszeredi@suse.cz>
> > > Um?  Do you ever need to take it outside of vfsmount_lock?
> > > 
> > 
> > Tried to think this through:
> > 
> > It's always called with namespace_sem, which is enough, no need for a
> > new lock.  The bigger problem, is that it _is_ called with
> > vfsmount_lock in one case, which is bad, since the allocation may
> > sleep.
> 
> It is called with vfsmount_lock in *all* cases.  You've missed one
> in umount_tree(), BTW; you won't block in that case, though.

set_mnt_shared() is called from namespace.c as well, without
vfsmount_lock.  But agreed, that's not the real issue.

> 
> > That is in do_change_type().  But do we really need to hold
> > vfsmount_lock in that case?
> 
> Not the issue.
> 
> >  I think not, the propagation tree has no
> > relevance outside namespace_sem, so that one should be sufficient.
> 
> Callers manipulate more than propagation tree.  Note that e.g.
> umount_tree() changes all sorts of data structures, including ones
> that are traversed without namespace_sem.
> 
> I _really_ don't like the idea of different locking rules for caller
> of a function depending on the value of argument of that function.
> They are complicated enough as it is.
> 
> Argh...  OK, I'll try to put something together tonight, after I get some
> sleep - 31 hours of uptime _suck_ ;-/

Gosh, yes.

Thanks,
Miklos
