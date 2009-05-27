Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbZE0BXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbZE0BXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 21:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbZE0BXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 21:23:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59632 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754789AbZE0BXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 21:23:07 -0400
Message-ID: <4A1C9645.7010107@cn.fujitsu.com>
Date: Wed, 27 May 2009 09:24:21 +0800
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
References: <4A1B6A2F.2040703@cn.fujitsu.com> <4A1B6A4C.3070407@cn.fujitsu.com> <alpine.DEB.2.00.0905261655120.26705@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0905261655120.26705@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> 
> On Tue, 26 May 2009, Li Zefan wrote:
> 
>> This changes __string(..., src) to __string(..., len), thus makes it more
>> general, and then block TRACE_EVENT() can use it.
>>
>> Also introduce __fetch_str(), which is used in TP_assign() and returns
>> the address of the string, while __get_str() is used in TP_print().
>>
>> [ Impact: TRACE_EVENT api change ]
> 
> What's the reason for the change?
> 
> Is it to handle NULL pointers? If so, lets change the ftrace.h to handle
> it instead.
> 

No, not for this purpose.

With __string(..., src), we need to have a source string, but sometimes no
source string is available, and what we know is how big the string will be.

Take block trace events for example, I want to convert an unsigned char array
into a string, after this patch, this can be done this way:

TP_STRUCT_entry(
	__string( cmd, rq->cmd_len * 3 )
)

TP_fast_assign(
	construct_str( cmd )
)

TP_prink("%s\n", get_str(cmd))

Seems Christoph also runs into this problem while doing his XFS tracing.
(and NULL str ptr that I'm not suffering)

> This is why I like the Impact line really be a "rational" line.
>  "TRACE_EVENT api change" is meaningless to me.
> 

So what should this impact be. :(
