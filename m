Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbXHYEev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbXHYEev (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 00:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbXHYEen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 00:34:43 -0400
Received: from qsrv02ps.mx.bigpond.com ([144.140.83.182]:23357 "EHLO
	qsrv02ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbXHYEem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 00:34:42 -0400
Message-ID: <46CF8AEE.4090009@bigpond.net.au>
Date: Sat, 25 Aug 2007 11:50:38 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <npiggin@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Reduce overhead in balance_tasks()
References: <46C2842E.3010806@bigpond.net.au> <20070824060403.GB24742@elte.hu>
In-Reply-To: <20070824060403.GB24742@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta05ps.mx.bigpond.com from [121.222.142.3] using ID pwil3058@bigpond.net.au at Sat, 25 Aug 2007 01:50:38 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Peter Williams <pwil3058@bigpond.net.au> wrote:
> 
>> At the moment, balance_tasks() provides low level functionality for 
>> both
>>  move_tasks() and move_one_task() (indirectly) via the load_balance() 
>> function (in the sched_class interface) which also provides dual 
>> functionality.  This dual functionality complicates the interfaces and 
>> internal mechanisms and makes the run time overhead of operations that 
>> are called with two run queue locks held.
>>
>> This patch addresses this issue and reduces the overhead of these 
>> operations.
> 
> hm, i like it, and added it to my queue (probably .24 material though), 
> but note that it increases .text and .data overhead:
> 
>    text    data     bss     dec     hex filename
>   41028   37794    2168   80990   13c5e sched.o.before
>   41349   37826    2168   81343   13dbf sched.o.after
> 
> is that expected?

Yes, sort off.  It's a trade off of space for time and I expected an 
increase (although I didn't think that it would be quite that much). 
But it's still less than 1% and since the time saved is time when two 
run queue locks are held I figure that it's a trade worth making.  Also 
this separation lays the ground for a clean up of the active load 
balancing code which should gain some space including making it possible 
to exclude active load balancing on systems that don't need it (i.e. 
those that don't have multiple multi core/hyperthreading packages).

I've got a patch available that reduces the .text and .data for non SMP 
systems by excluding the load balancing stuff (that has crept into those 
systems) so that should help on embedded systems where memory is tight.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
