Return-Path: <linux-kernel-owner+w=401wt.eu-S1757202AbZCYC2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbZCYC2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 22:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbZCYC2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 22:28:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62822 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbZCYC2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 22:28:35 -0400
Message-ID: <7867D4500D2F4CFFB36A9EA93C0DC2D5@zhaoleiwin>
From: "Zhaolei" <zhaolei@cn.fujitsu.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
References: <49BA23D9.1050900@cn.fujitsu.com> <20090313092558.GD2571@elte.hu> <18199AAD941A4071B7FD8A0D6C67733A@zhaoleiwin> <alpine.DEB.2.00.0903241152020.22830@gandalf.stny.rr.com>
Subject: Re: [PATCH] ftrace: Avoid double-free of dyn_ftrace
Date: Wed, 25 Mar 2009 10:25:47 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n2P2Slqu029371

* From: "Steven Rostedt" <rostedt@goodmis.org>
> On Fri, 13 Mar 2009, Zhaolei wrote:
> 
>> * From: "Ingo Molnar" <mingo@elte.hu>
>> > 
>> > * Zhaolei <zhaolei@cn.fujitsu.com> wrote:
>> > 
>> >> If dyn_ftrace is free before ftrace_release(), 
>> >> ftrace_release() will free it again and make 
>> >> ftrace_free_records wrong.
>> >> 
>> >> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
>> >> ---
>> >>  kernel/trace/ftrace.c |    3 ++-
>> >>  1 files changed, 2 insertions(+), 1 deletions(-)
>> >> 
>> >> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
>> >> index d33d306..26c45aa 100644
>> >> --- a/kernel/trace/ftrace.c
>> >> +++ b/kernel/trace/ftrace.c
>> >> @@ -356,7 +356,8 @@ void ftrace_release(void *start, unsigned long size)
>> >>  
>> >>  mutex_lock(&ftrace_lock);
>> >>  do_for_each_ftrace_rec(pg, rec) {
>> >> - if ((rec->ip >= s) && (rec->ip < e))
>> >> + if ((rec->ip >= s) && (rec->ip < e) &&
>> >> +     !(rec->flags & FTRACE_FL_FREE))
>> >>  ftrace_free_rec(rec);
>> > 
>> > Applied to tip:tracing/ftrace, thanks!
>> > 
>> > I'm wondering, did you trigger this in practice (if yes, how?), 
>> > or have you found it via code review?
>> Hello, Ingo
>> 
>> It is found via code review.
> 
> Hmm, could you explain this more. I'm thinking that this scenario should 
> not happen, and if it does, it should probably be a bug.
> 
> Because when we call ftrace_free_rec we change the rec->ip to point to the 
> next record in the chain. Something is very wrong if rec->ip >= s && 
> rec->ip < e and the record is already free.
Hello, Steven

Thanks for your comment.
I got your meaning, and I agree that if rec->ip >= s && rec->ip < e,
this record is not freed.
But IMHO, "if rec->ip >= s && rec->ip < e" is used to select records in the module,
and function of ignore "freed record" is only its side-effect.
So, add a special judgement to avoid "freed record" is not a bad idea.
And I also agree your suggestion of add a WARN_ON, because this should not happened.

B.R.
Zhaolei

> 
> We can add a:
> 
> WARN_ON(rec->flags & FTRACE_FL_FREE);
> 
> in ftrace_free_rec if you are worried about this happening.
> 
> -- Steve
> 
> 
>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
