Return-Path: <linux-kernel-owner+w=401wt.eu-S1754368AbZJBXlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbZJBXlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 19:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbZJBXlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 19:41:14 -0400
Received: from dovecot.org ([82.118.211.50]:36392 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbZJBXlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 19:41:13 -0400
Cc: linux-kernel@vger.kernel.org
Message-Id: <9ECCBC96-C88C-456B-B8BF-606156461E18@iki.fi>
From: Timo Sirainen <tss@iki.fi>
To: Bryan Donlan <bdonlan@gmail.com>
In-Reply-To: <3e8340490910021553ua53ab26gdb3f96af80cec768@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: setproctitle()
Date: Fri, 2 Oct 2009 19:41:13 -0400
References: <1254519449.4605.33.camel@timo-desktop> <3e8340490910021553ua53ab26gdb3f96af80cec768@mail.gmail.com>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 2, 2009, at 6:53 PM, Bryan Donlan wrote:

> On Fri, Oct 2, 2009 at 5:37 PM, Timo Sirainen <tss@iki.fi> wrote:
>> I'd like to get BSD's setproctitle() implemented for glibc so that  
>> more
>> programs could start using it. The current method of messing around  
>> with
>> argv and environment to implement it is horribly ugly, fragile and I
>> find it dangerous enough that I haven't dared to use it in my  
>> programs.
>>
>> Any chance of making all this easier so it could actually be  
>> implemented
>> in a generic and safe way in glibc?
>
> Interestingly, there is some code that purports to handle
> setproctitle(): (fs/proc/base.c)
>    res = access_process_vm(task, mm->arg_start, buffer, len, 0);
>
>    // If the nul at the end of args has been overwritten, then
>    // assume application is using setproctitle(3).

Yes, I saw this. It's especially interesting that it mentions  
setproctitle(3), which doesn't exist in Linux.

>    if (res > 0 && buffer[res-1] != '\0' && len < PAGE_SIZE) {
>        len = strnlen(buffer, res);
>        if (len < res) {
>            res = len;
>        } else {
>            len = mm->env_end - mm->env_start;
>            if (len > PAGE_SIZE - res)
>                len = PAGE_SIZE - res;
>            res += access_process_vm(task, mm->env_start, buffer+res,  
> len, 0);
>            res = strnlen(buffer, res);
>        }
>    }
>
> This would seem to allow the argument space to be extended up until
> the end of the environment variable area (although it seems to have a
> bug where it will ignore errors when reading this extra bit!)

That is the ugliness I referred to in my previous mail. It also looks  
to me like if the environment is very small, the process title length  
is also very limited.

> Nevertheless, if one were to insist on a more controllable method, a
> better way might be to simply define a syscall that userspace can use
> to select a new command line buffer. Overwrite mm->arg_end and
> mm->arg_start, and there you go. Of course, the logic over here needs
> to be disabled in this case, as env variables will no longer be found
> immediately after the argument vector.

That sounds good to me. Someone else mentioned prctl(PR_SET_NAME) that  
does something related already, so perhaps a new flag for prctl()?  
Something like: prctl(PR_SET_PROCTITLE, proctitle_start,  
proctitle_end). I could try implementing that this weekend (with my  
almost non-existent kernel coding skills) if no one else wants to.
