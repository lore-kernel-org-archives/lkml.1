Return-Path: <linux-kernel-owner+w=401wt.eu-S1752221AbZGUMBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbZGUMBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 08:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZGUMBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 08:01:16 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41188 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbZGUMBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 08:01:15 -0400
Date: Tue, 21 Jul 2009 17:31:06 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Zefan Li <lizf.kernel@gmail.com>
Cc: Xiaotian Feng <dfeng@redhat.com>, menage@google.com, lizf@cn.fujitsu.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: fix reverse unlock sequence in cgroup_get_sb
Message-ID: <20090721120106.GW24157@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1248171926-20232-1-git-send-email-dfeng@redhat.com> <20090721111019.GV24157@balbir.in.ibm.com> <8522a3d30907210438u6fce081fi835bf964d0c01e8a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <8522a3d30907210438u6fce081fi835bf964d0c01e8a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Zefan Li <lizf.kernel@gmail.com> [2009-07-21 19:38:03]:

> 2009/7/21, Balbir Singh <balbir@linux.vnet.ibm.com>:
> >
> > * Xiaotian Feng <dfeng@redhat.com> [2009-07-21 18:25:26]:
> >
> > > In cgroup_get_sb, the lock sequence is:
> > >       mutex_lock(&inode->i_mutex);
> > >       mutex_lock(&cgroup->mutex);
> > > so the last unlock sequence should be:
> > >       mutex_unlock(&cgroup->mutex);
> > >       mutex_unlock(&inode->i_mutex);
> > >
> > > Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> > > ---
> > >  kernel/cgroup.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> > > index 3737a68..11ef162 100644
> > > --- a/kernel/cgroup.c
> > > +++ b/kernel/cgroup.c
> > > @@ -1140,8 +1140,8 @@ static int cgroup_get_sb(struct file_system_type
> > *fs_type,
> > >               BUG_ON(root->number_of_cgroups != 1);
> > >
> > >               cgroup_populate_dir(root_cgrp);
> > > -             mutex_unlock(&inode->i_mutex);
> > >               mutex_unlock(&cgroup_mutex);
> > > +             mutex_unlock(&inode->i_mutex);
> > >       }
> > >
> >
> > Seems reasonable to me. You might also want to mention that elsewhere
> > the sequence is unlock cgroup_mutex followed by inode->i_mutex.
> >
> > Acked-by: Balbir Singh balbir@linux.vnet.ibm.com
> 
> 
> No, the unlock order is irrelevant. It's the lock order that matters. So
> this patch
> fixes nothing.
> 
> Xiaotian, you didn't run into deadlock, did you?
>


Li, Consider the following


lock(A)
lock(B)
unlock(A) 
unlock(B)

Tomorrow if a unsuspecting programmer does this

lock(A)
lock(B)
unlock(A) 

code block 

unlock(B)


What protects code block? lock B? Is that the intention?

-- 
	Balbir
