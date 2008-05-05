Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbYEEMcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbYEEMcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 08:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbYEEMcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 08:32:31 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36008 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbYEEMcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 08:32:31 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, menage@google.com
In-reply-to: <20080505110016.GC20910@infradead.org> (message from Christoph
	Hellwig on Mon, 5 May 2008 07:00:16 -0400)
Subject: Re: [patch 03/15] cgroup: dont call vfs_mkdir
References: <20080505095440.820370974@szeredi.hu> <20080505095511.217634550@szeredi.hu> <20080505110016.GC20910@infradead.org>
Message-Id: <E1Jszri-0005uq-4x@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 05 May 2008 14:32:22 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > cgroup_clone() calls vfs_mkdir() to create a directory in the cgroup
> > filesystem.  Replace with explicit call to cgroup_mkdir() and
> > fsnotify_mkdir().
> > 
> > This is equivalent, except that the following functions are not called
> > before cgroup_mkdir():
> > 
> >  - may_create()
> >  - security_inode_mkdir()
> >  - DQUOT_INIT()
> > 
> > Permission to clone the cgroup has already been checked in
> > copy_namespaces() (requiring CAP_SYS_ADMIN).  Additional file system
> > related capability checks are inappropriate and confusing.
> > 
> > The quota check is unnecessary, as quotas don't make any sense for
> > this filesystem.
> 
> Looks correct but I don't think it's a good idea.  Spreading more logic
> into filesystems without a good reason is rarely a good idea.

(Thanks for the review, Christoph)

Agreed completely, but vfs_* aren't for filesystems to call, rather
for entities calling _into_ filesystems from the outside.  This is
actually a very rare thing, so adding some extra logic for the sake of
cleanliness should be OK.

Now it can be argued, that cgroup_clone() is calling into the
filesystem from the outside.  But it's not really doing that, rather
it's making an internal modification to a specific filesystem,
triggered by some external action.

Miklos
