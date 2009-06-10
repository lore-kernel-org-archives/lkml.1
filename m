Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbZFJJHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbZFJJHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbZFJJHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:07:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:37340 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626AbZFJJHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:07:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,339,1241420400"; 
   d="scan'208";a="152642807"
Date: Wed, 10 Jun 2009 17:07:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [0/16] HWPOISON: Intro
Message-ID: <20090610090703.GF6597@localhost>
References: <20090603846.816684333@firstfloor.org> <20090609102014.GG14820@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609102014.GG14820@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 06:20:14PM +0800, Nick Piggin wrote:
> On Wed, Jun 03, 2009 at 08:46:31PM +0200, Andi Kleen wrote:
> > Also I thought a bit about the fsync() error scenario. It's really
> > a problem that can already happen even without hwpoison, e.g.
> > when a page is dropped at the wrong time.
> 
> No, the page will never be "dropped" like that except with
> this hwpoison. Errors, sure, might get dropped sometimes
> due to implementation bugs, but this is adding semantics that
> basically break fsync by-design.

You mean the non persistent EIO is undesirable?

In the other hand, sticky EIO that can only be explicitly cleared by
user can also be annoying. How about auto clearing the EIO bit when
the last active user closes the file?

> I really want to resolve the EIO issue because as I said, it
> is a user-abi issue and too many of those just get shoved
> through only for someone to care about fundamental breakage
> after some years.

Yup.

> You say that SIGKILL is overkill for such pages, but in fact
> this is exactly what you do with mapped pages anyway, so why
> not with other pages as well? I think it is perfectly fine to
> do so (and maybe a new error code can be introduced and that
> can be delivered to processes that can handle it rather than
> SIGKILL).

We can make it a user selectable policy.

They are different in that, mapped dirty pages are normally more vital
(data structures etc.) for correct execution, while write() operates
more often on normal data.

> Last request: do you have a panic-on-memory-error option?
> I think HA systems and ones with properly designed data
> integrity at the application layer will much prefer to
> halt the system than attempt ad-hoc recovery that does not
> always work and might screw things up worse.

Good suggestion. We'll consider such an option. But unconditionally
panic may be undesirable. For example, a corrupted free page or a
clean unmapped file page can be simply isolated - they won't impact
anything.

Thanks,
Fengguang
