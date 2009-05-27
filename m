Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbZE0ILf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbZE0ILf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 04:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756612AbZE0ILU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 04:11:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54068 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756410AbZE0ILT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 04:11:19 -0400
Message-ID: <4A1CF5F2.6050209@cn.fujitsu.com>
Date: Wed, 27 May 2009 16:12:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Steven Whitehouse <swhiteho@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jeff Moyer <jmoyer@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] tracing/events: make __string() more general
References: <4A1B6A2F.2040703@cn.fujitsu.com> <4A1B6A4C.3070407@cn.fujitsu.com> <20090526060232.GA10669@infradead.org> <4A1C9AC4.3090704@cn.fujitsu.com> <20090527072956.GC24381@infradead.org>
In-Reply-To: <20090527072956.GC24381@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, May 27, 2009 at 09:43:32AM +0800, Li Zefan wrote:
>> I'm not suffering from NULL str, so I'm not quite sure how you want __string()
>> deal with it.
> 
> The internals of __string is still magic to me, need to finish my
> advance cpp abuse degree first ;-)
> 

It's no longer magic to me. ;)

> But the expected outcome would be that when we get a NULL pointer as
> input we get a NULL pointer as output again.
> 

The following trick should meet your needs (based on this 1/2 patch):

(Not even compiled!)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index d1c0cc5..c5911d0 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -117,7 +117,10 @@
 #define TP_printk(fmt, args...) fmt "\n", args
 
 #undef __get_str
-#define __get_str(field)	((char *)__entry + __entry->__str_loc_##field)
+#define __get_str(field)						\
+	(__entry->__str_lock_##field != -1) ?				\
+		((char *)__entry + __entry->__str_loc_##field) :	\
+		NULL
 
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
@@ -412,8 +415,11 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *call) \
 
 #undef __string
 #define __string(item, len)						 \
-	__str_offsets.item = __str_size +				 \
-			     offsetof(typeof(*entry), __str_data);	 \
+	if (len)							 \
+		__str_offsets.item = __str_size +			 \
+				     offsetof(typeof(*entry), __str_data);\
+	else								 \
+		__str_offsets.item = -1;				 \
 	__str_size += (len) + 1;
 
 #undef __fetch_str

> What I currently do is:
> 
> TRACE_EVENT(xfs_dir2,
> 	TP_PROTO(struct xfs_da_args *args, int i, int j, int count),
> 	TP_ARGS(args, i, j, count),
> 
> 	TP_STRUCT__entry(
> 		__field(xfs_ino_t, ino)
> 		__array(char, name, TRACE_MAXNAMELEN)
> 		__field(int, namelen)
> 		...
> 	),
> 
>         TP_fast_assign(
> 		__entry->ino = args->dp->i_ino;
> 		if (args->namelen)
> 			memcpy(__entry->name, args->name,
> 			       min(args->namelen, TRACE_MAXNAMELEN));

This string is not NULL-terminated?

> 		__entry->namelen = args->namelen;
> 		...
> 	),
> 
> 	TP_printk("ino 0x%lld %pF name %.*s namelen %d hashval 0x%x "
> 		  "inumber 0x%llx op_flags %s i %d j %d count %d",
> 		  __entry->ino,
> 		  (void *)__entry->caller_ip,
> 		  min(__entry->namelen, TRACE_MAXNAMELEN),
> 		  __entry->namelen ? __entry->name : NULL,
> 		  __entry->namelen,
> 		  ...)
> );
> 

Then the above code can be rewrote:

TRACE_EVENT(xfs_dir2,
	TP_PROTO(struct xfs_da_args *args, int i, int j, int count),
	TP_ARGS(args, i, j, count),

	TP_STRUCT__entry(
		__field(xfs_ino_t, ino)
		__string(name, args->namelen)
		__field(int, namelen)
		...
	),

        TP_fast_assign(
		__entry->ino = args->dp->i_ino;
		memcpy(__fetch_str(name), args->name, args->namelen);
		__entry->namelen = args->namelen;
		...
	),

	TP_printk("ino 0x%lld %pF name %.*s namelen %d hashval 0x%x "
		  "inumber 0x%llx op_flags %s i %d j %d count %d",
		  __entry->ino,
		  (void *)__entry->caller_ip,
		  __entry->namelen,
		  __get_str(name),
		  __entry->namelen,
		  ...)
);

