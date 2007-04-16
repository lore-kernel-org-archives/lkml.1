Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243AbXDPTSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbXDPTSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 15:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbXDPTSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 15:18:32 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51784 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbXDPTSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 15:18:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linuxram@us.ibm.com, linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk,
       containers@lists.osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Devel] Re: [patch 05/10] add "permit user mounts in new namespace" clone flag
References: <20070412164541.580374744@szeredi.hu>
	<20070412164620.588752236@szeredi.hu>
	<20070412203208.GG27772@sergelap.austin.ibm.com>
	<m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com>
	<1176713221.9488.17.camel@ram.us.ibm.com>
	<E1HdNZn-0006i9-00@dorka.pomaz.szeredi.hu>
	<1176716941.9488.57.camel@ram.us.ibm.com>
	<E1HdNwV-0006l2-00@dorka.pomaz.szeredi.hu>
	<m18xcsl3yc.fsf@ebiederm.dsl.xmission.com>
	<E1HdTag-0007bd-00@dorka.pomaz.szeredi.hu>
Date: Mon, 16 Apr 2007 13:16:48 -0600
In-Reply-To: <E1HdTag-0007bd-00@dorka.pomaz.szeredi.hu> (Miklos Szeredi's
	message of "Mon, 16 Apr 2007 17:58:06 +0200")
Message-ID: <m1zm58jfj3.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

>> > That depends.  Current patches check the "unprivileged submounts
>> > allowed under this mount" flag only on the requested mount and not on
>> > the propagated mounts.  Do you see a problem with this?
>> 
>> I think privileges of this sort should propagate.  If I read what you
>> just said correctly if I have a private mount namespace I won't be able
>> to mount anything unless when it was setup the unprivileged submount
>> command was explicitly set.
>
> By design yes.  Why is that a problem?

It certainly doesn't match my intuition.

Why are directory permissions not sufficient to allow/deny non-priveleged mounts?
I don't understand that contention yet.

I should probably go back and look and see how plan9 handles mount/unmount
permissions.  Plan9 gets away with a lot more because it doesn't have
a suid bit and mount namespaces were always present, so they don't have
backwards compatibility problems.

My best guess at the moment is that plan9 treated mount/unmount as
completely unprivileged and used the mount namespaces to limit the
scope of what would be affected by a mount/unmount operation.  I think
that may be reasonable in linux as well but it will require the
presence of a mount namespace to limit the affects of what a user can
do.

So short of a more thorough audit I believe the final semantics should
be: 
- mount/unmount for non-priveleged processes should only be limited
  by the mount namespace and directory permissions.
- CLONE_NEWNS should not be a privileged operation. 

What prevents us from allowing these things?

- Unprivileged CLONE_NEWNS and unprivileged mounts needs resource
  accounting so we don't have a denial of service attack.

- Unprivileged mounts must be limited to directories that we have
  permission to modify in a way that we could get the same effect
  as the mount or unmount operation in terms of what files are visible
  otherwise we can mess up SUID executables.

- Anything else?

There are user space issues such as a reasonable pam module and how
to do backups.  However those are user space issues.

What am I missing that requires us to add MNT_USER and MNT_USERMNT?

Eric
