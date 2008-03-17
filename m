Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbYCQTXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbYCQTXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 15:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757612AbYCQTWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 15:22:42 -0400
Received: from smtp2f.orange.fr ([80.12.242.151]:22613 "EHLO smtp2f.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001AbYCQTWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 15:22:41 -0400
X-ME-UUID: 20080317192236736.B3D6A70000A7@mwinf2f08.orange.fr
Message-ID: <47DEC4F4.5010703@cosmosbay.com>
Date: Mon, 17 Mar 2008 20:22:28 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: Johannes Weiner <hannes@saeurebad.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
       Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: per cpun+ spin locks coexistence?
References: <804dabb00803120917w451b16e6q685016d464a2edde@mail.gmail.com>	 <47DABBCE.5010803@goop.org>	 <804dabb00803160930t40b7c415ic38f2b9955b515ac@mail.gmail.com>	 <87bq5e1kvm.fsf@saeurebad.de> <804dabb00803171006i4423c5b6w58bd95116510d3f5@mail.gmail.com>
In-Reply-To: <804dabb00803171006i4423c5b6w58bd95116510d3f5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Teoh a écrit :
> Thanks for the explanation, much apologies for this newbie discussion.
>   But I still find it inexplicable:
>
> On Mon, Mar 17, 2008 at 4:20 AM, Johannes Weiner <hannes@saeurebad.de> wrote:
>   
>>  A per-cpu variable is basically an array the size of the number of
>>  possible CPUs in the system.  get_cpu_var() checks what current CPU we
>>  are running on and gets the array-element corresponding to this CPU.
>>
>>  So, really oversimplified, get_cpu_var(foo) translates to something like
>>  foo[smp_processor_id()].
>>
>>     
>
> Ok, so calling get_cpu_var() always return the array-element for the
> current CPU, and since by design, only the current CPU can
> modify/write to this array element (this is my assumption - correct?),
> and the other CPU will just read it (using the per_cpu construct).
> So far correct?   So why do u still need to spin_lock() to lock other
> CPU from accessing - the other CPU will always just READ it, so just
> go ahead and let them read it.   Seemed like it defeats the purpose of
> get_cpu_var()'s design?
>
> But supposed u really want to put a spin_lock(), just to be sure
> nobody is even reading it, or modifying it, so then what is the
> original purpose of get_cpu_var() - is it not to implement something
> that can be parallelized among different CPU, without affecting each
> other, and using no locks?
>
> The dual use of spin_lock+get_cpu_var() confuses me here :-).   (not
> the per_cpu(), which I agree is supposed to be callabe from all the
> different CPU, for purpose of enumeration or data collection).
>
>   
You are right Peter, that fs/file.c contains some leftover from previous 
implementation of defer queue,
that was using a timer.

So we can probably provide a patch that :

- Use spin_lock() & spin_unlock() instead of spin_lock_bh() & 
spin_unlock_bh() in free_fdtable_work()
since we dont anymore use a softirq (timer) to reschedule the workqueue.

( this timer was deleted by the following patch :
http://readlist.com/lists/vger.kernel.org/linux-kernel/50/251040.html


But, you cannot avoid use of spin_lock()/spin_unlock() because 
schedule_work() makes no garantee that the work will be done by this cpu.

(free_fdtable_work() can be called to flush the fd defer queue of CPU X 
on behalf CPU Y,   with X != Y .
You then can have a corruption because CPU X is inside 
free_fdtable_rcu() and CPU Y is inside free_fdtable_work() )

So both spin_lock() and get_cpu_var() are necessary :

- One to get the precpu data for optimal performance on SMP (but not 
mandatory)
- One to protect the data from corruption on SMP.




