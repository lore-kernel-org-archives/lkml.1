Return-Path: <linux-kernel-owner+w=401wt.eu-S1761277AbYB1ROa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761277AbYB1ROa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 12:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbYB1ROU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 12:14:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181AbYB1ROR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 12:14:17 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 3/4] autofs4 - track uid and gid of last mount requestor
References: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
	<Pine.LNX.4.64.0802261208400.8490@raven.themaw.net>
	<20080227204546.72e16e8d.akpm@linux-foundation.org>
	<1204179747.3501.21.camel@raven.themaw.net>
	<20080227223734.caab0165.akpm@linux-foundation.org>
	<1204182500.3501.49.camel@raven.themaw.net>
	<20080227232339.af6e904a.akpm@linux-foundation.org>
	<1204185623.3501.84.camel@raven.themaw.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 28 Feb 2008 12:13:50 -0500
In-Reply-To: <1204185623.3501.84.camel@raven.themaw.net> (Ian Kent's message
	of "Thu, 28 Feb 2008 17:00:23 +0900")
Message-ID: <x494pbtxaup.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <raven@themaw.net> writes:

> On Wed, 2008-02-27 at 23:23 -0800, Andrew Morton wrote:
>> On Thu, 28 Feb 2008 16:08:20 +0900 Ian Kent <raven@themaw.net> wrote:
>> > which includes the process uid and gid, and as part of
>> > the lookup we set macros for several mount map substitution variables,
>> > derived from the uid and gid of the process requesting the mount and
>> > they can be used within autofs maps.
>> 
>> yeah, could be a problem.  Hopefully the namespace people can advise. 
>> Perhaps we need a concept of an exportable-to-userspace namespace-id+uid,
>> namespace-id+gid, namespace-id+pid, etc for this sort of thing.  It has
>> come up before.  Recently, but I forget what the context was.
>
> I'm all ears to any feedback from others on this, please.

I think there is some confusion surrounding what the UID and GID are
used for in this context.  I'll try to explain it as best I can.

When the automount daemon parses a map entry, it will do some amount of
variable substitution.  So, let's say you're running on an i386 box, and
you want to mount a library directory from a server.  You might have a
map entry that looks like this:

lib	server:/export/$ARCH/lib

In this case, the automount daemon will replace $ARCH with i386, and
will try the following mount command:

mount -t nfs server:/export/i386/lib /automountdir/lib

There are cases where it would be helpful to use the requesting
process's UID in such a variable substitution.  Consider the case of a
CIFS share, where the automount daemon runs as user root, but we want to
mount the share using the credentials of the requesting user.  In this
case, the UID and GID can be helpful in formatting the mount options for
mounting the share.

So, the UID and GID are used only for map substitutions.  Now, having
said all of that, I'll have to look more closely at why we even need to
keep track of it, given that it only needs to be used when performing
the lookup, and at that time we have information on the requesting UID
and GID.

Cheers,

Jeff
