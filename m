Return-Path: <linux-kernel-owner+w=401wt.eu-S1751705AbZEIEKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbZEIEKP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 00:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbZEIEKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 00:10:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34884 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbZEIEJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 00:09:59 -0400
Date: Sat, 9 May 2009 06:09:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       kdb@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/13] RFC ONLY - kdb: core for kgdb back end
Message-ID: <20090509040942.GB8007@elte.hu>
References: <1241817800-9320-1-git-send-email-jason.wessel@windriver.com> <1241817800-9320-2-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241817800-9320-2-git-send-email-jason.wessel@windriver.com>
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


* Jason Wessel <jason.wessel@windriver.com> wrote:

> This is an RFC patch.  This work is by no means in its final form, 
> nor is it in a form that would be suitible for upstream merging.  
> This is an early prototype of a kdb frontend talking to a kgdb 
> backend.  It is meant to foster some discussion around the 
> usefulness of merging kdb and kgdb together, as well as experiment 
> with changes to kgdb's core to improve robustness and 
> functionality.
> 
> This patch contains the kdb core and some instrumentation into the 
> core kernel which kdb requires in order to gather information for 
> some of its reporting functions.

Just a first quick 30-seconds impression from skimming through the 
patch:

 - The cleanups are an absolute must before doing any in-depth 
   review. We only want to waste valuable review bandwidth on code 
   that at least _looks_ nice and tidy.

 - Many functions are way too large, with many indentation levels - 
   they need a split-up.

 - Most of the code patterns dont match core kernel standards and 
   practices, so it's not reviewable in detail. It needs a 
   thorough clean-up not just on the surface, but on the algorithmic 
   level as well.

bits like:

> +		// HACK HACK HACK
> +		printk(KERN_CRIT "DOH NEED TO IMPLEMENT THIS!");

need fixed.

Locking needs reviewed and fixed:

> +/* Locking is awkward.  The debug code is called from all contexts, including
> + * non maskable interrupts.  A normal spinlock is not safe in NMI context.  Try
> + * to get the debug allocator lock, if it cannot be obtained after a second
> + * then give up.  If the lock could not be previously obtained on this cpu then
> + * only try once.
> + *
> + * sparse has no annotation for "this function _sometimes_ acquires a lock", so
> + * fudge the acquire/release notation.
> + */

Plus, if _any_ debugger front-end is considered for merging, it 
_must_ work with Kernel Mode Setting properly, out of X. No ifs
and when.

Also, high-level file organization: i'd suggest to move it all under 
the kernel/debug/ hierarchy, and move kernel/kgdb.c to 
kernel/debug/backend/core.c or so [possibly split up a bit, it's 
getting quite large] and the KDB bits under kernel/debug/frontend/. 
We dont want multiple back-ends nor multiple front-ends. We want one 
good back-end and one good (built-in) front-end.

I supported and helped a debugging backend and i dont consider a 
front-end completely impossible either. But it will have to meet a 
_lot_ of stringent standards because a good kernel debugging 
front-end's cross section to the system is even larger than a 
backend's. It's a tough job to get this done.

	Ingo
