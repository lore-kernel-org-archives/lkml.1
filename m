Return-Path: <linux-kernel-owner+w=401wt.eu-S1422953AbXCGRqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422953AbXCGRqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422823AbXCGRqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:46:32 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58616 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422826AbXCGRpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:45:55 -0500
Date: Wed, 7 Mar 2007 23:22:57 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org, xemul@sw.ru,
       dev@sw.ru, pj@sgi.com, sam@vilain.net, ebiederm@xmission.com,
       winget@google.com, containers@lists.osdl.org, serue@us.ibm.com,
       akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070307175257.GB17151@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070301133543.GK15509@in.ibm.com> <6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com> <20070307173031.GC2336@in.ibm.com> <6599ad830703070929r1fa9629cjef1570b461e2b77@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830703070929r1fa9629cjef1570b461e2b77@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 09:29:12AM -0800, Paul Menage wrote:
> That seems bad. With the current way you're doing it, if I mount
> hierarchies A and B on /mnt/A and /mnt/B, then initially all tasks are
> in /mnt/A/tasks and /mnt/B/tasks. If I then create /mnt/A/foo and move
> a process into it, that process disappears from /mnt/B/tasks, since
> its nsproxy no longer matches the nsproxy of B's root container. Or am
> I missing something?

I realized that bug as I was doing cpuset conversion.

Basically, we can't use just tsk->nsproxy to find what tasks are in
a directory (/mnt/B for ex). Here's what I was think we should be doing instead:


struct nsproxy *ns;
void *data;

ns = dentry_of(/mnt/B/tasks)->d_parent->d_fsdata;
data = ns->ctlr_data[some subsystem id which is bound in /mnt/B hierarchy]

we now scan tasklist and find a match if:

	tsk->nsproxy->ctlr_data[the above id] == data

(maybe we need to match on all data from all subsystems bound to B)

There is a similar bug in rcfs_rmdir also. We can't just use the nsproxy
pointed to by dentry to know whether the resource objects are free or
not. I am thinking (if at all resource control has to be provided on top
of nsproxy) that we should have a get_res_ns, similar to get_mnt_ns or
get_uts_ns, which will track number of nsproxies pointing to the same
resource object. If we do that, then rmdir() needs to go and check
those resource object's refcounts to see if a dir is in use or not.

-- 
Regards,
vatsa
