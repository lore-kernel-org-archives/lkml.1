Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbYKZEuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbYKZEuB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 23:50:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYKZEtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 23:49:52 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:24293 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYKZEtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 23:49:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=e7uK+/RoIY1Yj9RBLvmzTm04HUkM9x7NIpTWIWLzEn0/8U3TitjPQNsdbuEcghB47v
         EkiMCpmdAO1yXwbotmyDz2W5yzdxa7ft0xXYwW5q4kGeM+koc2J1dDLvBpqgrJF2rq/q
         B2O3+Iwdss8orvcME1U25lQlu1ov5nHo5Czrg=
Message-ID: <492CD567.6060507@gmail.com>
Date: Wed, 26 Nov 2008 13:49:43 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>,
       Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <mszeredi@suse.cz>,
       Davide Libenzi <davidel@xmailserver.org>,
       Brad Boyer <flar@allandria.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Roland McGrath <roland@redhat.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + poll-allow-f_op-poll-to-sleep-take-4.patch added to -mm tree
References: <20081125173032.GA21539@redhat.com> <492CD1AB.3000802@kernel.org>
In-Reply-To: <492CD1AB.3000802@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>> And don't we (in theory) actually need the mb() here instead?
>>
>> Let's suppose do_poll() starts the next iteration, so we are doing
>>
>> 	pwq->triggered = 0;
>>
>> 	->poll(file)
>> 		if (!check_file(file))
>> 			return 0;
>>
>> 		return POLLXXX;
>>
>> We don't have any barriers in between (unless fget_light bumps
>> ->f_count), so this can be reordered as
>>
>> 	->poll(file)
>> 		if (!check_file(file))
>> 			return 0;
>>
>> 		pwq->triggered = 0;
>>
>> And, if pollwake() happens in between we can miss the event, no?
> 
> Hmmmm... yes, from the second run, ->poll doesn't grab the waitqueue
> lock, so it doesn't necessary have the required barriers.
> Heh... set_mb() should be here not in pollwake().  Thanks for spotting
> it.

Oh, I remembered why I didn't use set_mb() there.  The logic was that
once the wait is over by either event triggering or timeout, the
poll/select finishes by either valid event or the timeout, but that
isn't true as the wake up could be spurious due to implementation
details or event masking, so yes we do need barrier there.

Thanks.

-- 
tejun
