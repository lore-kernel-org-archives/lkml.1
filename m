Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbZKGV4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbZKGV4M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 16:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbZKGV4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 16:56:11 -0500
Received: from smtp201.iad.emailsrvr.com ([207.97.245.201]:43515 "EHLO
	smtp201.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbZKGV4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 16:56:10 -0500
Message-ID: <4AF5ECFD.3000509@librato.com>
Date: Sat, 07 Nov 2009 16:56:13 -0500
From: Oren Laadan <orenl@librato.com>
Organization: Librato
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: Matt Helsley <matthltc@us.ibm.com>, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [v11][PATCH 9/9] Document clone_with_pids() syscall
References: <20091105053053.GA11289@us.ibm.com>	<20091105054204.GI16142@us.ibm.com>	<20091106183936.GA32531@us.ibm.com>	<20091106201814.GA26614@count0.beaverton.ibm.com>	<20091106214529.GB26614@count0.beaverton.ibm.com> <20091107022612.GA18039@suka>
In-Reply-To: <20091107022612.GA18039@suka>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sukadev Bhattiprolu wrote:
> Matt Helsley [matthltc@us.ibm.com] wrote:
> | > If userspace passes an array with n pids and there are k namespace levels
> | > then clone_with_pids() makes sure that the kernel sees a pid array like:
> | > 
> | > index	  0     ... k - (n + 1)        ...          k - 1
> | > 	+-----------------------+-------------------------+
> | > pid_t	| 0 ..................0 | <copied from userspace> |
> | > 	+-----------------------+-------------------------+
> | 
> | (diagram assumes n != k. If n == k then pids[0] is the pid desired
> | in the initial namespace..)
> 
> True.
> 
> Also I was not sure if we should prevent choosing pids in ancestor containers.
> since a process is not even supposed to know of ancestor namespaces. Is there
> a need for choosing pids in those namespaces.

IMHO this is a bit confusing.

A process observes a single namespace - the one in which it "lives".
There is no such thing as descendant namespaces for that process.
There may be ancestor namespaces.

The clone occurs in the context of the process. So the process that
is forking _must_ indicate pids in _ancestor_ namespaces if it wishes
to select pids in those (as is the case in c/r).

> 
> | 
> | > 
> | > So even though the order is different from choosepid() the calling
> | > task still doesn't need to know its pidns level. Of course, just
> | > like choosepid(), n <= k or userspace will get EINVAL.
> | 
> | Forgot to mention that I prefer the way choosepid orders the pids.
> | It's not inspired by the way that the kernel implements pid namespaces
> | and has more to do with the way userspace sees things (IMHO).
> 
> Hmm, In general we C/R a descendant container. So the way userspace
> sees it at that point is "what are the pids of this process in my current
> and in any descendant namespaces". IOW, the pid of container from which
> we checkpoint seems more interesting first - right ?  If so, the pids[]
> are better ordered from older namespace to younger namespace ?

When we checkpoint, we use an external process to record the state of
(current or) descendant namespaces.

When we restart, we run in the context of the restarting process, so
we select a pid in the current and _ancestor_ namespaces.

So the order of pids as it (will) appear in the checkpoint image for
a given process will be from an ancestor down to descendant namespaces.
And this is how we (will) hand it over to eclone().

> 
> | I don't know if it makes more sense to change clone_with_pids() or have
> | [e]glibc wrappers swap the array contents.

I prefer to decide now on an order and stick to it in the kernel and
in glibc.

Oren

