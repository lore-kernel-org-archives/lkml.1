Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbZBHOQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbZBHOQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 09:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZBHOQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 09:16:10 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49738 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752117AbZBHOQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 09:16:09 -0500
Subject: Re: x86: unify genapic code, unify subarchitectures, remove old
	subarchitecture code
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, hpa <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Sun, 08 Feb 2009 14:16:06 +0000
Message-Id: <1234102566.4244.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I ported the NUMAQ / Summit / bigsmp and ES7000 subarchitectures to the
> new setup. They build and boot on regular hardware but are otherwise
> untested. The x86/Voyager subarch is not fully ported yet (i cleaned up
> its Kconfig impact) and hence disabled it for the time being. It
> ought to be relatively straightforward to port it to the new code.

OK, so I analysed the voyager requirements.

The first simple one is that safe_smp_processor_id() and
hard_smp_processor_id() need to be abstracted, probably through smp_ops.
This one is probably trivial since 99% of the price of doing this has
already been paid in the smp ops.

The other big problem is mm/tlb.c.  This directly uses genapic with 8
vectors which is impossible for voyager: the QIC only has 8 separate IPI
vectors for everything.  The two alternatives which spring to mind are
either to rebase mm/tlb.c on top of smp_call_function.  This would add a
small amount to the critical path, but would also allow vector scaling
beyond the current 8 IPI vectors to a per processor number (i.e. might
scale better beyond 8 cores).  Or to keep voyager separate and move
pieces of paravirt ops (or rather a separated piece of pv_ops) into
smp_ops to effect the separation.  Instinct says to try the former
first.

James




