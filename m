Return-Path: <linux-kernel-owner+w=401wt.eu-S1761171AbXH3RJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761171AbXH3RJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 13:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbXH3RJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 13:09:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:53606 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755564AbXH3RJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 13:09:32 -0400
X-Authenticated: #12383568
X-Provags-ID: V01U2FsdGVkX18VgAhesRsVlPXF3CDlrKOV/x0/y35AVrXzp5+aGh
	xP065vk+kOh//o
From: Clemens Kolbitsch <clemens.kol@gmx.at>
To: Jiri Kosina <jikos@jikos.cz>
Subject: Re: Forbid deletion of memory mappings
Date: Thu, 30 Aug 2007 19:09:28 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200708301844.10532.clemens.kol@gmx.at> <Pine.LNX.4.64.0708301906020.2460@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0708301906020.2460@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708301909.28894.clemens.kol@gmx.at>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 August 2007 19:07:05 Jiri Kosina wrote:
> On Thu, 30 Aug 2007, Clemens Kolbitsch wrote:
> > It all works perfectly well (creating & deleting the additional
> > mappings), however, when the kernel feels like it needs to allocate a
> > mapping in user-space it sometimes deletes my mapping and overwrites it
> > with the new one, although there is plenty of free memory at some other
> > location.
>
> Hi Clemens,
>
> what do you mean by "overwrites it"? It just probably merges your vma with
> the newly created one, right?

that's exactly the problem... it replaces my mapping with the new one... i.e. 
it first deletes my mapping and then creates the new one at the same 
location.

i *guess* this all happens in exec.c, lines 1033ff:

munmap_back:
	vma = find_vma_prepare(mm, addr, &prev, &rb_link, &rb_parent);
	if (vma && vma->vm_start < addr + len) {
		if (do_munmap(mm, addr, len))
			return -ENOMEM;
		goto munmap_back;
	}
