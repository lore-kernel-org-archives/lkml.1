Return-Path: <linux-kernel-owner+w=401wt.eu-S1762652AbXEWKlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762652AbXEWKlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 06:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758267AbXEWKlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 06:41:22 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:60960 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758191AbXEWKlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 06:41:22 -0400
To: viro@ftp.linux.org.uk
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
In-reply-to: <20070523102437.GS4095@ftp.linux.org.uk> (message from Al Viro on
	Wed, 23 May 2007 11:24:38 +0100)
Subject: Re: [RFC PATCH] file as directory
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu> <20070523095127.GQ4095@ftp.linux.org.uk> <E1HqnmR-0001dI-00@dorka.pomaz.szeredi.hu> <20070523102437.GS4095@ftp.linux.org.uk>
Message-Id: <E1HqoGh-0001kd-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 23 May 2007 12:40:35 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Right.  After locking vfsmount_lock, mount_dironfile() should recheck
> > if there was a race and bail out.
> 
> Owww...  Not pretty, that...

If the cost of ->enter() is low, then it shouln't really be a problem.
We can't use ->i_mutex for locking, and introducing a new lock for
this doesn't sound right either.

> > I don't think the filesystem ought to try _creating_ a vfsmount.  I
> > imagine, that the fs has already a kernel-internal mounted for this
> > kind of stuff, and it just supplies a dentry from that.  The vfsmount
> > isn't actually important, but it should be readily available, and it's
> > easier to clone from a vfsmount/dentry pair.
> 
> I don't get it.  What's the point of that exercise, then?  When do you
> create that kernel-internal mount?

When the real superblock is created.  It could even be the _same_
super block as the real one.  There'd be just the problem of anchoring
the dir-on-file dentries somewhere...

Or with fuse the dir-on-file mount can just come from any mounted
filesystem, again possibly the same one as the parent.  I do actually
test with this.  The userspace filesystem supplies a file descriptor,
from which the struct path is extracted and returned from ->enter().

Miklos
