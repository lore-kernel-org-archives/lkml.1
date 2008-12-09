Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbYLITVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbYLITVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 14:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbYLITVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 14:21:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43476 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569AbYLITVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 14:21:19 -0500
Message-ID: <493EC53F.8060106@redhat.com>
Date: Tue, 09 Dec 2008 14:21:35 -0500
From: Casey Dahlin <cdahlin@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Scott James Remnant <scott@netsplit.com>
Subject: Re: [RFC PATCH] waitfd: file descriptor to wait on child processes
References: <493EA441.1070706@redhat.com>	<20081209170543.59b4fb73@lxorguk.ukuu.org.uk>	<493EBD23.3020800@redhat.com> <20081209190403.2731dfd0@lxorguk.ukuu.org.uk>
In-Reply-To: <20081209190403.2731dfd0@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> This propogates the fundamental braindamage of waitpid - the fact the
>>> notification only works on child process trees.
>>>
>>> Here is a more elegant suggestion - use epoll, inotify and friends  fully
>>> on /proc process nodes.
>>>       
>
>   
>> Last I checked inotify was not supported in /proc, or at least most of 
>> it. What kind of work load is it to change that?
>>     
>
> I don't know but I think it would be the better approach to find it. That
> also separates notification of state to parents from the general problem
> of wanting to know when a service has died, which seems to be an ever
> more common point of interest on the desktop in particular.
>
>   
Of course, using inotify on proc will not (and should not) actually reap 
dead processes, meaning waitpid() isn't obviated by the change (though 
now it is always called on a specific pid and is never expected to block 
or EAGAIN). We also introduce a new gotcha for userspace programs: this 
mechanism works identically for child and non-child processes, so a 
process may or may not be waitable when returned. A simple "do not shoot 
self in foot" should suffice for this though.

Also, it doesn't work if /proc hasn't been mounted, which just so 
happens to matter for my particular use cases :)
> File content change notification for /proc is hard because the contents
> don't exist in the normal way and get updated but can be done if there is
> a wait queue for the job. Actual changes to structure (new directories
> etc) is in part a similar problem but there are clear points already in
> existence when the proc nodes are created/destroyed and thus notification
> can occur.
>
>   
Changes to structure are more interesting in terms of this particular 
problem anyway, and definitely simpler to capture.

--CJD

