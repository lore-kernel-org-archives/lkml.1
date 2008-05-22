Return-Path: <linux-kernel-owner+w=401wt.eu-S1758400AbYEVUC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400AbYEVUC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757611AbYEVUCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:02:43 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:60850 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006AbYEVUCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:02:42 -0400
Message-ID: <4835D14B.20904@nortel.com>
Date: Thu, 22 May 2008 14:02:19 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, mingo@elte.hu,
       pj@sgi.com
Subject: Re: fair group scheduler not so fair?
References: <4834B75A.40900@nortel.com> <1211439417.29104.7.camel@twins>
In-Reply-To: <1211439417.29104.7.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 May 2008 20:02:23.0490 (UTC) FILETIME=[BFFE3620:01C8BC46]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

> Could you see if the patches found here:
> 
>  http://programming.kicks-ass.net/kernel-patches/sched-smp-group-fixes/
> 
> make any difference for you?

Not much difference.  In the following case pid 2438 is in group "a" and
pids 2439/2440 are in group "b".  Pid 2438 still gets stuck with only 66%.

  2439 cfriesen  20   0  3800  392  336 R 99.7  0.0   3:17.37 cat 

  2438 cfriesen  20   0  3800  392  336 R 66.2  0.0   2:33.63 cat 

  2440 cfriesen  20   0  3800  392  336 R 33.6  0.0   1:47.53 cat 



With 3 tasks in group a, 2 in group b, it's still pretty poor:

  2514 cfriesen  20   0  3800  392  336 R 52.5  0.0   0:48.11 cat 

  2515 cfriesen  20   0  3800  392  336 R 50.2  0.0   0:42.53 cat 

  2439 cfriesen  20   0  3800  392  336 R 35.4  0.0   4:37.07 cat 

  2438 cfriesen  20   0  3800  392  336 R 33.3  0.0   3:34.97 cat 

  2440 cfriesen  20   0  3800  392  336 R 28.3  0.0   2:26.17 cat 




If I boot with "nosmp" it behaves more or less as expected:

3 tasks in default:
  2427 cfriesen  20   0  3800  392  336 R 33.7  0.0   0:36.54 cat 

  2429 cfriesen  20   0  3800  392  336 R 33.5  0.0   0:35.63 cat 

  2428 cfriesen  20   0  3800  392  336 R 32.9  0.0   0:35.84 cat 


1 task in a, 2 in b:
  2427 cfriesen  20   0  3800  392  336 R 49.8  0.0   1:45.74 cat 

  2428 cfriesen  20   0  3800  392  336 R 25.0  0.0   1:38.65 cat 

  2429 cfriesen  20   0  3800  392  336 R 25.0  0.0   1:38.18 cat 


3 tasks in a, 2 in b:
  2521 cfriesen  20   0  3800  392  336 R 25.2  0.0   0:08.52 cat 

  2522 cfriesen  20   0  3800  392  336 R 25.2  0.0   0:08.23 cat 

  2427 cfriesen  20   0  3800  392  336 R 16.6  0.0   1:59.39 cat 

  2429 cfriesen  20   0  3800  392  336 R 16.6  0.0   1:47.63 cat 

  2428 cfriesen  20   0  3800  392  336 R 16.4  0.0   1:48.65 cat 



I haven't really dug into the scheduler yet (although that's next), but 
based on these results it doesn't really look like the load balancer is 
properly group-aware.

Chris
