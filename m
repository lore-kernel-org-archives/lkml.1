Return-Path: <linux-kernel-owner+w=401wt.eu-S965865AbXDEJcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965865AbXDEJcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 05:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965816AbXDEJcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 05:32:03 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:2718
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965641AbXDEJcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 05:32:00 -0400
Message-Id: <4614DE61.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Thu, 05 Apr 2007 10:32:49 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>, <discuss@x86-64.org>
Subject: change_page_attr() and global_flush_tlb()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at both the i386 and x86-64 implementations I fail to understand why
there is an explicit requirement on calling global_flush_tlb() after
change_page_attr(), yet actual TLB flushing will not normally happen (on i386
it will happen if the CPU doesn't support clflush, but if it does, or on x86-64,
the flushing depends on the list of deferred pages being non-empty, which
can only happen when a large page gets re-combined). Is it assumed that
the callers additionally call tlb_flush_all() (I think none of them do)?

Further, change_page_attr()'s reference counting in a split large page's
page table appears to imply that attributes are only changed from or back to
the reference attributes, but not from one kind of non-default ones to the
same or another set of non-default ones (otherwise the reference count
will never again drop to zero), and also not from default to default (i.e. the
caller trying to revert attributes to normal not knowing what state they are
currently in) - this would BUG() if the large page was already reverted, or
screw the reference count otherwise. Is all of this intentional? I think it
will need to be changed as a prerequisite to supporting on-the-fly attribute
changes in the SMP alternatives code, which was requested as a follow-up
to the tightening of the CONFIG_DEBUG_RODATA effects.

Finally, at least for the kernel image range it would seem to me that it might
be beneficial to recombine mappings into large ones even when the
attributes are not at their default anymore, but consistent across an entire
2Mb/4Mb range (i.e. after write-protecting .text). At the same time I wonder,
though, whether it wouldn't be safer to remove execute permission from
anything but .text along with write-protecting read-only regions under
CONFIG_DEBUG_RODATA.

Thanks for any insight,
Jan
