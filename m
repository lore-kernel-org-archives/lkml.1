Return-Path: <linux-kernel-owner+w=401wt.eu-S967262AbXG3Qgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967262AbXG3Qgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967153AbXG3Qfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:35:47 -0400
Received: from cb2.northrockquote.com ([64.251.14.146]:2939 "EHLO
	dejavu.debianpt.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S967145AbXG3Qfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:35:45 -0400
X-Greylist: delayed 1862 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2007 12:35:45 EDT
From: Miguel Figueiredo <elmig@debianpt.org>
Organization: DebianPT.org
To: ck@vds.kolivas.org
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Date: Mon, 30 Jul 2007 17:04:29 +0100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <930f95dc0707291431j4e50214di3c01cd44b5597502@mail.gmail.com> <20070730114649.GB19186@elte.hu>
In-Reply-To: <20070730114649.GB19186@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707301704.29670.elmig@debianpt.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Segunda, 30 de Julho de 2007 12:46, Ingo Molnar escreveu:
> * John <darknessenvelops@gmail.com> wrote:
> > On 7/29/07, Ingo Molnar <mingo@elte.hu> wrote:
> > > * John <darknessenvelops@gmail.com> wrote:
> > > > Ingo-
> > > >
> > > > Why not perform the same test using the native linux Q3 client to
> > > > compare numbers to wine? [...]


[...]

> and that matches my experience as well (as limited as it may be). In
> general my impression is that CFS and SD are roughly on par when it
> comes to 3D smoothness.
>
> The Wine+Quake3 numbers i posted yesterday are so bad under SD that they
> must be some artifact in SD (possibly related to yield - i've strace-ed
> the tasks under SD today and they are blocking in yield), so they are
> not really representative of the general quality of SD (unless you are
> being hit by that particular regression). Still it is kind of ironic
> that when i tried to find a 3D regression in CFS i found a 3D regression
> in SD.

I also tryied Q3A demo and i got similar values to yours:

CFS		90
2.6.22	90
SD		90

while running that endless loop, on 2.6.22 and SD it drops instantly to 4 fps.
While CFS runs ~70 with 1.9 load. I was able to play the game without noticing 
much degradation. I written these values while playing under CFS:

load fps
1.66	81
1.73	75
1.97	70s


With this patch [1] someone sent me over IRC i get similar values to CFS, 
maybe a few fps more, but thats insignificant and not very accurate to 
measure. Anyway with this patch i am playing with a load of 2.2 at ~75 fps, 
1024x768 windowed. It's enjoyable to frag the dumb 'Major'  as under CFS. 


I think the main difference in performance of CFS and SD it's the 
implementation of sched_yield (which is used by graphic drivers) and CFS has 
changed the implementation of sched_yield. You use:

in mainline (2.6.22): 
/**
 * sys_sched_yield - yield the current processor to other threads.
 *
 * This function yields the current CPU by moving the calling thread
 * to the expired array. If there are no other threads running on this
 * CPU then this function will return.
 */

you changed it to something like:

if (unlikely(rq->nr_running == 1))
                schedstat_inc(rq, yld_act_empty);
        else
                current->sched_class->yield_task(rq, current);


wile mainline (2.6.22) and SD use:

dequeue_task(current, array);
enqueue_task(current, target);

and

requeue_task()


Anyway i am going to continue to frag a bit more :)


[1] - http://rafb.net/p/Rbpqaz26.html
There are 2 modes for this hack:
sysctl kernel.sched_yield = 1 or 2, see patch.


[...]

>
> 	Ingo
> _______________________________________________
> http://ck.kolivas.org/faqs/replying-to-mailing-list.txt
> ck mailing list - mailto: ck@vds.kolivas.org
> http://vds.kolivas.org/mailman/listinfo/ck

-- 

Com os melhores cumprimentos/Best regards,

Miguel Figueiredo
http://www.DebianPT.org
