Return-Path: <linux-kernel-owner+w=401wt.eu-S934479AbZJJB6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934479AbZJJB6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 21:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933694AbZJJB6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 21:58:48 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38112 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933097AbZJJB6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 21:58:47 -0400
Date: Fri, 9 Oct 2009 18:58:59 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Daniel Lezcano <dlezcano@fr.ibm.com>, andrea@cpushare.com,
       Pavel Emelianov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: pidns memory leak
Message-ID: <20091010015859.GB11904@us.ibm.com>
References: <4AC5F198.2070407@fr.ibm.com> <20091006040526.GA22923@us.ibm.com> <4ACAFD6A.3060008@fr.ibm.com> <20091008030828.GA18973@us.ibm.com> <4ACD9ECC.90508@fr.ibm.com> <20091009032928.GA2031@us.ibm.com> <4ACF381F.9050808@fr.ibm.com> <20091009203809.GA12230@us.ibm.com> <m18wfkl2bf.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m18wfkl2bf.fsf@fess.ebiederm.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman [ebiederm@xmission.com] wrote:
| Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> writes:
| 
| > Andrea,
| >
| > We have been running a leak in child pid namespaces and some early debugging
| > points to the following commit:
| >
| >>> 	commit 7766755a2f249e7e0dabc5255a0a3d151ff79821
| >>> 	Author: Andrea Arcangeli <andrea@suse.de>
| >>> 	Date:   Mon Feb 4 22:29:21 2008 -0800
| >>>
| >
| > Reverting the commit seems to fix the leak but we need to do some more
| > analysis (like the lstat() question Daniel has).
| 
| Yes.
| 
| That entire path is an optimization.  It should not be needed for correct
| operation.  Although it may be responsible for some false positives.
| 
| > However I have a basic question regarding the commit - the log mentions:
| >
| > 	> do_exit->release_task->mark_inode_dirty_sync->schedule() (will never
| > 	> come back to run journal_stop)
| >
| > But release_task() calls shrink_dcache_parent() for a _procfs_ dentry. Does
| > journal_stop() apply to procfs also ?
| 
| The problem when the that PF_EXITING check was introduced is that
| shrink_dcache_parent could shrink dcache entries for other
| filesystems.  Last I looked that is no longer the case and we can
| remove that code.

Ok.

| As I recall proc_flush_task_mnt has a few other minor bugs as well that
| could cause problems.

Can you give me some more details on those bugs ? Reverting the commit
seems to fix the problem.

| 
| Ultimately what problems are you seeing?

We are leaking 'struct pid', proc_inode, and 'struct pid_namespace', when
container-init exits before its descendant processes. i.e when the
container-init zaps its descendants and waits for them, it calls the
proc_flush_task_mnt(), but then misses the shrink_dcache_parent() call due
to the above commit.

So the proc_inode is never deleted and the references to struct pid and
pid_namespace never go away. Details of the leak are buried in the
previous mail...
