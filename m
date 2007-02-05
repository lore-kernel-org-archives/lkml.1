Return-Path: <linux-kernel-owner+w=401wt.eu-S933463AbXBEVW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463AbXBEVW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933464AbXBEVW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:22:27 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:16676 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933463AbXBEVW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:22:26 -0500
In-Reply-To: <Pine.LNX.4.64.0702051223390.8424@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org> <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org> <20070202222110.GA1212@elte.hu> <Pine.LNX.4.64.0702021445410.15057@woody.linux-foundation.org> <20070202235531.GA18904@elte.hu> <Pine.LNX.4.64.0702021636410.15057@woody.linux-foundation.org> <20070203082308.GA6748@elte.hu> <B27B1E97-10E3-4A60-A476-4ED4173481A5@oracle.com> <Pine.LNX.4.64.0702051121420.14453@alien.or.mcafeemobile.com> <8CF4BE18-8EEF-4ACA-A4B4-B627ED3B4831@oracle.com> <Pine.LNX.4.64.0702051147100.14453@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0702051223390.8424@woody.linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <A78C08EA-8D2B-42DD-AC42-7D42E480E698@oracle.com>
Cc: Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Date: Mon, 5 Feb 2007 16:21:49 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> - we'd need to do it in the kernel (which is actually nasty, since
>    different system calls have slightly different semantics - some  
> don't
>    return any error value at all, and negative numbers are real  
> numbers)
>
>  - we'd have to teach user space about the "negative errno"  
> mechanism, in
>    which case one word really is alwats enough.
>
> Quite frankly, I much prefer the second alternative. The "negative  
> errno"
> thing has not only worked really really well inside the kernel,  
> it's so
> obviously 100% superior to the standard UNIX "-1 + errno" approach  
> that
> it's not even funny.

I agree, and I imagine you'd have a hard time finding someone who  
actually *likes* the errno convention :)

> I would actually argue that it's not the kernel that should  
> generate any
> cookie, but that user-space should *pass*in* the cookie it wants  
> to, and
> the kernel should consider it a pointer to a 64-bit entity which is  
> the
> return code.

Yup.  That's how the current code (and epoll, and fs/aio.c, and..) work.

Cancelation comes into this discussion, I think.  Hopefully its  
reasonable to expect userspace to be able to manage cookies well  
enough that they can use them to issue cancels and only hit the ops  
they intend to.  It means we have to give them the tools to  
differentiate between a racing completion and cancelation so they can  
reuse a cookie at the right time, but that doesn't sound fatal.

>  - make everything use 64-bit values.

This would be my preference.

> Now, making an architecture-independent system call enumeration may
> actually make sense regardless, because it would allow sys_async()  
> to have
> its own system call table and put the limitations and rules for those
> system calls there, instead of depending on the per-architecture  
> system
> call table that tends to have some really architecture-specific  
> details.

Maybe, sure.  I don't have a lot of insight into this.  Hopefully  
some arch maintainers can jump in?

- z
