Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbXDJIjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbXDJIjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 04:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbXDJIjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 04:39:37 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43729 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbXDJIjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 04:39:35 -0400
Subject: Re: [patch 0/8] unprivileged mount syscall
From: Ram Pai <linuxram@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serue@us.ibm.com, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1Hb0CH-0000nX-00@dorka.pomaz.szeredi.hu>
References: <20070404183012.429274832@szeredi.hu>
	 <20070406160238.f3178189.akpm@linux-foundation.org>
	 <E1Ha4cN-0004rc-00@dorka.pomaz.szeredi.hu>
	 <20070409143802.GB4891@sergelap.austin.ibm.com>
	 <E1Hawf4-0000E7-00@dorka.pomaz.szeredi.hu>
	 <20070409170743.GF24415@sergelap.austin.ibm.com>
	 <E1Hb0CH-0000nX-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Tue, 10 Apr 2007 01:38:04 -0700
Message-Id: <1176194285.2903.67.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-09 at 22:10 +0200, Miklos Szeredi wrote:
> > > The one in pam-0.99.6.3-29.1 in opensuse-10.2 is totally broken.  Are
> > > you interested in the details?  I can reproduce it, but forgot to note
> > > down the details of the brokenness.
> > 
> > I don't know how far removed that is from the one being used by redhat,
> > but assuming it's the same, then redhat-lspp@redhat.com will be
> > very interested.
> 
> OK.
> 
> > >  - user namespace setup: what if user has multiple sessions?
> > > 
> > >    1) namespaces are shared?  That's tricky because the session needs to
> > >    be a child of a namespace server, not of login.  I'm not sure PAM
> > >    can handle this
> > > 
> > >    2) or mounts are copied on login?  That's not possible currently,
> > >    as there's no way to send a mount between namespaces.  Also it's
> > >    tricky to make sure that new mounts are also shared
> > 
> > See toward the end of the 'shared subtrees' OLS paper from last year for
> > a suggestion on how to let users effectively 'log in to' an existing
> > private mounts ns.
> 
> This?
> 
>   1. create a new namespace
>   2. bind /share/$USER to /share
>   3. for each pair ($who, $what) such that
>      /share/$USER/$who/$what exists, look
>      in /share/$who/allowed for "peer $what
>      $USER" or "slave $what $USER". If the
>      former is found, rbind /share/$who/$what
>      on /share/$USER/$who/$what; if the
>      latter is found, do the same and
>      follow with marking subtree under
>      /share/$USER/$who/$what as slave.
>   4. rbind /share/$USER to /share
>   5. mark subtree under /share as private.
>   6. umount -l /share
> 
> Well, someone please explain using short words, because I don't
> understand at all.

I am trying to re-construct Viro's thoughts.  I think the steps outlined
above; though not accurate, are still insightful.

The idea is -- there is one master namespace, which has
under /share, a replica of the mount tree of namespaces belonging to all
users. 

for example if there are two users A and B, then in the master namespace
under /share you will find /share/A and /share/B, each reflecting the
mount tree for the namespaces belonging to user-A and user-B
respectively. 

Note: /share is a shared mount-tree, which means it can propagate mount
events.

Everytime the user logs on the machine, a new namespace is created which
is the clone of the master namespace. In this new namespace,
the /share/$user is made the root of the namespace. Also if other
users have allowed part of their namespace available to this user,
than those mounts are also brought under this namespace. And finally the
entire tree under /share is unmounted.

Note, though multiple namespaces can exist simultaneously for the same
user, the user is provided the illusion of per-process-namespace since
all the namespaces look identical.  

I am trying to rewrite the steps outlined above, which may or may not
reflect Viro's thoughts, but certainly reflect my reconstruction of
viro's thoughts.

1. clone the master namespace.

2. in the new namespace

	move the tree under /share/$me to /
        for each ($user, $what, $how) {
            move /share/$user/$what to /$what
	    if ($how == slave) {
                 make the mount tree under /$what as slave
            }
        }
        
3. in the new namespace make the tree under 
       /share as private and unmount /share
                      
             
           
RP


> 
> Thanks,
> Miklos

