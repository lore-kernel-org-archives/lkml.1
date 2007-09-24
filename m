Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbXIXINJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbXIXINJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 04:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbXIXIM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 04:12:57 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:56156 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbXIXIM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 04:12:56 -0400
Message-ID: <46F772DA.5060100@bull.net>
Date: Mon, 24 Sep 2007 10:18:34 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
References: <20070919140726.GA4603@ff.dom.local> <46F2123A.9070201@bull.net> <20070920072821.GA2065@ff.dom.local> <46F234DB.7030403@bull.net> <46F270DA.5030101@bull.net> <20070921084453.GA1758@ff.dom.local> <46F398C3.3000804@bull.net> <20070921110347.GB1758@ff.dom.local> <20070924065407.GA1776@ff.dom.local>
In-Reply-To: <20070924065407.GA1776@ff.dom.local>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 24/09/2007 10:18:50,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 24/09/2007 10:18:51,
	Serialize complete at 24/09/2007 10:18:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:
> On Fri, Sep 21, 2007 at 01:03:47PM +0200, Jarek Poplawski wrote:
> ...
> 
>>I hope not! But, then it would be probably another logical trick:
>>ipc_rcu_getref/putref() seems to prevent kfreeing of a structure, so
>>if it's used in do_msgsnd() there should be a risk something can do
>>this kfree at this moment, and it seems freeque() is the only one,
>>which both: can do this and cares for this refcount. Then, e.g., if
>>any of them does ipc_rcu_getref() a bit later and sees old (cached)
>>value - kfree can be skipped forever. [...]
> 
> 
> After rethinking, this scenario seems to be wrong or very unprobable
> (I'm not sure of all ways "if (--container...)" could be compiled),
> so there should be no such risk - double kfree/vfree is more probable,
> so no danger. More likely is such refcount abuse: ipc_rcu_getref() in
> do_msgsnd() done a bit after ipc_rcu_putref() in freeque() (msq
> pointer acquired by do_msgsend() before freeque() started); then,
> after schedule(), do_msgsnd() can work with kfreed msq_queue structure
> (at least considering classic RCU).
> 

If msgsnd() acquires the pointer first, it does it under lock + 
rcu_getref(). ==> refcount = 2
When schedule() is called if freeque() takes the pointer it will call 
msg_rmid() that sets the deleted field in the msg queue. When the lock 
is released by freeque(), we have either 1) or 2):
1) freeque()'s putref called 1st ==> refocunt = 1
    Then msgsnd()'s lock_by_ptr() is called ==> rcu lock
    Then msgsnd()'s putref is called ==> refcount = 0
    But this is done under RCU lock, so should be no problem
    Then the deleted field is checked ==> return
2) msgsnd()'s lock_by_ptr() is called ==> rcu lock
    Then we don't mind in which order are done the other operations
    since we under rcu_lock: the structure won't disappear till we test
    the deleted field.

Regards,
Nadia

