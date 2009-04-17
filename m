Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbZDQJAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbZDQJAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 05:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757673AbZDQI76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 04:59:58 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:54780 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757084AbZDQI75 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 04:59:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dRBplK5fYv495zK9eKO/xw/cy81Yjj7mQLfX12172ACFcb8RaARV1wMG0sZCl9IWeO
         AwvJIdVUO9KYWMOo+ozYPjzD7NySKEM5tNpekLMXg04/q15dM82BS3KO7RKtS+vx0L1k
         UQFPez55+U0UG0vrfAsKZABF/VsrfR6Nfk8CQ=
MIME-Version: 1.0
In-Reply-To: <1239949360.23397.4065.camel@laptop>
References: <1239912047-6282-1-git-send-email-fweisbec@gmail.com>
	 <1239912812.23397.3432.camel@laptop>
	 <c62985530904161328g299e8a67q2012a577e8a2f1a4@mail.gmail.com>
	 <1239949360.23397.4065.camel@laptop>
Date: Fri, 17 Apr 2009 10:59:54 +0200
Message-ID: <c62985530904170159j6f3b5477g411a028e69fd93f6@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] tracing/events: provide string with undefined size 
	support
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 17 avril 2009 08:22, Peter Zijlstra <a.p.zijlstra@chello.nl> a écrit :
> On Thu, 2009-04-16 at 22:28 +0200, Frédéric Weisbecker wrote:
>> 2009/4/16 Peter Zijlstra <a.p.zijlstra@chello.nl>:
>> > On Thu, 2009-04-16 at 22:00 +0200, Frederic Weisbecker wrote:
>> >> Impact: less memory usage for tracing
>> >>
>> >> This patch provides the support for dynamic size strings on
>> >> event tracing.
>> >>
>> >> The key concept is to use a structure with an ending char array field of
>> >> undefined size and use such ability to allocate the minimal size on the ring
>> >> buffer to make the entry fit inside as opposite to a fixed length strings with
>> >> upper bound.
>> >>
>> >> This patch provides one new macro:
>> >>
>> >> -__ending_string(name, src)
>> >>
>> >> This one declares the string to the structure inside TP_STRUCT__entry.
>> >> You need to provide the name of the string field and the source that will be
>> >> copied inside.
>> >> Two constraints: only one __ending_string() per TRACE_EVENT can be added and
>> >> it must be the last field to be declared. Hence the __ending prefix.
>> >>
>> >> This macro will declare the necessary field and will also add the dynamic
>> >> size of the string needed for the ring buffer entry allocation.
>> >>
>> >> It also support filtering because these strings behave essentially
>> >> like usual fixed length string.
>> >
>> > can't we simply do __string(name, src) and output something like:
>> >
>> >  struct {
>> >   u16 size;
>> >   char str[0];
>> >  } name;
>> >
>> > That would get rid of this __ending_ wart.
>> >
>> >
>>
>> Hmm, I don't understand.
>> Such a thing doesn't seem to work. Once we fill the string it would
>> override the fields that
>> follow it if it's not at the end.
>
> Just grow the thing to fit whatever string length -- rather common
> pattern:
>
> struct foo {
>  int length;
>  char data[0];
> };
>
> struct foo *bar = kmalloc(sizeof(struct foo) + data_size);
>
> and bob's your uncle.
>
>


Ok, but I can't do that.
What we do is allocating towards the ring buffer before filling:

struct foo {
   field1;
   field2;
   ...
};

struct foo *f;

event = ring_buffer_lock_reserve(sizeof(*f), ...);
f = ring_buffer_event_data(event);

I can't use a kmalloc here. We are tracing a random event which can happen
at a random frequency, random context, etc...
