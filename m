Return-Path: <linux-kernel-owner+w=401wt.eu-S1756401AbZBIShh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbZBIShh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 13:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbZBISh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 13:37:29 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:25359 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbZBISh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 13:37:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UC82MX5+SBlU5uWoO98+8jFBChXuHXOu/8JQ/DZN7kN+kqHDyPZraSwd00sSBMYHuC
         Ss7HkGyqVMMUdoaJ7dEgssoXhnBqX2uR/s9JgW4WemFYjCAMRUjjxcgZuNsE4NA2glYb
         1Jfl+m5ZUPS9tps0GyQqNbWB00veOqmeJXZZQ=
Date: Mon, 9 Feb 2009 20:37:54 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/3] tracing: clean up splice code
Message-ID: <20090209183754.GB5283@localhost>
References: <20090209172830.087244662@goodmis.org> <20090209172956.970104543@goodmis.org> <20090209182500.GA5283@localhost> <4990754C.7010301@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4990754C.7010301@cs.helsinki.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 08:26:20PM +0200, Pekka Enberg wrote:
> Eduard - Gabriel Munteanu wrote:
>>> @@ -2573,45 +2607,25 @@ static ssize_t tracing_splice_read_pipe(struct 
>>> file *filp,
>>>  		ret = iter->trace->splice_read(iter, filp,
>>>  					       ppos, pipe, len, flags);
>>>  		if (ret)
>>> -			goto out;
>>> +			goto out_err;
>>>  	}
>>>   	ret = tracing_wait_pipe(filp);
>>>  	if (ret <= 0)
>>> -		goto out;
>>> +		goto out_err;
>>>   	if (!iter->ent && !find_next_entry_inc(iter)) {
>>>  		ret = -EFAULT;
>>> -		goto out;
>>> +		goto out_err;
>>>  	}
>>>   	/* Fill as many pages as possible. */
>>>  	for (i = 0, rem = len; i < PIPE_BUFFERS && rem; i++) {
>>>  		pages[i] = alloc_page(GFP_KERNEL);
>>> +		if (!pages[i])
>>> +			break;
>> I believe you should decrement 'i' before breaking, since we fill
>> spd.nr_pages just after the loop. In case the current page couldn't be
>> allocated, spd.nr_pages will be one too many (that is, 'i').
>
> But, but, if we fail for i == 1, for example, we want ->nr_pages == 1, no?
>
> 			Pekka

Sure, my bad. I even made the same assumption myself about the outer
'for' loop when I wrote it ('i' would end up last page + 1). The patch is
okay. :-)


	Eduard

