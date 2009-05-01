Return-Path: <linux-kernel-owner+w=401wt.eu-S1765388AbZEAV0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765388AbZEAV0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 17:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbZEAVZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 17:25:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37864 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbZEAVZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 17:25:51 -0400
Message-ID: <49FB68B5.4090804@redhat.com>
Date: Fri, 01 May 2009 14:25:09 -0700
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jason Baron <jbaron@redhat.com>, mingo@elte.hu, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] export softirq_to_name symbol
References: <20090501193022.GB3111@redhat.com> <20090501195015.GA31694@infradead.org> <49FB5686.8020908@redhat.com> <20090501201028.GA2084@infradead.org> <49FB58F7.8080109@redhat.com> <20090501202246.GA20056@infradead.org>
In-Reply-To: <20090501202246.GA20056@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2009 01:22 PM, Christoph Hellwig wrote:
> On Fri, May 01, 2009 at 01:17:59PM -0700, Josh Stone wrote:
>> More precisely, it's the piece of code that copies the trace into an
>> __entry pointer.  In my case, __entry has nothing to do with the ring
>> buffer.
> 
> Well, it should be the ring buffer.  If you want to do something more
> fancy rewrite it in proper C code and submit a patch for discussion to
> lkml.

It's not that fancy -- this is basically it:

#define __field(type, item)         type item;
#define __array(type, item, len)    type item[len];
#define __string(item, src)         const char * __str_##item;
#define __assign_str(item, src)     __entry->__str_##item = src
#define __get_str(item)             __entry->__str_##item
#define TRACE_EVENT(name, proto, args, tstruct, assign, print)  \
  static inline int                                             \
  trace_snprintf_##name(char * __buf, size_t __size, proto) {   \
    struct { tstruct } __value, *__entry = &__value;            \
    assign;                                                     \
    return snprintf(__buf, __size, print);                      \
  }

I don't know if anyone would need this besides stap, but I can post it
as a patch if there's interest.

Josh
