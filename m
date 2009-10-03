Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbZJCCrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbZJCCrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 22:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbZJCCrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 22:47:42 -0400
Received: from dovecot.org ([82.118.211.50]:57038 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbZJCCrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 22:47:42 -0400
Cc: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
Message-Id: <3DB386D4-C03F-4F2A-B0DD-7F4236325B4B@iki.fi>
From: Timo Sirainen <tss@iki.fi>
To: Bryan Donlan <bdonlan@gmail.com>
In-Reply-To: <3e8340490910021901i35ba8a5v7647b1e02b054270@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
Date: Fri, 2 Oct 2009 22:47:41 -0400
References: <1254518602.5050.4.camel@hurina> <3e8340490910021901i35ba8a5v7647b1e02b054270@mail.gmail.com>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 2, 2009, at 10:01 PM, Bryan Donlan wrote:

> On Fri, Oct 2, 2009 at 5:23 PM, Timo Sirainen <tss@iki.fi> wrote:
>> PR_SET_PROCTITLE_AREA updates mm_struct->arg_start and arg_end to the
>> given pointers, which makes it possible for user space to implement
>> setproctitle(3) cleanly.
>
>
>> @@ -267,9 +267,12 @@ static int proc_pid_cmdline(struct task_struct  
>> *task, char * buffer)
>>
>>        res = access_process_vm(task, mm->arg_start, buffer, len, 0);
>>
>> -       // If the nul at the end of args has been overwritten, then
>> -       // assume application is using setproctitle(3).
>> -       if (res > 0 && buffer[res-1] != '\0' && len < PAGE_SIZE) {
>> +       if (mm->arg_end != mm->env_start) {
>> +               // PR_SET_PROCTITLE_AREA used
>> +               res = strnlen(buffer, res);
>
> Is this check really needed? Surely it's enough to simply state that
> behavior if the area isn't null-terminated is undefined.

Well, that depends. I was hoping to use the syscall only once per  
process. That would allow me to just update the process title whenever  
I feel like it, possibly hundreds of times per second. This is much  
cheaper if I don't have to use a syscall every time.

So if I'm setting the PR_SET_PROCTITLE_AREA initially to e.g. 1 kB  
memory area, without the above code ps will show it entirely  
regardless of any \0 characters (because parameters are separated by  
\0).

>> +       } else if (res > 0 && buffer[res-1] != '\0' && len <  
>> PAGE_SIZE) {
>> +               // If the nul at the end of args has been  
>> overwritten, then
>> +               // assume application is using old style  
>> setproctitle(3).
>>                len = strnlen(buffer, res);
>>                if (len < res) {
>>                    res = len;
>
> Might want to fix the bug later on in that function while you're in
> here - the second access_process_vm call is never checked for errors,
> but (from my reading) it's possible that the page that the environment
> is on could be unmapped between those two calls. The result could
> either be a short read (not the end of the world) or a negative value
> (error code + small original argument length) passed to strnlen.

Hmm. Originally I thought it would have returned only -1, but if it's - 
errno then I'm beginning to wonder if this is a security hole. If the  
original res is small enough, and it looks like it can be, that code  
could get res to negative, i.e. unlimited. But I can't follow the code  
right now if it also means that userspace can read tons of data or if  
it gets caught by some "< 0" check.

> That said, come to think of it, I'm not actually sure if this prctl
> stuff is strictly necessary. Wouldn't it be enough for glibc to copy
> the environment somewhere safe, and then have the kernel guarantee a
> full PAGE_SIZE between arg_start and env_end, even if this means
> padding out the environment? The process could then measure to make
> sure it has this much space (in case of running on an old kernel) by
> testing the difference between arg_start and the top of the stack, or
> an auxiliary vector could be passed down from the kernel with the
> maximum proctitle length.

This would get around the potential "not enough space" problem, but  
not really the ugliness. I can't really think of other potential  
problems with it right now, but my main concern is actually getting  
setproctitle() to glibc. Based on Ulrich's previous reply to me I  
don't know if he'd be willing to accept that solution: http://sources.redhat.com/ml/libc-alpha/2009-10/msg00000.html
