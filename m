Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbYK1Nzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbYK1Nzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 08:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYK1Nzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 08:55:46 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:27880 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbYK1Nzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 08:55:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZhShmoe9AxIUeTNXmXq/xu6AD3+xfmncWlUgwF7b2NQhoFuVO5aV0Up0qfeEpkEo4Z
         KY5vUNGqoY+EGPaLRCPx9WyXaZKHYf+br1ntxU3cZJcipXlTteYEKu9SgPBuZFRiJ/8l
         5lZudKneANX3SxkDHYIUd+mX7W9LACaX9C5+E=
Message-ID: <c62985530811280555m3b6eaa7fwb50bbe0f5c13bdd3@mail.gmail.com>
Date: Fri, 28 Nov 2008 14:55:44 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing/function-graph-tracer: adjustments of the trace informations
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Tim Bird" <tim.bird@am.sony.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081128091800.GA1725@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492F3076.7050104@gmail.com> <20081128091800.GA1725@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/28 Ingo Molnar <mingo@elte.hu>:
> Firstly, what do you think about the additional tweaks i did - see the
> patch below?
>
> Before:
>
> 0)           |     sys_read() {
> 0)      0.796 us |   fget_light();
> 0)           |       vfs_read() {
> 0)           |         rw_verify_area() {
> 0)           |           security_file_permission() {
> ------------8<---------- thread sshd-1755 ------------8<----------
>
> After:
>
>  0)               |  sys_read() {
>  0)      0.796 us |    fget_light();
>  0)               |    vfs_read() {
>  0)               |      rw_verify_area() {
>  0)               |        security_file_permission() {
>  ------------------------------------------
>  | 1)  migration/0--1  =>  sshd-1755
>  ------------------------------------------


Thanks! That good, but I remember you wanted a limited number of
characters for thread name/pid couple?


> Secondly:
>
>> +     /* Must not exceed 8 characters: xxxx.yyy us */
>> +     if (duration > 10000000ULL)
>> +             duration = 9999999ULL;
>
> 10 milliseconds isnt much or full system calls, etc.- so i believe the
> rule should be what i outlined in an earlier mail. The relevant
> transition points go like this:
>
>     0.000
>  xxxx.yyy
>  9999.999
>  10000.00
>  xxxxx.yy
>  99999.99
>  100000.0
>  xxxxxx.y
>  999999.9
>   1000000
>   9999999
>  10000000
>  xxxxxxxx
>  99999999 [ 100 seconds ]
>  100000000 ... up to infinity
>
> this way we can get up to 99999999 usecs with the same fixed width -
> or 100 seconds. _That_ is enough in practice.
>
> But even beyond that we should print it all out: we should still not
> clip actual information but instead shift the line to the right. The
> slightly inconsistent line is not a big problem - we want a 100
> seconds delay to stand out anyway ;-)
>
> The moving decimal point above 10 milliseconds is not a big problem
> with the '+' and '!' marker. Maybe add a '!!' marker to these lines?


Yeah, I was sure I misunderstood your idea about it in your last email :-)
Ok. I will do so, I felt a bit uncomfortable with the fixed width above a limit,
so I like it this way. Long sleeping functions will be rare enough in the trace
to let us move a bit the columns to the right in such cases...

Thanks.
