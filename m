Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbYE1Ogw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbYE1Ogw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 10:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYE1OgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 10:36:22 -0400
Received: from el-out-1112.google.com ([209.85.162.177]:31870 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbYE1OgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 10:36:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C6B2soJ4inO/BUOErDYG1oDKKQYYZi0FJJO7jlutiPuIvyRSOa6c75xo2PnZnidqW1aiAfMzeqh9qjlEBChyT73IuqrtWDPealFx/BmRDk/eDpUqnsM7/Aj5jt3jXJS0LXz330ZAP+/WD7qlV6GMz69kafpgR+TSaTt88Pxi12E=
Message-ID: <170fa0d20805280736hfe19c3m790c435ff3949441@mail.gmail.com>
Date: Wed, 28 May 2008 10:36:07 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Eric Sandeen" <sandeen@redhat.com>
Subject: Re: 4KSTACKS + DEBUG_STACKOVERFLOW harmful
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>
In-Reply-To: <46D5F462.9010401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46D5F462.9010401@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2007 at 6:34 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> Noticed today that the combination of 4KSTACKS and DEBUG_STACKOVERFLOW
> config options is a bit deadly.
>
> DEBUG_STACKOVERFLOW warns in do_IRQ if we're within THREAD_SIZE/8 of the
> end of useable stack space, or 512 bytes on a 4k stack.
>
> If we are, then it goes down the dump_stack path, which uses most, if
> not all, of the remaining stack, thereby turning a well-intentioned
> warning into a full-blown catastrophe.
>
> The callchain from the warning looks something like this, with stack
> usage shown as found on my x86 box:
>
> 4 dump_stack
> 4   show_trace
> 8     show_trace_log_lvl
> 4       dump_trace
>          print_context_stack
> 12          print_trace_address
>              print_symbol
> 232             __print_symbol
> 164               sprint_symbol
> 20                  printk
> ___
> 448
>
> 448 bytes to tell us that we're within 512 bytes (or less) of certain
> doom... and I think there's call overhead on top of that?
>
> The large stack usage in those 2 functions is due to big char arrays, of
> size KSYM_NAME_LEN (128 bytes) and KSYM_SYMBOL_LEN (223 bytes).
>
> IOW, the stack warning effectively reduces useful stack left in our itty
> bitty 4k stacks by over 10%.

Hi Eric,

Did you happen to get a patch together that reduces the stack usage of
dump_stack?

Also, what did you use to print your (above) indented callchain stack
usage of dump_stack?

I'd like to be able to audit the worst case stack usage of _all_ call
chains that originate from a given thread. This would effectively be
like DEBUG_STACK_USAGE except with finer grained (per call-chain)
statistics.  One crude way of doing this is to dump_stack() whenever a
task's call-chain is the new "winner" as the biggest stack hog.

To do this safely it would seem to me that a leaner dump_stack() is needed...

Lastly, would it be reasonable to utilize systemtap to implement what
I described above?  I'm actually looking to debug 4KSTACKS as
unobtrusively as possible so as to not alter the underlying kernel (in
this case it happens to be a RHEL5 kernel but this could apply to any
kernel).

please advise, thanks.
