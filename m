Return-Path: <linux-kernel-owner+w=401wt.eu-S1030778AbXDWRUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030778AbXDWRUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 13:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030812AbXDWRUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 13:20:10 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:15829 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030778AbXDWRUH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 13:20:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:user-agent:cc:references:in-reply-to:mime-version:content-disposition:date:content-type:content-transfer-encoding:message-id;
        b=QlSihYofNu4gYfZXhutaJWqvTCgeXp6BGBxk49Hmbvgs6gotTNnELQFFPmHT+fg/MUTvU6kO6vfvGTorOoHmuNPRBkLTk75VG1kLobjv8kAkWH7OEoRIo6+Kt14HI87UO3UGGiFS8MNRKtcvMwZFHosxeF6lj4RxRnrLsH+hDK8=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [report] renicing X, cfs-v5 vs sd-0.46
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr
References: <20070420140457.GA14017@elte.hu> <20070423024245.GA8378@elte.hu> <alpine.LFD.0.98.0704230805510.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704230805510.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Date: Mon, 23 Apr 2007 13:19:59 -0400
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <200704231320.00068.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2007, Linus Torvalds wrote:
>On Mon, 23 Apr 2007, Ingo Molnar wrote:
>> You are completely right in the case of traditional schedulers.
>
>And apparently I'm completely right with CFS too.
>
>> Using CFS-v5, with Xorg at nice 0, the context-switch rate is low:
>>
>> procs -----------memory---------- ---swap-- -----io---- --system--
>> -----cpu------ r  b   swpd   free   buff  cache   si   so    bi    bo   in
>>   cs us sy id wa st 2  0      0 472132  13712 178604    0    0     0    32
>>  113  170 83 17  0  0  0 2  0      0 472172  13712 178604    0    0     0 
>>    0  112  184 85 15  0  0  0 2  0      0 472196  13712 178604    0    0  
>>   0     0  108  162 83 17  0  0  0 1  0      0 472076  13712 178604    0  
>>  0     0     0  115  189 86 14  0  0  0
>
>Around 170 context switches per second.
>
>> Renicing X to -10 increases context-switching, but not dramatically so,
>> because it is throttled by CFS:
>>
>> procs -----------memory---------- ---swap-- -----io---- --system--
>> -----cpu------ r  b   swpd   free   buff  cache   si   so    bi    bo   in
>>   cs us sy id wa st 4  0      0 475752  13492 176320    0    0     0    64
>>  116 1498 85 15  0  0  0 4  0      0 475752  13492 176320    0    0     0 
>>    0  107 1488 84 16  0  0  0 4  0      0 475752  13492 176320    0    0  
>>   0     0  140 1514 86 14  0  0  0 4  0      0 475752  13492 176320    0  
>>  0     0     0  107 1477 85 15  0  0  0 4  0      0 475752  13492 176320  
>>  0    0     0     0  122 1498 84 16  0  0  0
>
>Did you even *look* at your own numbers? Maybe you looked at "interrpts".
>The context switch numbers go from 170 per second, to 1500 per second!
>
>If that's not "dramatically so", I don't know what is! Just how many
>orders of magnitude worse does it have to be, to be "dramatic"? Apparently
>one order of magnitude isn't "dramatic"?
>
>So you were wrong. The fact that it was still "usable" is a good
>indication, but how about just admitting that you were wrong, and that
>renicing X is the *WRONG*THING*TO*DO*.
>
>Just don't do it. It's wrong. It was wrong with the old schedulers, it's
>wrong with the new scheduler, it's just WRONG.
>
>It was a hack, and it's a failed hack. And the fact that you don't seem to
>realize that it's a failure, even when your OWN numbers clearly show that
>it's failed, is a bit scary.
>
>		Linus

This message prompted me to do some checking in re context switches myself, 
and I've come to the conclusion that there could be a bug in vmstat itself.

Run singly the context switching is reasonable even for a -19 niceness of x, 
its only showing about 200 or so on the first loop of vmstat.  But throw in 
the -n 1 arguments and it goes crazy on the second and subsequent loops.

X nice=0
[root@coyote ~]# vmstat -n 1
procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa 
st
 3  0    324  62836  37952 518080    0    0   786   446  474  201 10  4 82  4  
0
 0  0    324  62712  37952 518080    0    0     0     0 1309 2361  2  5 93  0  
0
 2  0    324  62712  37952 518080    0    0     0     0 1275 2203  2  4 94  0  
0
 0  0    324  62744  37952 518080    0    0     0     0 1305 2224  1  2 97  0  
0
 0  0    324  62744  37952 518080    0    0     0     0 1291 2232  0  1 99  0  
0

X nice=-10
procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa 
st
 3  0    324  62432  38052 518080    0    0   784   445  476  205 10  4 82  4  
0
 0  0    324  62432  38052 518080    0    0     0     0 1190 3223  1  1 98  0  
0
 2  0    324  62440  38052 518080    0    0     0     0 1209 3210  2  3 95  0  
0
 0  0    324  62316  38060 518080    0    0     0   232 1201 3355  3  4 92  1  
0
 2  0    324  62316  38060 518080    0    0     0     0 1207 2794  1  2 97  0  
0

X nice=10
procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa 
st
 4  0    324  62372  38184 518132    0    0   783   445  477  209 10  4 82  4  
0
 0  0    324  62372  38192 518132    0    0     0   272 1318 2262  0  3 97  0  
0
 0  0    324  62372  38192 518132    0    0     0     0 1293 2249  1  4 95  0  
0
 0  0    324  62248  38192 518132    0    0     0     0 1280 2443  4  2 94  0  
0
 0  0    324  62248  38192 518132    0    0     0     4 1294 2272  0  3 97  0  
0

Now, I have NDI which set of figures is the true set, but please note that in 
all 3 cases the reported values for cs didn't scale up and down all that much 
if separated out into 1st pass, and subsequent passes.

And, even with X nice=10, the system is still fairly smooth and usable.

This is with 2.6.21-rc7-CFS-v5 I built late last evening.  At Xnice=10 I just 
played a game of patience to watch the card animations and they were 
absolutely acceptably smooth. (and I won it in about 112 moves :)

>From this users viewpoint, it (cfs-v5) works, and works very well indeed, and 
it deserves a place as one of 3 selectable options in mainline.  The other 2 
being the existing mainline way, & Con K's sd-0.45 or later.  Both of these 
seem to be very large enhancements to the user experience over current 
mainline, which I'd discuss in terms borrowed from Joanne Dow.  Comparatively 
speaking, mainline has a very high vacuum.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Jayne: "Let's move this conversation in a not-Jayne's-fault direction."
				--Episode #14, "Objects in Space"
