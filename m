Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbYCNS3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbYCNS3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 14:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbYCNS26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 14:28:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546AbYCNS25 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 14:28:57 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: fw-ohci: sync AT dma buffer before use
Date: Fri, 14 Mar 2008 14:26:26 -0400
User-Agent: KMail/1.9.9
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200803121743.29438.jwilson@redhat.com> <200803122111.55754.jwilson@redhat.com> <47D8EA7F.8040703@s5r6.in-berlin.de>
In-Reply-To: <47D8EA7F.8040703@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803141426.26098.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008 04:49:03 am Stefan Richter wrote:
> >> So this patch shouldn't do
> >> anything, except that it inserts a call which happens to have barrier
> >> characteristics on some platforms.
>
> ...and potentially delays execution.
>
> > ...but got lucky in that it actually helps this particular setup (x86_64
> > kernel, dual quad-core opteron, 8G RAM, 3 FireWire controllers). Hrm.
>
> Unless you or I spot the real solution earlier, you could also try
> replacing your dma_sync_ with mb() and with mdelay() respectively to see
> what aspect of the dma_sync_ is fixing your setup.  Also move the mb()
> to other interesting places of the involved code.

So it would seem I screwed up something in my testing, and failed to reproduce 
the panic after adding '[PATCH] firewire: fw-ohci: use dma_alloc_coherent for 
ar_buffer' to the mix. Best as I can tell now, the panic was actually 
resolved by that patch, as backing out the sync altogether now works just as 
well as with the sync, with an mb and with an mdelay.

This sort of makes some degree of sense, since this is another x86_64 system 
w/>= 4GB of RAM. It would appear possible that at some higher layer, where AT 
and AR transactions are coordinated with one another, we were getting an AT 
packet into a bad state due to its corresponding AR traffic being stuck in a 
non-coherent buffer we couldn't read. But this is only semi-informed 
speculation...

-- 
Jarod Wilson
jwilson@redhat.com
