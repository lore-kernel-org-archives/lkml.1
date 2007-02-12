Return-Path: <linux-kernel-owner+w=401wt.eu-S964845AbXBLJ4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964845AbXBLJ4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964846AbXBLJ4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:56:50 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:29088
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964845AbXBLJ4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:56:49 -0500
Message-Id: <45D04806.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Mon, 12 Feb 2007 09:57:10 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Bryan O'Sullivan" <bos@pathscale.com>, "Andi Kleen" <ak@suse.de>
Cc: "Roland Dreier" <rolandd@cisco.com>, <linux-kernel@vger.kernel.org>,
       <patches@x86-64.org>
Subject: Re: [patches] [PATCH 2.6.21 review I] [21/25] x86_64: a memcpy
	that tries to reduce cache pressure
References: <200702101250.142420000@suse.de>
 <20070210115034.694B013DBF@wotan.suse.de>
In-Reply-To: <20070210115034.694B013DBF@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <ak@suse.de> 10.02.07 12:50 >>>
>
>From: "Bryan O'Sullivan" <bos@pathscale.com>
>
>This copy routine is memcpy-compatible, but on some architectures will use
>cache-bypassing loads to avoid bringing the source data into the cache.
>
>One case where this is useful is when a device issues a DMA to a memory
>region, and the CPU must copy the DMAed data elsewhere before doing any work
>with it.  Since the source data is read-once, write-never from the CPU's
>perspective, caching the data at those addresses can only evict potentially
>useful data.
>
>We provide an x86_64 implementation that uses SSE non-temporal loads, and a
>generic version that falls back to plain memcpy.
>
>Implementors for other arches should not use cache-bypassing stores to the
>destination, as in most cases, the destination is accessed almost immediately
>after a copy finishes.

This looks a little strange to me:
- the first 128 bytes are still going through the cache
- up to 192 bytes past the copied area are being marked non-temporal, while
  there's nothing known about that area
- sfence seems questionable here, I would have thought this should be lfence,
  or perhaps even none at all

Minor remarks would be to remove the double .align before .L12 and replace
or-ing a register with itself by test.

Jan
