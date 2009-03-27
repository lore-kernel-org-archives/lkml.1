Return-Path: <linux-kernel-owner+w=401wt.eu-S1761959AbZC0XET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761959AbZC0XET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761778AbZC0XDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:03:50 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:47995 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759870AbZC0XDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:03:49 -0400
Subject: Re: [patch 0/6] Guest page hinting version 7.
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, frankeh@watson.ibm.com, akpm@osdl.org,
       nickpiggin@yahoo.com.au, hugh@veritas.com, riel@redhat.com
In-Reply-To: <20090327150905.819861420@de.ibm.com>
References: <20090327150905.819861420@de.ibm.com>
Content-Type: text/plain
Date: Fri, 27 Mar 2009 16:03:43 -0700
Message-Id: <1238195024.8286.562.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-27 at 16:09 +0100, Martin Schwidefsky wrote:
> If the host picks one of the
> pages the guest can recreate, the host can throw it away instead of writing
> it to the paging device. Simple and elegant.

Heh, simple and elegant for the hypervisor.  But I'm not sure I'm going
to call *anything* that requires a new CPU instruction elegant. ;)

I don't see any description of it in there any more, but I thought this
entire patch set was to get rid of the idiotic triple I/Os in the
following scenario:

1. Hypervisor picks a page and evicts it out to disk, pays the I/O cost
   to get it written out. (I/O #1)
2. Linux comes along (being a bit late to the party) and picks the same
   page, also decides it needs to be out to disk
3. Linux tries to write the page to disk, but touches it in the 
   process, pulling the page back in from the store where the hypervisor
   wrote it. (I/O #2)
4. Linux writes the page to its swap device (I/O #3)

I don't see that mentioned at all in the current description.
Simplifying the hypervisor is hard to get behind, but cutting system I/O
by 2/3 is a much nicer benefit for 1200 lines of invasive code. ;)

Can we persuade the hypervisor to tell us which pages it decided to page
out and just skip those when we're scanning the LRU?

-- Dave

