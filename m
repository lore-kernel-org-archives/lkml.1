Return-Path: <linux-kernel-owner+w=401wt.eu-S1751777AbZLII1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbZLII1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 03:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZLII1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 03:27:48 -0500
Received: from RELAY.ANDREW.CMU.EDU ([128.2.10.85]:37679 "EHLO
	relay.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbZLII1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 03:27:47 -0500
Date: Wed, 9 Dec 2009 03:27:29 -0500
From: Ben Blum <bblum@andrew.cmu.edu>
To: Li Zefan <lizf@cn.fujitsu.com>, bblum@andrew.cmu.edu
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, menage@google.com
Subject: Re: [RFC] [PATCH 1/5] cgroups: revamp subsys array
Message-ID: <20091209082729.GA14114@andrew.cmu.edu>
Mail-Followup-To: Li Zefan <lizf@cn.fujitsu.com>,
	linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
	akpm@linux-foundation.org, menage@google.com
References: <20091204085349.GA18867@andrew.cmu.edu> <20091204085508.GA18912@andrew.cmu.edu> <4B1E0283.70108@cn.fujitsu.com> <20091209055016.GA12342@andrew.cmu.edu> <4B1F3EB9.6080502@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1F3EB9.6080502@cn.fujitsu.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 02:07:53PM +0800, Li Zefan wrote:
> Ben Blum wrote:
> > On Tue, Dec 08, 2009 at 03:38:43PM +0800, Li Zefan wrote:
> >>> @@ -1291,6 +1324,7 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
> >>>  	struct cgroupfs_root *new_root;
> >>>  
> >>>  	/* First find the desired set of subsystems */
> >>> +	down_read(&subsys_mutex);
> >> Hmm.. this can lead to deadlock. sget() returns success with sb->s_umount
> >> held, so here we have:
> >>
> >> 	down_read(&subsys_mutex);
> >>
> >> 	down_write(&sb->s_umount);
> >>
> >> On the other hand, sb->s_umount is held before calling kill_sb(),
> >> so when umounting we have:
> >>
> >> 	down_write(&sb->s_umount);
> >>
> >> 	down_read(&subsys_mutex);
> > 
> > Unless I'm gravely mistaken, you can't have deadlock on an rwsem when
> > it's being taken for reading in both cases? You would have to have at
> > least one of the cases being down_write.
> > 
> 
> lockdep will warn on this..

Hm. Why did I not see this warning...?

> And it can really lead to deadlock, though not so obivously:
> 
>   thread 1       thread 2        thread 3
> -------------------------------------------
> | read(A)        write(B)
> |
> |                                write(A)
> |
> |                read(A)
> |
> | write(B)
> |
> 
> t3 is waiting for t1 to release the lock, then t2 tries to
> acquire A lock to read, but it has to wait because of t3,
> and t1 has to wait t2.
> 
> Note: a read lock has to wait if a write lock is already
> waiting for the lock.

Okay, clever, the deadlock happens because of a behavioural optimization
of the rwsems. Good catch on the whole issue.

How does this sound as a possible solution, in cgroup_get_sb:

1) Take subsys_mutex
2) Call parse_cgroupfs_options()
3) Drop subsys_mutex
4) Call sget(), which gets sb->s_umount without subsys_mutex held
5) Take subsys_mutex
6) Call verify_cgroupfs_options()
7) Proceed as normal

In which verify_cgroupfs_options will be a new function that ensures the
invariants that rebind_subsystems expects are still there; if not, bail
out by jumping to drop_new_super just as if parse_cgroupfs_options had
failed in the first place.

Another question: What's the justification for having an interface of
seemingly symmetrical "initialize" and "destroy" functions, one of which
has to take a lock and the other gets called with the lock already held?
Seems like it's asking for trouble.

-- bblum
