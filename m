Return-Path: <linux-kernel-owner+w=401wt.eu-S1758586AbYFPWjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586AbYFPWjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 18:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbYFPWji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 18:39:38 -0400
Received: from as3.cineca.com ([130.186.84.211]:47279 "EHLO as3.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbYFPWjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 18:39:37 -0400
Message-ID: <4856EB9D.6070804@gmail.com>
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Divyesh Shah <dpshah@google.com>
Cc: balbir@linux.vnet.ibm.com, menage@google.com, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, matt@bluehost.com, roberto@unbit.it,
       randy.dunlap@oracle.com, akpm@linux-foundation.org
Subject: Re: i/o bandwidth controller infrastructure
References: <20030410181011$6d15@gated-at.bofh.it> <aC1Yl-2AL-1@gated-at.bofh.it> <75b07c02-1595-4af2-ac87-3b067459f62e@w8g2000prd.googlegroups.com> <48D0786A-AC3B-46C3-B35C-EAAA47BFAEBC@google.com>
In-Reply-To: <48D0786A-AC3B-46C3-B35C-EAAA47BFAEBC@google.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 17 Jun 2008 00:39:26 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Divyesh Shah wrote:
>> This is the core io-throttle kernel infrastructure. It creates the
>> basic
>> interfaces to cgroups and implements the I/O measurement and
>> throttling
>> functions.
> 
> I am not sure if throttling an application's cpu usage by explicitly  
> putting it to sleep
> in order to restrain it from making more IO requests is the way to go  
> here (though I can't think
> of anything better right now).
> With this bandwidth controller, a cpu-intensive job which otherwise  
> does not care about its IO
> performance needs to be pin-point accurate about IO bandwidth  
> required in order to not suffer
> from cpu-throttling. IMHO, if a cgroup is exceeding its limit for a  
> given resource, the throttling
> should be done _only_ for that resource.
> 
> -Divyesh

Divyesh,

I understand your point of view. It would be nice if we could just
"disable" the i/o for a cgroup that exceeds its limit, instead of
scheduling some sleep()s, so the tasks running in this cgroup would be
able to continue their non-i/o operations as usual.

However, how to do if the tasks continue to perform i/o ops under this
condition? we could just cache the i/o in memory and at the same time
reduce the i/o priority of those tasks' requests, but this would require
a lot of memory, more space in the page cache, and probably could lead
to potential OOM conditions. A safer approach IMHO is to force the tasks
to wait synchronously on each operation that directly or indirectly
generates i/o. The last one is the solution implemented by this
bandwidth controller.

We could collect additional statistics, or implement some heuristics to
predict the tasks' i/o patterns in order to not penalize cpu-bound jobs
too much, but the basic concept is the same.

Anyway, I agree there must be a better solution, but this is the best
I've found right now... nice ideas are welcome.

-Andrea
