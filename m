Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbXLKT6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbXLKT6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 14:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbXLKT55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 14:57:57 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:47636 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbXLKT54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 14:57:56 -0500
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
	settings for task actions [try #2]
From: Stephen Smalley <sds@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: David Howells <dhowells@redhat.com>, Karl MacMillan <kmacmill@redhat.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <266601.55481.qm@web36607.mail.mud.yahoo.com>
References: <266601.55481.qm@web36607.mail.mud.yahoo.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 11 Dec 2007 14:56:37 -0500
Message-Id: <1197402998.28006.95.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-12-11 at 11:26 -0800, Casey Schaufler wrote:
> --- Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > On Mon, 2007-12-10 at 14:26 -0800, Casey Schaufler wrote:
> > > --- Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > > 
> > > > On Mon, 2007-12-10 at 21:08 +0000, David Howells wrote:
> > > > > Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > > > > 
> > > > > > Otherwise, only other issue I have with this interface is it won't
> > > > > > generalize to dealing with nfsd, where we want to set the acting
> > context
> > > > > > to a context we obtain from or determine based upon the client.
> > > > > 
> > > > > Are you speaking of security_kernel_act_as() and
> > security_create_files_as()
> > > > > specifically?  Or the task_struct::act_as override pointer in general?
> > > > 
> > > > security_kernel_act_as()
> > > > 
> > > > > I don't really know how nfsd wants to obtain and set its LSM context,
> > so
> > > > it's
> > > > > a bit difficult for me to make something that works for nfsd as well as
> > > > > cachefiles.
> > > > 
> > > > It would get a context from the client or from a local configuration
> > > > that would map security-unaware clients to a default context, and then
> > > > want to assume that context for the particular operation.  No transition
> > > > involved.
> > > 
> > > I would expect that the operation would be more sophisticated
> > > than that. You certainly aren't going to use what comes from
> > > the other side without any processing, and I expect you'll have
> > > some sort of operation on anything you pull from a config file
> > > before you actually apply it.
> > 
> > Yes, that's true - the contexts would be subjected to a permission
> > check.  But that's separable from the act of setting it as the task's
> > acting security state (and needs to be separated, as the precise check
> > will vary depending on the situation - cachefiles is going to apply a
> > different sort of check than nfsd).
> > 
> > > > > > Why can't cachefilesd just push a context into the kernel and pass
> > that
> > > > > > into the hook as the acting context,
> > > > > 
> > > > > How does cachefilesd come up with such a context?  Grab it from
> > > > > /etc/cachefilesd.conf?
> > > > 
> > > > >From a config file whose pathname would be provided by libselinux (ala
> > > > the way in which dbusd imports contexts), or directly as a context
> > > > returned by a libselinux function.  Has to be done that way so that it
> > > > can be set differently for different policy types (strict, targeted,
> > > > mls).
> > > 
> > > Unless you've got an LSM other than SELinux, of course. If
> > > cachefilesd is going to be responsible for maintaining this
> > > magic context there needs to be an LSM interface for it, not
> > > just an SELinux interface.
> > 
> > LSM is an in-kernel interface.  Here we are talking about a userspace
> > interface for obtaining the right security label to use.  There is no
> > equivalent to LSM in userspace as of yet.  Feel free to invent one, but
> > don't ask the rest of us to do it or wait for it to materialize.
> 
> I am much more concerned with the interfaces used to pass the
> information into the kernel. I would expect that to be LSM
> independent, not a call into libselinux that resolves into a
> selinuxfs operation, or it's netlink equivilant. It would be
> unfortunate if the userland/kernel interface became an obstacle
> to cachefiles being adopted.

That wasn't the issue.  The interface to the cachefiles module would
just consist of cachefilesd writing a string label to some pseudo file
tell cachefiles what label to apply as the acting label for operations
performed by cachefiles.  Which isn't SELinux-specific at all.

David was asking though how cachefilesd (the userspace agent) would
obtain such a label to use.  And that may very well be LSM-specific, and
as there is no LSM userspace API, it makes sense for him to invoke a
libselinux function at present.  If a liblsm is later created and
provides a common front-end API (internally dlopen'ing the right shared
library based on some configuration, whether libselinux or libsmack or
whatever), then cachefilesd can instead call the liblsm interface, but
that doesn't exist today.

-- 
Stephen Smalley
National Security Agency

