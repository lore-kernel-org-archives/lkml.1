Return-Path: <linux-kernel-owner+w=401wt.eu-S1030847AbXDMVoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030847AbXDMVoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 17:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030848AbXDMVoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 17:44:19 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52489 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030847AbXDMVoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 17:44:17 -0400
Date: Fri, 13 Apr 2007 16:44:15 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serue@us.ibm.com, linuxram@us.ibm.com, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, containers@lists.osdl.org,
       util-linux-ng@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] unprivileged mount syscall
Message-ID: <20070413214415.GA28629@sergelap.austin.ibm.com>
References: <20070409143802.GB4891@sergelap.austin.ibm.com> <E1Hawf4-0000E7-00@dorka.pomaz.szeredi.hu> <20070409170743.GF24415@sergelap.austin.ibm.com> <E1Hb0CH-0000nX-00@dorka.pomaz.szeredi.hu> <1176194285.2903.67.camel@ram.us.ibm.com> <E1HbaJV-00059N-00@dorka.pomaz.szeredi.hu> <1176316116.2811.39.camel@ram.us.ibm.com> <E1HcKQd-0001yO-00@dorka.pomaz.szeredi.hu> <20070413132832.GA1483@sergelap.austin.ibm.com> <E1HcMOq-0002As-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HcMOq-0002As-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> > > Thinking a bit more about this, I'm quite sure most users wouldn't
> > > even want private namespaces.  It would be enough to
> > > 
> > >   chroot /share/$USER
> > > 
> > > and be done with it.
> > > 
> > > Private namespaces are only good for keeping a bunch of mounts
> > > referenced by a group of processes.  But my guess is, that the natural
> > > behavior for users is to see a persistent set of mounts.
> > > 
> > > If for example they mount something on a remote machine, then log out
> > > from the ssh session and later log back in, they would want to see
> > > their previous mount still there.
> > > 
> > > Miklos
> > 
> > Agreed on desired behavior, but not on chroot sufficing.  It actually
> > sounds like you want exactly what was outlined in the OLS paper.
> > 
> > Users still need to be in a different mounts namespace from the admin
> > user so long as we consider the deluser and backup problems
> 
> I don't think it matters, because /share/$USER duplicates a part or
> the whole of the user's namespace.
> 
> So backup would have to be taught about /share anyway, and deluser
> operates on /home/$USER and not on /share/*, so there shouldn't be any
> problem.

In what I was thinking of, /share/$USER is bind mounted to
~$USER/share, so it would have to be done in a private namespace in
order for deluser to not be tricked.

> There's actually very little difference between rbind+chroot, and
> CLONE_NEWNS.  In a private namespace:
> 
>   1) when no more processes reference the namespace, the tree will be
>     disbanded
> 
>   2) the mount tree won't be accessible from outside the namespace

But it *can* be, if properly set up.  That's part of the point of the
example in the OLS paper.  When a user logs in, sshd clones a new
namespace, then bind-mounts /share/$USER into ~$USER/share.  So assuming
that /share/$USER was --make-shared'd, it and ~$USER are now in the
same peer group, and any changes made by the user under ~$USER will
be reflected back into /share/$USER.

> Wanting a persistent namespace contradicts 1).

Not necessarily, see above.

> Wanting a per-user (as opposed to per-session) namespace contradicts
> 2).  The namespace _has_ to be accessible from outside, so that a new
> session can access/copy it.

Again, I *think* you are wrong that private namespace contradicts this
requirement.

> So both requirements point to the rbind/chroot solution.

It all points to a combination of the two  :-)

-serge
