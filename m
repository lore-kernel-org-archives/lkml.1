Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbZJBMN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbZJBMN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 08:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755701AbZJBMNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 08:13:55 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:65472 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134AbZJBMNy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 08:13:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CWDlupa39d2fs4+3qpx5RR4qdrctKsZLxKjPIlrbKMPjfF7FpkapsRjQLNPvhqjcWW
         ZCqCHqKcnPBpepdbt4akXlTSKS2eS4nsGNQxTl+n0w/BaMj/mmagekRjk6MEArJp2Nw1
         82sE9kLlgJCE4M7cs4j7Bp5j9lnADsMFez2T4=
MIME-Version: 1.0
In-Reply-To: <19140.13582.223629.56214@cargo.ozlabs.ibm.com>
References: <19140.13582.223629.56214@cargo.ozlabs.ibm.com>
Date: Fri, 2 Oct 2009 14:13:57 +0200
Message-ID: <c62985530910020513t45c32b00w30ac6204164e27ef@mail.gmail.com>
Subject: Re: Possible bug in ftrace_profile_enable_event
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/1 Paul Mackerras <paulus@samba.org>:
> I was looking through kernel/trace/trace_event_profile.c and I saw
> this code:
>
> static int ftrace_profile_enable_event(struct ftrace_event_call *event)
> {
>        char *buf;
>        int ret = -ENOMEM;
>
>        if (atomic_inc_return(&event->profile_count))
>                return 0;
>
>        if (!total_profile_count++) {
>                buf = (char *)alloc_percpu(profile_buf_t);
>                if (!buf)
>                        goto fail_buf;
>
>                rcu_assign_pointer(trace_profile_buf, buf);
>
>                buf = (char *)alloc_percpu(profile_buf_t);
>                if (!buf)
>                        goto fail_buf_nmi;
>
>                rcu_assign_pointer(trace_profile_buf_nmi, buf);
>        }
>
>        ret = event->profile_enable();
>        if (!ret)
>                return 0;
>
>        kfree(trace_profile_buf_nmi);
> fail_buf_nmi:
>        kfree(trace_profile_buf);
> fail_buf:
>        total_profile_count--;
>
> ...
>
> So we only allocate trace_profile_buf and trace_profile_buf_nmi if
> total_profile_count was zero on entry, but if we get an error returned
> from event->profile_enable(), we free them both unconditionally,
> regardless of the value of total_profile_count.  That seems wrong.  Is
> there a subtle reason why that is the right thing to do?


Oh right. Good catch.
I'll fix that soon.


>
> (Also, is kfree the appropriate counterpart to alloc_percpu?)

No indeed.
That said it looks harmless for now because percpu_free seem to just
roughly wrap kfree. But
its implementation may change later, so I'll fix that too.

Thanks.
