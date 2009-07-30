Return-Path: <linux-kernel-owner+w=401wt.eu-S1751139AbZG3BtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139AbZG3BtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 21:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbZG3BtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 21:49:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:55417 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbZG3BtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 21:49:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,291,1246863600"; 
   d="scan'208";a="170380126"
Date: Thu, 30 Jul 2009 09:49:17 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Martin Bligh <mbligh@google.com>
Cc: Chad Talbott <ctalbott@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Michael Rubin <mrubin@google.com>, Andrew Morton <akpm@google.com>,
       "sandeen@redhat.com" <sandeen@redhat.com>,
       Michael Davidson <md@google.com>
Subject: Re: Bug in kernel 2.6.31, Slow wb_kupdate writeout
Message-ID: <20090730014917.GB7326@localhost>
References: <1786ab030907281211x6e432ba6ha6afe9de73f24e0c@mail.gmail.com> <33307c790907281449k5e8d4f6cib2c93848f5ec2661@mail.gmail.com> <33307c790907290015m1e6b5666x9c0014cdaf5ed08@mail.gmail.com> <20090729114322.GA9335@localhost> <33307c790907291719r2caf7914xb543877464ba6fc2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33307c790907291719r2caf7914xb543877464ba6fc2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 08:19:34AM +0800, Martin Bligh wrote:
> BTW, can you explain this code at the bottom of generic_sync_sb_inodes
> for me?
> 
>                 if (wbc->nr_to_write <= 0) {
>                         wbc->more_io = 1;
>                         break;
>                 }
> 
> I don't understand why we are setting more_io here? AFAICS, more_io
> means there's more stuff to write ... I would think we'd set this if
> nr_to_write was > 0 ?

That's true: wbc.nr_to_write will always be set to MAX_WRITEBACK_PAGES
by wb_writeback() before entering generic_sync_sb_inodes().

So wbc.nr_to_write <=0 indicates we are interrupted by the quota and
should revisit generic_sync_sb_inodes() to check for more io (which will
_normally_ find more dirty pages to write).

> Or just have the section below brought up above this
> break check and do:
> 
> if (!list_empty(&sb->s_more_io) || !list_empty(&sb->s_io))
>         wbc->more_io = 1;
> 
> Am I just misunderstanding the intent of more_io ?

It should be OK. I agree on the change if it makes the logic more
straightforward.

Thanks,
Fengguang
