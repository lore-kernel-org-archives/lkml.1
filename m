Return-Path: <linux-kernel-owner+w=401wt.eu-S1758167AbZBSO7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167AbZBSO7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 09:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZBSO7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 09:59:34 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:41412 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbZBSO7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 09:59:33 -0500
Message-ID: <499D73C8.3090209@free.fr>
Date: Thu, 19 Feb 2009 15:59:20 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Containers <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       roland@redhat.com, Greg Kurz <gkurz@fr.ibm.com>
Subject: Re: [PATCH 0/7][v8] Container-init signal semantics
References: <20090219030207.GA18783@us.ibm.com>
In-Reply-To: <20090219030207.GA18783@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu wrote:
> Patch 5/7 is new in this set and fixes a bug. Remaining patches are
> just a forward-port from previous version and I believe they address
> all comments I have received.
>
> Oleg please sign-off/ack if you agree.
>
> ---
>
> Container-init must behave like global-init to processes within the
> container and hence it must be immune to unhandled fatal signals from
> within the container (i.e SIG_DFL signals that terminate the process).
>
> But the same container-init must behave like a normal process to 
> processes in ancestor namespaces and so if it receives the same fatal
> signal from a process in ancestor namespace, the signal must be
> processed.
>
> Implementing these semantics requires that send_signal() determine pid
> namespace of the sender but since signals can originate from workqueues/
> interrupt-handlers, determining pid namespace of sender may not always
> be possible or safe.
>
> This patchset implements the design/simplified semantics suggested by
> Oleg Nesterov.  The simplified semantics for container-init are:
>
> 	- container-init must never be terminated by a signal from a
> 	  descendant process.
>
> 	- container-init must never be immune to SIGKILL from an ancestor
> 	  namespace (so a process in parent namespace must always be able
> 	  to terminate a descendant container).
>
> 	- container-init may be immune to unhandled fatal signals (like
> 	  SIGUSR1) even if they are from ancestor namespace. SIGKILL/SIGSTOP
> 	  are the only reliable signals to a container-init from ancestor
> 	  namespace.
>   
Hi Suka,

I agree with these semantics, they look good.

What is planned to have the init process to die when a system container 
shuts down ?

Let's say we use the "shutdown" command, it will telinit to go to the 
runlevel 0, and will kill -1.
At this point, the container finishes with a sys_reboot (we take care to 
do nothing otherwise the real system shuts down). But the init process 
will stay there and the launcher of the container will never know if the 
container has stopped or not.

Gregory Kurz proposed a solution:
    * when shutdown is called and we are not in the init pidns, then we 
kill the process 1 of the pidnamespace.
    * when reboot is called and we are not in the init pidns, then we 
reexec the init process, using the same command line. I guess this one 
could be easily retrieved if we are able to display /proc/1/cmdline ;)

IMHO, this is a good proposition because it is generic and intuitive, no ?

What do you thing ?

  -- Daniel
