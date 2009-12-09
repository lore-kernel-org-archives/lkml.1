Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbZLISLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbZLISLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756473AbZLISLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:11:17 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:56074 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347AbZLISLP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:11:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SjAQADPvEVxx8/Q35DMAOadAZwt3bWF0MX15mi9oxgrIsOHtrREXDeb2i6XXRagJuP
         Sgx+p+Pl1AtM/+QMAaoet2k2+lyqvFDVyFW7sKjTNdIEdthkGumuWQmaunwDDaF44cNK
         N5a1x7QDejcGT16ZRHAt/M9ZjYLj6ex0bEKbM=
MIME-Version: 1.0
In-Reply-To: <3877989d0912090052v79fdce6aqb507639143b5d71e@mail.gmail.com>
References: <3877989d0908272018va6ee8f7n7ab2838fdf1b26e6@mail.gmail.com>
	 <20090828062212.GB11552@elte.hu>
	 <3877989d0912032329u7c05a761wfdd5c7000b43218d@mail.gmail.com>
	 <4BDB13256095B24D9644F65379E604265C12@orsmsx505.amr.corp.intel.com>
	 <3877989d0912041919i458300d7ydce73cf77979dad3@mail.gmail.com>
	 <3877989d0912062156v7ba2a192y726f45b550ba50e@mail.gmail.com>
	 <12c511ca0912071335i1a805c2eudb6ecb8f726f6a80@mail.gmail.com>
	 <3877989d0912080425o4bf9e2beuf573e47930fd707f@mail.gmail.com>
	 <3877989d0912082245m3ee1ea14y3b3c8aca99e9f378@mail.gmail.com>
	 <3877989d0912090052v79fdce6aqb507639143b5d71e@mail.gmail.com>
Date: Wed, 9 Dec 2009 10:11:20 -0800
X-Google-Sender-Auth: 0232fe81ae06d5cd
Message-ID: <12c511ca0912091011g1d6308c4if7684adf9b0c5baf@mail.gmail.com>
Subject: Re: [RFC PATCH] Add TRACE_IRQFLAGS_SUPPORT, LOCKDEP_SUPPORT then 
	enable ftrace for ia64
From: Tony Luck <tony.luck@intel.com>
To: Luming Yu <luming.yu@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "Li, Shaohua" <shaohua.li@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 9, 2009 at 12:52 AM, Luming Yu <luming.yu@gmail.com> wrote:
> Commenting out the change make -32 Lockdep kernel boot.
>
> Tony, please let me know whether you can reproduce..

Yes.  Commenting this out makes the system bootable for me.

> kernel/lockdep.c
> static int save_trace(struct stack_trace *trace)
> {
>        trace->nr_entries = 0;
>        trace->max_entries = MAX_STACK_TRACE_ENTRIES - nr_stack_trace_entries;
>        trace->entries = stack_trace + nr_stack_trace_entries;
>
>        trace->skip = 3;
>
>        save_stack_trace(trace);
> #if 0
>
>        /*
>         * Some daft arches put -1 at the end to indicate its a full trace.
>         *
>         * <rant> this is buggy anyway, since it takes a whole extra entry so a
>         * complete trace that maxes out the entries provided will be reported
>         * as incomplete, friggin useless </rant>
>         */
>        if (trace->entries[trace->nr_entries-1] == ULONG_MAX)
>                trace->nr_entries--;
> #endif

This happens because ia64 save_stack_trace() is currently an empty stub, so it
doesn't set trace->nr_entries.

Options:
1) Add trace->nr_entries = 1; to ia64 stub.
2) Change the generic code to defend against an unexpected failure in
save_stack_trace()

       if (trace->nr_entries > 0 &&
           trace->entries[trace->nr_entries-1] == ULONG_MAX)
               trace->nr_entries--;
3) Delete the code in the "daft"[1] architectures, and drop this hunk
from the generic code.

-Tony

[1] arm, parisc, s390, sh, x86
