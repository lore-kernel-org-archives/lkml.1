Return-Path: <linux-kernel-owner+w=401wt.eu-S1764323AbZFLKs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764323AbZFLKs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763571AbZFLKsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:48:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49311 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762806AbZFLKsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:48:12 -0400
Date: Fri, 12 Jun 2009 12:56:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <npiggin@suse.de>, Andi Kleen <andi@firstfloor.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] [RFC] HWPOISON incremental fixes
Message-ID: <20090612105610.GK25568@one.firstfloor.org>
References: <20090611142239.192891591@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611142239.192891591@intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 10:22:39PM +0800, Wu Fengguang wrote:
> Hi all,
> 
> Here are the hwpoison fixes that aims to address Nick and Hugh's concerns.
> Note that
> - the early kill option is dropped for .31. It's obscure option and complex
>   code and is not must have for .31. Maybe Andi also aims this option for
>   notifying KVM, but right now KVM is not ready to handle that.

KVM is ready to handle it, patches for that have been submitted and
are queued.

Also without early kill it's not really possible right now to recover
in the guest. Also for some other scenarios early kill is much easier
to handle than late kill: for late kill you always have to bail
out of your current execution context, while early kill that can be 
done out of line (e.g. by just dropping a corrupted object similar to 
what the kernel does). That's a much nicer and gentle model than late
kill.

Of course very few programs will try to handle this, but if any does
it's better to make it easier for them. 

That we send too many signals in a few cases is not fatal right now
I think. Remember always the alternative is to die completely.

So please don't drop that code right now.


> - It seems that even fsync() processes are not easy to catch, so I abandoned
>   the SIGKILL on fsync() idea. Instead, I choose to fail any attempt to
>   populate the poisoned file with new pages, so that the corrupted page offset
>   won't be repopulated with outdated data. This seems to be a safe way to allow
>   the process to continue running while still be able to promise good (but not
>   complete) data consistency.

The fsync() error reporting is already broken anyways, even without hwpoison,
for metadata errors which also only rely on the address space bit and not the
page and run into all the same problems.

I don't think we need to be better here than normal metadata.

Possibly if metadata can be fixed then hwpoison will be fixed too in the
same pass. But that's something longer term.

> - I didn't implement the PANIC-on-corrupted-data option. Instead, I guess
>   sending uevent notification to user space will be a more flexible scheme?

Normally you can get very aggressive panics by setting the x86 mce tolerant 
modus to 0 (default is 1); i suspect that will be good enough.

If other architectures add hwpoison support presumably they can add
a similar tunable.

Doing that in the low level handler is better than in the high level
VM because there are some corruption cases which are not reported
to high level (e.g. not affecting memory directly)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
