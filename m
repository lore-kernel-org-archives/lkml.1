Return-Path: <linux-kernel-owner+w=401wt.eu-S1031349AbXDZTmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031349AbXDZTmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031401AbXDZTmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:42:31 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:57754 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031395AbXDZTm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:42:29 -0400
Date: Thu, 26 Apr 2007 14:42:25 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serge@hallyn.com, hpa@zytor.com, linuxram@us.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       linux-security-module@vger.kernel.org, ebiederm@xmission.com,
       viro@ftp.linux.org.uk, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch] unprivileged mounts update
Message-ID: <20070426194225.GA11038@sergelap.austin.ibm.com>
References: <20070425172012.GA20336@sergelap.austin.ibm.com> <m1k5w0s5y0.fsf@ebiederm.dsl.xmission.com> <20070425175609.GB20165@vino.hallyn.com> <m1647ks3dm.fsf@ebiederm.dsl.xmission.com> <20070425185244.GA20688@vino.hallyn.com> <E1HgnFH-0006gR-00@dorka.pomaz.szeredi.hu> <20070426145733.GA10078@sergelap.austin.ibm.com> <E1Hh5oQ-0000w1-00@dorka.pomaz.szeredi.hu> <20070426161929.GA6439@sergelap.austin.ibm.com> <E1Hh6qi-0002LI-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Hh6qi-0002LI-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> > So then as far as you're concerned, the patches which were in -mm will
> > remain unchanged?
> 
> Basically yes. I've merged the update patch, which was not yet added
> to -mm, did some cosmetic code changes, and updated the patch headers.
> 
> There's one open point, that I think we haven't really explored, and
> that is the propagation semantics.  I think you had the idea, that a
> propagated mount should inherit ownership from the parent into which
> it was propagated.

Don't think that was me.  I stayed out of those early discussions
because I wasn't comfortable guessing at the proper semantics yet.

But really, I, as admin, have to set up both propagation and user mounts
for a particular subtree, so why would I *not* want user mounts to be
propagated?

So, in my own situation, I have done

	make / rshared
	mount --bind /share /share
	make /share unbindable
	for u in $users; do
		mount --rbind / /share/$u/root
		make /share/$u/root rslave
		make /share/$u/root rshared
		mount --bind -o user=$u /share/$u/root/home/$u /share/$u/root/home/$u
	done

All users get chrooted into /share/$USER/root, some also get their own
namespace.  Clearly if a user in a new namespace does

	mount --bind -o user=me ~/somedir ~/otherdir

then logs out, and logs back in, I want the ~/otherdir in the new
namespace (and the one in the 'init' namespace) to also be owned by
'me'.

> That sounds good if everyone agrees?

I've shown where I think propagating the mount owner is useful.  Can you
detail a scenario where doing so would be bad?  Then we can work toward
semantics that make sense...

-serge
