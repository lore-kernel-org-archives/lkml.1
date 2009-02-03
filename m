Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbZBCQUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbZBCQUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZBCQT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:19:57 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:56565 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750845AbZBCQT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:19:57 -0500
Date: Tue, 3 Feb 2009 19:19:55 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <srostedt@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ftrace: On PowerPC we don't need frame pointers for
	CALLER_ADDRs
Message-ID: <20090203161955.GA776@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090131190650.GA4284@oksana.dev.rtsoft.ru> <1233534919.18767.69.camel@pasglop> <1233583455.16878.3.camel@localhost.localdomain> <20090203145649.GA19955@oksana.dev.rtsoft.ru> <20090203160645.GA9020@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090203160645.GA9020@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 05:06:45PM +0100, Ingo Molnar wrote:
> 
> * Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > According to this discussion:
> > 
> > http://lkml.org/lkml/2008/7/25/338
> > http://lkml.org/lkml/2008/7/26/72
> > 
> > Frame pointers do nothing useful on PowerPC, so lib/Kconfig.debug
> > makes CONFIG_FRAME_POINTER unselectable on PPC targets. But ftrace.h
> > requires CONFIG_FRAME_POINTER for CALLER_ADDR macros. [...]
> 
> hm, why not add PPC to FRAME_POINTERS list of architectures, and select it 
> from the powerpc arch Kconfig? Does that cause complications somewhere?

-fno-omit-frame-pointers makes the code worse w/o any actual
benefit that we would use. Plus, there is a long standing bug in
gcc that makes -fno-omit-frame-pointer generate wrong code for PPC
targets:

http://lkml.org/lkml/2008/9/2/25

That is, the only tracer that needs[1] -fno-omit-frame-pointer is
"FUNCTION_TRCER", but we workaround the issue via -mno-sched-epilog,
quoting arch/powerpc/Makefile:

# Work around a gcc code-gen bug with -fno-omit-frame-pointer.
ifeq ($(CONFIG_FUNCTION_TRACER),y)
KBUILD_CFLAGS           += -mno-sched-epilog
endif

[1] Btw, why exactly do we need the -fno-omit-frame-pointer for
"FUNCTION_TRCER" tracer? Why just -pg isn't sufficient?..

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
