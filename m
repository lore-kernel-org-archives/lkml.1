Return-Path: <linux-kernel-owner+w=401wt.eu-S965536AbXDVILZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965536AbXDVILZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 04:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965544AbXDVILY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 04:11:24 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:44082 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965525AbXDVILW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 04:11:22 -0400
To: ebiederm@xmission.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
In-reply-to: <m1ps5w26rz.fsf@ebiederm.dsl.xmission.com>
Subject: Re: [patch 1/8] add user mounts to the kernel
References: <20070420102532.385211890@szeredi.hu>
	<20070420102624.975879175@szeredi.hu>
	<m1wt05kgy8.fsf@ebiederm.dsl.xmission.com>
	<E1HfW5I-00044y-00@dorka.pomaz.szeredi.hu> <m1ps5w26rz.fsf@ebiederm.dsl.xmission.com>
Message-Id: <E1HfX4D-0004H9-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 22 Apr 2007 10:05:05 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> > +	if (mnt->mnt_flags & MNT_USER)
> >> > +		seq_printf(m, ",user=%i", mnt->mnt_uid);
> >> How about making the test "if (mnt->mnt_user != &root_user)"
> >
> > We don't want to treat root_user special.  That's what capabilities
> > were invented for.
> 
> For the print statement?  What ever it is minor.

It is a user interface, not a print statement.  Your suggested change
would be vetoed by any number of people.  

So either we have all mounts having owners, AND have /proc/mounts add
"user=0" to all mounts.  While I don't _think_ this would actually
break userspace, it would definitely make people complain.

The other choice is what the current patchset does: is to have
"legacy" mounts without owners, and "new generation" mounts with
owners having "user=UID" in /proc/mounts, regardless of the value of
UID.

> So I want to minimize the changes needed to existing programs.
> Now if all we have to do is specify MS_SETUSER when root a
> user with CAP_SETUID is setting up a mount as a user other
> then himself then I don't much care.  If we have to call MS_SETUSER
> as unprivileged users

You don't.  Unprivileged mounts _imply_ MS_SETUSER.

> >> > +
> >> > +	uid_t mnt_uid;			/* owner of the mount */
> >> 
> >> Can we please make this a user struct.   That requires a bit of
> >> reference counting but it has uid namespace benefits as well
> >> as making it easy to implement per user mount rlimits.
> >
> > OK, can you ellaborate, what the uid namespace benifits are?
> 
> In the uid namespace the comparison is simpler as are the propagations
> rules.  Basically if you use a struct user you will never need to
> care about a uid namespace.  If you don't we will have to tear through
> this code another time.

Well, OK.  I'll do the user_struct thing then.

Miklos
