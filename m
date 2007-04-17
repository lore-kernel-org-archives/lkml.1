Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbXDQOZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbXDQOZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 10:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbXDQOZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 10:25:36 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38898 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbXDQOZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 10:25:35 -0400
Date: Tue, 17 Apr 2007 09:25:19 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk,
       containers@lists.osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Devel] Re: [patch 05/10] add "permit user mounts in new namespace" clone flag
Message-ID: <20070417142519.GF1442@sergelap.austin.ibm.com>
References: <m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com> <1176713221.9488.17.camel@ram.us.ibm.com> <E1HdNZn-0006i9-00@dorka.pomaz.szeredi.hu> <1176716941.9488.57.camel@ram.us.ibm.com> <E1HdNwV-0006l2-00@dorka.pomaz.szeredi.hu> <m18xcsl3yc.fsf@ebiederm.dsl.xmission.com> <E1HdTag-0007bd-00@dorka.pomaz.szeredi.hu> <m1zm58jfj3.fsf@ebiederm.dsl.xmission.com> <20070416195652.GA350@sergelap.austin.ibm.com> <m1k5wbjrsh.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1k5wbjrsh.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serue@us.ibm.com> writes:
> >> 
> >> Why are directory permissions not sufficient to allow/deny non-priveleged
> > mounts?
> >> I don't understand that contention yet.
> >
> > The same scenarios laid out previously in this thread.  I.e.
> >
> > 1. user hallyn does mount --bind / /home/hallyn/root
> > 2. (...)
> > 3. admin does "deluser hallyn"
> >
> > and deluser starts wiping out root
> >
> > Or,
> >
> > 1. user hallyn does mount --bind / /home/hallyn/root
> > 2. backup daemon starts backing up /home/hallyn/root/home/hallyn/root/home...
> >
> > So we started down the path of forcing users to clone a new namespace
> > before doing user mounts, which is what the clone flag was about.  Using
> > per-mount flags also suffices as you had pointed out, which is being
> > done here.  But directory permissions are inadequate.
> 
> Interesting....
> 
> So far even today these things can happen, however they are sufficiently
> unlikely the tools don't account for them.
> 
> Once a hostile user can cause them things are more of a problem.
> 
> > (Unless you want to tackle each problem legacy tool one at a time to
> > remove problems - i.e. deluser should umount everything under
> > /home/hallyn before deleting, backup should be spawned from it's own
> > namespace cloned right after boot or just back up on one filesystem,
> > etc.)
> 
> I don't see a way that backup and deluser won't need to be modified
> to work properly in a system where non-priveleged mounts are allowed,
> at least they will need to account for /share.

Yes, all the tools need to avoid /share.  Though at least it's a single
location we can avoid, and it is purely a system configuration issue,
whereas fixing deluser to watch for user mounts under /home involves (I
assume) rewriting a part of it.

> That said it is clearly a hazard if we enable this functionality by
> default.
> 
> If we setup a pam module that triggers on login and perhaps when
> cron and at jobs run to setup an additional mount namespace I think
> keeping applications locked away in their own mount namespace is
> sufficient to avoid hostile users from doing unexpected things to
> the initial mount namespace.  So unless I am mistake it should be
> relatively simple to prevent user space from encountering problems.
> 
> That still leaves the question of how we handle systems with an old
> user space that is insufficiently robust to deal with mounts occurring
> at unexpected locations.
> 
> 
>   I think a simple sysctl to enable/disable of non-priveleged mounts 
>   defaulting to disabled is enough.
> 
> Am I correct or will it be more difficult than just a little pam
> module to ensure non-trusted users never run in the initial mount
> namespace?

The danger with relying on the pam module is that you have to plug it in
all the right places.  For instance, if we're talking about malicious
users, now we have to start worrying about an ftp daemon with user login
that isn't using pam, and happens to have an exploitable bug.

So it seems to me the per-mount flag you suggested really is the best
solution.  Now the pam module is still needed, but only to set things up
so that the user *can* do user mounts.  If there's a way to login
bypassing the pam module, then the user simply won't be able to do user
mounts anywhere but under /share, and as Miklos suggested the perms on
share can probably be set to 000.

-serge
