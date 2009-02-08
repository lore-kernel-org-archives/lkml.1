Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbZBHQ5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbZBHQ5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 11:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbZBHQ5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 11:57:00 -0500
Received: from gw.goop.org ([64.81.55.164]:38139 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbZBHQ47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 11:56:59 -0500
Message-ID: <498F0ED9.1080906@goop.org>
Date: Sun, 08 Feb 2009 08:56:57 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       hpa <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: unify genapic code, unify subarchitectures, remove old	subarchitecture
 code
References: <1234102566.4244.7.camel@localhost.localdomain>
In-Reply-To: <1234102566.4244.7.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> The other big problem is mm/tlb.c.  This directly uses genapic with 8
> vectors which is impossible for voyager: the QIC only has 8 separate IPI
> vectors for everything.  The two alternatives which spring to mind are
> either to rebase mm/tlb.c on top of smp_call_function.  This would add a
> small amount to the critical path, but would also allow vector scaling
> beyond the current 8 IPI vectors to a per processor number (i.e. might
> scale better beyond 8 cores).

I floated an experimental patch to do just that last year.  There were 
concerns because it had a pretty significantly hit on the performance of 
tlb-heavy benchmarks; and since then a multicast smp_call_function ends 
up kmallocing, which probably won't help matters.  I got called away to 
other things before really exploring all the options here, so it may 
well be worth reviving that work.

>   Or to keep voyager separate and move
> pieces of paravirt ops (or rather a separated piece of pv_ops) into
> smp_ops to effect the separation. 

This should be easy since you can can hook all the tlb operations via 
pv_mmu_ops.  And to avoid duplicating a lot of similar-looking code, you 
could just do a generic smp_call_function-based version.

    J
