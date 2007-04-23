Return-Path: <linux-kernel-owner+w=401wt.eu-S1161029AbXDWRXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161029AbXDWRXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 13:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161001AbXDWRXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 13:23:40 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37758 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161029AbXDWRXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 13:23:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Chuck Ebbert <cebbert@redhat.com>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem mappings
References: <20070414204154.871250608@goop.org>
	<200704192250.52633.ak@suse.de> <4627D756.5020405@zytor.com>
	<200704192304.01053.ak@suse.de> <4627DB0C.2010804@zytor.com>
	<4627DDAD.4070805@redhat.com> <4627E099.209@goop.org>
	<m1d51vxxm4.fsf@ebiederm.dsl.xmission.com> <462CE027.4030302@goop.org>
	<462CE1E0.9060007@zytor.com>
Date: Mon, 23 Apr 2007 11:21:12 -0600
In-Reply-To: <462CE1E0.9060007@zytor.com> (H. Peter Anvin's message of "Mon,
	23 Apr 2007 09:42:08 -0700")
Message-ID: <m1zm4zvwfr.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Since we allocate the maximum possible memory statically, I fail to see how
> holes could make the situation any worse, or better.

Consider a memory hole of size 8M immediately after our bootmem bitmap.
head.S which knows nothing of holes will map the pages of the hole
into the initial page tables assuming that is where the page tables
will live.

alloc_bootmem_low_pages which understands holes will skip those pages
and return a higher address, which is outside of our initial mapping
of pages.

As for how to fix this, we need to call boot_ioremap or better
bt_ioremap on the address returned from alloc_bootmem_pages_low to
force the allocated page into the page table.  After we have setup
the page table page we can call unmap the page to free up the scarce
early mapping resource.

Eric
