Return-Path: <linux-kernel-owner+w=401wt.eu-S1752461AbXE3Ady@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbXE3Ady (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 20:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbXE3Adr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 20:33:47 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:37094 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbXE3Adq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 20:33:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gWTSymhxLiTB4nrQo5NMPvzqCT6zNHs2Ny8X3o0N9shLzhwEXDL/SSzUI2SOoZHgdkQuGW2za6H62CaAj1aLZSPc5SDsCVFcCQbjl9W3Q6bWHyjw9ooTFkwwUKwOJ3kCNN1pjWyHxd+6yVrKBKvn6pE7kAyLKdZl/gtyK7igZis=
Message-ID: <787b0d920705291733t7a2ca052tbad7e11bbe0b1eff@mail.gmail.com>
Date: Tue, 29 May 2007 20:33:44 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC, PATCH 1/3] introduce SYS_CLONE_MASK
Cc: linux-kernel@vger.kernel.org, jengelh@linux01.gwdg.de, holt@sgi.com,
       oleg@tv-sign.ru, roland@redhat.com
In-Reply-To: <m1646c8c33.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920705282023v22316e6bk709dc8d3aa3213d7@mail.gmail.com>
	 <m1646c8c33.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/29/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "Albert Cahalan" <acahalan@gmail.com> writes:
> > Jan Engelhardt writes:

>>> -    if(self_pid==1 && ADOPTED(processes[i]) && forest_type!='u')
>>> +    if(ADOPTED(processes[i]) && forest_type!='u')
>>
>> That's not compatible because init's children are now in the
>> logical place. Since the days of procps-1.x.x or earlier,
>> such processes have been listed at top level.
>>
>> BTW, what does "ps -ejH" do for you, with and without the patch?
>
> ps -ejH displays everything.

That's not what I mean. (the "-e" causes that of course)
I'm asking about the parent-child relationships shown.
The "-H" option is a bit different from the "f" option.

>> I'd be a lot happier about breaking compatibility in this area
>> if I could get a functional adoption flag. That is, I really
>> would like to show a process as child of init if it naturally
>> was created as a child of init. It's less informative to have
>> fake children showing up the same as real ones. The original
>> parent PID would do. (BTW, the original parent name and/or
>> grandparent PID would be great to have) As a bonus, the kernel
>> could reap these processes more quickly than init can... and
>> then maybe we can stop caring if init is alive.
>
> Having the kernel not reparent user processes to init is an interesting
> idea, especially when those processes have not existed.  I'm not
> certain that is POSIX complaint and otherwise backwards compatible.

I'm not suggesting that this be visible via POSIX APIs.

It's almost certainly a given that getppid() must return 1, and
probably /proc needs to show this as well. Without question,
any process created by init must be reaped by init.

Processes NOT created by init could be silently reaped by
the kernel. They need to see their own PPID as 1, but there
need not be any parent-child relationship in the kernel data
structures. The kernel can fake the whole thing, which is nice
because then the kernel isn't depending on userspace to
correctly perform the pointless action of playing with zombies.
(might setting the death signal to 0 be useful here?)

For "ps fax" and such, I'd like to distinguish between init's
real and adopted children. Right now the adopted children
look like they were created by init, which is not true. I only
need a simple boolean flag, set upon reparenting, to tell me.
Such a flag may also be useful for optimizing away the whole
wait/waitpid/wait4/waitid/wait3 nonsense when an adopted
child dies.
