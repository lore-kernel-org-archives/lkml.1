Return-Path: <linux-kernel-owner+w=401wt.eu-S1752813AbXCER2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbXCER2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 12:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbXCER2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 12:28:20 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40497 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbXCER2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 12:28:19 -0500
Date: Mon, 5 Mar 2007 23:04:01 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Paul Jackson <pj@sgi.com>, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, ebiederm@xmission.com,
       winget@google.com, containers@lists.osdl.org, menage@google.com,
       akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070305173401.GA17044@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070301133543.GK15509@in.ibm.com> <20070301113900.a7dace47.pj@sgi.com> <20070303093655.GA1028@in.ibm.com> <20070303173244.GA16051@MAIL.13thfloor.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070303173244.GA16051@MAIL.13thfloor.at>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2007 at 06:32:44PM +0100, Herbert Poetzl wrote:
> > Yes, perhaps this overloads nsproxy more than what it was intended for.
> > But, then if we have to to support resource management of each
> > container/vserver (or whatever group is represented by nsproxy),
> > then nsproxy seems the best place to store this resource control 
> > information for a container.
> 
> well, the thing is, as nsproxy is working now, you
> will get a new one (with a changed subset of entries)
> every time a task does a clone() with one of the 
> space flags set, which means, that you will end up
> with quite a lot of them, but resource limits have
> to address a group of them, not a single nsproxy
> (or act in a deeply hierarchical way which is not
> there atm, and probably will never be, as it simply
> adds too much overhead)

Thats why nsproxy has pointers to resource control objects, rather than
embedding resource control information in nsproxy itself.

>From the patches:

struct nsproxy {

+#ifdef CONFIG_RCFS
+       struct list_head list;
+       void *ctlr_data[CONFIG_MAX_RC_SUBSYS];
+#endif

}

This will let different nsproxy structures share the same resource
control objects (ctlr_data) and thus be governed by the same parameters.

Where else do you think the resource control information for a container
should be stored?

> > It should have the same perf overhead as the original
> > container patches (basically a double dereference -
> > task->containers/nsproxy->cpuset - required to get to the 
> > cpuset from a task).
> 
> on every limit accounting or check? I think that
> is quite a lot of overhead ...

tsk->nsproxy->ctlr_data[cpu_ctlr->id]->limit (4 dereferences) is what we 
need to get to the cpu b/w limit for a task.

If cpu_ctlr->id is compile time decided, then that would reduce it to 3.

But I think if CPU scheduler schedules tasks from same container one
after another (to the extent possible that is), then other derefences
(->ctlr_data[] and ->limit) should be fast, as they should be in the cache?


-- 
Regards,
vatsa
