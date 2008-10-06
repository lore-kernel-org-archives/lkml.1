Return-Path: <linux-kernel-owner+w=401wt.eu-S1753777AbYJFLG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbYJFLG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 07:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbYJFLGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 07:06:19 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35691 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbYJFLGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 07:06:17 -0400
To: serue@us.ibm.com
CC: ebiederm@xmission.com, miklos@szeredi.hu, akpm@linux-foundation.org,
       hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080930193941.GA2013@us.ibm.com> (serue@us.ibm.com)
Subject: Re: unprivileged mounts git tree
References: <20080905153134.GA18367@us.ibm.com> <E1Kd3Mh-0001vk-F5@pomaz-ex.szeredi.hu> <m11vzrge86.fsf@frodo.ebiederm.org> <E1KdnOb-00068L-Eq@pomaz-ex.szeredi.hu> <20080911152033.GA29318@us.ibm.com> <m13ak6ecoi.fsf@frodo.ebiederm.org> <20080912220802.GA23230@us.ibm.com> <m1tzck68od.fsf@frodo.ebiederm.org> <20080914015646.GC18604@us.ibm.com> <m1od2r1l4p.fsf@frodo.ebiederm.org> <20080930193941.GA2013@us.ibm.com>
Message-Id: <E1KmnuG-0002ha-Cp@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Oct 2008 13:05:40 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008, Serge E. Hallyn wrote:
> Quoting Eric W. Biederman (ebiederm@xmission.com):

> > Ok.  I couldn't find Mikolos's code when I looked quickly.  What
> > are the current rules?  It sounds like my original example could
> > apply.
> 
> Rules according to permit_mount:
> 
> 	if CAP_SYS_ADMIN, allowed
> 	if fs type is not marked safe for user mounts (and not bind), -EPERM
> 	if target is a link, -EPERM
> 	if target is labeled with new nosubmnt flag, -EPERM
> 	if target is not a user mount owned by current->uid, -EPERM
> 	if recursive bind mount, -EPERM (?)

The rationale for the last one is that the user might not have access
to the submounts.  Recursive bind mounts can be implemented in
userspace if needed.

> > The implementation of mounts in plan9 is a bit different.  In
> > plan9 mounts are looked up by mount namespace and qid (effectively
> > the inode number).  So the semantics are slightly different.
> > Requiring a new mount namespace if you want to see what a
> > filesystem looks like without a mount on top of a given file.
> > 
> > It also looks like plan9 is likely to have a unmountable and
> > unusable mount if you actually delete an file, from another mount
> > namespace.
> > 
> > Linux actually has a very similar case where we can loose a mount
> > if you rename the directory that contains it to be somewhere
> > higher in the mount hierarchy than the location the mount was
> > under.
> 
> Can you give an example?

# mkdir -p /tmp/a/b/c
# mkdir /tmp/x
# mount --bind /tmp/a /tmp/x
# mount --bind /bin /tmp/x/b/c
# mv /tmp/a/b/c /tmp
mv: cannot move `/tmp/a/b/c' to `/tmp/c': Device or resource busy
# mv /tmp/a/b /tmp
# ls -al /tmp/x
total 64
drwxr-xr-x  2 root root  4096 Oct  6 12:55 .
drwxrwxrwt 95 root root 57344 Oct  6 12:55 ..
# umount /tmp/x
umount: /tmp/x: device is busy.

The mount under /tmp/x/b/c is now inaccessible and lost forever.  The
only way to get rid of it is to lazy umount /tmp/x itself.

What this means is that the current EBUSY restriction only prevents
the mountpoint disappearing in a subset of cases.

Miklos
