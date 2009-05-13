Return-Path: <linux-kernel-owner+w=401wt.eu-S1758923AbZEMLlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923AbZEMLlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 07:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758532AbZEMLlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 07:41:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58842 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759026AbZEMLlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 07:41:24 -0400
Date: Wed, 13 May 2009 13:46:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Tejun Heo <teheo@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jan Beulich <JBeulich@novell.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: remap allocator for per-CPU memory
Message-ID: <20090513114647.GQ19296@one.firstfloor.org>
References: <4A09B23B02000078000007F1@vpn.id2.novell.com> <4A09991E.9010903@kernel.org> <4A0A9C70.6090803@novell.com> <87vdo5l0u6.fsf@basil.nowhere.org> <4A0AAB6B.3090903@novell.com> <4A0AAF10.3030709@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0AAF10.3030709@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I couldn't find anything explicitly prohibiting PMD/PTE aliases w/
> different attributes although there are plenty of warnings and don'ts
> against giving different attributes to the same linear addresses.  At
> any rate, it definitely looks way too dangerous to depend on.

It is. We've had data corruption because of this in the past.
Worse it's very subtle data corruption, taking a long time
to track down. So yes it's definitely dangerous.
> 
> And, set_memory_*() is basically allowed on any memory allocated via
> get_free_page(), so... we're between rock and hard place.  Looks like

The x86-64 kernel has the text mapping alias which had similar problems.
That was avoided by special casing this.

> remapping partially using large pages is no go.

I'm not sure it was ever a good idea because most CPUs have much less
large TLB entries than small entries. 
(in some cases the difference is dramatic, a few older cores
only had something like 4 2/4MB entries) 
Unless it's really a lot of memory you're talking about here
it's probably better to use small pages for such specific
purposes.

The other issue is that with 1GB pages used in the direct mapping
the problem generally gets much worse. Although luckily it only
hits because there is some dumb kernel code which always forces
smaller pages for GB 0 and 4.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
