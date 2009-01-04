Return-Path: <linux-kernel-owner+w=401wt.eu-S1760293AbZADSlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760293AbZADSlg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 13:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755676AbZADSlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 13:41:24 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:33020 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbZADSlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 13:41:22 -0500
Date: Sun, 4 Jan 2009 11:41:03 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: Btrfs for mainline
Message-ID: <20090104184103.GE2002@parisc-linux.org>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <20081231104533.abfb1cf9.akpm@linux-foundation.org> <1230765549.7538.8.camel@think.oraclecorp.com> <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231093310.27690.5.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 07:21:50PM +0100, Peter Zijlstra wrote:
> The -rt tree has adaptive spin patches for the rtmutex code, its really
> not all that hard to do -- the rtmutex code is way more tricky than the
> regular mutexes due to all the PI fluff.
> 
> For kernel only locking the simple rule: spin iff the lock holder is
> running proved to be simple enough. Any added heuristics like max spin
> count etc. only made things worse. The whole idea though did make sense
> and certainly improved performance.

That implies moving

        struct thread_info      *owner;

out from under the CONFIG_DEBUG_MUTEXES code.  One of the original
justifications for mutexes was:

 - 'struct mutex' is smaller on most architectures: .e.g on x86,
   'struct semaphore' is 20 bytes, 'struct mutex' is 16 bytes.
    A smaller structure size means less RAM footprint, and better
    CPU-cache utilization.

I'd be reluctant to reverse that decision just for btrfs.

Benchmarking required!  Maybe I can put a patch together that implements
the simple 'spin if it's running' heuristic and throw it at our
testing guys on Monday ...

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
