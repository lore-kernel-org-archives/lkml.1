Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbYBWNHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbYBWNHY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 08:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbYBWNHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 08:07:03 -0500
Received: from ns2.suse.de ([195.135.220.15]:44852 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbYBWNHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 08:07:00 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?iso-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC PATCH 8/8] Jhash in too big for inlining, move under lib/
From: Andi Kleen <andi@firstfloor.org>
References: <1203515238-22848-1-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-2-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-3-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-4-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-5-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-6-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-7-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-8-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-9-git-send-email-ilpo.jarvinen@helsinki.fi>
	<20080223000214.81b1390a.akpm@linux-foundation.org>
Date: Sat, 23 Feb 2008 14:06:53 +0100
In-Reply-To: <20080223000214.81b1390a.akpm@linux-foundation.org> (Andrew Morton's message of "Sat\, 23 Feb 2008 00\:02\:14 -0800")
Message-ID: <p738x1b95zm.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>
> It should be possible to use a modular jhash.ko.  The things which you
> have identified as clients of the jhash library are usually loaded as modules.

For very small functions like this own modules are quite expensive. First  
everything gets rounded up to at least one 4K page (or worse on architectures
with larger pages). That just wastes some memory. 

But then since modules live in vmalloc space they also need an own 
TLB entry, which are notouriously scarce in the kernel because often user space
wants to monopolize them all. So if you're unlucky and user space
is thrashing the TLB just a single call to this hash function will be an own 
TLB miss and quite expensive.

It would be better to just always link it in for this case.

-Andi
