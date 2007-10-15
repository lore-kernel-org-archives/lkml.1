Return-Path: <linux-kernel-owner+w=401wt.eu-S1760146AbXJOJhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146AbXJOJhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 05:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756437AbXJOJgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 05:36:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:40872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902AbXJOJgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 05:36:53 -0400
To: David Chinner <dgc@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xfs@oss.sgi.com,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       Morten =?iso-8859-1?Q?B=C3=B8geskov?= 
	<xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com, nickpiggin@yahoo.com.au
Subject: Re: Interaction between Xen and XFS: stray RW mappings
From: Andi Kleen <andi@firstfloor.org>
References: <470FA7C3.90404@goop.org> <20071014225618.GN23367404@sgi.com>
Date: Mon, 15 Oct 2007 11:36:50 +0200
In-Reply-To: <20071014225618.GN23367404@sgi.com> (David Chinner's message of "Mon\, 15 Oct 2007 08\:56\:18 +1000")
Message-ID: <p731wbw4t3h.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner <dgc@sgi.com> writes:
>
> And yes, we delay unmapping pages until we have a batch of them
> to unmap. vmap and vunmap do not scale, so this is batching helps
> alleviate some of the worst of the problems.

You're keeping vmaps around for already freed pages?

That will be a big problem for proper PAT support, which needs
to track all mappings to memory. It's not just a problem for Xen.

In fact I suspect it is already broken with DRM or AGP for example which
can use UC and WC mappings -- if you keep the mapping around and
DRM or AGP turns the page in another mapping uncacheable you're
creating an illegal cache attribute alias. These are known to occasionally
create cache corruptions on several x86s; giving ___VERY___ hard to debug
bugs once a blue moon.

Probably it'll require some generic VM batching mechanism where
Xen or PAT code can hook into the list or force unmap the mappings
as needed.

Definitely needs to be fixed if true. You're lucky that Xen caught it
in time.

-Andi
