Return-Path: <linux-kernel-owner+w=401wt.eu-S1759657AbZCPN3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657AbZCPN3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 09:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbZCPN3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 09:29:41 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:44807 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbZCPN3k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 09:29:40 -0400
Message-Id: <49BE627E.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Mon, 16 Mar 2009 13:30:22 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "David Airlie" <airlied@linux.ie>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 10/27] xen: make sure swiotlb
	 allocation isphysically contigious
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
 <1236963612-14287-11-git-send-email-jeremy@goop.org>
In-Reply-To: <1236963612-14287-11-git-send-email-jeremy@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 13.03.09 17:59 >>>
> void * __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
> {
>-	return alloc_bootmem_low_pages(size);
>+	void *ret = alloc_bootmem_low_pages(size);
>+
>+	if (ret && xen_pv_domain())
>+		xen_swiotlb_fixup(ret, size, nslabs);
>+
>+	return ret;
> }
 
While on native using alloc_bootmem_low_pages() is a requirement here,
on Xen this should explicitly not be used, as we realized just a couple of
days ago: The way the bootmem allocator works, running out of space
below 4Gb is pretty easy on machines with lots of memory, and since the
swiotlb is a requirement for Dom0, the risk of allocation failures must be
kept as low as possible.

Jan

