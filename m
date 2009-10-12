Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbZJLTFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbZJLTFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbZJLTF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:05:29 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51589 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757896AbZJLTF2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:05:28 -0400
Date: Tue, 13 Oct 2009 04:03:45 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Bryan Donlan <bdonlan@gmail.com>
Subject: Re: [resend][PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>,
       linux-api@vger.kernel.org, Timo Sirainen <tss@iki.fi>
In-Reply-To: <3e8340490910100011u17497293o613334c64f1543c8@mail.gmail.com>
References: <2f11576a0910092332s6e0e3dcs35864e3a2164be0@mail.gmail.com> <3e8340490910100011u17497293o613334c64f1543c8@mail.gmail.com>
Message-Id: <20091013031853.C744.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Sorry for the delaying.

> On Sat, Oct 10, 2009 at 2:32 AM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> >> It does seem like a maximum spin count should be put in there - and
> >> maybe a timeout as well (since with FUSE etc it's possible to engineer
> >> page faults that take arbitrarily long).
> >> Also, it occurs to me that:
> >
> > makes sense.
> > I like maximum spin rather than timeout.
> 
> I'm worried about the scenario where process A sets its cmdline buffer
> to point to a page which will take a _VERY_ long time to pagein (maybe
> forever), and then process B goes to try to read its cmdline. What
> happens now?

Honestly, I don't worry about so much. if attacker want DoS attack, fork bomb is
efficient than this way. then, attacker never use this.


> Process A can arrange for this to happen by using a FUSE filesystem
> that sits on a read forever. And since the first thing the admin's
> likely to do to track down the problem is 'ps awux', this is liable to
> be a rather nasty DoS...

Probably, I haven't understand this paragraph. Why is this FUSE related issue?

> Of course, this is no worse than it is now - it's already possible to
> replace the page in question. But we should think about ways this
> could be fixed for good...

Plus, please look my mesurement data as another post. seqlock implementation is very fast
although contention occured.



> >>> +     do {
> >>> +             seq = read_seqbegin(&mm->arg_lock);
> >>> +
> >>> +             len = mm->arg_end - mm->arg_start;
> >>> +             if (len > PAGE_SIZE)
> >>> +                     len = PAGE_SIZE;
> >>
> >> If arg_end or arg_start are modified after this, is it truly safe to
> >> assume that len will remain <= PAGE_SIZE without a memory barrier
> >> before the conditional?
> >
> > 1) access_process_vm() doesn't return error value.
> > 2) read_seqretry(&mm->arg_lock, seq)) check seq, not mm->arg_start or len.
> >
> > then, if arg_{start,end} is modified, access_process_vm() may return 0
> > and strnlen
> > makes bad calculation, but read_seqretry() can detect its modify
> > rightly. I think.
> 
> No, I'm worried about what if the compiler decides to rewrite like so:
> if (mm->arg_end - mm->arg_start > PAGE_SIZE)
>   len = PAGE_SIZE;
> else /* here we reload arg_end/arg_start! */
>   len = mm->arg_end - mm->arg_start;
> 
> Now we might write into buffer more than PAGE_SIZE bytes, which is
> probably a buffer overrun into kernel space...

Rgiht. I'll fix this issue at next spin.
Thank you.



