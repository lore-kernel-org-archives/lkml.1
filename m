Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbZJJHNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbZJJHNV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 03:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754451AbZJJHNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 03:13:17 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:35755 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbZJJHNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 03:13:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=dk5rHBGVpoSRJiDDnf0ENs32FaKJ2Rf7FgnEKFgjE6207UwEdXuRXA5vnzQ3kxXS9K
         umQVpV5O+dcrlKmwqFKNN/zxU09UFiJ0xVoz1ioLSg9by6KvTgz/nil6z2CfhxOgiu6L
         Zk+FmCc/R1L+EbXyCmopuGhwGPoIjRGtJFliY=
MIME-Version: 1.0
In-Reply-To: <2f11576a0910092332s6e0e3dcs35864e3a2164be0@mail.gmail.com>
References: <20091009134354.12A7.A69D9226@jp.fujitsu.com> <20091009171344.3fc5f28b.akpm@linux-foundation.org> 
	<3e8340490910091922g7891b31al649e91f15ffae687@mail.gmail.com> 
	<20091009194250.eb76e338.akpm@linux-foundation.org> <3e8340490910091957t21eb16e0r63eba2314ddb83a8@mail.gmail.com> 
	<2f11576a0910092332s6e0e3dcs35864e3a2164be0@mail.gmail.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Sat, 10 Oct 2009 03:11:48 -0400
Message-ID: <3e8340490910100011u17497293o613334c64f1543c8@mail.gmail.com>
Subject: Re: [resend][PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>, linux-api@vger.kernel.org,
       Timo Sirainen <tss@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 10, 2009 at 2:32 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:

>> It does seem like a maximum spin count should be put in there - and
>> maybe a timeout as well (since with FUSE etc it's possible to engineer
>> page faults that take arbitrarily long).
>> Also, it occurs to me that:
>
> makes sense.
> I like maximum spin rather than timeout.

I'm worried about the scenario where process A sets its cmdline buffer
to point to a page which will take a _VERY_ long time to pagein (maybe
forever), and then process B goes to try to read its cmdline. What
happens now?
Process A can arrange for this to happen by using a FUSE filesystem
that sits on a read forever. And since the first thing the admin's
likely to do to track down the problem is 'ps awux', this is liable to
be a rather nasty DoS...

Of course, this is no worse than it is now - it's already possible to
replace the page in question. But we should think about ways this
could be fixed for good...

>
>>> +     do {
>>> +             seq = read_seqbegin(&mm->arg_lock);
>>> +
>>> +             len = mm->arg_end - mm->arg_start;
>>> +             if (len > PAGE_SIZE)
>>> +                     len = PAGE_SIZE;
>>
>> If arg_end or arg_start are modified after this, is it truly safe to
>> assume that len will remain <= PAGE_SIZE without a memory barrier
>> before the conditional?
>
> 1) access_process_vm() doesn't return error value.
> 2) read_seqretry(&mm->arg_lock, seq)) check seq, not mm->arg_start or len.
>
> then, if arg_{start,end} is modified, access_process_vm() may return 0
> and strnlen
> makes bad calculation, but read_seqretry() can detect its modify
> rightly. I think.

No, I'm worried about what if the compiler decides to rewrite like so:
if (mm->arg_end - mm->arg_start > PAGE_SIZE)
  len = PAGE_SIZE;
else /* here we reload arg_end/arg_start! */
  len = mm->arg_end - mm->arg_start;

Now we might write into buffer more than PAGE_SIZE bytes, which is
probably a buffer overrun into kernel space...
