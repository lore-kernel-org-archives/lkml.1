Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbXDOUlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbXDOUlB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 16:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbXDOUlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 16:41:00 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:49580 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbXDOUk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 16:40:59 -0400
To: serue@us.ibm.com
CC: miklos@szeredi.hu, serue@us.ibm.com, linuxram@us.ibm.com,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20070413214415.GA28629@sergelap.austin.ibm.com>
	(serue@us.ibm.com)
Subject: Re: [patch 0/8] unprivileged mount syscall
References: <20070409143802.GB4891@sergelap.austin.ibm.com> <E1Hawf4-0000E7-00@dorka.pomaz.szeredi.hu> <20070409170743.GF24415@sergelap.austin.ibm.com> <E1Hb0CH-0000nX-00@dorka.pomaz.szeredi.hu> <1176194285.2903.67.camel@ram.us.ibm.com> <E1HbaJV-00059N-00@dorka.pomaz.szeredi.hu> <1176316116.2811.39.camel@ram.us.ibm.com> <E1HcKQd-0001yO-00@dorka.pomaz.szeredi.hu> <20070413132832.GA1483@sergelap.austin.ibm.com> <E1HcMOq-0002As-00@dorka.pomaz.szeredi.hu> <20070413214415.GA28629@sergelap.austin.ibm.com>
Message-Id: <E1HdBVc-0005pL-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 15 Apr 2007 22:39:40 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Agreed on desired behavior, but not on chroot sufficing.  It actually
> > > sounds like you want exactly what was outlined in the OLS paper.
> > > 
> > > Users still need to be in a different mounts namespace from the admin
> > > user so long as we consider the deluser and backup problems
> > 
> > I don't think it matters, because /share/$USER duplicates a part or
> > the whole of the user's namespace.
> > 
> > So backup would have to be taught about /share anyway, and deluser
> > operates on /home/$USER and not on /share/*, so there shouldn't be any
> > problem.
> 
> In what I was thinking of, /share/$USER is bind mounted to
> ~$USER/share, so it would have to be done in a private namespace in
> order for deluser to not be tricked.

But /share/$USER is surely not bind mounted to ~$USER/share in the
_global_ namespace, is it?  I can't see any sense in that.

> > There's actually very little difference between rbind+chroot, and
> > CLONE_NEWNS.  In a private namespace:
> > 
> >   1) when no more processes reference the namespace, the tree will be
> >     disbanded
> > 
> >   2) the mount tree won't be accessible from outside the namespace
> 
> But it *can* be, if properly set up.  That's part of the point of the
> example in the OLS paper.  When a user logs in, sshd clones a new
> namespace, then bind-mounts /share/$USER into ~$USER/share.  So assuming
> that /share/$USER was --make-shared'd, it and ~$USER are now in the
> same peer group, and any changes made by the user under ~$USER will
> be reflected back into /share/$USER.

I acknowledge, that it can be done.  My point was that it can be done
more simply _without_ using CLONE_NS.

> > Wanting a persistent namespace contradicts 1).
> 
> Not necessarily, see above.
> 
> > Wanting a per-user (as opposed to per-session) namespace contradicts
> > 2).  The namespace _has_ to be accessible from outside, so that a new
> > session can access/copy it.
> 
> Again, I *think* you are wrong that private namespace contradicts this
> requirement.

I'm not saying there's any contradiction, I'm saying rbind+chroot is a
better fit.

I haven't yet heard a single reason why a per-session namespace with
parts shared per-user is better than just a per-user namespace.

Miklos
