Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810Ab0ATO0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab0ATO0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 09:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613Ab0ATO0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 09:26:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54078 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab0ATO0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 09:26:35 -0500
Date: Wed, 20 Jan 2010 12:26:26 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: fix write_event()
Message-ID: <20100120142626.GQ14636@ghostprotocols.net>
References: <4B570657.5090105@cn.fujitsu.com>
 <1263994901.4283.1060.camel@laptop>
 <1263995096.4283.1062.camel@laptop>
 <20100120140942.GP14636@ghostprotocols.net>
 <1263996897.4283.1065.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263996897.4283.1065.camel@laptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 20, 2010 at 03:14:57PM +0100, Peter Zijlstra escreveu:
> On Wed, 2010-01-20 at 12:09 -0200, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Jan 20, 2010 at 02:44:56PM +0100, Peter Zijlstra escreveu:
> > > On Wed, 2010-01-20 at 14:41 +0100, Peter Zijlstra wrote:
> > > > Uhm, how why? it didn't used to know about events and just copied the
> > > > data.
> > > 
> > > looks like acme wrecked it in f5a2c3dc.. anyway the fix is wrong, record
> > > should not know or care about the actual events and simply write data
> > > out.
> > 
> > Oh well, I guess then we should do that after record finishes,
> > reprocessing all the data in the file.
> 
> Why do we need it at all?
> 
> Can't report/archive/etc.. sort all this out?

We need to record the buildids at record time, preferrably at
PERF_RECORD_MMAP time, from the kernel, for long running, low frequency
sessions were DSOs may be updated.

Or for when a developer is updating his binary and doing perf record
runs to then use perf diff:

	perf record ./myapp
	vi myapp.c
	make
	perf record ./myapp
	perf diff

Works now because the first 'perf record' saved a copy of myapp so that
'perf diff', finding the right build-id in ~/.debug/.build-id/ can do
the right thing.

But till we send the buildid in an extended PERF_RECORD_MMAP event sent
from the kernel, I try to reduce the window by doing this at record
time.

The current way of intercepting events at write_event() is deemed
broken, so I can do it atexit(), when we go to write the header, but
this will hurt because we'll have to reprocess it all.

Yes, since we'd still have the window, we could do it on perf archive,
but it would be an extra explicit step and since I think the right place
to do this is at perf record (with the kernel injecting the buildid, if
present in the binary being loaded), I'd prefer to keep it that way.

Then work on having the buildid stored in some suitable kernel data
structure and injected in the PERF_RECORD_MMAP event.

- Arnaldo
