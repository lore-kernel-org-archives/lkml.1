Return-Path: <linux-kernel-owner+w=401wt.eu-S1757960AbZA2M22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960AbZA2M22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 07:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZA2M2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 07:28:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:52544 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbZA2M2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 07:28:19 -0500
Subject: Re: PFs on pages pinned with get_user_pages()
From: Peter Zijlstra <peterz@infradead.org>
To: Frank Mehnert <Frank.Mehnert@Sun.COM>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200901290905.10966.frank.mehnert@sun.com>
References: <200901290905.10966.frank.mehnert@sun.com>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 13:28:14 +0100
Message-Id: <1233232094.4495.45.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-29 at 09:05 +0100, Frank Mehnert wrote:
> Hi,
> 
> please could someone explain me under which circumstances a pagefault,
> either generated from kernel code or from userland code, can occur on
> pages which are pinned with get_user_pages()?
> 
> So far my understanding was that this can _never_ happen but I seems to
> be wrong. Under high memory pressure I get PFs on such pages raised from
> kernel code and the PFs are handled by do_swap_page(). When this happens,
> page_count is 3 but page_mapped() returns false.

Under memory pressure the page reclaim will first unmap the physical
page from the virtual address range, and then try to free it.

Obviously the freeing bit fails if you hold a reference to it, but the
unmap will work.

After that, userspace will have to (minor) fault the stuff back in.

Also, that same page-reclaim, or pdflush might decide to write out dirty
data, which will also result in (minor) faults when userspace will
re-dirty the pages.

Having a page reference will only avoid the physical page from getting
removed from its current mapping (and thereby also pins the mapping).

