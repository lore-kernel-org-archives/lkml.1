Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbZHLWQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbZHLWQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 18:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbZHLWQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 18:16:26 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:54897 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752388AbZHLWQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 18:16:26 -0400
Subject: Re: kmemleak: Protect the seq start/next/stop sequence
	byrcu_read_lock()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090812205215.GA21451@elte.hu>
References: <20090812205215.GA21451@elte.hu>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 12 Aug 2009 23:16:15 +0100
Message-Id: <1250115375.11496.25.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Aug 2009 22:16:16.0132 (UTC) FILETIME=[82785C40:01CA1B9A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 21:52 +0100, Ingo Molnar wrote:
> * Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > kmemleak: Allow rescheduling during an object scanning
> 
> i tried this in -tip testing, and it crashes quickly:
> 
> [   81.900051] BUG: unable to handle kernel paging request at ffff880020000000
> [   81.901382] IP: [<ffffffff8112ae7e>] scan_block+0xee/0x190

It looks like my check for object->flags & OBJECT_ALLOCATED in
scan_object() may not be enough.

I'm a bit confused as the config you sent says x86_32 but the fault
address above looks like a 64 bit one (and my knowledge of x86 isn't
great). Is this x86_64?

Anyway, does the virtual address above happen to be in the vmalloc
range? The kmemleak_free() callback for vfree() is run before __vunmap()
is executed and the OBJECT_ALLOCATED bit should be cleared.

If it's not vmalloc, do you know what else could be at that virtual
address which may be unmapped without first calling kmemleak_free()?

I've been testing the patch on both x86_32 and ARM and seemed fine (more
intensively on the latter, though obviously not exactly with the same
config as yours but as close as possible).

Thanks.

-- 
Catalin

