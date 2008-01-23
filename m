Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbYAWPYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbYAWPYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 10:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbYAWPYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 10:24:14 -0500
Received: from as1.cineca.com ([130.186.84.213]:33506 "EHLO as1.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbYAWPYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 10:24:12 -0500
Message-ID: <47975C0F.3010609@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Naveen Gupta <ngupta@google.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Paul Menage <menage@google.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH] cgroup: limit block I/O bandwidth
References: <2846be6b0801181439o55dcff09ted2b8f817e7ba682@mail.gmail.com>	 <4791DC2C.9090405@users.sourceforge.net>	 <4793507B.6040706@users.sourceforge.net>	 <20080120143239.GS6258@kernel.dk>	 <47936BC1.9060805@users.sourceforge.net>	 <20080120160651.GU6258@kernel.dk>	 <4793E047.1000602@users.sourceforge.net>	 <2846be6b0801221102y2ad297e2u2f9df06e33b72162@mail.gmail.com>	 <47967805.4060307@users.sourceforge.net> <2846be6b0801221717j41984f93v920d271b948d39be@mail.gmail.com>
In-Reply-To: <2846be6b0801221717j41984f93v920d271b948d39be@mail.gmail.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Date: Wed, 23 Jan 2008 16:23:59 +0100 (MET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naveen Gupta wrote:
> On 22/01/2008, Andrea Righi <righiandr@users.sourceforge.net> wrote:
>> Naveen Gupta wrote:
>>> See if using priority levels to have per level bandwidth limit can
>>> solve the priority inversion problem you were seeing earlier. I have a
>>> priority scheduling patch for anticipatory scheduler, if you want to
>>> try it. It's much simpler than CFQ priority.  I still need to port it
>>> to 2.6.24 though and send across for review.
>>>
>>> Though as already said, this would be for read side only.
>>>
>>> -Naveen
>> Thanks Naveen, I can test you scheduler if you want, but the priority
>> inversion problem (or better we should call it a "bandwidth limiting"
>> that impacts in wrong tasks) occurs only with write operations and, as
>> said by Jens, the I/O scheduler is not the right place to implement this
>> kind of limiting, because at this level the processes have already
>> performed the operations (dirty pages in memory) that raise the requests
>> to the I/O scheduler (made by different processes asynchronously).
> 
> If the i/o submission is happening in bursts, and we limit the rate
> during submission, we will have to stop the current task from
> submitting any further i/o and hence change it's pattern. Also, then
> we are limiting the submission rate and not the rate which is going on
> the wire as scheduler may reorder.

True. Doing i/o throttling at the scheduler level is probably more
correct, at least for read ops.

> One of the ways could be - to limit the rate when the i/o is sent out
> from the scheduler and if we see that the number of allocated requests
> are above a threshold we disallow request allocation in the offending
> task. This way an application submitting bursts under the allowed
> average rate will not stop frequently. Something like leaky bucket.

Right, for read requests too.

> Now for dirtying of memory happening in a different context than the
> submission path, you could still put a limit looking at the dirty
> ratio and this limit is higher than the actual b/w rate you are
> looking to achieve. In process making sure you always have something
> to write and still  now blow your entire memory. Or you can get really
> fancy and track who dirtied the i/o and start limiting it that way.

Probably tracking who dirtied the pages would be the best approach, but
we want also to reduce the overhead of this tracking. So, we should find
a smart way to track which cgroup dirtied the pages and then only when
the i/o scheduler dispatches the write requests of those pages, account
the i/o operations to the opportune cgroup. In this way throttling could
be done probably in __set_page_dirty() as well.

-Andrea
