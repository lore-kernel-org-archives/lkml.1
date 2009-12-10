Return-Path: <linux-kernel-owner+w=401wt.eu-S932786AbZLJFTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbZLJFTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 00:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932733AbZLJFTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 00:19:30 -0500
Received: from RELAY-02.ANDREW.CMU.EDU ([128.2.10.85]:50967 "EHLO
	relay.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727AbZLJFT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 00:19:29 -0500
Date: Thu, 10 Dec 2009 00:19:12 -0500
From: Ben Blum <bblum@andrew.cmu.edu>
To: Li Zefan <lizf@cn.fujitsu.com>, bblum@andrew.cmu.edu
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, Paul Menage <menage@google.com>
Subject: Re: [RFC] [PATCH 1/5] cgroups: revamp subsys array
Message-ID: <20091210051912.GA11893@andrew.cmu.edu>
Mail-Followup-To: Li Zefan <lizf@cn.fujitsu.com>,
	linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
	akpm@linux-foundation.org, Paul Menage <menage@google.com>
References: <20091204085349.GA18867@andrew.cmu.edu> <20091204085508.GA18912@andrew.cmu.edu> <4B1E0283.70108@cn.fujitsu.com> <20091209055016.GA12342@andrew.cmu.edu> <4B1F3EB9.6080502@cn.fujitsu.com> <20091209082729.GA14114@andrew.cmu.edu> <4B20686E.3070907@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B20686E.3070907@cn.fujitsu.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 11:18:06AM +0800, Li Zefan wrote:
> >> And it can really lead to deadlock, though not so obivously:
> >>
> >>   thread 1       thread 2        thread 3
> >> -------------------------------------------
> >> | read(A)        write(B)
> >> |
> >> |                                write(A)
> >> |
> >> |                read(A)
> >> |
> >> | write(B)
> >> |
> >>
> >> t3 is waiting for t1 to release the lock, then t2 tries to
> >> acquire A lock to read, but it has to wait because of t3,
> >> and t1 has to wait t2.
> >>
> >> Note: a read lock has to wait if a write lock is already
> >> waiting for the lock.
> > 
> > Okay, clever, the deadlock happens because of a behavioural optimization
> > of the rwsems. Good catch on the whole issue.
> > 
> > How does this sound as a possible solution, in cgroup_get_sb:
> > 
> > 1) Take subsys_mutex
> > 2) Call parse_cgroupfs_options()
> > 3) Drop subsys_mutex
> > 4) Call sget(), which gets sb->s_umount without subsys_mutex held
> > 5) Take subsys_mutex
> > 6) Call verify_cgroupfs_options()
> > 7) Proceed as normal
> > 
> > In which verify_cgroupfs_options will be a new function that ensures the
> > invariants that rebind_subsystems expects are still there; if not, bail
> > out by jumping to drop_new_super just as if parse_cgroupfs_options had
> > failed in the first place.
> > 
> 
> The current code doesn't need this verify_cgroupfs_options, so why it
> will become necessary? I think what we need is grab module refcnt in
> parse_cgroupfs_options, and then we can drop subsys_mutex.

Oh, good point. I thought pinning the modules had to happen in rebinding
since there's a case where rebind_subsystems is called without parsing,
but that's just in kill_sb where no new subsystems are added. So, better
would be to make sure we can't get owned while we drop the lock instead
of checking afterwards if we got owned and bailing if so.

> But why you are using a rw semaphore? I think a mutex is fine.

The "most of cgroups wants to look at the subsys array" versus "module
loading/unloading modifies the array" is clearly a readers/writers case.

> And why not just use cgroup_mutex to protect the subsys[] array?
> The adding and spreading of subsys_mutex looks ugly to me.

The reasoning for this is that there are various chunks of code that
need to be protected by a mutex guarding subsys[] that aren't already
under cgroup_mutex - like parse_cgroupfs_options, or the first stage
of cgroup_load_subsys. Do you think those critical sections are small
enough that sacrificing reentrancy for simplicity of code is worth it?
