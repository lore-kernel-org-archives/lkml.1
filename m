Return-Path: <linux-kernel-owner+w=401wt.eu-S1758866AbYFZRqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbYFZRqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 13:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758247AbYFZRpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 13:45:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758258AbYFZRpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 13:45:51 -0400
Date: Thu, 26 Jun 2008 09:30:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
cc: Anton Arapov <aarapov@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix copy_user on x86_64
In-Reply-To: <m3prq4dw7i.fsf@gravicappa.englab.brq.redhat.com>
Message-ID: <alpine.LFD.1.10.0806260925220.14031@hp.linux-foundation.org>
References: <m3myl9hf0o.fsf@gravicappa.englab.brq.redhat.com> <48635DA0.80102@redhat.com> <alpine.LFD.1.10.0806260837290.10755@hp.linux-foundation.org> <m3prq4dw7i.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Jun 2008, Vitaly Mayatskikh wrote:
> 
> Seems reasonable. However, we still need specialized memset() routine,
> because, again, destination can fail. Thanks for the review, Linus!

Actually, the "zero at the end" case is only for copy_from_user() (at 
least it _should_ be), so for the clearing-at-end you should be able to 
use a regular memset().

But it's not a big deal either way. As long as we only get into the fixup 
routine at exception time, and handle all the common cases fast (ie do the 
32-byte unrolled thing etc optimally), the fixup routine can do everything 
a byte at a time with "get_user()" and "put_user()" etc. The "fault at 
copy_*_user()" case really isn't all that performance-sensitive, because 
it really happens essentially _never_.

(That's obviously why nobody even noticed how broken they were for 
essentially what must have been _years_. It's not just not a performance 
sensitive area, it's one that is entered so seldom that it's hard to ever 
hit any correctness issues either)

		Linus
