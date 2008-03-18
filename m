Return-Path: <linux-kernel-owner+w=401wt.eu-S1759063AbYCSTry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063AbYCSTry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbYCSTc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:32:27 -0400
Received: from over.ny.us.ibm.com ([32.97.182.150]:53316 "EHLO
	over.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624AbYCSTc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:32:26 -0400
Date: Tue, 18 Mar 2008 23:04:38 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Johannes Weiner <hannes@saeurebad.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>
Subject: Re: per cpun+ spin locks coexistence?
Message-ID: <20080318173438.GA24237@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <804dabb00803120917w451b16e6q685016d464a2edde@mail.gmail.com> <47DABBCE.5010803@goop.org> <804dabb00803160930t40b7c415ic38f2b9955b515ac@mail.gmail.com> <87bq5e1kvm.fsf@saeurebad.de> <804dabb00803171006i4423c5b6w58bd95116510d3f5@mail.gmail.com> <47DEC4F4.5010703@cosmosbay.com> <804dabb00803181000g408b8ab9oe1075952dc859823@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804dabb00803181000g408b8ab9oe1075952dc859823@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 01:00:27AM +0800, Peter Teoh wrote:
> First, the following is possible:
> 
>                 fddef = &get_cpu_var(fdtable_defer_list);
>                 spin_lock(&fddef->lock);
>                 fdt->next = fddef->next;
>                 fddef->next = fdt;==============>executing at CPU A
>                 /* vmallocs are handled from the workqueue context */
>                 schedule_work(&fddef->wq);
>                 spin_unlock(&fddef->lock);==============>executing at CPU B
>                 put_cpu_var(fdtable_defer_list);
> 
> where the execution can switch CPU after the schedule_work() API, then
> LOGICALLY u definitely need the spin_lock(), and the per_cpu data is
> really not necessary.
> 
> But without the per_cpu structure, then the following "dedicated
> chunk" can only execute on one processor, with the possibility of
> switching to another processor after schedule_work():

Wrong. You cannot switch to another processor in schedule_work(),
it doesn't block. Just read the code.

The reason why I used a per-cpu fdtable_defer_list is that I
did not want to make it a global list of deferred fdtable
structures to be freed and then have to protect it by a global lock.  
Every fdtable free would have had to take the same global lock
in that case and this would have resulted in scalability
issues (cacheline bouncing, lock contention). Instead,
I used a per-cpu list in essence creating finer-grain locking.
Two CPUs doing fdtable free operations simultaneously will
not contend for the same lock in this case. The fddef lock
is still required for the reasons Eric pointed out.


> and per_cpu is so that the same chunk of code can be executing at
> multiple CPUs all at the same time.
> 
> Now the key issue rises up - as I have just asked before u answered my question:
> 
> http://mail.nl.linux.org/kernelnewbies/2008-03/msg00236.html
> 
> can schedule_work() sleep?   (just like schedule(), whcih can sleep right?)
> schedule_work() is guaranteed to execute the work queue at least once,
> and so this thread may or may not sleep. correct?   Or wrong?

Wrong.

Thanks
Dipankar
