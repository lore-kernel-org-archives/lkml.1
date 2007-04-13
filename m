Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbXDMOGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbXDMOGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 10:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbXDMOGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 10:06:40 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:48144 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbXDMOGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 10:06:38 -0400
To: serue@us.ibm.com
CC: linuxram@us.ibm.com, serue@us.ibm.com, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, containers@lists.osdl.org,
       util-linux-ng@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20070413132832.GA1483@sergelap.austin.ibm.com>
	(serue@us.ibm.com)
Subject: Re: [patch 0/8] unprivileged mount syscall
References: <20070406160238.f3178189.akpm@linux-foundation.org> <E1Ha4cN-0004rc-00@dorka.pomaz.szeredi.hu> <20070409143802.GB4891@sergelap.austin.ibm.com> <E1Hawf4-0000E7-00@dorka.pomaz.szeredi.hu> <20070409170743.GF24415@sergelap.austin.ibm.com> <E1Hb0CH-0000nX-00@dorka.pomaz.szeredi.hu> <1176194285.2903.67.camel@ram.us.ibm.com> <E1HbaJV-00059N-00@dorka.pomaz.szeredi.hu> <1176316116.2811.39.camel@ram.us.ibm.com> <E1HcKQd-0001yO-00@dorka.pomaz.szeredi.hu> <20070413132832.GA1483@sergelap.austin.ibm.com>
Message-Id: <E1HcMOq-0002As-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 13 Apr 2007 16:05:16 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Thinking a bit more about this, I'm quite sure most users wouldn't
> > even want private namespaces.  It would be enough to
> > 
> >   chroot /share/$USER
> > 
> > and be done with it.
> > 
> > Private namespaces are only good for keeping a bunch of mounts
> > referenced by a group of processes.  But my guess is, that the natural
> > behavior for users is to see a persistent set of mounts.
> > 
> > If for example they mount something on a remote machine, then log out
> > from the ssh session and later log back in, they would want to see
> > their previous mount still there.
> > 
> > Miklos
> 
> Agreed on desired behavior, but not on chroot sufficing.  It actually
> sounds like you want exactly what was outlined in the OLS paper.
> 
> Users still need to be in a different mounts namespace from the admin
> user so long as we consider the deluser and backup problems

I don't think it matters, because /share/$USER duplicates a part or
the whole of the user's namespace.

So backup would have to be taught about /share anyway, and deluser
operates on /home/$USER and not on /share/*, so there shouldn't be any
problem.

There's actually very little difference between rbind+chroot, and
CLONE_NEWNS.  In a private namespace:

  1) when no more processes reference the namespace, the tree will be
    disbanded

  2) the mount tree won't be accessible from outside the namespace

Wanting a persistent namespace contradicts 1).

Wanting a per-user (as opposed to per-session) namespace contradicts
2).  The namespace _has_ to be accessible from outside, so that a new
session can access/copy it.

So both requirements point to the rbind/chroot solution.

Miklos
