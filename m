Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbYKKMvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbYKKMvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 07:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756647AbYKKMut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 07:50:49 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56609 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765AbYKKMus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 07:50:48 -0500
Date: Tue, 11 Nov 2008 11:30:43 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CONFIG_NUMA breaks hibernation on x86-32 with PAE
Message-ID: <20081111103043.GD5464@elf.ucw.cz>
References: <20081109140726.GB1786@ucw.cz> <20081110080436.GF2093@elte.hu> <87hc6fpwof.fsf@basil.nowhere.org> <200811101928.04565.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811101928.04565.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-11-10 19:28:03, Rafael J. Wysocki wrote:
> On Monday, 10 of November 2008, Andi Kleen wrote:
> > Ingo Molnar <mingo@elte.hu> writes:
> > >
> > > No good ideas - the bug description gives me the impression of memory 
> > > maps save/restore hickup in the hibernation code - and memory maps are 
> > > pretty much the only thing that are significantly different on NUMA. 
> > 
> > I assume the problem happened on a single node system.
> > On single node the memory map should be actually quite similar
> > to the UMA case.
> 
> It is.  However, the problem is 100% reproducible on any 32-bit single-node
> system with CONFIG_NUMA set, from what I can tell.
> 
> It doesn't happen if the kernel is booted with highmem=0, so it looks like
> the code that saves highmem causes the problem to happen.  However, this
> same code works well for all of the !CONFIG_NUMA cases and practically only
> the only non-open-coded it uses is kmap_atomic().

kmap_atomic() and kernel_map_pages(), AFAICT.

Can kmap_atomic() modify pages in highmem, too?

Wait... are we putting kernel pagetables in the high memory?

What about this cleanup (warning: untested)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 5d2ab83..f1d8336 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -966,7 +966,7 @@ static void copy_data_page(unsigned long
 			 * data modified by kmap_atomic()
 			 */
 			safe_copy_page(buffer, s_page);
-			dst = kmap_atomic(pfn_to_page(dst_pfn), KM_USER0);
+			dst = kmap_atomic(d_page, KM_USER0);
 			memcpy(dst, buffer, PAGE_SIZE);
 			kunmap_atomic(dst, KM_USER0);
 		} else {

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
