Return-Path: <linux-kernel-owner+w=401wt.eu-S1031479AbXDZT62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031479AbXDZT62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031477AbXDZT62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:58:28 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:39018 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031473AbXDZT60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:58:26 -0400
To: serue@us.ibm.com
CC: miklos@szeredi.hu, serge@hallyn.com, hpa@zytor.com, linuxram@us.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       linux-security-module@vger.kernel.org, ebiederm@xmission.com,
       viro@ftp.linux.org.uk, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
In-reply-to: <20070426194225.GA11038@sergelap.austin.ibm.com>
	(serue@us.ibm.com)
Subject: Re: [patch] unprivileged mounts update
References: <20070425172012.GA20336@sergelap.austin.ibm.com> <m1k5w0s5y0.fsf@ebiederm.dsl.xmission.com> <20070425175609.GB20165@vino.hallyn.com> <m1647ks3dm.fsf@ebiederm.dsl.xmission.com> <20070425185244.GA20688@vino.hallyn.com> <E1HgnFH-0006gR-00@dorka.pomaz.szeredi.hu> <20070426145733.GA10078@sergelap.austin.ibm.com> <E1Hh5oQ-0000w1-00@dorka.pomaz.szeredi.hu> <20070426161929.GA6439@sergelap.austin.ibm.com> <E1Hh6qi-0002LI-00@dorka.pomaz.szeredi.hu> <20070426194225.GA11038@sergelap.austin.ibm.com>
Message-Id: <E1HhA4o-0002yi-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 26 Apr 2007 21:56:26 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Miklos Szeredi (miklos@szeredi.hu):
> > > So then as far as you're concerned, the patches which were in -mm will
> > > remain unchanged?
> > 
> > Basically yes. I've merged the update patch, which was not yet added
> > to -mm, did some cosmetic code changes, and updated the patch headers.
> > 
> > There's one open point, that I think we haven't really explored, and
> > that is the propagation semantics.  I think you had the idea, that a
> > propagated mount should inherit ownership from the parent into which
> > it was propagated.
> 
> Don't think that was me.  I stayed out of those early discussions
> because I wasn't comfortable guessing at the proper semantics yet.

Yes, sorry, it was Eric's suggestion.

> But really, I, as admin, have to set up both propagation and user mounts
> for a particular subtree, so why would I *not* want user mounts to be
> propagated?
> 
> So, in my own situation, I have done
> 
> 	make / rshared
> 	mount --bind /share /share
> 	make /share unbindable
> 	for u in $users; do
> 		mount --rbind / /share/$u/root
> 		make /share/$u/root rslave
> 		make /share/$u/root rshared
> 		mount --bind -o user=$u /share/$u/root/home/$u /share/$u/root/home/$u
> 	done
> 
> All users get chrooted into /share/$USER/root, some also get their own
> namespace.  Clearly if a user in a new namespace does
> 
> 	mount --bind -o user=me ~/somedir ~/otherdir
> 
> then logs out, and logs back in, I want the ~/otherdir in the new
> namespace (and the one in the 'init' namespace) to also be owned by
> 'me'.
> 
> > That sounds good if everyone agrees?
> 
> I've shown where I think propagating the mount owner is useful.  Can you
> detail a scenario where doing so would be bad?  Then we can work toward
> semantics that make sense...

But in your example, the "propagated mount inherits ownership from
parent mount" would also work, since in all namespaces the owner of
the parent would necessary be "me".

The "inherits parent" semantics would work better for example in the
"all nosuid" namespace, where the user is free to modify it's mount
namespace. 

If for example propagation is set up from the initial namespace to
this user's namespace and a new mount is added to the initial
namespace, it would be nice if the propagated new mount would also be
owned by the user (and be "nosuid" of course).

Does the above make sense?  I'm not sure I've explained clearly
enough.

Miklos
