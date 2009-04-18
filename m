Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbZDRSmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbZDRSmi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 14:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbZDRSm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 14:42:29 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:53133 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbZDRSm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 14:42:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sBNm7e/bS3TgUb6UgbA8VJnGOQqi99aB8NXXHy+yzZ4dOekIJ8TtFAVKtmq/PWdHbc
         DXQcIkzeE2xdArz3ysTEkXtTI+Wc73d2mBlBnNZpNFI0sDRyIgvKOtobp4FgqDppLlja
         w6WsararC9FZPSddegFVQSe952qhiZW73gnNw=
Date: Sat, 18 Apr 2009 20:42:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] tracing/events: provide string with undefined
	size support
Message-ID: <20090418184222.GB6212@nowhere>
References: <1239912047-6282-1-git-send-email-fweisbec@gmail.com> <1239912812.23397.3432.camel@laptop> <c62985530904161328g299e8a67q2012a577e8a2f1a4@mail.gmail.com> <1239949360.23397.4065.camel@laptop> <c62985530904170159j6f3b5477g411a028e69fd93f6@mail.gmail.com> <1239960548.23397.4282.camel@laptop> <alpine.DEB.2.00.0904170552160.20429@gandalf.stny.rr.com> <alpine.DEB.2.00.0904170613370.20429@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904170613370.20429@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 06:39:56AM -0400, Steven Rostedt wrote:
> On Fri, 17 Apr 2009, Steven Rostedt wrote:
> > 
> > But that said, one could still do what you are suggesting. The "__ending" 
> > wart still needs to be there, since it must happen at the end of the 
> > struct.
> > 
> > 
> >         TP_STRUCT__entry(
> >                 __field(int, str2loc)
> >                 __field(int, str3loc)
> > 		__string(str1)
> > 		__string(str2)
> >                 __ending_string(data, str3)
> >         ),
> >         TP_fast_assign(
> > 		__entry->str2loc = strlen(str1);
> > 		__entry->str3loc = strlen(str2) + __entry->str2loc;
> >                 strcpy(__entry->data, str1);
> > 		strcpy(__entry->data + __entry->str2loc, str2)
> > 		strcpy(__entry->data + __entry->str3loc, str3)
> >         ),
> >         TP_printk("str1:%s str2:%s str3:%s\n",
> > 		__entry->data,
> > 		__entry->data + __entry->str2loc,
> > 		__entry->date + __entry->str3loc)
> > 
> > 
> > For this to work, we need to just add a define for the __string macro for 
> > the reservation:
> > 
> > #define __string(x)  __str_size_ += strlen(x) + 1;
> 
> Hmm, thinking about this more, we could do...
> 
> 
> Make all structs end with:

> 
> 	char __str_data__[0];
> 
> 
> then we could just have __string(dec, param), ie.
> 
> 
> 	__string(str1, param_str1)
> 	__string(str2, param_str2)
> 	__string(srt3, param_str3)
> 
> But instead of defining string as a character, it would just be an index 
> into the __str_data_.
> 
> #define __string(dec, param)	int dec;
> 
> 
> We can break up the TRACE_EVENT macro again to create the declaration:
> 
> #undef everything and make empty macros of all we don't use
> 
> #define __string(dec, str)	int __str_loc_##dec;
> 
> #define TRACE_EVENT(...)	\
> static void ftrace_raw_event_##call(proto)	\
> {	\
> 	struct ring_buffer_event *event;	\
> 	struct ftrace_raw_##call *entry;	\
> 	unsigned long flags;			\
> 	int pc;					\
> 	int _str_size_ = 0;			\
> 						\
> 	tstruct
> 
> #include the file
> 
> #undef __string
> #define __string(str, param)	__str_loc_##str = _str_size_; \
> 				_str_size_ += strlen(param) + 1;
> 
> #define TRACE_EVENT(...)
> 	tstruct
> 
> #include the file again


While I'm trying to implement this, I'm discovering that it's
impossible, unless we have only one TRACE_EVENT in the file we are
including, otherwise we would end up with interleaving functions:

 static void ftrace_raw_event_event1(proto)
 {
       struct ring_buffer_event *event;
       struct ftrace_raw_event1 *entry;
       unsigned long flags;
       int pc;
       int _str_size_ = 0;

       tstruct

 static void ftrace_raw_event_event2(proto)     
 {      
       struct ring_buffer_event *event;         
       struct ftrace_raw_event2 *entry;   
       unsigned long flags;                     
       int pc;                                  
       int _str_size_ = 0;                      

       tstruct


So we still need something inside the fast_assign to do the
assignment job.

Something like the following macro will suffice:

#define	__assign_string(field, src)	\
	strcpy(entry->__ending_str + __str_loc_##field, src);

That's not a big deal, we just actually need this in TP__fast_assign()
and then we are done.

And also:


> The tstruct would do the assign for the user.
> 
> Then this is what a TRACE_EVENT would look like:
> 
> TRACE_EVENT(my_event,
> 
> 	TP_PROTO(char *str1, char *str2, char *str3),
> 
> 	TP_ARGS(str1, str2, str3),
> 
> 	TP_STRUCT__entry(
> 		__string(str1, str1)
> 		__string(str2, str2)
> 		__string(str3, str3)
> 	),
> 
> 	TP_fast_assign(
> 		/* empty, strings are automated */
> 	),
> 
> 	TP_printk("str1:%s str2:%s str3:%s\n",
> 		__entry->__str_data__ + __entry->str1,
> 		__entry->__str_data__ + __entry->str2,
> 		__entry->__str_data__ + __entry->str3)



A simple macro here to simplify that for the users:

#define __get_str(item)		\
	__entry->__ending_str + __entry->__str_loc_#item

would be much more convenient.

Anyway, I'll submit it and will wait for your comments.

Frederic.


> );
> 
> 
> /me feels more evil than ever ;-)
> 
> -- Steve
> 
> 

