Return-Path: <linux-kernel-owner+w=401wt.eu-S1759926AbZA2WaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759926AbZA2WaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbZA2WaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:30:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41041 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbZA2WaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:30:09 -0500
Date: Thu, 29 Jan 2009 23:29:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: unify genapic code, unify subarchitectures, remove old
	subarchitecture code
Message-ID: <20090129222956.GA1668@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu> <87vdryw6ql.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vdryw6ql.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Also bigsmp is kind of obsolete too, it could be probably
> merged with default with very tiny impact because it's not
> all that different.

i dont think you have understood the driving principle behind this 
restructuring and unification.

The whole _point_ of the apic driver infrastructure is to use it for 
dissimilar APIC modes.

In the future we'll create _more_ of them, not less - so that we can 
remove runtime conditionals from the drivers and that we can use the APIC 
driver for the hardware that is the most efficient.

For example, the apic_default driver (which is used if all APIC IDs are 
between 0 and 7 - which is the majority of current hardware), is more 
efficient at sending IPIs, because it can send a broadcast IPI (used for 
TLB flushes for example) as a single IPI.

The apic_bigsmp driver on the other hand has to use a 'serialized' 
sequence of IPIs, to each CPU separately. That is less efficient, 
especially for something as performance-sensitive as TLB flushes.

To "unify" the ability of apic_bigsmp to deal with APIC IDs >= 8 with the 
more efficient logical addressing mode of apc_default is possible but ugly 
- we'd have to add runtime checks and flip between the two methods. What 
So what you call "very tiny impact" is in reality unnecessary and 
avoidable overhead.

	Ingo
