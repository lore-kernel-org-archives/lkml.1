Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbYB2Dfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbYB2Dfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 22:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbYB2Dfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 22:35:40 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:43611 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753977AbYB2Dfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 22:35:39 -0500
X-Sasl-enc: U5ghFOqrdF2CtDBRnSdx+7bMHxmscJnLpa96d/XnQM+F 1204256136
Subject: Re: [PATCH 3/4] autofs4 - track uid and gid of last mount requestor
From: Ian Kent <raven@themaw.net>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20080228195118.GA16634@sergelap.austin.ibm.com>
References: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
	 <Pine.LNX.4.64.0802261208400.8490@raven.themaw.net>
	 <20080227204546.72e16e8d.akpm@linux-foundation.org>
	 <1204179747.3501.21.camel@raven.themaw.net>
	 <20080227223734.caab0165.akpm@linux-foundation.org>
	 <1204182500.3501.49.camel@raven.themaw.net>
	 <20080227232339.af6e904a.akpm@linux-foundation.org>
	 <1204185623.3501.84.camel@raven.themaw.net>
	 <x494pbtxaup.fsf@segfault.boston.devel.redhat.com>
	 <20080228195118.GA16634@sergelap.austin.ibm.com>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 12:32:12 +0900
Message-Id: <1204255932.3969.86.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 13:51 -0600, Serge E. Hallyn wrote:
> Quoting Jeff Moyer (jmoyer@redhat.com):
> > Ian Kent <raven@themaw.net> writes:
> > 
> > > On Wed, 2008-02-27 at 23:23 -0800, Andrew Morton wrote:
> > >> On Thu, 28 Feb 2008 16:08:20 +0900 Ian Kent <raven@themaw.net> wrote:
> > >> > which includes the process uid and gid, and as part of
> > >> > the lookup we set macros for several mount map substitution variables,
> > >> > derived from the uid and gid of the process requesting the mount and
> > >> > they can be used within autofs maps.
> > >> 
> > >> yeah, could be a problem.  Hopefully the namespace people can advise. 
> > >> Perhaps we need a concept of an exportable-to-userspace namespace-id+uid,
> > >> namespace-id+gid, namespace-id+pid, etc for this sort of thing.  It has
> > >> come up before.  Recently, but I forget what the context was.
> > >
> > > I'm all ears to any feedback from others on this, please.
> > 
> > I think there is some confusion surrounding what the UID and GID are
> > used for in this context.  I'll try to explain it as best I can.
> > 
> > When the automount daemon parses a map entry, it will do some amount of
> > variable substitution.  So, let's say you're running on an i386 box, and
> > you want to mount a library directory from a server.  You might have a
> > map entry that looks like this:
> > 
> > lib	server:/export/$ARCH/lib
> > 
> > In this case, the automount daemon will replace $ARCH with i386, and
> > will try the following mount command:
> > 
> > mount -t nfs server:/export/i386/lib /automountdir/lib
> > 
> > There are cases where it would be helpful to use the requesting
> > process's UID in such a variable substitution.  Consider the case of a
> > CIFS share, where the automount daemon runs as user root, but we want to
> > mount the share using the credentials of the requesting user.  In this
> > case, the UID and GID can be helpful in formatting the mount options for
> > mounting the share.
> > 
> > So, the UID and GID are used only for map substitutions.  Now, having
> > said all of that, I'll have to look more closely at why we even need to
> > keep track of it, given that it only needs to be used when performing
> > the lookup, and at that time we have information on the requesting UID
> > and GID.
> 
> Thanks Jeff.  If that's the case then user namespaces don't affect this
> at all.

Yep, that's precisely the way this is used, by autofs anyway.

I guess the problem we face is that since this is a public interface
other applications could use this in a different way and we can't
control that. I think I need more information so I can document the
defined usage in my revised patch set.

In version 5 I set $UID, $GID, $USER, $GROUP and $HOME in addition to
the standard autofs macros, $ARCH, $CPU, $HOST, $OSNAME, $OSREL and
$OSVERS, and then expand the map entry.

The question that Jeff is asking himself is, why do we need this
information when we re-connect at startup, since the mounts are already
present.

The answer isn't easy to explain and will be lengthy, sorry, but let me
try anyway.

There are two types on maps, direct (in the module source you will see a
third type called an offset, which is just a direct mount in disguise)
and indirect.

For example, here is master map with direct and indirect map entries:

/-	/etc/auto.direct
/test	/etc/auto.indirect

/etc/auto.direct:

/automount/dparse/g6  budgie:/autofs/export1
/automount/dparse/g1  shark:/autofs/export1
and so on.

/etc/auto.indirect:

g1    shark:/autofs/export1
g6    budgie:/autofs/export1
and so on.

For the above indirect map an autofs file system is mounted on /test and
mounts are triggered by the inode lookup operation. So we see a mount of
shark:/autofs/export1 on /test/g1, for example.

The way that direct mounts are handled is by makeing an autofs mount on
each full path, such as /automount/dparse/g1, and using it as a mount
trigger. So when we walk on the path we mount shark:/autofs/export1 on
top of this mount point, for example. Since these are always a
directories we can use the follow_link inode operation to trigger the
mount.

But, each entry in direct and indirect maps can have offsets (often
called multi-mount map entries).

For example, 

a direct mount map entry could also be:

/automount/dparse/g1 \
    /       shark:/autofs/export5/testing/test \
    /s1     shark:/autofs/export/testing/test/s1 \
    /s2     shark:/autofs/export5/testing/test/s2 \
    /s1/ss1 shark:/autofs/export2 \
    /s2/ss2 shark:/autofs/export2

and a similar indirect mount:

g1    \  
   /        shark:/autofs/export5/testing/test \
   /s1      shark:/autofs/export/testing/test/s1 \
   /s2      shark:/autofs/export5/testing/test/s2 \
   /s1/ss1  shark:/autofs/export1 \
   /s2/ss2  shark:/autofs/export2

One of the issues with version 4 of autofs was that, when mounting an
entry with a large number of offsets, possibly with nesting, we needed
to mount and umount all of them as a single unit. Not really a problem,
except for people with a large number of offsets in map entries. This
mechanism is used for the well known "hosts" map and we have seen cases
(in 2.4) where the available number of mounts are exhausted or where the
number of privileged ports available is exhausted.

In version 5 we mount only as we go down the tree of offsets and
similarly for expiring them which resolves the above problem. There is
somewhat more detail to the implementation but it isn't needed for the
sake of the explanation. The one important detail is that these offsets
are implemented using the same mechanism as the direct mounts above and
so can also be covered by another mount.

To be able to do this I need to maintain context. In the daemon I use a
list to represent these offsets and use it to manage the mounting and
expiration of the mount tree, something which can only be discovered
from the original map entry. So, to rebuild this context at startup for
existing mounts I need to do the lookup to get the map entry as part of
the process of re-connecting to the mounts. Hence the need to get the
uid and gid of the original requester.

Few, that was hard work, just for those last couple of sentences.

Please, lets not go into the issue that the maps can change during a
restart, that's an issue for another time and isn't a kernel issue
anyway. 

> 
> (Still trying to follow the rest of the thread bc i definately feel like
> I'm missing something.  I swear I understood autofs 10+ years ago :)

Me too, but now I've change it so much even I'm confused most of the
time, ;)

Hopefully the above explanation is useful in some small way.

Ian


