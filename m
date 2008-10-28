Return-Path: <linux-kernel-owner+w=401wt.eu-S1753116AbYJ1VnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbYJ1VnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 17:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbYJ1Vmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 17:42:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:50795 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbYJ1Vmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 17:42:44 -0400
Date: Tue, 28 Oct 2008 14:42:55 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Avi Kivity <avi@redhat.com>, Glauber Costa <glommer@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       aliguori@codemonkey.ws, npiggin@suse.de,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: Re: [PATCH] regression: vmalloc easily fail.
Message-ID: <20081028144255.05712d70@infradead.org>
In-Reply-To: <ada7i7so1o7.fsf@cisco.com>
References: <1225234513-3996-1-git-send-email-glommer@redhat.com>
	<49077E1A.5080105@redhat.com>
	<ada7i7so1o7.fsf@cisco.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008 14:22:16 -0700
Roland Dreier <rdreier@cisco.com> wrote:

>  > I'm guessing that the missing comment explains that this is
>  > intentional, to trap buffer overflows?
> 
> Actually, speaking of comments, it's interesting that
> __get_vm_area_node() -- which is called from vmalloc() -- does:
> 
> 	/*
> 	 * We always allocate a guard page.
> 	 */
> 	size += PAGE_SIZE;
> 
> 	va = alloc_vmap_area(size, align, start, end, node, gfp_mask);
> 
> and alloc_vmap_area() adds another PAGE_SIZE, as the original email
> pointed out:
> 
> 		while (addr + size >= first->va_start && addr + size
> <= vend) { addr = ALIGN(first->va_end + PAGE_SIZE, align);
> 
> I wonder if the double padding is causing a problem when things get
> too fragmented?

I suspect it's a case of off-by-one... ALIGN() might round down, and
the "+ (PAGE_SIZE-1)" was there to make it round up.
Except for that missing -1 ...

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
