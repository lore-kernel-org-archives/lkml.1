Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752250AbYLQSwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbYLQSwK (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 13:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYLQSvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 13:51:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:51943 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYLQSvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 13:51:50 -0500
Message-ID: <49494A50.3090201@vlnb.net>
Date: Wed, 17 Dec 2008 21:52:00 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Fabio Checconi <fabio@gandalf.sssup.it>
CC: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Dynamic switching of io_context
References: <4942B90F.6050807@vlnb.net> <20081216082235.GD3284@gandalf.sssup.it>
In-Reply-To: <20081216082235.GD3284@gandalf.sssup.it>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+jJa/9TAG6S5F8j6+2gXpoXtaTenEozAi/7GY
 elN5Z0v7hnCuNDb/Obxg4Tzmt7zphT+ft7CJ6RI81YR/DIGdSs
 MY/GZpRovLLh+YTB076mg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fabio Checconi, on 12/16/2008 11:22 AM wrote:
>> In SCST (http://scst.sf.net) in some cases IO can be submitted 
>> asynchronously. This is possible for pass-through (i.e. using 
>> scsi_execute_async()) and BLOCKIO (i.e. using direct bio interface, see 
>> blockio_exec_rw() in 
>> http://scst.svn.sourceforge.net/viewvc/scst/trunk/scst/src/dev_handlers/scst_vdisk.c?revision=614&view=markup) 
>> backend. For them there's no need to have a per device pool of threads, one 
>> or more global thread(s) can perfectly do all the work. But it is very 
>> desirable for performance that all the IO is submitted in a dedicated IO 
>> context for each initiator (i.e. client), which originated it. I.e. 
>> commands from initiator 1 submitted in IO context IOC1, from initiator 2 - 
>> IOC2, etc. Most likely, the same approach would be very useful for NFS 
>> server as well.
>>
>> To achieve that it is necessary to have a possibility to switch IO 
>> context of the threads on the fly. I tried to implement that (see the 
>> attached patch), but hit BUG_ON(!cic->dead_key) in cic_free_func(), when 
>> session for initiator with the corresponding IO context was being 
>> destroyed by scst_free_tgt_dev(). At that point it was guaranteed that 
>> there was no outstanding IO with this IO context.
>>
>> So, I had to go to a more defensive approach to have for each pool of 
>> threads, including threads for async. IO, a dedicated IO context, which 
>> is currently implemented.
>>
>> Could you advice please what was going wrong? What should I do to 
>> achieve what's desired?
> 
> I think the problem may be that cfq expects cfq_exit_io_context()
> to be called before the last reference to an io context is put.
> Since cfq_exit_io_context() is called during process exit, and AFAICT
> you are not calling exit_io_context() on the given ioc, cfq finds it
> in an incorrect state.

With your hint I figured out that put_io_context() isn't sufficient and 
I should also call exit_io_context() instead of the latest 
put_io_context(). Thanks!

> I haven't seen the rest of the code, so I may be wrong, but I suppose
> that a better approach would be to use CLONE_IO to share io contexts,
> if possible.

Unfortunately, it would be very non-optimal. As it is known, to achieve 
the best performance with async. IO, it should be submitted by a limited 
number of threads <= CPU count. So, the only way to submit IO from each 
of, e.g. 100, clients in a dedicated per-client IO context is to 
dynamically switch io_context of the current threads to io_context of 
the client before IO submission.

Vlad

