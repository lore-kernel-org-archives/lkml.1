Return-Path: <linux-kernel-owner+w=401wt.eu-S1751327AbXCCKVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbXCCKVK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 05:21:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbXCCKVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 05:21:09 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37786 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751328AbXCCKVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 05:21:06 -0500
Date: Sat, 3 Mar 2007 02:21:00 -0800
From: Paul Jackson <pj@sgi.com>
To: vatsa@in.ibm.com
Cc: menage@google.com, ebiederm@xmission.com, sam@vilain.net,
       akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on
 top of nsproxy!
Message-Id: <20070303022100.8cee6997.pj@sgi.com>
In-Reply-To: <20070303093655.GA1028@in.ibm.com>
References: <20070301133543.GK15509@in.ibm.com>
	<20070301113900.a7dace47.pj@sgi.com>
	<20070303093655.GA1028@in.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Regarding semantics, can you be more specific?

Unfortunately not - sorry.

I've been off in other areas, and not found the time
to read through this current PATCH or think about it
carefully enough to be really useful.

Your reply seemed reasonable enough.

> It should have the same perf overhead as the original container patches
> (basically a double dereference - task->containers/nsproxy->cpuset -
> required to get to the cpuset from a task). 

There is just one spot that this might matter to cpusets.

Except for one hook, cpusets uses the mems_allowed and cpus_allowed
masks in the task struct to avoid having to look at the cpuset on hot
code paths.

There is one RCU guarded reference per memory allocation to
	current->cpuset->mems_generation
in the call to cpuset_update_task_memory_state(), for tasks that are in
some cpuset -other- than the default top cpuset, on systems that have
explicitly created additional (other than the top cpuset) cpusets after
boot.

If that RCU guarded reference turned into taking a global lock, or
pulling in a cache line that was frequently off dirty in some other
node, that would be unfortunate.

But that's the key hook so far as cpuset performance impact is
concerned.

Perhaps you could summarize what becomes of this hook, in this
brave new world of rcfs ...

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
