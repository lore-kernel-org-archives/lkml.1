Return-Path: <linux-kernel-owner+w=401wt.eu-S1760053AbXFWQgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053AbXFWQgR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 12:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbXFWQgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 12:36:07 -0400
Received: from smtpout.mac.com ([17.250.248.173]:57012 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbXFWQgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 12:36:06 -0400
In-Reply-To: <200706230946.44023.info@gnebu.es>
References: <200706230007.15622.info@gnebu.es> <B6065113-E9C7-42CE-A43D-55E6BF1EE2C0@mac.com> <200706230946.44023.info@gnebu.es>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <EC86BD0E-7829-4DBF-864A-795804235C5C@mac.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Question about fair schedulers
Date: Sat, 23 Jun 2007 12:35:18 -0400
To: Alberto Gonzalez <info@gnebu.es>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 23, 2007, at 03:46:43, Alberto Gonzalez wrote:
> On Saturday 23 June 2007, Kyle Moffett wrote:
>> On Jun 22, 2007, at 18:07:15, Alberto Gonzalez wrote:
>>> Ok, so what will a fair scheduler do in this case? It is my  
>>> understanding that it would give 50% CPU to each task, resulting  
>>> in the video dropping frames. Is this correct?
>>
>> Yes, that's correct.
>>
>> What this *actually* means is that you want the media player to  
>> have higher priority than the DVD ripping program.  Ergo you  
>> should run "nice +20 my_dvd_burner" or "nice +20  
>> my_vorbis_encoder" under CFS or other fair schedulers.
>
> Ok, that makes sense. The problem is that desktop users don't know  
> about such things, so the ideal situation would be that the  
> scheduler knows about it and does it for you.

No, it is *categorically* *impossible* for the scheduler to get that  
decision right.  For example, if my job is as a programmer and I'm  
waiting for a build during lunchbreak then I may not care that the  
process in the background makes my DVD-player drop a few frames, as  
long as it gets done 10% quicker.  That kind of decision is *POLICY*,  
and it does not belong in the kernel.  If you want the kernel to  
treat one job or the other as more important then you must *TELL* it  
that, end of story.

>> Under the new CFS scheduler it will get evenly allocated CPU and  
>> so while you *will* get dropped frames, they will be less visible  
>> (IE: Render 7 frames, drop 1, render 7 frames, drop 1, render 7  
>> frames, drop 1).
>
> Yes, I see your point. In a scenario of dropping frames it seems  
> that CFS does a better job. It's just that an ideal scheduler  
> shouldn't drop frames in this case (it should give 70% to the video  
> even without nicing the encoder).

It can't do that.  The with-CFS kernel just sees 2 CPU-heavy  
processes and guesses that it should give them equal CPU.  "stock"  
kernels have an algorithm designed to promote some tasks for  
"interactivity", but in practice it also tended to cause other  
processes to be denied CPU for arbitrarily long periods of time,  
hence why CFS is an improvement.  Under the old scheduler even if you  
had 2 DVD player processes each chewing 45% CPU, you could still have  
dropped frames because for a second or two one would be more  
"interactive" than the other, and vice versa.  Under CFS/SD, they are  
both classified equally and so get equal CPU allocation *AND* latency.

>> Basically you are telling the kernel that your video player is no  
>> more important than your re-encoder process which, judging by your  
>> email, is completely untrue.  If you really want it to treat the  
>> video player as specially important (or alternatively treat the  
>> reencoder process and specially unimportant) then you must tell it  
>> so with "nice" or "renice".
>
> That's my whole point. On a desktop, some tasks have by nature a  
> higher priority than others. A fair scheduler treats them all the  
> same (hence, fair) way. So a user must nice/renice processes for  
> them to get the correct CPU time (something you can't expect normal  
> desktop users to do).

I don't see any reason someone couldn't write a simple little GUI  
program to enumerate the user-owned X processes (somewhat like the  
Windows Task-Manager but less complicated) and allow them to change  
priorities.  Alternatively your desktop environment could set up a  
little privileged wrapper which appropriately executes the HD video  
player.  One of the primary rules of kernel development is that you  
cannot put policy in the kernel, and a statement of the form  
"PROCESS1 is more important than PROCESS2" is pure policy and must be  
done from userspace.  We even give appropriate enforcement mechanisms  
to userspace to take such action (nice levels).

Cheers,
Kyle Moffett



