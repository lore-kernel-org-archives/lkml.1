Return-Path: <linux-kernel-owner+w=401wt.eu-S1030284AbXDQO3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030284AbXDQO3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 10:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030187AbXDQO3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 10:29:08 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48085 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbXDQO3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 10:29:05 -0400
Date: Tue, 17 Apr 2007 09:28:45 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk,
       containers@lists.osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Devel] Re: [patch 05/10] add "permit user mounts in new namespace" clone flag
Message-ID: <20070417142845.GG1442@sergelap.austin.ibm.com>
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
> 
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

There is a sysctl for max_user_mounts which can be set to 0.

So a simple on/off sysctl is unnecessary, but given that admins might
wonder whether 0 means infinite :), and I agree on/off is important, a
second one wouldn't hurt.

> Am I correct or will it be more difficult than just a little pam
> module to ensure non-trusted users never run in the initial mount
> namespace?
> 
> Eric
