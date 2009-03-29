Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbZC2ONT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbZC2ONT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 10:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbZC2OND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 10:13:03 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:50699 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbZC2ONB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 10:13:01 -0400
Date: Sun, 29 Mar 2009 16:12:53 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, frankeh@watson.ibm.com, akpm@osdl.org,
       nickpiggin@yahoo.com.au, hugh@veritas.com, riel@redhat.com
Subject: Re: [patch 0/6] Guest page hinting version 7.
Message-ID: <20090329161253.3faffdeb@skybase>
In-Reply-To: <1238195024.8286.562.camel@nimitz>
References: <20090327150905.819861420@de.ibm.com>
	<1238195024.8286.562.camel@nimitz>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 16:03:43 -0700
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> On Fri, 2009-03-27 at 16:09 +0100, Martin Schwidefsky wrote:
> > If the host picks one of the
> > pages the guest can recreate, the host can throw it away instead of writing
> > it to the paging device. Simple and elegant.
> 
> Heh, simple and elegant for the hypervisor.  But I'm not sure I'm going
> to call *anything* that requires a new CPU instruction elegant. ;)

Hey its cool if you can request an instruction to solve your problem :-)

> I don't see any description of it in there any more, but I thought this
> entire patch set was to get rid of the idiotic triple I/Os in the
> following scenario:
> 
> 1. Hypervisor picks a page and evicts it out to disk, pays the I/O cost
>    to get it written out. (I/O #1)
> 2. Linux comes along (being a bit late to the party) and picks the same
>    page, also decides it needs to be out to disk
> 3. Linux tries to write the page to disk, but touches it in the 
>    process, pulling the page back in from the store where the hypervisor
>    wrote it. (I/O #2)
> 4. Linux writes the page to its swap device (I/O #3)
> 
> I don't see that mentioned at all in the current description.
> Simplifying the hypervisor is hard to get behind, but cutting system I/O
> by 2/3 is a much nicer benefit for 1200 lines of invasive code. ;)

You are right, for a newcomer to the party the advantages of this
approach are not really obvious. Should have copied some more text from
the boilerplate from the previous versions.

Yes, the guest page hinting code aims to reduce the hosts swap I/O.
There are two scenarios, one is the above, the other is a simple
read-only file cache page.
Without hinting:
1. Hypervisor picks a page and evicts it, that is one write I/O
2. Linux access the page and causes a host page fault. The host reads
the page from its swap disk, one read I/O.
In total 2 I/O operations.
With hinting:
1. Hypervisor picks a page, finds it volatile and throws it away.
2. Linux access the page and gets a discard fault from the host. Linux
reads the file page from its block device.
This is just one I/O operation.

> Can we persuade the hypervisor to tell us which pages it decided to page
> out and just skip those when we're scanning the LRU?

One principle of the whole approach is that the hypervisor does not
call into an otherwise idle guest. The cost of schedulung the virtual
cpu is just too high. So we would a means to store the information where
the guest can pick it up when it happens to do LRU. I don't think that
this will work out.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

