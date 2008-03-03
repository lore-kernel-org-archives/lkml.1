Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbYCCHq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbYCCHq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 02:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYCCHqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 02:46:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38318 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbYCCHqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 02:46:47 -0500
Date: Mon, 3 Mar 2008 08:46:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: torvalds@linux-foundation.org, hans.rosenfeld@amd.com,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: bisected boot regression post 2.6.25-rc3.. please revert
Message-ID: <20080303074620.GC5934@elte.hu>
References: <20080301105646.2c8620d9@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080301105646.2c8620d9@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> Hi Linus, Ingo, Hans,
> 
> Please revert commit cded932b75ab0a5f9181ee3da34a0a488d1a14fd ( x86: 
> fix pmd_bad and pud_bad to support huge pages ) since it prevents the 
> kernel to finish booting on my (Penryn based) laptop. The boot stops 
> right after freeing the init memory. Took a while to bisect (due to it 
> touching page*.h, which forces a full recompile), but it definitely is 
> caused by this commit...

hm, lets figure out why this patch breaks your box, ok? We obviously 
have to revert it if we cannot figure it out, but lets at least try - 
because the patch itself fixes a real regression and it's not obviously 
wrong either. I think there might be some bug hiding somewhere that we 
really want to fix instead of this revert.

Could you try to hack up a debug patch perhaps? Uninline the fucntion(s) 
then add two versions (one is that breaks on your box and one is that 
works on your box) of this same pmd_bad()/pud_bad() functions and do 
something like this (pseudocode):

pmd_bad()
{
	if (pmd_bad_working(x) != pmd_bad_broken(x))
		panic_timeout++;

	return pmd_bad_working(x);
}

i.e. we actually use the working function so your box should boot up 
just fine - but we instrument things with the broken function as well 
and detect the cases where the two values differ. It is an anomaly if 
either function ever returns true instead of false.

if after bootup you have a non-zero panic_timeout then there is a 
material difference somewhere. In that case try to stick a dump_stack() 
into the above case as well - and if the box still boots, send us the 
stackdumps. (if the box doesnt boot then perhaps the printout itself 
hangs - in that case try a save_stack_trace() hack and print it out 
later)

	Ingo
