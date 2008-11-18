Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbYKRPRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbYKRPRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYKRPR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:17:28 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:56042 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYKRPR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:17:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ewgXMcm/HAz6yrnQBQkGmIJWNesbNlk+szmlzoAhiVu/BLMQrSjN1N7j/wKTmlxvJi
         RR/n9wBRTSMiCJuEOwJTTB5j+osYcRXOLiD4BohnuKwoHbXGZAwuAy03eJ/9X3K9QSrY
         xg2hQq67OzXoxrS3+62t7z/eHrWVP9cPveC0U=
Date: Tue, 18 Nov 2008 23:17:21 +0800
From: walimis <walimisdev@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ftrace: fix wrong pos computing when read buffer
	has been fulfilled.
Message-ID: <20081118151721.GA23383@ubuntu.mshome.net>
References: <1226733546-23190-1-git-send-email-walimisdev@gmail.com> <alpine.DEB.1.10.0811180933490.15003@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811180933490.15003@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 09:36:07AM -0500, Steven Rostedt wrote:
>
>On Sat, 15 Nov 2008, walimis wrote:
>
>> 
>> hi Steven,
>> 
>> Could you help me to review this patch?
>> 
>> Thanks.
>> 
>> Impact: make output of available_filter_functions complete
>> 
>> phenomenon:
>> 
>> The first value of dyn_ftrace_total_info is not equal with
>> `cat available_filter_functions | wc -l`, but they should be equal.
>> 
>> root cause:
>> 
>> When printing functions with seq_printf in t_show, if the read buffer
>> is just overflowed by current function record, then this function
>> won't be printed to user space through read buffer, it will
>> just be dropped. So we can't see this function printing.
>> So, every time the last function to fill the read buffer, if overflowed,
>> will be dropped.
>> This also applies to set_ftrace_filter if set_ftrace_filter has
>> more bytes than read buffer.
>> 
>> fix:
>> 
>> Through checking return value of seq_printf, if less than 0, we know
>> this function doesn't be printed. Then we decrease position to force
>> this function to be printed next time, in next read buffer.
>
>A lot of the code for seq files I cut and paste from other places that I 
>have written it. The seq files always confuse me, so I like to use stuff 
>that worked before. Some of the things that walimis fixed were not needed 
>for this file, and was overkill.
It also confuse me a lot. I also checked all places using seq files in
trace/ftrace code, to see whether there are similar problem.
  - trace.c: in s_start() it force pos to decrease one such as: 
	l = *pos - 1;
	so it works well.
  - trace_stack.c: t_start, in almost all cases, can be only called
    once, so we don't see the error. But I wonder whether it still works
    well if output message exceeds the size of seq file buffer and call
    t_start twice. If needed, I can test it.
  - trace_branch.c : the same with above.


walimis
>
>> 
>> another little fix is to show correct allocating pages count.
>
>Ack.
>
>> 
>> Signed-off-by: walimis <walimisdev@gmail.com>
>
>Acked-by: Steven Rostedt <srostedt@redhat.com>
>
>-- Steve
