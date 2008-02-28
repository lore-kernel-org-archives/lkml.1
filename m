Return-Path: <linux-kernel-owner+w=401wt.eu-S1759417AbYB1M7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417AbYB1M7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 07:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755736AbYB1M65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 07:58:57 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:26258
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755025AbYB1M64 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:58:56 -0500
Message-Id: <47C6BE37.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 Beta 
Date: Thu, 28 Feb 2008 12:59:19 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>
Subject: x86: potential ioremap() issues
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

with the new ioremap() implementation I see a couple of (potential)
issues:
- When ioremap_page_range() fails, remove_vm_area() is used rather
  than vunmap() - I think this will cause a 'struct vm_struct' leak.
- While ioremap() continues to happily map RAM pages (with a bogus
  [see below] WARN_ON_ONCE()), cacheability of the memory is not
  being restored in iounmap().
- The check for RAM pages (except for the WARN_ON_ONCE())
  continues to be applied only to lowmem pages.
- The WARN_ON_ONCE() itself is applied to the pfn after the
  preceding loop finished, i.e. to a pfn that doesn't actually participate
  in the operation. Shouldn't it be moved inside the loop?

Thanks for any clarification,
Jan

