Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbZBISao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbZBISao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 13:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZBISaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 13:30:35 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51595 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbZBISaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 13:30:35 -0500
Message-ID: <4990754C.7010301@cs.helsinki.fi>
Date: Mon, 09 Feb 2009 20:26:20 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/3] tracing: clean up splice code
References: <20090209172830.087244662@goodmis.org> <20090209172956.970104543@goodmis.org> <20090209182500.GA5283@localhost>
In-Reply-To: <20090209182500.GA5283@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduard - Gabriel Munteanu wrote:
>> @@ -2573,45 +2607,25 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
>>  		ret = iter->trace->splice_read(iter, filp,
>>  					       ppos, pipe, len, flags);
>>  		if (ret)
>> -			goto out;
>> +			goto out_err;
>>  	}
>>  
>>  	ret = tracing_wait_pipe(filp);
>>  	if (ret <= 0)
>> -		goto out;
>> +		goto out_err;
>>  
>>  	if (!iter->ent && !find_next_entry_inc(iter)) {
>>  		ret = -EFAULT;
>> -		goto out;
>> +		goto out_err;
>>  	}
>>  
>>  	/* Fill as many pages as possible. */
>>  	for (i = 0, rem = len; i < PIPE_BUFFERS && rem; i++) {
>>  		pages[i] = alloc_page(GFP_KERNEL);
>> +		if (!pages[i])
>> +			break;
> 
> I believe you should decrement 'i' before breaking, since we fill
> spd.nr_pages just after the loop. In case the current page couldn't be
> allocated, spd.nr_pages will be one too many (that is, 'i').

But, but, if we fail for i == 1, for example, we want ->nr_pages == 1, no?

			Pekka
