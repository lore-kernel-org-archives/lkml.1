Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbYBGJFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbYBGJFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 04:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbYBGJFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 04:05:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34528 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbYBGJFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 04:05:16 -0500
Date: Thu, 7 Feb 2008 10:04:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Balaji Rao <balajirrao@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, jesse.barnes@intel.com,
       ak@suse.de, Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH][Regression] x86, 32-bit: trim memory not covered by wb
	mtrrs - FIX
Message-ID: <20080207090452.GB12884@elte.hu>
References: <200802071257.51893.balajirrao@gmail.com> <20080207080245.GA28631@elte.hu> <200802071351.02763.balajirrao@gmail.com> <86802c440802070050t2566a261t50cccd649912a4a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440802070050t2566a261t50cccd649912a4a9@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> minor difference
> +               trim_start = highest_pfn << PAGE_SHIFT;
> +               trim_size = end_pfn << PAGE_SHIFT;
> 
> could cause some problem with 32 bit kernel when mem > 4g. becase 
> highest_pfn and end_pfn is unsigned long aka 32 bit ...could overflow.
> 
> so need to assign thtem to trim_start/trim_end at first
> or
> +               trim_start = (u64)highest_pfn << PAGE_SHIFT;
> +               trim_size = (u64)end_pfn << PAGE_SHIFT;

indeed ...

i think the 64-bit behavior of gcc is inherently dangerous, we had 
numerous subtle bugs in that area.

i think perhaps Sparse should be extended to warn about this. I think 
any case where on _32-bit_ we have an 'unsigned long' that is shifted to 
the left by any significant amount is clearly in danger of overflowing. 
_Especially_ when the lvalue is 64-bit!

or in other words, on any such construct:

   64-bit lvalue = ... 32-bit value

we should enforce _explicit_ (u64) conversions.

	Ingo
