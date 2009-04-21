Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbZDUSQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbZDUSQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 14:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755625AbZDUSQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 14:16:45 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:1122 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbZDUSQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 14:16:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KYDDwzlTzQV2wdDOmDPMM309j5ljVmZ1BRHC00rjsAi3/5nNDnnhvP50UX8ZNYGQhV
         mBGtBED6zlV117AF6lCKkhQ9tqSI7uvPzl7lBlp3UAVcn/SDueIOnuIgiGCZtD4OV9kK
         ULea5r6euY0ngJ42yOla9wQ71x/PzREaDadHQ=
Date: Tue, 21 Apr 2009 20:16:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2 v3] tracing/events: provide string with undefined
	size support
Message-ID: <20090421181636.GA6001@nowhere>
References: <1240117295-6873-1-git-send-email-fweisbec@gmail.com> <1240117295-6873-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240117295-6873-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19, 2009 at 07:01:34AM +0200, Frederic Weisbecker wrote:
> This patch provides the support for dynamic size strings on
> event tracing.
> 
> The key concept is to use a structure with an ending char array field of
> undefined size and use such ability to allocate the minimal size on the
> ring buffer to make one or more string entries fit inside, as opposite
> to a fixed length strings with upper bound.
> 
> The strings themselves are represented using fields which have an offset
> value from the beginning of the entry.
> 
> This patch provides three new macros:
> 
> __string(item, src)
> 
> This one declares a string to the structure inside TP_STRUCT__entry.
> You need to provide the name of the string field and the source that will
> be copied inside.
> This will also add the dynamic size of the string needed for the ring
> buffer entry allocation.
> A stack allocated structure is used to temporarily store the offset
> of each strings, avoiding double calls to strlen() on each event
> insertion.
> 
> __get_str(field)
> 
> This one will give you a pointer to the string you have created. This
> is an abstract helper to resolve the absolute address given the field
> name which is a relative address from the beginning of the trace_structure.
> 
> __assign_str(dst, src)
> 
> Use this macro to automatically perform the string copy from src to
> dst. src must be a variable to assign and dst is the name of a __string
> field.
> 
> Example on how to use it:
> 
> TRACE_EVENT(my_event,
> 	TP_PROTO(char *src1, char *src2),
> 
> 	TP_ARGS(src1, src2),
> 	TP_STRUCT__entry(
> 		__string(str1, src1)
> 		__string(str2, src2)
> 	),
> 	TP_fast_assign(
> 		__assign_str(str1, src1);
> 		__assign_str(str2, src2);
> 	),
> 	TP_printk("%s %s", __get_str(src1), __get_str(src2))
> )
> 
> Of course you can mix-up any __field or __array inside this
> TRACE_EVENT. The position of the __string or __assign_str
> doesn't matter.
> 
> Changes in v2:
> 
> Address the suggestion of Steven Rostedt: drop the opening_string() macro
> and redefine __ending_string() to get the size of the string to be copied
> instead of overwritting the whole ring buffer allocation.
> 
> Changes in v3:
> 
> Address other suggestions of Steven Rostedt and Peter Zijlstra with
> some changes: drop the __ending_string and the need to have only one
> string field.
> Use offsets instead of absolute addresses.
> 
> [ Impact: better usage of memory for string tracing ]
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---


Hi,

Do you have doubts about this?
It would be nice to have a (N)Acked-by from you for these
two patches :-)

Thanks!

