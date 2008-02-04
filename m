Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbYBDOHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbYBDOHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 09:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbYBDOH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 09:07:28 -0500
Received: from sacred.ru ([62.205.161.221]:36565 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615AbYBDOH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 09:07:27 -0500
Message-ID: <47A71BDF.5000801@openvz.org>
Date: Mon, 04 Feb 2008 17:06:23 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Kirill Korotaev <dev@sw.ru>
CC: Cedric Le Goater <clg@fr.ibm.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [Devel] Re: [PATCH 2.6.24-rc8-mm1 09/15] (RFC) IPC: new kernel
 API to change an ID
References: <20080129160229.612172683@bull.net>	<20080129162000.454857358@bull.net>	<20080129210656.GB1990@martell.zuzino.mipt.ru>	<47A18E47.5050206@bull.net>	<47A19AC2.7040709@sw.ru>	<47A1B78C.7050405@bull.net>	<47A1C8FE.9010700@sw.ru> <47A1F2DB.7080600@fr.ibm.com> <47A71606.5030201@sw.ru>
In-Reply-To: <47A71606.5030201@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 04 Feb 2008 17:06:05 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill Korotaev wrote:
> 
> Cedric Le Goater wrote:
>> Hello Kirill !
>>
>> Kirill Korotaev wrote:
>>> Pierre,
>>>
>>> my point is that after you've added interface "set IPCID", you'll need
>>> more and more for checkpointing:
>>> - "create/setup conntrack" (otherwise connections get dropped),
>>> - "set task start time" (needed for Oracle checkpointing BTW),
>>> - "set some statistics counters (e.g. networking or taskstats)"
>>> - "restore inotify"
>>> and so on and so forth.
>> right. we know that we will have to handle a lot of these
>> and more and we will need an API for it :) so how should we handle it ?
>> through a dedicated syscall that would be able to checkpoint and/or
>> restart a process, an ipc object, an ipc namespace, a full container ?
>> will it take a fd or a big binary blob ?  
>> I personally really liked Pavel idea's of filesystem. but we dropped the
>> thread.
> 
> Imho having a file system interface means having all its problems.
> Imagine you have some information about tasks exported with a file system interface.
> Obviously to collect the information you have to hold some spinlock like tasklist_lock or similar.
> Obviously, you have to drop the lock between sys_read() syscalls.
> So interface gets much more complicated - you have to rescan the objects and somehow find the place where
> you stopped previous read. Or you have to to force reader to read everything at once.

To remember the place when we stopped previous read we have a "pos" counter
on the struct file.

Actually, tar utility, that I propose to perform the most simple migration
reads the directory contents with 4Kb buffer - that's enough for ~500 tasks.

Besides, is this a real problem for a frozen container?

>> that's for the user API but we will need also kernel services to expose
>> (checkpoint) states and restore them. If it's too
>> early to talk about the user API, we could try first to refactor
>> the kernel internals to expose correctly what we need.
> 
> That's what I would start with.
> 
>> That's what Pierre's patchset is trying to do.
> 
> Not exactly. For checkpointing/restoring we actually need only one new API call for each
> subsystem - create some object with given ID (and maybe parameters, if they are not dynamically changeable by user).
> While Pierre's patchset adds different API call - change object ID.
> 
> Thanks,
> Kirill
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
> 
> _______________________________________________
> Devel mailing list
> Devel@openvz.org
> https://openvz.org/mailman/listinfo/devel
> 

