Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbYKQIyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbYKQIyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 03:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbYKQIyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 03:54:08 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:33347 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbYKQIyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 03:54:07 -0500
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Nov 2008 03:54:06 EST
X-IronPort-AV: E=Sophos;i="4.33,617,1220227200"; 
   d="scan'208";a="2773015"
User-Agent: Microsoft-Entourage/11.4.0.080122
Date: Mon, 17 Nov 2008 08:44:20 +0000
Subject: Re: [Xen-devel] [PATCH 03 of 38] swiotlb: allow architectures
 tooverride swiotlb pool allocation
From: Keir Fraser <keir.fraser@eu.citrix.com>
To: Chris Lalancette <clalance@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
CC: Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Message-ID: <C546DF64.1F481%keir.fraser@eu.citrix.com>
Thread-Topic: [Xen-devel] [PATCH 03 of 38] swiotlb: allow architectures
 tooverride swiotlb pool allocation
Thread-Index: AclIkK6v7PwvhLSDEd2TBAAWy6hiGQ==
In-Reply-To: <49212587.8020702@redhat.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 17 Nov 2008 08:44:25.0015 (UTC) FILETIME=[B1ACC470:01C94890]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/11/08 08:04, "Chris Lalancette" <clalance@redhat.com> wrote:

>> Could you be more specific?  The swiotlb allocation should be machine
>> contiguous and so there's no stradding required, but I think I'm missing
>> your point.
> 
> In general, I think you are right; swiotlb should be machine contiguous, so it
> works in the normal case.  The range_straddles_page_boundary function takes
> care
> of a corner case, where you can run into swiotlb exhaustion when you really
> shouldn't.  As I understand it, it comes about because it is possible to get a
> swiotlb request with two pages that just happen to be machine contiguous, but
> were *not* allocated through xen_create_contiguous_region (and hence weren't
> marked in the contiguous_bitmap as such).  In this case, you split the request
> into two separate requests, and this can more easily lead to exhaustion.
> range_straddles_page_boundary works around this by checking whether any two
> pages coming through the swiotlb layer are machine contiguous, and if they
> are,
> not splitting the request.

A more specific problem solved by range_straddle_page_boundary() in our
2.6.18 kernel was that the block layer would do bio merging because it
checked that pages really were contiguous, and then swiotlb (without
r_s_p_b) would decide that the pages weren't contiguous (because the
contiguity was random luck rather than explicitly requested) and hence do
bounce buffering. Result was that sufficiently aggressive I/O would exhaust
swiotlb resources and crash the kernel.

In the 2.6.18 port we actually got rid of contiguous_bitmap[] entirely.

 -- Keir


