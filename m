Return-Path: <linux-kernel-owner+w=401wt.eu-S1761610AbYFDTAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761610AbYFDTAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757599AbYFDTAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:00:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756191AbYFDTAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:00:06 -0400
Subject: Re: [PATCH 0/7] Boot IRQ quirks and rerouting
From: Jon Masters <jcm@redhat.com>
To: Stefan Assmann <sassmann@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Olaf Dabrunz <od@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <48467DA7.9030309@suse.de>
References: <12124107071847-git-send-email-od@suse.de>
	 <m1tzgauduu.fsf@frodo.ebiederm.org> <4846651F.4070802@suse.de>
	 <m1ve0pqy06.fsf@frodo.ebiederm.org>  <48467DA7.9030309@suse.de>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 14:57:39 -0400
Message-Id: <1212605859.8410.22.camel@londonpacket.bos.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-06-04 at 13:33 +0200, Stefan Assmann wrote:
> Eric W. Biederman schrieb:
> > Stefan Assmann <sassmann@suse.de> writes:

> > What is the reason why you don't simply disable the ioapic vector of
> > the boot interrupt?  Do some devices not use anything else?
> 
> That's exactly the reason why disabling them is a bad idea, you end up
> having devices fixed to IO-APIC pins that boot interrupts are routed to.

Usually, it's a *really* ugly combo of devices too. The symptom to this
problem was a large number of test systems that would fall over under
heavy IO after some time. I spent many weeks at the end of last year
trawling through the qla2xxx, megaraid/megasas, and other drivers
looking for the "problem", we even shipped some systems to some of these
hardware folks so they could hook up bus analyzers to see if the
interrupts really were being generated, and a lot more fun.

In the end, because I didn't have the level of information about the
unfortunate implementation of some of these chipsets, I reworked a patch
from Thomas that handles mask/unmask vs. edge->level->edge transition
depending upon PCI quirks for known at-issue bridges. I've been hoping
someone would dig up enough information to actually disable these
horrible "features" so we can get that upstream and into RT.

Meanwhile, I think this really shows that a couple of us who've been
meaning to poke at per-device IRQs should do so once again. This is the
real solution - kill off all those per-IRQ threads, have one per device
and split each IRQ into a "top" and "bottom" (just kidding on the names)
half. Have the first part be *incredibly* small and just return if the
device actually was responsible for the IRQ (and quiesse it), and have
the second part do the heavyweight handling. Since the second part can
run as a thread (and actually sleep for however long, because it's now
per device) - and since we have threaded tasklets and all this on RT
anyway - we can just kill off most of the extra logic in many Linux
interrupt handlers and have just the interrupt thread do the work. 

Anyway, that's the bluesky idea (and rejected OLS 2008 paper :P)...

Jon.


