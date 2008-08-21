Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbYHUGLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbYHUGLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 02:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbYHUGL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 02:11:28 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:28836 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751566AbYHUGL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 02:11:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rykbosKWo5Kz9/r0g2zcP4dh6InLSXJfDQWtuIAsep/76XTF/q+/agc/2axt5LjJUozA7q2Mp/6NjSs6wmpYlJ4LhXgJ+G+/F82SkOoefw6d7pLxzd5icUYTxc8Z5kbC05vcvscrrIieHJzyeznBGl71s/lAmcPVTPSnPgA574M=  ;
X-YMail-OSG: O4.deW0VM1kCyLvvVcPqcC03N7MCBPZDtZmi4lDsl9U.18cDBzkovO6CyHt4EsOc5R7n5VwxLpZDzqtU8y0j8qZ9IM6vyq.3IgHQ5qsZXBZL15BRo6GEDcY369RRqbtclfU-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: VolanoMark regression with 2.6.27-rc1
Date: Thu, 21 Aug 2008 16:11:17 +1000
User-Agent: KMail/1.9.5
Cc: Ray Lee <ray-lk@madrabbit.org>, adobriyan@gmail.com,
       Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Chris Friesen <cfriesen@nortel.com>
References: <1912217169.25608.228.camel@ymzhang> <1219264236.8651.76.camel@twins> <1219265798.8651.84.camel@twins>
In-Reply-To: <1219265798.8651.84.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211611.17889.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008 06:56, Peter Zijlstra wrote:
> On Wed, 2008-08-20 at 22:30 +0200, Peter Zijlstra wrote:

> > works for the above example, but when I make it long long, so as to
> > match the longest supported type, it goes boom again - for as of yet
> > unknown reasons.
>
> Ok, people pointed out I got my promotion rules mixed up, I casted the
> result of the division to signed, instead of ending up with a signed
> division.
>
> #define avg(x, y) ({                            \
>         typeof(x) _avg1 = (x);                  \
>         typeof(y) _avg2 = (y);                  \
>         (void) (&_avg1 == &_avg2);              \
>         (typeof(x))(_avg1 + ((long long)_avg2 - _avg1)/2); })
>
> seems to work.

Right, I guess that will work, but unfortunately the code gen on 32-bit
is a monstrosity. If you're going to cast to 64-bit anyway, we might as
well then just do the normal add rather than playing the game to avoid
overflow.

Secondly, this is operating on the fixed point scaled load numbers, so in
the case of the scheduler I wouldn't worry too much about rounding... also
in most integer operations, rounding down is less surprising than rounding
up like the last code did.

I still don't know whether it is appropriate to put it into kernel.h
(because of rounding, and variability when it comes to what type size will
hold the sum of parameters), but for the scheduler, I would use this:

	((unsigned long long)a + b) / 2;

Which gives this on 32-bit:
div:
        movl    %edx, %ecx
        xorl    %edx, %edx
        pushl   %ebx
        xorl    %ebx, %ebx
        addl    %ecx, %eax
        adcl    %ebx, %edx
        popl    %ebx
        shrdl   $1, %edx, %eax
        shrl    %edx
        ret

Rather than this:
div:
        subl    $8, %esp
        xorl    %ecx, %ecx
        movl    %ebx, (%esp)
        movl    %edx, %ebx
        movl    %esi, 4(%esp)
        xorl    %esi, %esi
        subl    %eax, %ebx
        sbbl    %ecx, %esi
        movl    %esi, %ecx
        movl    %esi, %edx
        sarl    $31, %ecx
        movl    %ecx, %edx
        xorl    %ecx, %ecx
        shrl    $31, %edx
        addl    %ebx, %edx
        movl    (%esp), %ebx
        adcl    %esi, %ecx
        movl    4(%esp), %esi
        addl    $8, %esp
        shrdl   $1, %ecx, %edx
        addl    %edx, %eax
        sarl    %ecx
        ret

And it's also slightly better on 64-bit.
