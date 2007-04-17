Return-Path: <linux-kernel-owner+w=401wt.eu-S1031230AbXDQRIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031230AbXDQRIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031231AbXDQRIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:08:06 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:56850 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031224AbXDQRHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:07:55 -0400
Date: Tue, 17 Apr 2007 12:07:37 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linuxram@us.ibm.com, devel@openvz.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, viro@ftp.linux.org.uk,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [Devel] Re: [patch 05/10] add "permit user mounts in new namespace" clone flag
Message-ID: <20070417170737.GA14891@sergelap.austin.ibm.com>
References: <20070412164541.580374744@szeredi.hu> <20070412164620.588752236@szeredi.hu> <20070412203208.GG27772@sergelap.austin.ibm.com> <m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com> <1176713221.9488.17.camel@ram.us.ibm.com> <E1HdNZn-0006i9-00@dorka.pomaz.szeredi.hu> <1176716941.9488.57.camel@ram.us.ibm.com> <E1HdNwV-0006l2-00@dorka.pomaz.szeredi.hu> <1176743669.9488.62.camel@ram.us.ibm.com> <E1HdVLi-0007oe-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HdVLi-0007oe-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> > > > > > Also for bind-mount and remount operations the flag has to be propagated
> > > > > > down its propagation tree.  Otherwise a unpriviledged mount in a shared
> > > > > > mount wont get reflected in its peers and slaves, leading to unidentical
> > > > > > shared-subtrees.
> > > > > 
> > > > > That's an interesting question.  Do we want shared mounts to be
> > > > > totally identical, including mnt_flags?  It doesn't look as if
> > > > > do_remount() guarantees that currently.
> > > > 
> > > > Depends on the semantics of each of the flags. Some flags like of the
> > > > read/write flag, would not interfere with the propagation semantics
> > > > AFAICT.  But this one certainly seems to interfere.
> > > 
> > > That depends.  Current patches check the "unprivileged submounts
> > > allowed under this mount" flag only on the requested mount and not on
> > > the propagated mounts.  Do you see a problem with this?
> > 
> > Don't see a problem if the flag is propagated to all peers and slave
> > mounts. 
> > 
> > If not, I see a problem. What if the propagated mount has its flag set
> > to not do un-priviledged mounts, whereas the requested mount has it
> > allowed?
> 
> Then the mount is allowed.
> 
> It is up to the sysadmin/distro to design set up the propagations in a
> way that this is not a problem.
> 
> I think it would be much less clear conceptually, if unprivileged
> mounting would have to check propagations as well.
> 
> Miklos

I'm a bit lost about what is currently done and who advocates for what.

It seems to me the MNT_ALLOWUSERMNT (or whatever :) flag should be
propagated.  In the /share rbind+chroot example, I assume the admin
would start by doing

	mount --bind /share /share
	mount --make-slave /share
	mount --bind -o allow_user_mounts /share (or whatever)
	mount --make-shared /share

then on login, pam does

	chroot /share/$USER

or some sort of

	mount --bind /share /home/$USER/root
	chroot /home/$USER/root

or whatever.  In any case, the user cannot make user mounts except under
/share, and any cloned namespaces will still allow user mounts.

Or are you guys talking about something else?

-serge
