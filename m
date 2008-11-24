Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbYKXTty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbYKXTty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbYKXTtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:49:45 -0500
Received: from smtp-out.google.com ([216.239.45.13]:47689 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbYKXTto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:49:44 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=LCazuW6Cajf/z5uTTv0gJydN/ALeUXI0w75LwnsVLSMW4yhGA2UGAZ17/QMSzhbv1
	4RCx0vPpOGI+NIVJ/C2Sw==
Date: Mon, 24 Nov 2008 11:49:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Dave Chinner <david@fromorbit.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] mm: change dirty limit type specifiers to unsigned
 long
In-Reply-To: <1227554201.4259.538.camel@twins>
Message-ID: <alpine.DEB.2.00.0811241140390.19930@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0811230228070.11384@chino.kir.corp.google.com> <1227554201.4259.538.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2008, Peter Zijlstra wrote:

> This didn't pop up any weird and wonderfull assumptions on the
> signed-ness of these variables I take it :-)
> 

It didn't; in fact, callers already used them as though they were 
unsigned.  For example, bdi_debug_stats_show():

	seq_printf(m,
		   "BdiDirtyThresh:   %8lu kB\n"
		   "DirtyThresh:      %8lu kB\n"
		   "BackgroundThresh: %8lu kB\n",
		   K(bdi_thresh),
		   K(dirty_thresh),
		   K(background_thresh));

And get_dirty_limits() itself implicitly uses an unsigned type specifier 
for the long *pbdi_dirty limit:

	if (bdi) {
		u64 bdi_dirty;
		...
		*pbdi_dirty = bdi_dirty;
	}

And, given that the remainder of the get_dirty_limits() callers simply use 
these for comparisons to the ZVC global_page_state() values, which are 
also unsigned long, this conversion is safe.

Thanks Peter!
