Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbYKQIFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbYKQIFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 03:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbYKQIFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 03:05:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58046 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbYKQIFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 03:05:06 -0500
Message-ID: <49212587.8020702@redhat.com>
Date: Mon, 17 Nov 2008 09:04:23 +0100
From: Chris Lalancette <clalance@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jan Beulich <jbeulich@novell.com>,
       Xen-devel <xen-devel@lists.xensource.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 03 of 38] swiotlb: allow architectures	tooverride
 swiotlb pool allocation
References: <patchbomb.1226603398@abulafia.goop.org>	<e9f25b3bb6625ee88f9f.1226603401@abulafia.goop.org> <491D4C89.76E4.0078.0@novell.com> <491DD27A.30707@goop.org>
In-Reply-To: <491DD27A.30707@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>> While perhaps less intrusive to take care of, I also didn't see an equivalent
>> of the range_straddles_page_boundary() logic, without which I can't see
>> how this would work in the common case.
>>   
> Could you be more specific?  The swiotlb allocation should be machine 
> contiguous and so there's no stradding required, but I think I'm missing 
> your point.

In general, I think you are right; swiotlb should be machine contiguous, so it
works in the normal case.  The range_straddles_page_boundary function takes care
of a corner case, where you can run into swiotlb exhaustion when you really
shouldn't.  As I understand it, it comes about because it is possible to get a
swiotlb request with two pages that just happen to be machine contiguous, but
were *not* allocated through xen_create_contiguous_region (and hence weren't
marked in the contiguous_bitmap as such).  In this case, you split the request
into two separate requests, and this can more easily lead to exhaustion.
range_straddles_page_boundary works around this by checking whether any two
pages coming through the swiotlb layer are machine contiguous, and if they are,
not splitting the request.

-- 
Chris Lalancette
