Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbZCEIUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbZCEIUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 03:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbZCEIUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 03:20:47 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:53702 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbZCEIUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 03:20:46 -0500
Message-ID: <49AF8B5A.4080505@free.fr>
Date: Thu, 05 Mar 2009 09:20:42 +0100
From: Cedric Le Goater <legoater@free.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       hch@infradead.org, Nathan Lynch <ntl@pobox.com>,
       Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC][PATCH 8/8] check files for checkpointability
References: <20090227203425.F3B51176@kernel>	<20090227203435.98735E54@kernel> <20090302133754.GA8033@us.ibm.com>	<20090302095917.6cfeda55@thinkcentre.lan>	<1236011251.26788.450.camel@nimitz>	<20090302112247.76bb3662@thinkcentre.lan>	<1236015052.26788.471.camel@nimitz> <20090302174433.GA12708@us.ibm.com> <1236017600.26788.488.camel@nimitz>
In-Reply-To: <1236017600.26788.488.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Mon, 2009-03-02 at 11:44 -0600, Serge E. Hallyn wrote:
>> Quoting Dave Hansen (dave@linux.vnet.ibm.com):
>>> On Mon, 2009-03-02 at 11:22 -0600, Nathan Lynch wrote:
>>>> No.. I mean what if a process 1234 does
>>>>
>>>> f = fopen("/proc/1234/stat", "r");
>>>>
>>>> and is then checkpointed.  Can that path be resolved during restart,
>>>> before pid 1234 is alive?
>>> Heh, that's a good one.
>>>
>>> It does mean that we can't do restore like this:
>>>
>>> 	for_each_cr_task()
>>> 		restore_task_struct()
>>> 		restore_files()
>>> 		...
>>>
>>> We have to do:
>>>
>>> 	for_each_cr_task()
>>> 		restore_task_struct()
>>> 	for_each_cr_task()
>>> 		restore_files()
>>>
>> Which is what we actually do, right?
> 
> OK, I have a really evil one.
> 
> What if task 1234 does:
> 
> 	open(O_RDONLY, "/proc/5678/fdinfo/44");
> 
> and task 5678 does:
> 
> 	open(O_RDONLY, "/proc/5678/fdinfo/55");
> 
> There is no right order.
> 
> The only right way I can think to do it is that we have to loop on the
> restore and defer files that we can't seem to find right now, hoping
> that they'll show up as the restore progresses.

or the restore algorithm should support recursion. for example, epoll, 
attached 'struct files' to af_unix socket, pipes (2 ends), fifos (idem),
connected socket (you need the listening end), etc. 

C.

> Basically:
> 
> 	for_each_cr_task()
> 		deferred_files = restore_files()
> retry:
> 	making_progress = 0
> 	for_each(deferred_file)
> 		restore(deferred_file)
> 	if (making_progress)
> 		goto retry;




 
