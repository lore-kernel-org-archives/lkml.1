Return-Path: <linux-kernel-owner+w=401wt.eu-S1750929AbXCXT0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750929AbXCXT0H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 15:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbXCXT0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 15:26:07 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38543 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750929AbXCXT0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 15:26:05 -0400
Date: Sat, 24 Mar 2007 12:25:59 -0700
From: Paul Jackson <pj@sgi.com>
To: vatsa@in.ibm.com
Cc: menage@google.com, akpm@osdl.org, sekharan@us.ibm.com, dev@sw.ru,
       xemul@sw.ru, serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, winget@google.com,
       rohitseth@google.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 1/7] containers (V7): Generic container
 system abstracted from cpusets code
Message-Id: <20070324122559.11b9ba34.pj@sgi.com>
In-Reply-To: <20070324150505.GB9475@in.ibm.com>
References: <20070212081521.808338000@menage.corp.google.com>
	<20070212085104.130746000@menage.corp.google.com>
	<20070324150505.GB9475@in.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> IMO, we need to use task_lock() in container_exit() to avoid this race.
> 
> (I think this race already exists in mainline cpuset.c?)
> 
> P.S : cpuset.c checks for PF_EXITING twice in attach_task(), while this
> patch seems to be checking only once. Is that fine?

I think the cpuset code is ok, because, as you note, it locks the task,
picks off the cpuset pointer, and then checks a second time that the
task still does not have PF_EXITING set:

In the kernel/cpuset.c code for attach_task():

        task_lock(tsk);
        oldcs = tsk->cpuset;
        /*
         * After getting 'oldcs' cpuset ptr, be sure still not exiting.
         * If 'oldcs' might be the top_cpuset due to the_top_cpuset_hack
         * then fail this attach_task(), to avoid breaking top_cpuset.count.
         */
        if (tsk->flags & PF_EXITING) {
                task_unlock(tsk);
                mutex_unlock(&callback_mutex);
                put_task_struct(tsk);
                return -ESRCH;
        }

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
