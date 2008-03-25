Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbYCYLpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbYCYLpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 07:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbYCYLow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 07:44:52 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:36347 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbYCYLow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 07:44:52 -0400
Message-ID: <47E8E4F3.6090604@linux.vnet.ibm.com>
Date: Tue, 25 Mar 2008 17:11:39 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: linux-mm@kvack.org, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][-mm] Memory controller add mm->owner
References: <20080324140142.28786.97267.sendpatchset@localhost.localdomain> <6599ad830803240803s5160101bi2bf68b36085f777f@mail.gmail.com> <47E7D51E.4050304@linux.vnet.ibm.com> <6599ad830803240934g2a70d904m1ca5548f8644c906@mail.gmail.com> <47E7E5D0.9020904@linux.vnet.ibm.com> <6599ad830803241046l61e2965t52fd28e165d5df7a@mail.gmail.com>
In-Reply-To: <6599ad830803241046l61e2965t52fd28e165d5df7a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Mar 24, 2008 at 10:33 AM, Balbir Singh
> <balbir@linux.vnet.ibm.com> wrote:
>>  > OK, so we don't need to handle this for NPTL apps - but for anything
>>  > still using LinuxThreads or manually constructed clone() calls that
>>  > use CLONE_VM without CLONE_PID, this could still be an issue.
>>
>>  CLONE_PID?? Do you mean CLONE_THREAD?
> 
> Yes, sorry - CLONE_THREAD.
> 
>>  For the case you mentioned, mm->owner is a moving target and we don't want to
>>  spend time finding the successor, that can be expensive when threads start
>>  exiting one-by-one quickly and when the number of threads are high. I wonder if
>>  there is an efficient way to find mm->owner in that case.
>>
> 
> But:
> 
> - running a high-threadcount LinuxThreads process is by definition
> inefficient and expensive (hence the move to NPTL)
> 
> - any potential performance hit is only paid at exit time
> 
> - in the normal case, any of your children or one of your siblings
> will be a suitable alternate owner
> 
> - in the worst case, it's not going to be worse than doing a
> for_each_thread() loop
> 
> so I don't think this would be a major problem
> 

I've been looking at zap_threads, I suspect we'll end up implementing a similar
loop, which makes me very uncomfortable. Adding code for the least possible
scenario. It will not get invoked for CLONE_THREAD, but will get invoked for the
case when CLONE_VM is set without CLONE_THREAD.

I'll try and experiment a bit more and see what I come up with


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
