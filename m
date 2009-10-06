Return-Path: <linux-kernel-owner+w=401wt.eu-S1756323AbZJFITd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323AbZJFITd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 04:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755696AbZJFITc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 04:19:32 -0400
Received: from mtagate5.de.ibm.com ([195.212.17.165]:59217 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246AbZJFITa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 04:19:30 -0400
Message-ID: <4ACAFD6A.3060008@fr.ibm.com>
Date: Tue, 06 Oct 2009 10:18:50 +0200
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: Pavel Emelianov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: pidns memory leak
References: <4AC5F198.2070407@fr.ibm.com> <20091006040526.GA22923@us.ibm.com>
In-Reply-To: <20091006040526.GA22923@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu wrote:
> Daniel Lezcano [dlezcano@fr.ibm.com] wrote:
>> Hi,
>>
>> I am facing a problem with the pid namespace when I launch the following  
>> lxc commands:
>>
>> lxc-execute -n foo sleep 3600 &
>> ls -al /proc/$(pidof lxc-init)/exe && lxc-stop -n foo
>>
>> All the processes related to the container are killed, but there is  
>> still a refcount on the pid_namespace which is never released.
> 
> Thanks for the bug report.
> 
> Did you notice any leak in 'struct pids' also or just the pid_namespace ?
> If the pids are not leaking, this may be slightly different from the problem
> Catalin Marinas ran into:
> 
> 	http://lkml.org/lkml/2009/7/29/406

I am not sure what you mean by 'struct pids' but what I observed is:

pid_2 and pid_namespace (as they are named in /proc/slabinfo) are never 
decremented.

> And the pid_namespace does not seem to reproduce for me, with out the
> 'ls -al /proc/...' above, or with the simpler 'ns_exec' approach to
> creating pid namespace.

I tried to write a simpler program but I failed to reproduce it.

> I am going through the code for lxc-execute, but does it remount /proc 
> in the container ?

Right, the parent does a clone(NEWMNT|NEWPID|NEWIPC|NEWUTS), wait for 
the child while this one (pid 1) 'execs' the lxc-init process. This 
program mounts /proc and fork-exec the command passed as parameter (here 
'sleep 3600').

Without this intermediate process, the leak *seems* not happening.

If you don't access /proc/<pid>/<file>, the leak is not happening.

So to summarize:

Leak when:
----------

lxc-execute -n foo sleep 3600 &
ls -al /proc/$(pidof sleep)/exe && lxc-stop -n foo

The stop can be done, immediately after looking at the proc file or 
later, the leak happens in all the cases.

No leak when:
-------------
lxc-execute -n foo sleep 3600 &
lxc-stop -n foo


I tried to create a simpler program doing the same but that did not 
triggered the problem.

   -- Daniel
