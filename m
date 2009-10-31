Return-Path: <linux-kernel-owner+w=401wt.eu-S933299AbZJaVUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299AbZJaVUA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 17:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933276AbZJaVTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 17:19:55 -0400
Received: from smtp-out.google.com ([216.239.33.17]:10979 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933249AbZJaVTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 17:19:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=O6Ayl0Wx4Um9q3K4zvu3eVP0CJacxGGAFq1J09uY0pwsx8wa5qpC08yQW7VYyv0b1
	okjtlcWe8WAI78C5G3MKg==
Date: Sat, 31 Oct 2009 14:19:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pavel Machek <pavel@ucw.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       stable@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 2/3] page allocator: Do not allow interrupts to use
 ALLOC_HARDER
In-Reply-To: <20091031201158.GB29536@elf.ucw.cz>
Message-ID: <alpine.DEB.2.00.0910311413160.25524@chino.kir.corp.google.com>
References: <1256650833-15516-1-git-send-email-mel@csn.ul.ie> <1256650833-15516-3-git-send-email-mel@csn.ul.ie> <20091027130924.fa903f5a.akpm@linux-foundation.org> <alpine.DEB.2.00.0910271411530.9183@chino.kir.corp.google.com> <20091031184054.GB1475@ucw.cz>
 <alpine.DEB.2.00.0910311248490.13829@chino.kir.corp.google.com> <20091031201158.GB29536@elf.ucw.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Oct 2009, Pavel Machek wrote:

> > Um, no, it's a matter of the kernel implementation.  We allow such tasks 
> > to allocate deeper into reserves to avoid the page allocator from 
> > incurring a significant penalty when direct reclaim is required.  
> > Background reclaim has already commenced at this point in the
> > slowpath.
> 
> But we can't guarantee that enough memory will be ready in the
> reserves. So if realtime task relies on it, it is broken, and will
> fail to meet its deadlines from time to time.

This is truly a bizarre tangent to take, I don't quite understand the 
point you're trying to make.  Memory reserves exist to prevent blocking 
when we need memory the most (oom killed task or direct reclaim) and to 
allocate from when we can't (GFP_ATOMIC) or shouldn't (rt tasks) utilize 
direct reclaim.  The idea is to kick background reclaim first in the 
slowpath so we're only below the low watermark for a short period and 
allow the allocation to succeed.  If direct reclaim actually can't free 
any memory, the oom killer will free it for us.

So the realtime[*] tasks aren't relying on it at all, the ALLOC_HARDER 
exemption for them in the page allocator are a convenience to return 
memory faster than otherwise when the fastpath fails.  I don't see much 
point in arguing against that.

 [*] This is the current mainline definition of "realtime," which actually
     includes a large range of different priorities.  For strict realtime,
     you'd need to check out the -rt tree.
