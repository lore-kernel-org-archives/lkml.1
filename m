Return-Path: <linux-kernel-owner+w=401wt.eu-S964882AbZJJC6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964882AbZJJC6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 22:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbZJJC6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 22:58:13 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:51261 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbZJJC6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 22:58:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=e2oE+4XlhZbet1zIYSa1EB7ZomEP7ilgTku+DxeVxDmKH2hp498ZcDpZ7KvxpCJdgc
         opq+g6gYac4rZESN7gxajrCHkauIqYq47zgDFUEi15Dgr5YEDoj/6Yt6E0qJjDtVpr2T
         /AFa66nE6mieZAbZLVxaEAUx/v3syQVnNOeTc=
MIME-Version: 1.0
In-Reply-To: <20091009194250.eb76e338.akpm@linux-foundation.org>
References: <20091009134354.12A7.A69D9226@jp.fujitsu.com> <20091009171344.3fc5f28b.akpm@linux-foundation.org> 
	<3e8340490910091922g7891b31al649e91f15ffae687@mail.gmail.com> 
	<20091009194250.eb76e338.akpm@linux-foundation.org>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Fri, 9 Oct 2009 22:57:14 -0400
Message-ID: <3e8340490910091957t21eb16e0r63eba2314ddb83a8@mail.gmail.com>
Subject: Re: [resend][PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>,
       linux-api@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 9, 2009 at 10:42 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:

>> >> + __ __ __ __ __ __ __ __ __ __ __ __ __ __ res += access_process_vm(task, mm->env_start,
>
> Your email client is converting tabs to non-ascii crap.  gmail.  Sigh.

Weird ... I'll have to see if I can do something about that :/

> OK.
>
> But there's no way in which the reader of either the patch or the
> resulting code can discover this subtlety.

I didn't write the log message or the code - I just mentioned these
same issues back in the lkml thread :) But yes, this should be
mentioned somewhere.

>> The solution is to use the seqlock to detect this, and prevent the
>> secret information from ever making it back to process B's userspace.
>> Note that it's not enough to just recheck arg_start, as process A may
>> reassign the proctitle area back to its original position after having
>> it somewhere else for a while.
>
> Well seqlock is _a_ solution.  Another is to use a mutex or an rwsem
> around the whole operation.
>
> With the code as you propose it, what happens if a process sits in a
> tight loop running setproctitle?  Do other processes running `ps' get
> stuck in a livelock until the offending process gets scheduled out?

It does seem like a maximum spin count should be put in there - and
maybe a timeout as well (since with FUSE etc it's possible to engineer
page faults that take arbitrarily long).
Also, it occurs to me that:

> +     do {
> +             seq = read_seqbegin(&mm->arg_lock);
> +
> +             len = mm->arg_end - mm->arg_start;
> +             if (len > PAGE_SIZE)
> +                     len = PAGE_SIZE;

If arg_end or arg_start are modified after this, is it truly safe to
assume that len will remain <= PAGE_SIZE without a memory barrier
before the conditional?
