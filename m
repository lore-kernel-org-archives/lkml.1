Return-Path: <linux-kernel-owner+w=401wt.eu-S1763511AbYBTADV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763511AbYBTADV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbYBTADO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:03:14 -0500
Received: from n8a.bullet.mail.mud.yahoo.com ([209.191.87.104]:41908 "HELO
	n8a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752597AbYBTADM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:03:12 -0500
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2008 19:03:12 EST
X-Yahoo-Newman-Id: 4394.1189.bm@omp424.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1VO45x3VieYRo7Q+TtIrSTGSr6XunUEbqXdjNU9GwsYTEWROydP5a0RBdc0INPkrkxTTdO8QaFyCOqV8KH15WjXGta4UAFzdkoDsINkzCrgsW6YXjgPDh8D8G/7haLdaK2ZimHH4PSYfqwGSXJYVLFL+CW3V6xXF56KKEXDz4Sg=  ;
X-YMail-OSG: Vu6ZwIUVM1lplq92TkV9ZyBRPi9FKK_gpBA75YLlN2CsLsI2qjyIXoQ4V8T0PJ21d8eMLwTH1w--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 5/6] mmu_notifier: Support for drivers with revers maps (f.e. for XPmem)
Date: Wed, 20 Feb 2008 10:55:20 +1100
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, Andrea Arcangeli <andrea@qumranet.com>,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
References: <20080215064859.384203497@sgi.com> <20080215064933.376635032@sgi.com>
In-Reply-To: <20080215064933.376635032@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802201055.21343.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 February 2008 17:49, Christoph Lameter wrote:
> These special additional callbacks are required because XPmem (and likely
> other mechanisms) do use their own rmap (multiple processes on a series
> of remote Linux instances may be accessing the memory of a process).
> F.e. XPmem may have to send out notifications to remote Linux instances
> and receive confirmation before a page can be freed.
>
> So we handle this like an additional Linux reverse map that is walked after
> the existing rmaps have been walked. We leave the walking to the driver
> that is then able to use something else than a spinlock to walk its reverse
> maps. So we can actually call the driver without holding spinlocks while we
> hold the Pagelock.

I don't know how this is supposed to solve anything. The sleeping
problem happens I guess mostly in truncate. And all you are doing
is putting these rmap callbacks in page_mkclean and try_to_unmap.


> However, we cannot determine the mm_struct that a page belongs to at
> that point. The mm_struct can only be determined from the rmaps by the
> device driver.
>
> We add another pageflag (PageExternalRmap) that is set if a page has
> been remotely mapped (f.e. by a process from another Linux instance).
> We can then only perform the callbacks for pages that are actually in
> remote use.
>
> Rmap notifiers need an extra page bit and are only available
> on 64 bit platforms. This functionality is not available on 32 bit!
>
> A notifier that uses the reverse maps callbacks does not need to provide
> the invalidate_page() method that is called when locks are held.

That doesn't seem right. To start with, the new callbacks aren't
even called in the places where invalidate_page isn't allowed to
sleep.

The problem is unmap_mapping_range, right? And unmap_mapping_range
must walk the rmaps with the mmap lock held, which is why it can't
sleep. And it can't hold any mmap_sem so it cannot prevent address
space modifications of the processes in question between the time
you unmap them from the linux ptes with unmap_mapping_range, and the
time that you unmap them from your driver.

So in the meantime, you could have eg. a fault come in and set up a
new page for one of the processes, and that page might even get
exported via the same external driver. And now you have a totally
inconsistent view.

Preventing new mappings from being set up until the old mapping is
completely flushed is basically what we need to ensure for any sane
TLB as far as I can tell. To do that, you'll need to make the mmap
lock sleep, and either take mmap_sem inside it (which is a
deadlock condition at the moment), or make ptl sleep as well. These
are simply the locks we use to prevent that from happening, so I
can't see how you can possibly hope to have a coherent TLB without
invalidating inside those locks.

