Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbXITGV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbXITGV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 02:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbXITGVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 02:21:19 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47737 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbXITGVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 02:21:18 -0400
Message-ID: <46F2123A.9070201@bull.net>
Date: Thu, 20 Sep 2007 08:24:58 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
References: <20070919140726.GA4603@ff.dom.local>
In-Reply-To: <20070919140726.GA4603@ff.dom.local>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/09/2007 08:25:12,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/09/2007 08:25:14,
	Serialize complete at 20/09/2007 08:25:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:
> On 18-09-2007 16:55, Nadia Derbey wrote:
> ...
> 
>>Well, reviewing the code I found another place where the 
>>rcu_read_unlock() was missing.
>>I'm so sorry for the inconvenience. It's true that I should have tested 
>>with CONFIG_PREEMPT=y :-(
>>Now, the ltp tests pass even with this option set...
>>
>>In attachment you'll find a patch thhat
>>1) adds the missing rcu_read_unlock()
>>2) replaces Andrew's fix with a new one: the rcu_read_lock() is now 
>>taken in ipc_lock() / ipc_lock_by_ptr() and released in ipc_unlock(), 
>>exactly as it was done in the ref code.
> 
> 
> BTW, probably I miss something, but I wonder, how this RCU is working
> here. E.g. in msg.c do_msgsnd() there is:
> 
> msq = msg_lock_check(ns, msqid);
> ...
> 
> msg_unlock(msq);
> schedule();
> 
> ipc_lock_by_ptr(&msq->q_perm);
> 
> Since msq_lock_check() gets msq with ipc_lock_check() under
> rcu_read_lock(), and then goes msg_unlock(msq) (i.e. ipc_unlock())
> with rcu_read_unlock(), is it valid to use this with
> ipc_lock_by_ptr() yet?

Before Calling msg_unlock() they call ipc_rcu_getref() that increments a 
refcount in the rcu header for the msg structure. This guarantees that 
the the structure won't be freed before they relock it. Once the 
structure is relocked by ipc_lock_by_ptr(), they do the symmetric 
operation i.e. ipc_rcu_putref().

Regards,
Nadia
