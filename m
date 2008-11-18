Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbYKRSHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbYKRSHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 13:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbYKRSHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 13:07:33 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:60066 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750844AbYKRSHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 13:07:32 -0500
Subject: Re: arch_flush_lazy_mmu_mode() in arch/x86/mm/highmem_32.c
From: Zachary Amsden <zach@vmware.com>
To: Jan Beulich <jbeulich@novell.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4923096A.76E4.0078.0@novell.com>
References: <4921428A.76E4.0078.0@novell.com>
	 <1226944387.9969.77.camel@bodhitayantram.eng.vmware.com>
	 <4921BA8E.60806@goop.org> <492284CE.76E4.0078.0@novell.com>
	 <4922F4EC.6050408@goop.org>  <4923096A.76E4.0078.0@novell.com>
Content-Type: text/plain
Date: Tue, 18 Nov 2008 10:06:41 -0800
Message-Id: <1227031601.13665.33.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-18 at 09:28 -0800, Jan Beulich wrote:
> >>> Jeremy Fitzhardinge <jeremy@goop.org> 18.11.08 18:01 >>>

> Latency, as before. The page fault should have to take longer than it really
> needs, and the flushing of a pending batch clearly doesn't belong to the
> page fault itself.

Page faults for vmalloc area syncing are extremely rare to begin with,
and only happen on non-PAE kernels (although, perhaps on Xen in
PAE-mode, since the PMD isn't fully shared).  Latency isn't an issue
there.

Latency could be added on interrupts which somehow end up in a
kmap_atomic path, but there are very restricted uses of this; glancing
around, I see ide_io_buffers, aio, USB DMA peeking, bounce buffers,
memory sticks, NTFS, a couple SCSI drivers...

Most of these are doing things like PIO or data copy... I'm sure there
are some hot paths here such as aio, but do you really see an issue with
potentially having to process 32 queued multicalls, I mean the latency
can't be that high?  Do you have any statistics that show this latency
to be a problem?

Our measurements show that the lazy mode batching rarely gets more than
a couple updates; every once in a while, you might get a blob of 32 or
so, but in the common case, there are typically only a few updates.  I
really can't realistically imagine a scenario where it would measurably
affect performance to have to issue a typically small flush in the
already rare case that you happen to take an interrupt in a MMU batching
region...

This whole thing is already pretty tricky to get right and one could
even say a bit fragile.  It's been a problematic source of bugs in the
past.  I don't see how making it more complex than it already is, is
going to help anyone.  If anything, we should be looking to simplify
it..

Zach

