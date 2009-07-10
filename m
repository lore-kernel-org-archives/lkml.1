Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbZGJIsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbZGJIsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 04:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbZGJIrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 04:47:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42910 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbZGJIrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 04:47:52 -0400
Date: Fri, 10 Jul 2009 10:47:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Janboe Ye <yuan-bo.ye@motorola.com>, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com, graydon@redhat.com, fche@redhat.com
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already
	using mudflap
Message-ID: <20090710084745.GA26752@elte.hu>
References: <1247156020.27671.40.camel@debian-nb> <84144f020907090944u51f60cbsc0a4ec2c2cbdcc8c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020907090944u51f60cbsc0a4ec2c2cbdcc8c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Janboe,
> 
> On Thu, Jul 9, 2009 at 7:13 PM, Janboe Ye<yuan-bo.ye@motorola.com> wrote:
> > slab debug detects the corruption when it allocates and frees the slab. But if someone write to slab memory when it already freed, slab debug could only report its last free point when slab allocates the same block.
> >
> > This information is not enough for debugging when system has complex memory usage. gcc mudflap could insert some check point when a memory is writing and it is helpful to check if the address is writing freed.
> >
> > Because most codes of kernel are drivers, it is most possible that drivers have such problem. So I use mudflap to compile all drivers.
> >
> > kmemcheck is also helpful to check same issue, and it triggers trap every reading and writing, and it need to analysis the instruct which trigger the trap to get the memory address.
> > This heavy depends on the cpu capability. arm has no single-step like x86, so kmemcheck is too heavy to run on real arm system. mudflap way is lighter than kmemcheck for this purpose.
> >
> > As stack allocation is useless for checking slab, kernel mudflap does not implement alloc which is required by gcc mudflap when codes use variable array. So variable array, such as array[i] which i could not determined by compiler, is not supported.
> >
> > Thanks a lot for comments!
> 
> Yeah, something like this makes sense. Some comments below.
> 
> >  arch/arm/include/asm/elf.h |    1 +
> >  arch/arm/kernel/module.c   |    1 +
> >  drivers/Makefile           |    4 +-
> >  include/mf-runtime.h       |   42 ++++++++++++++
> >  kernel/Makefile            |    2 +-
> >  kernel/mudflap.c           |  132 ++++++++++++++++++++++++++++++++++++++++++++
> >  lib/Kconfig.debug          |    7 ++
> >  mm/slab.c                  |   53 ++++++++++++++++++
> >  8 files changed, 240 insertions(+), 2 deletions(-)
> 
> SLAB is (slowly) going away so you might want to port this to SLUB 
> as well so we can merge both.

and SLQB which will replace both? :-/

	Ingo
