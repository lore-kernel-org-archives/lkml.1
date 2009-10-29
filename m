Return-Path: <linux-kernel-owner+w=401wt.eu-S1754325AbZJ2LTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbZJ2LTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 07:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbZJ2LTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 07:19:49 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55560 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbZJ2LTs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 07:19:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GD3U8T1zloehm8dXaLIb6hHMLfiBpk5iF8XNT8CRfH0LDgRVqKzwHHleVD/hQHst/p
         YWLIx5QVaPy4PBopEbrSBqmF/hi1tELjPcdLekXCUHoosI0EvVpvCV1RPG8mYdyrdBnd
         Fllgl89oqZM/x8lhSK+2TEnnxmhPWpqeOOPUM=
MIME-Version: 1.0
In-Reply-To: <4AE83541.3030306@kernel.org>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1256712464-21472-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <20091028074832.GC19402@elte.hu> <4AE7FA12.2070905@kernel.org>
	 <84144f020910280438j65bcacacq731f6076cbd8d99@mail.gmail.com>
	 <4AE83541.3030306@kernel.org>
Date: Thu, 29 Oct 2009 13:19:51 +0200
X-Google-Sender-Auth: e8469d64166b67fb
Message-ID: <84144f020910290419k45a0c47fp500f5b5c390b80e2@mail.gmail.com>
Subject: Re: [PATCH 07/10] bootmem: add free_bootmem_late
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org, dwmw2@infradead.org,
       joerg.roedel@amd.com, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 2:12 PM, Tejun Heo <tj@kernel.org> wrote:
>> We're doing it before scheduler init now but I haven't put any effort
>> into moving it earlier than that yet. I don't see any fundamental
>> reason we can't do that but the practical problem is that we're going
>> to affect architecture specific boot code which is really hard to
>> test.
>
> Thanks for the explanation.  It would be really great if we can pull
> that off someday.  This should be doable architecture-by-architecture,
> right?  You can, for example, first convert x86 and then make bootmem
> allocator thin wrapper around the slab allocator.  After all archs
> have been converted, the wrappers can be dropped.

I am not sure how you we could do that.

The main challenge in initializing slab earlier is the various
implicit dependencies between different parts of the kernel boot code.
If we initialize slab earlier, we also need to initialize page
allocator earlier which requires page table setup, mem_init(), and so
on. Unfortunately architectures don't do boot-time setup in "standard"
places which means that for some architectures mem_init() might need
traps but for other architectures we can't just enable traps earlier
unless we do something else before that as well.

So I think we need to untagle the mess in init/main.c some more first
before we try to initialize slab earlier.

                        Pekka
