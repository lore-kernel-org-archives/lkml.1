Return-Path: <linux-kernel-owner+w=401wt.eu-S1030864AbXDUMzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030864AbXDUMzv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 08:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030973AbXDUMzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 08:55:51 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52124 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030864AbXDUMzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 08:55:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, serue@us.ibm.com,
       viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [patch 2/8] allow unprivileged umount
References: <20070420102532.385211890@szeredi.hu>
	<20070420102626.825263599@szeredi.hu>
	<20070421005506.6a315bec.akpm@linux-foundation.org>
	<E1HfAf8-0002Ky-00@dorka.pomaz.szeredi.hu>
	<20070421013622.1f2a7d00.akpm@linux-foundation.org>
Date: Sat, 21 Apr 2007 06:53:58 -0600
In-Reply-To: <20070421013622.1f2a7d00.akpm@linux-foundation.org> (Andrew
	Morton's message of "Sat, 21 Apr 2007 01:36:22 -0700")
Message-ID: <m11widlwgp.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Sat, 21 Apr 2007 10:09:42 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> > > +static bool permit_umount(struct vfsmount *mnt, int flags)
>> > > +{
>> > >
>> > > ...
>> > >
>> > > +	return mnt->mnt_uid == current->uid;
>> > > +}
>> > 
>> > Yes, this seems very wrong.  I'd have thought that comparing user_struct*'s
>> > would get us a heck of a lot closer to being able to support aliasing of
>> > UIDs between different namespaces.
>> > 
>> 
>> OK, I'll fix this up.
>> 
>> Actually an earlier version of this patch did use user_struct's but
>> I'd changed it to uids, because it's simpler.
>
> OK..
>
>>  I didn't think about
>> this being contrary to the id namespaces thing.
>
> Well I was madly assuming that when serarate UID namespaces are in use, UID
> 42 in container A will have a different user_struct from UID 42 in
> container B.  I'd suggest that we provoke an opinion from Eric & co before
> you do work on this.

That is what I what I have been thinking as well, storing a user
struct on each mount point seems sane, plus it allows per user mount
rlimits which is major plus.  Especially since we seem to be doing
accounting only for user mounts a per user rlimit seems good.

To get the user we should be user fs_uid as HPA suggested.

Finally I'm pretty certain the capability we should care about in
this context is CAP_SETUID.  Instead of CAP_SYS_ADMIN.

If we have CAP_SETUID we can become which ever user owns the mount,
and the root user in a container needs this, so he can run login
programs.  So changing the appropriate super user checks from
CAP_SYS_ADMIN to CAP_SETUID I think is the right thing todo.

With the CAP_SETUID thing handled I'm not currently seeing any adverse
implications to using this in containers.

Ok.  Now that I have a reasonable approximation of the 10,000 foot
view now to see how the patches match up.

Eric


