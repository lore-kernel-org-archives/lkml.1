Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbZE0CP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbZE0CP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 22:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbZE0CPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 22:15:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34692 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbZE0CPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 22:15:14 -0400
Date: Tue, 26 May 2009 22:15:15 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Steven Whitehouse <swhiteho@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] tracing/events: make __string() more general
In-Reply-To: <4A1C9E70.8000609@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0905262202390.27902@gandalf.stny.rr.com>
References: <4A1B6A2F.2040703@cn.fujitsu.com> <4A1B6A4C.3070407@cn.fujitsu.com> <alpine.DEB.2.00.0905261655120.26705@gandalf.stny.rr.com> <4A1C9645.7010107@cn.fujitsu.com> <alpine.DEB.2.00.0905262147470.27902@gandalf.stny.rr.com>
 <4A1C9E70.8000609@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 27 May 2009, Li Zefan wrote:
> >>
> >> With __string(..., src), we need to have a source string, but sometimes no
> >> source string is available, and what we know is how big the string will be.
> >>
> >> Take block trace events for example, I want to convert an unsigned char array
> >> into a string, after this patch, this can be done this way:
> >>
> >> TP_STRUCT_entry(
> >> 	__string( cmd, rq->cmd_len * 3 )
> >> )
> >>
> >> TP_fast_assign(
> >> 	construct_str( cmd )
> > 
> > What does the construct_str do?
> > 
> 
> Ah, it's pseudo code.. Should be construct_str(__entry->cmd, rq),
> this helper function convert rq->cmd (unsigned char[]) to a string of
> hex dump.
> 
> No source string is available, so I'm not calling assign_str() in
> TP_fast_assign.

OK, I think I have a better understanding of what you are doing.

But, I don't like changing the interface for string by adding that 
"strlen" to all users. I find that very ugly.

Could we instead perhaps add a __dynamic_array? That would take a length, 
and append itself to after the strings?

stage 1:

#define __dynamic_array(item, len)	int __dyn_loc_##item;

stage 2:

#define __dynamic_array(item, len)	int item;

stage 3:

#define __get_dynamic_array(item)	\
	((void *)__entry + __entry->__str_loc_##field

stage 4:

#define __dynamic_array(item, len)	\
	__str_offsets.item = __str_size + \
		offsetof(typeof(*entry), __str_data);	\
	__str_size += len;


And so on. You should be able to do something like this, and make it more 
generic.

-- Steve

