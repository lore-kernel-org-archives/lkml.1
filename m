Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754733AbYLPWgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbYLPWgu (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 17:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbYLPWgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 17:36:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbYLPWgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 17:36:38 -0500
Date: Tue, 16 Dec 2008 17:36:28 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jon Masters <jonathan@jonmasters.org>,
        Clark Williams <clark.williams@gmail.com>,
        Gregory Haskins <ghaskins@novell.com>
Subject: Creating the RT git tree
Message-ID: <alpine.DEB.1.10.0812161556460.25356@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This email is an explanation on how the RT git tree is created. Note, the 
tree is still in a "broken" state. But it now compiles!

The git tree is located at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-rt.git

The branches are:

  linus
  master
  preempt-rt (only on local machine)
  rt-master
  rt/rt
  rt/convert-locks
  
  rt/<topics>

All branches that start with rt/ will be merged into the rt-master branch, 
with the exception of the branches rt/rt and rt/convert-locks

The work is done against the rt/<topic> branches, for example:

  rt/rt-locks
  rt/workqueues
  rt/sched
  rt/mainline

Each of these topic branches should (in theory) compile and boot by 
themselves.

The 'linus' branch is the mainline upstream tree from Linus that the 
master branch is based on (if you could not figure that out yourself ;-)

The rt/rt branch contains the administrative scripts that create the 
rt-master and preempt-rt (master) branches. If you check out rt/rt the 
scripts will be in .rt/bin/  These scripts are based off of the scripts 
used to manage linux-tip that is maintained by Ingo Molnar.

The first of these I use is the rt-update-branches

This script will update the linus branch if necessary (but it will also 
prompt you first). Then it will go and check out each branch one at a time 
and compare it to see if any changes has been made in the linus branch 
that might conflict with the current branch. If there are changes, then it 
will run a test merge, and if no conflicts occur then it will back out the 
merge. If conflicts happen it will start a shell (with the 'conflict>' 
prompt) and let you resolve the conflict. When the conflict is resolved, 
you exit and the script will continue to the next branch.

Note, a branch will be merged with the linus branch only if there is a 
conflict that can not be resolved by the script. Otherwise, the branch 
stays based off of the linus branch that it was created with.

The next script is rt-merge-branches.

This script will checkout the rt-master branch and merge in all the 
rt/<topic> branches as well as the linus branch. This branch is expected 
to be able to compile and boot too (but probably does not at the moment).

Finally, rt-make-preempt-rt is performed.

This script will checkout the preempt-rt branch.  If a preempt-rt-last 
branch does not exist, the following is performed:

It will do a reset --hard against the rt-master branch.  It merges in the 
rt/convert-locks branch. It creates a preempt-rt-last branch from this 
merge. It runs ./scripts/convert-spinlocks which will convert all 
spinlock_t types in the kernel to lock_t (and the functions as well). It 
will not convert any file in the BLACKLIST_FILES variable defined in 
./scripts/convert-blacklist.

This conversion is committed with the message:

  Convert all spinlocks to lock_t

Then rt-make-preempt-rt runs ./scripts/convert-locks which converts the 
locks defined in ./scripts/convert-locks-list. The format in that file
is:

<path/file>:<regex>lock

The left of the colon is the full path name to the file that contains the 
lock that needs to be a spinlock. The right of the colon is the regular 
expression and lock to convert the lock back. Some regex is already in 
the conversion script, namely the appending of & or *.

Example:

kernel/kprobes.c:(.*(->|\.))?lock

The regex is a perl regular expression. That is '(' and ')' are special 
characters and if you want to represent a parenthesis you need to 
backslash it '\(' and '\)'.

This change is also committed with the message:

    Convert some locks back to spinlock_t

The rt-master + merge of rt/convert-locks is branched to become the 
preempt-rt-last branch.

That's it for a full rebase of preempt-rt.  But what happens if a 
preempt-rt-last exists?  Here's that scenario.

Because running convert-spinlocks takes about 10 minutes to run, I try to 
avoid it. It also rebases preempt-rt and I like to avoid that too, since 
that will break bisects. So I have the script make a back up of the 
rt-master + merge of rt/convert-locks and compare against that 
(preempt-rt-last).

Now is also a good time to explain rt/convert-locks. Some files 
(currently only sched.h), are hard to get right with scripts. That is, 
which lock is a spinlock_t and which lock is a lock_t.  So I cheated. I 
added sched.h to the BLACKLIST_FILES and do the work myself. Since each of 
the rt/<topic> branches must compile on their own, touching sched.h means I 
need to touch all the spin_lock() and spin_unlock() that are in the kernel 
that I changed to lock_t. This change is much bigger than I would like, 
and would cause unwanted conflicts with mainline. Thus, rt/convert-locks 
was created. This is the one branch that does not compile by itself. Its 
only purpose is to do the lock conversions that the scripts have a hard 
time getting right.

Back to the rt-make-preempt-rt with a preempt-rt-last branch.  A compare 
is done against preempt-rt-last and rt-master + merge of rt/convert-locks. 
The files that are changed are brought to preempt-rt and each of them will 
have the convert-file-spinlocks run on them, if they are not in the 
BLACKLIST_FILES. If a file changed that was in convert-locks-list, then 
the convert-lock.pl is executed on that file.

These changes are committed with the change log:

    Automated update of changed files

followed by a list of files that were detected to have changed. Note, this 
may not include all changed files if the full convert-locks is run again.
One might notice that some early logs in the master branch do not list the 
changed files. That is because the script changed to include the files.

When all is done, the rt-master + merge becomes the new preempt-rt-last.

Note, if convert-locks or convert-lock.pl is modified, the convert-locks 
is executed again. If convert-file-spinlocks is modified, then we do a new 
rebase against rt-master again as if the preempt-rt-last did not exist.

As you can see, doing a 'git log master' will not give you the true
commits to the RT git tree. It will show you the files that changed, but 
to get a true log, you need to do a log against rt-master.

One last script of importance, and that is the rt-push-all. I run this 
script to push the changes to my master machine. If I run this on my 
master machine, then it pushes the changes to kernel.org and in the 
process renames the branch preempt-rt to master.

Well, I hope this helps others. All the scripts I use are public in this 
git repo. The .rt/bin/ scripts I have copied elsewhere, so they 
sometimes become out of sync, but I try to keep them up to date.

-- Steve

