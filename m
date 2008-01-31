Return-Path: <linux-kernel-owner+w=401wt.eu-S1759630AbYAaC35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630AbYAaC35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 21:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754984AbYAaC3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 21:29:49 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:54305 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbYAaC1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 21:27:16 -0500
Date: Thu, 31 Jan 2008 08:10:49 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, Ingo Molnar <mingo@elte.hu>, menage@google.com,
       containers@lists.osdl.org, dhaval@linux.vnet.ibm.com,
       Balbir Singh <balbir@in.ibm.com>, pj@sgi.com
Subject: [RFC] Default child of a cgroup
Message-ID: <20080131024049.GA9544@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
	As we were implementing multiple-hierarchy support for CPU
controller, we hit some oddities in its implementation, partly related
to current cgroups implementation. Peter and I have been debating on the 
exact solution and I thought of bringing that discussion to lkml.

Consider the cgroup filesystem structure for managing cpu resource.

	# mount -t cgroup -ocpu,cpuacct none /cgroup
	# mkdir /cgroup/A
	# mkdir /cgroup/B
	# mkdir /cgroup/A/a1

will result in:

	/cgroup
	   |------<tasks>
	   |------<cpuacct.usage>
 	   |------<cpu.shares>
	   |
	   |----[A]
	   |     |----<tasks>
	   |     |----<cpuacct.usage>
	   |     |----<cpu.shares>
	   |     |
	   |     |---[a1]
	   |           |----<tasks>
	   |   	       |----<cpuacct.usage>
	   |           |----<cpu.shares>
	   |           |
	   |
	   |----[B]
	   |     |----<tasks>
	   |     |----<cpuacct.usage>
	   |     |----<cpu.shares>
	   |     


Here are some questions that arise in this picture:

1. What is the relationship of the task-group in A/tasks with the
   task-group in A/a1/tasks? In otherwords do they form siblings
   of the same parent A?

2. Somewhat related to the above question, how much resource should the 
   task-group A/a1/tasks get in relation to A/tasks? Is it 1/2 of parent
   A's share or 1/(1 + N) of parent A's share (where N = number of tasks
   in A/tasks)?

3. What should A/cpuacct.usage reflect? CPU usage of A/tasks? Or CPU usage
   of all siblings put together? It can reflect only one, in which case
   user has to manually derive the other component of the statistics.
 
It seems to me that tasks in A/tasks form what can be called the
"default" child group of A, in which case:

4. Modifications to A/cpu.shares should affect the parent or its default
   child group (A/tasks)?

To avoid these ambiguities, it may be good if cgroup create this
"default child group" automatically whenever a cgroup is created?
Something like below (not the absence of tasks file in some directories
now):


	/cgroup
	   |
	   |------<cpuacct.usage>
 	   |------<cpu.shares>
	   |
  	   |---[def_child]
	   |     |----<tasks>
	   |     |----<cpuacct.usage>
	   |     |----<cpu.shares>
	   |     |
	   |
	   |----[A]
	   |     |
	   |     |----<cpuacct.usage>
	   |     |----<cpu.shares>
	   |     |
	   |     |---[def_child]
	   |     |     |----<tasks>
	   |   	 |     |----<cpuacct.usage>
	   |     |     |----<cpu.shares>
	   |     |     |
	   |     | 
	   |     |---[a1]
	   |           |
	   |   	       |----<cpuacct.usage>
	   |           |----<cpu.shares>
	   |           |
	   | 	       |---[def_child]
	   |	       |       |---<tasks>
	   |	       |       |---<cpuacct.usage>
	   | 	       |       |---<cpu.shares>
	   |	       |       |
	   |
	   |----[B]
	   |     |
	   |     |----<cpuacct.usage>
	   |     |----<cpu.shares>
	   |     | 
	   |     |---[def_child]
	   |     |     |----<tasks>
	   |   	 |     |----<cpuacct.usage>
	   |     |     |----<cpu.shares>
	   |     |     |

Note that user cannot create subdirectories under def_child with this
scheme! I am also not sure what impact this will have on other resources
like cpusets ..

Thoughts?


-- 
Regards,
vatsa
