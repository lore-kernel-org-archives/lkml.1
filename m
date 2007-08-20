Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbXHTAqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbXHTAqS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 20:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbXHTAqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 20:46:04 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:19915 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbXHTAqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 20:46:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=rs/T51he8aG67IAsrcm9o2SHWv7Aul0g4BkfuV16QLUpjpZfmcloHWtoGYA2asy+CixL2pPytKSgS9ot83iQesTYKYn1c2wnt1JclTl49hQw9/oWcwkaI70hj9MMQ7zNgM2O5SJUvu9z3OVXfrjzrr4ZMNDf9tLFDumM1TUFWl0=
Message-ID: <21d7e9970708191745h3b579f3bp72f138e089c624da@mail.gmail.com>
Date: Mon, 20 Aug 2007 10:45:59 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: dri-devel <dri-devel@lists.sourceforge.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: uncached page allocator
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've started doing some work with using the new DRM memory manager
from TG for pixmaps in the X server using Intel 9xx series hardware.

The intel hardware pretty much requires pages to be uncached for the
GPU to access them. It can use cached memory for some operations but
it isn't very useful and my attempts to use it ended in a lot of
crashiness..

Now one of the major usage patterns for pixmaps is

allocate pixmap
copy data into pixmap
use pixmap from hardware
free pixmap

with the current memory manager + updated change_page_attr (to use
clflush when we have it) fixes from Andi Kleen, it operates something
like this

allocate pixmap gets cached memory
copy data into the pixmap
pre-use from hardware we flush the cache lines and tlb
use the pixmap in hardware
pre-free we need to set the page back to cached so we flush the tlb
free the memory.

The other path is if we don't want to use the memory cached ever is just
allocate pixmap
flush cache lines/tlb
use uncached from CPU
use uncached from GPU
pre-free set the page back to cached, flush the TLB
free the page

Now the big issue here on SMP is that the cache and/or tlb flushes
require IPIs and they are very noticeable on the profiles,

So after all that I'd like to have some sort of uncached page list I
can allocate pages from, so with frequent pixmap creation/destruction
I don't spend a lot of time in the cache flushing routines and avoid
the IPI in particular.

The options I can sorta see roughly are:
1. the DRM just allocates a bunch of uncached pages and manages a
cache of them for interacting with the hardware, this sounds wrong and
we run into how do we correctly size the pool issues.

2. (Is this idea crazy??) We modify the VM somehow so we have an
uncached list, when we first allocate pages with the GFP_UNCACHED they
get migrated to the uncached zone and the pages use a page flag to say
they are uncached. Then the DRM just re-uses things from that list. If
later we end up with memory pressure, the free pages on the uncached
list could be migrated back to the normal page lists by modifying the
page attributes and flushing the tlb....

Any other ideas and suggestions?

Dave.
