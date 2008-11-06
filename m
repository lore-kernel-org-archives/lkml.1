Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbYKFAmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbYKFAmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 19:42:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYKFAlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 19:41:52 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:3406 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbYKFAlv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 19:41:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=h+CKbTHoIVEwFFi+3zQTGXWCnxyxLV6h98Me7La65wX9YZAY1vJYeKCgIIrJHb45iK
         Qk2NFJADHe0IcR6FVlQcTojKLlSNgdjsTNWGPGR6wqgd1tRk2jKiEsLbIHni/jE/8M/X
         MmKw1hJttUIWeybnaH3/b9yX2x0HeLy4xwqnw=
Message-ID: <c62985530811051641o2569dba1p2dc5f32512ba6497@mail.gmail.com>
Date: Thu, 6 Nov 2008 01:41:49 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing: use raw spinlocks instead of spinlocks
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081105105541.GB19361@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <490E3F73.1000405@gmail.com>
	 <alpine.DEB.1.10.0811021940030.32371@gandalf.stny.rr.com>
	 <20081103064647.GA4826@elte.hu>
	 <c62985530811031803o6909518ax137d42189dcff0de@mail.gmail.com>
	 <20081104094341.GO23790@elte.hu>
	 <c62985530811040314o13394d43t201ae3fc2f1304be@mail.gmail.com>
	 <20081104120355.GA19969@elte.hu>
	 <c62985530811050250u638c8f95j7d80a13f834b06bf@mail.gmail.com>
	 <20081105105541.GB19361@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/5 Ingo Molnar <mingo@elte.hu>:
>
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>
>> 2008/11/4 Ingo Molnar <mingo@elte.hu>:
>> > just make sure normal printk is totally silent. (otherwise you get
>> > double lines on the console plus no reduction in recursion risk)
>> >
>> > i usually add a return; hack to kernel/printk.c:printk(), to make sure
>> > it never executes anything. (and add a notrace to it as well) Maybe we
>> > could even make this dependent on early_printk=...,keep.
>>
>> Thanks for your help!
>>
>> I tried the earlyprintk=vga,keep and I thought that the normal printk
>> output would
>> be replaced by early_printk output but that's not the case...
>> So I replaced the content of printk by this of early_printk and it worked.
>> But it seems that after the setting of the console, the early_printk
>> doesn't work anymore.
>>
>> Should I disable something else? I haven't any console=.... parameter
>> but I guess I missed
>> something there...
>
> perhaps try a "console=tty 3" bootup - to boot into non-graphics
> initlevel 3, and to have a vga tty set up. Then comment out the
> regular printk(), to make sure it never tries to output to the regular
> tty.
>
> does earlyprintk=vga,keep work in that case?
>
>> But, I set the parameter nmi_watchdog=2 (I didn't know I had to
>> start explicitly the nmi watchdog) and at last... I had my
>> backtraces :-)
>
> heh :-)
>
>> All these backtraces were related to time function. And one of the
>> special things of the time functions is that they often manipulate
>> 64 bits numbers. Actually I totally forgot that a function could
>> return a long long, so I had to save edx register in the return
>> handler to restore it in its end because 64 bits numbers are
>> returned as a couple into eax and edx in x86-32.
>>
>> So the main problem is now solved. But it remains a last (but more
>> rare) deadlock somewhere. I don't know why at this time and the nmi
>> watchdog doesn't tell anything. So I will have to use early_printk
>> to see the last functions traced. But the problem is that it doesn't
>> print on the console...
>
> hm. Let me know if you cannot get this to work. I regularly use
> earlyprintk=serial,...,keep myself, and it works there - but i dont
> use earlyprintk=vga,keep that often.
>
>        Ingo
>


Actually, I didn't need it. I just turned off the nmi watchdog and I
don't have anymore deadlock. The good news is that I have now
something that seems stable. I will have some time this week-end to
try to make a proper patch with this feature.

Thanks for your help!
