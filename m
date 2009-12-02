Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbZLBB10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbZLBB10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 20:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbZLBB1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 20:27:25 -0500
Received: from kroah.org ([198.145.64.141]:50506 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbZLBB1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 20:27:25 -0500
Date: Tue, 1 Dec 2009 17:21:00 -0800
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       stable kernel team <stable@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [stable] Kernel oops in resched_task() with 2.6.31.5
Message-ID: <20091202012100.GD30050@kroah.com>
References: <4AF80B8B.8080203@jp.fujitsu.com>
 <1257770720.4108.195.camel@laptop>
 <4AF810C5.4010505@jp.fujitsu.com>
 <4AF8F63B.1040402@jp.fujitsu.com>
 <20091110051537.GF7897@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110051537.GF7897@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 06:15:37AM +0100, Ingo Molnar wrote:
> 
> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> wrote:
> 
> > Kenji Kaneshige wrote:
> > >Peter Zijlstra wrote:
> > >>On Mon, 2009-11-09 at 21:31 +0900, Kenji Kaneshige wrote:
> > >>>Hi,
> > >>>
> > >>>I frequently encounter the kernel oops attached below in resched_task()
> > >>>with 2.6.31.5. This kernel oops happens also with 2.6.32-rc5. I don't
> > >>>know about other kernel.
> > >>>
> > >>>Here is my analysis:
> > >>>
> > >>>The immediate cause of this kernel oops is that NULL was passed to
> > >>>resched_task() from resched_cpu(). From my investigation, this was
> > >>>caused as follows:
> > >>>
> > >>>- trigger_load_balance() caluculated cpu number of idle load balancer
> > >>>  using find_new_ilb(), and find_new_ilb() returned *offline* CPU
> > >>>  number (16 in my case). Note that I didn't do any CPU hotplug
> > >>>  operation. On my system, present, online and offline under
> > >>>  /sys/devices/system/cpu/ are
> > >>>
> > >>>    [kanesige@localhost ~]$ cat /sys/devices/system/cpu/present
> > >>>    0-15
> > >>>    [kanesige@localhost ~]$ cat /sys/devices/system/cpu/online
> > >>>    0-15
> > >>>    [kanesige@localhost ~]$ cat /sys/devices/system/cpu/offline
> > >>>    16-255
> > >>>
> > >>>  And nr_cpu_ids is 256.
> > >>>
> > >>>- resched_cpu() calculated current task by cpu_curr() with offline CPU
> > >>>  number.
> > >>>
> > >>>So this kernel oops seems to be caused by invalid CPU number returned
> > >>>from find_new_ilb(). I don't know the find_new_ilb() implementation,
> > >>>but I suspect the initialization of cpumasks used by find_new_ilb().
> > >>>The patch attached below seems to fix the problem (With this patch,
> > >>>the kernel oops doesn't happen). But I don't know if this is the
> > >>>correct fix.
> > >>
> > >>Please send patches against -tip.
> > >>
> > >>You might find that Rusty has already fixed a similar issue there in
> > >>commit: 49557e620339cb134127b5bfbcfecc06b77d0232.
> > >>
> > >>Now, Rusty's patch does not clear the ilb mask, so maybe it doesn't
> > >>fully cover your issue, please test.
> > >>
> > >
> > >Thank you for quick response.
> > >
> > >I didn't notice Rusty's fix.
> > >I'll look at and test it tomorrow.
> > >
> > 
> > I tested Rusty's patch and confirmed it fixes the problem.
> 
> Thanks.
> 
> -stable team, please cherry-pick this upstream commit for .31.x:
> 
>  49557e6: sched: Fix boot crash by zalloc()ing most of the cpu masks

Now queued up.

thanks,

greg k-h
