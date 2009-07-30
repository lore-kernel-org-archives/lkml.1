Return-Path: <linux-kernel-owner+w=401wt.eu-S1753725AbZG3DTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbZG3DTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 23:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZG3DTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 23:19:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:13729 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbZG3DTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 23:19:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,292,1246863600"; 
   d="scan'208";a="170401097"
Date: Thu, 30 Jul 2009 11:19:27 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Martin Bligh <mbligh@google.com>
Cc: Chad Talbott <ctalbott@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Michael Rubin <mrubin@google.com>, Andrew Morton <akpm@google.com>,
       "sandeen@redhat.com" <sandeen@redhat.com>,
       Michael Davidson <md@google.com>
Subject: Re: Bug in kernel 2.6.31, Slow wb_kupdate writeout
Message-ID: <20090730031927.GA17669@localhost>
References: <1786ab030907281211x6e432ba6ha6afe9de73f24e0c@mail.gmail.com> <33307c790907281449k5e8d4f6cib2c93848f5ec2661@mail.gmail.com> <33307c790907290015m1e6b5666x9c0014cdaf5ed08@mail.gmail.com> <20090729114322.GA9335@localhost> <33307c790907291719r2caf7914xb543877464ba6fc2@mail.gmail.com> <33307c790907291828x6906e874l4d75e695116aa874@mail.gmail.com> <20090730020922.GD7326@localhost> <33307c790907291957n35c55afehfe809c6583b10a76@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <33307c790907291957n35c55afehfe809c6583b10a76@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 10:57:35AM +0800, Martin Bligh wrote:
> > On closer looks I found this line:
> >
> >                if (inode_dirtied_after(inode, start))
> >                        break;
> 
> Ah, OK.
> 
> > In this case "list_empty(&sb->s_io)" is not a good criteria:
> > here we are breaking away for some other reasons, and shall
> > not touch wbc.more_io.
> >
> > So let's stick with the current code?
> 
> Well, I see two problems. One is that we set more_io based on
> whether s_more_io is empty or not before we finish the loop.
> I can't see how this can be correct, especially as there can be
> other concurrent writers. So somehow we need to check when
> we exit the loop, not during it.

It is correct inside the loop, however with some overheads.

We put it inside the loop because sometimes the whole filesystem is
skipped and we shall not set more_io on them whether or not s_more_io
is empty.

> The other is that we're saying we are setting more_io when
> nr_to_write is <=0 ... but we only really check it when
> nr_to_write is > 0 ... I can't see how this can be useful?

That's the caller's fault - I guess the logic was changed a bit by
Jens in linux-next. I noticed this just now. It shall be fixed.

> I'll admit there is one corner case when page_skipped it set
> from one of the branches, but I am really not sure what the
> intended logic is here, given the above?
> 
> In the case where we hit the inode_dirtied_after break
> condition, is it bad to set more_io ? There is more to do
> on that inode after all. Is there a definition somewhere for
> exactly what the more_io flag means?

"More dirty pages to be put to io"?

The exact semantics of more_io is determined by the caller,
which used to be (in 2.6.31):

background_writeout():

                if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
                        /* Wrote less than expected */
                        if (wbc.encountered_congestion || wbc.more_io)
                                congestion_wait(BLK_RW_ASYNC, HZ/10);
                        else   
                                break;
                }

wb_kupdate() is same except that it does not check pages_skipped.

Note that in 2.6.31, more_io is not used at all for sync().

Thanks,
Fengguang
