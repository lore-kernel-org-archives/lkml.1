Return-Path: <linux-kernel-owner+w=401wt.eu-S1752404AbZLII7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbZLII7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 03:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZLII7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 03:59:35 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:44323 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbZLII7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 03:59:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=uOyZBZEmT+3HqvnS5cs866Bp+6mXApsjPhMEsnSAhQTcsLvOZtQcLM69cO7vs/+HSk
         UP0edRz3hKXX9kjxXNoWcsw08L+aSpoSAnzadTeSaBwtCmdad8NIV40gxk+jE14Gt6hg
         t9dAALGv4QreFk61mcWYHoQzMcnBUMjldJrus=
MIME-Version: 1.0
In-Reply-To: <3877989d0912082245m3ee1ea14y3b3c8aca99e9f378@mail.gmail.com>
References: <3877989d0908272018va6ee8f7n7ab2838fdf1b26e6@mail.gmail.com>
	 <20090828062212.GB11552@elte.hu>
	 <3877989d0912032329u7c05a761wfdd5c7000b43218d@mail.gmail.com>
	 <4BDB13256095B24D9644F65379E604265C12@orsmsx505.amr.corp.intel.com>
	 <3877989d0912041919i458300d7ydce73cf77979dad3@mail.gmail.com>
	 <3877989d0912062156v7ba2a192y726f45b550ba50e@mail.gmail.com>
	 <12c511ca0912071335i1a805c2eudb6ecb8f726f6a80@mail.gmail.com>
	 <3877989d0912080425o4bf9e2beuf573e47930fd707f@mail.gmail.com>
	 <3877989d0912082245m3ee1ea14y3b3c8aca99e9f378@mail.gmail.com>
Date: Wed, 9 Dec 2009 16:52:36 +0800
Message-ID: <3877989d0912090052v79fdce6aqb507639143b5d71e@mail.gmail.com>
Subject: Re: [RFC PATCH] Add TRACE_IRQFLAGS_SUPPORT, LOCKDEP_SUPPORT then 
	enable ftrace for ia64
From: Luming Yu <luming.yu@gmail.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "Li, Shaohua" <shaohua.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 9, 2009 at 2:45 PM, Luming Yu <luming.yu@gmail.com> wrote:
>>
>> But let me try more on other ia64 boxes that I can get access.
>>
>> Stay tuned.
>
> I might have reproduced the problem on a HP ia64 system
> with -32 kernel as the following info. But -31 kernel with
> lockdep code enabled just works. ....debugging...

ah, I seem to have found the change in -32 against -31 that causes the trouble.

Commenting out the change make -32 Lockdep kernel boot.

Tony, please let me know whether you can reproduce..

kernel/lockdep.c
static int save_trace(struct stack_trace *trace)
{
        trace->nr_entries = 0;
        trace->max_entries = MAX_STACK_TRACE_ENTRIES - nr_stack_trace_entries;
        trace->entries = stack_trace + nr_stack_trace_entries;

        trace->skip = 3;

        save_stack_trace(trace);
#if 0

        /*
         * Some daft arches put -1 at the end to indicate its a full trace.
         *
         * <rant> this is buggy anyway, since it takes a whole extra entry so a
         * complete trace that maxes out the entries provided will be reported
         * as incomplete, friggin useless </rant>
         */
        if (trace->entries[trace->nr_entries-1] == ULONG_MAX)
                trace->nr_entries--;
#endif
