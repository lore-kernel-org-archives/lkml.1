Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793Ab0AZHEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab0AZHEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 02:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821Ab0AZHEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 02:04:43 -0500
Received: from mail-qy0-f204.google.com ([209.85.221.204]:41945 "EHLO
	mail-qy0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab0AZHEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 02:04:42 -0500
X-Greylist: delayed 60547 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jan 2010 02:04:42 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=PkBao0DNrPm4NjwAgHQwcH9Cs9dCWHZTUEOnfILv1tAy5PC2m4CQKYY8/6fKB5epz+
         3rKcXXcmy/rBgyILQw8sd6Iqa75cYRV8gm66jPopgUiP/T817id2w6mFmGktfq+nFvp7
         xgmmex583J7wxaQeYb8Nv7gbQ6BjFJnIXoto0=
MIME-Version: 1.0
In-Reply-To: <1264430883.4283.1907.camel@laptop>
References: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <20100122164248.GA2651@redhat.com>
	 <a6b9f31a1001250615y6e4501b3k17074bcc4ce26c7c@mail.gmail.com>
	 <1264430883.4283.1907.camel@laptop>
Date: Tue, 26 Jan 2010 16:04:41 +0900
X-Google-Sender-Auth: e16f3fb14757e300
Message-ID: <a6b9f31a1001252304j68f9c9e3n81143dddd337ec16@mail.gmail.com>
Subject: Re: [PATCH 00/12] perf lock: New subcommand "perf lock", for 
	analyzing lock statistics
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Baron <jbaron@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <srostedt@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 23:48, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-01-25 at 23:15 +0900, Hitoshi Mitake wrote:
>>
>> As Peter told, this patch series depends on lockdep.
>> But, checking dependency and tracing lock events are
>> essentially different things. So I think dividing these is possible.
>
> Still you need quite a lot of instrumentation at the actual lock sites,
> not something you'd want to have on your production machine.
>
>> But, perf depends on debugfs.
>> I don't know about production box well,
>> does your production box turns on debugfs?
>> It seems that debugfs is not a thing for production box...
>
> debugfs isn't a problem to have.

I didn't know that, thanks Peter and Greg!

>
>> And I'm interesting in in-kernel histogram of locks.
>> Is there requirement of it?
>> I have some ideas (not done yet, completely).
>
> No real concrete ideas yet.. One possibility is to add a range,
> bucket_size tuple to perf_event_attr and store the histrogram in the
> mmap() area instead of samples.
>
> One difficulty is how to specify what to make that histogram over.
>
> Anyway, its all open still..
>
>
>

I think my previous patch will helpful for this purpose,
http://lkml.org/lkml/2009/12/13/16
# This patch is too dangerous and too incomplete, please don't use!

I think distributing numerical IDs for lock instances makes things easily.
Distributing IDs means that kernel can know where the lock instances are.
Updating information of ID should be triggered by:

1) booting
   Lock defined by DEFINE_SPINLOCK(), DEFINE_RWLOCK(), etc can be
   corrected into specific section and initialized.
   Like the way of event_trace_init() in kernel/trace/trace_events.c

2) loading/unloading modules
   Lock defined by DEFINE_SPINLOCK(), DEFINE_RWLOCK(), etc can be in .ko files.
   So hooking module loading or unloading will be required.

3) calling spin_lock_init(), rwlock_init(), etc...

It seems that difficulty of drawing histogram came from the running kernel's
lack of knowledge about where the lock instances are, isn't it?

Thanks,
	Hitoshi
