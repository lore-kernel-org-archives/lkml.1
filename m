Return-Path: <linux-kernel-owner+w=401wt.eu-S1422740AbXCBDIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422740AbXCBDIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 22:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422742AbXCBDIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 22:08:35 -0500
Received: from gw.goop.org ([64.81.55.164]:59524 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422740AbXCBDIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 22:08:35 -0500
Message-ID: <45E79529.9000305@goop.org>
Date: Thu, 01 Mar 2007 19:08:25 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andi Kleen <ak@muc.de>, Linus Torvalds <torvalds@osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Dan Hecht <dhecht@vmware.com>,
       Dan Arai <arai@vmware.com>, Andrew Morton <akpm@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] Vmi fix highpte
References: <200703020254.l222smBB009668@zach-dev.vmware.com>
In-Reply-To: <200703020254.l222smBB009668@zach-dev.vmware.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Provide a PT map hook for HIGHPTE kernels to designate where they are mapping
> page tables.  This information is required so the physical address of PTE
> updates can be determined; otherwise, the mm layer would have to carry the
> physical address all the way to each PTE modification callsite, which is
> even more hideous that the macros required to provide the proper hooks.
>
> So lets not mess up arch neutral code to achieve this, but keep the horror
> in an #ifdef HIGHPTE in include/asm-i386/pgtable.h.  I had to use macros
> here because some types are not yet defined in all the include paths for
> this header.
>
> This patch is absolutely required for HIGHPTE kernels to operate properly
> with VMI.
>   

Hm, I don't think this interface will work for Xen.  In Xen, whenever a
pagetable page gets mapped, it must be mapped RO.  map_pt_hook gets
called after the mapping has already been created, so its too late for Xen.

I was planning on adding kmap_atomic_pte() for use in pte_offset_map*(),
which would be wired through to paravirt_ops to allow Xen to make this a
RO mapping.  Would this be sufficient for you to do your vmi thing?

    J
