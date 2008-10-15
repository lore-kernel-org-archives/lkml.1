Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbYJOPXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbYJOPXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 11:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYJOPXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 11:23:43 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:46895 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbYJOPXm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 11:23:42 -0400
Message-Id: <48F6274D.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Wed, 15 Oct 2008 16:24:29 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Chris Lalancette" <clalance@redhat.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH]: Fix Xen domU boot with batched
	 mprotect
References: <48F5CE10.3060403@redhat.com>
In-Reply-To: <48F5CE10.3060403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Chris Lalancette <clalance@redhat.com> 15.10.08 13:03 >>>
>The right thing to do is to use arbitrary_virt_to_machine, so that we can be
>sure we are modifying the right pfn.  This unfortunately introduces a
>performance penalty because of a full page-table-walk, but we can avoid that
>penalty for pages in the p2m list by checking if virt_addr_valid is true, and if
>so, just doing the lookup in the p2m table.

Could you explain how virt_addr_valid() can validly be used here? Looking
at its implementation

#define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)

a kaddr in kmap space (i.e. above high_memory) would return a bogus
physical address, and hence pfn_valid() on the resulting pfn is meaningless.

I'd instead simply compare the address in question against high_memory,
and perhaps instead of in arbitrary_virt_to_machine() in
ptep_modify_prot_commit() under an #ifdef CONFIG_HIGHPTE. But
performance-wise, CONFIG_HIGHPTE sucks under Xen anyway, so you'd
better not turn this on in the first place. We may want/need to provide
a means to disable this at run time so the same kernel when run natively
could still make use of it, but without impacting performance under Xen.

Jan

