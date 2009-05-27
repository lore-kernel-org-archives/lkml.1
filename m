Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbZE0Ccj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbZE0Ccj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 22:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbZE0Ccc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 22:32:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53711 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbZE0Ccc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 22:32:32 -0400
Message-ID: <4A1CA68B.4070609@cn.fujitsu.com>
Date: Wed, 27 May 2009 10:33:47 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Steven Whitehouse <swhiteho@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] tracing/events: make __string() more general
References: <4A1B6A2F.2040703@cn.fujitsu.com> <4A1B6A4C.3070407@cn.fujitsu.com> <alpine.DEB.2.00.0905261655120.26705@gandalf.stny.rr.com> <4A1C9645.7010107@cn.fujitsu.com> <alpine.DEB.2.00.0905262147470.27902@gandalf.stny.rr.com> <4A1C9E70.8000609@cn.fujitsu.com> <alpine.DEB.2.00.0905262202390.27902@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0905262202390.27902@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Ah, it's pseudo code.. Should be construct_str(__entry->cmd, rq),
>> this helper function convert rq->cmd (unsigned char[]) to a string of
>> hex dump.
>>
>> No source string is available, so I'm not calling assign_str() in
>> TP_fast_assign.
> 
> OK, I think I have a better understanding of what you are doing.
> 
> But, I don't like changing the interface for string by adding that 
> "strlen" to all users. I find that very ugly.
> 

Yeah, it does look somewhat ugly..

> Could we instead perhaps add a __dynamic_array? That would take a length, 
> and append itself to after the strings?
> 

I thought about this actually. ;)

What troubled me is to give this new macro a better name.

We have __array() which is fixed-size, but __dynamic_array() is not
a dynamic-size version of __array(). How about __dyn_string() or
__dynamic_string()?

> stage 1:
> 
> #define __dynamic_array(item, len)	int __dyn_loc_##item;
> 
> stage 2:
> 
> #define __dynamic_array(item, len)	int item;
> 
> stage 3:
> 
> #define __get_dynamic_array(item)	\
> 	((void *)__entry + __entry->__str_loc_##field
> 
> stage 4:
> 
> #define __dynamic_array(item, len)	\
> 	__str_offsets.item = __str_size + \
> 		offsetof(typeof(*entry), __str_data);	\
> 	__str_size += len;
> 

Then we can make __string() reuse __dynamic_array().

> 
> And so on. You should be able to do something like this, and make it more 
> generic.
> 

