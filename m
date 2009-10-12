Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbZJLKN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbZJLKN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbZJLKNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:13:25 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:37231 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893AbZJLKNY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:13:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rMoMVXWBwpSK2LqcnG2wYWV2ws0MiNwcyUuZxpsFXP/n+lPGSbqCoriIpSLK5xm+cN
         xgXNmOGAne1rTJVYC1g4FkdHp61Id9BLokLOVQwJ25jxg1HAx48rHZKv0DJA5A475a4R
         Ba5E5v7NTmgKy0XO5l/bwHu7b3FCdAz6iZFSE=
MIME-Version: 1.0
In-Reply-To: <c62985530910120310m386e9289v29e71fee1992476b@mail.gmail.com>
References: <20091007222733.1684.32035.stgit@dhcp-100-2-132.bos.redhat.com>
	 <20091007222807.1684.26880.stgit@dhcp-100-2-132.bos.redhat.com>
	 <c62985530910120310m386e9289v29e71fee1992476b@mail.gmail.com>
Date: Mon, 12 Oct 2009 12:12:47 +0200
Message-ID: <c62985530910120312q35c9b413s6671d8353694bf63@mail.gmail.com>
Subject: Re: [PATCH tracing/kprobes v3 4/7] tracing/kprobes: Avoid field name 
	confliction
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 12 octobre 2009 12:10, Frédéric Weisbecker <fweisbec@gmail.com> a écrit :
> 2009/10/8 Masami Hiramatsu <mhiramat@redhat.com>:
>> Check whether the argument name is conflict with other field names.
>>
>> Changes in v3:
>>  - Check strcmp() == 0 instead of !strcmp().
>>
>> Changes in v2:
>>  - Add common_lock_depth to reserved name list.
>>
>> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Mike Galbraith <efault@gmx.de>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Cc: Christoph Hellwig <hch@infradead.org>
>> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> Cc: Jim Keniston <jkenisto@us.ibm.com>
>> Cc: Frank Ch. Eigler <fche@redhat.com>
>> ---
>>
>>  kernel/trace/trace_kprobe.c |   65 +++++++++++++++++++++++++++++++++++--------
>>  1 files changed, 53 insertions(+), 12 deletions(-)
>>
>> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
>> index 030f28c..e3b824a 100644
>> --- a/kernel/trace/trace_kprobe.c
>> +++ b/kernel/trace/trace_kprobe.c
>> @@ -38,6 +38,25 @@
>>  #define MAX_EVENT_NAME_LEN 64
>>  #define KPROBE_EVENT_SYSTEM "kprobes"
>>
>> +/* Reserved field names */
>> +#define FIELD_STRING_IP "ip"
>> +#define FIELD_STRING_NARGS "nargs"
>> +#define FIELD_STRING_RETIP "ret_ip"
>> +#define FIELD_STRING_FUNC "func"
>
>
> If it might conflict, then we should minimize the possibilities for
> that to happen.
>
> What if we prefix these fields with kprobed_ ?
>
> kprobed_ip
> kprobed_nargs
> kprobed_ret_ip
> kprobed_func
>
> We are lucky there in that kprobe functions in the kernel can't be kprobed
> so it's safe wrt the conflict in the same namespace.
>
> And we can further schrink the kprobed prefixes in userspace post processing.
>
> (If you agree with the above, that can be done incrementally).
>
> Thanks.


I'm an idiot. I should have looked at the 5/7 patch before sending this reply.
Just forget about what I said :-)
