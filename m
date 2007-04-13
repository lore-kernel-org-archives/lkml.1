Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbXDMN2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbXDMN2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 09:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbXDMN2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 09:28:36 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:33013 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbXDMN2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 09:28:34 -0400
Date: Fri, 13 Apr 2007 08:28:32 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linuxram@us.ibm.com, serue@us.ibm.com, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, containers@lists.osdl.org,
       util-linux-ng@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] unprivileged mount syscall
Message-ID: <20070413132832.GA1483@sergelap.austin.ibm.com>
References: <20070406160238.f3178189.akpm@linux-foundation.org> <E1Ha4cN-0004rc-00@dorka.pomaz.szeredi.hu> <20070409143802.GB4891@sergelap.austin.ibm.com> <E1Hawf4-0000E7-00@dorka.pomaz.szeredi.hu> <20070409170743.GF24415@sergelap.austin.ibm.com> <E1Hb0CH-0000nX-00@dorka.pomaz.szeredi.hu> <1176194285.2903.67.camel@ram.us.ibm.com> <E1HbaJV-00059N-00@dorka.pomaz.szeredi.hu> <1176316116.2811.39.camel@ram.us.ibm.com> <E1HcKQd-0001yO-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HcKQd-0001yO-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> > On Wed, 2007-04-11 at 12:44 +0200, Miklos Szeredi wrote:
> > > > 1. clone the master namespace.
> > > > 
> > > > 2. in the new namespace
> > > > 
> > > > 	move the tree under /share/$me to /
> > > >         for each ($user, $what, $how) {
> > > >             move /share/$user/$what to /$what
> > > > 	    if ($how == slave) {
> > > >                  make the mount tree under /$what as slave
> > > >             }
> > > >         }
> > > >         
> > > > 3. in the new namespace make the tree under 
> > > >        /share as private and unmount /share
> > > 
> > > Thanks.  I get the basic idea now: the namespace itself need not be
> > > shared between the sessions, it is enough if "share" propagation is
> > > set up between the different namespaces of a user.
> > > 
> > > I don't yet see either in your or Viro's description how the trees
> > > under /share/$USER are initialized.  I guess they are recursively
> > > bound from /, and are made slaves.
> > 
> > yes. I suppose, when a userid is created one of the steps would be
> > 
> > mount --rbind / /share/$USER
> > mount --make-rslave /share/$USER
> > mount --make-rshared /share/$USER
> 
> Thinking a bit more about this, I'm quite sure most users wouldn't
> even want private namespaces.  It would be enough to
> 
>   chroot /share/$USER
> 
> and be done with it.
> 
> Private namespaces are only good for keeping a bunch of mounts
> referenced by a group of processes.  But my guess is, that the natural
> behavior for users is to see a persistent set of mounts.
> 
> If for example they mount something on a remote machine, then log out
> from the ssh session and later log back in, they would want to see
> their previous mount still there.
> 
> Miklos

Agreed on desired behavior, but not on chroot sufficing.  It actually
sounds like you want exactly what was outlined in the OLS paper.

Users still need to be in a different mounts namespace from the admin
user so long as we consider the deluser and backup problems to be
legitimate problems (well, so long as user mounts are allowed).  So,
when they log in, pam gives them a new namespace and chroots them into
/share/$USER.

Assuming I'm thinking clearly  :)

-serge
