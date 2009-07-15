Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563AbZGOHGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbZGOHGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 03:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbZGOHGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 03:06:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:39444 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbZGOHGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 03:06:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,403,1243839600"; 
   d="scan'208";a="165141342"
Date: Wed, 15 Jul 2009 15:06:17 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Ronald Moesbergen <intercommit@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "Alan.Brunelle@hp.com" <Alan.Brunelle@hp.com>,
       "hifumi.hisashi@oss.ntt.co.jp" <hifumi.hisashi@oss.ntt.co.jp>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
Message-ID: <20090715070617.GB6145@localhost>
References: <a0272b440907062349k24041e74sbb1776ab3e172c58@mail.gmail.com> <4A5395FD.2040507@vlnb.net> <a0272b440907080149j3eeeb9bat13f942520db059a8@mail.gmail.com> <4A5493A8.2000806@vlnb.net> <a0272b440907092332o7c5bf1d0oa51d1cfc9b9e98f5@mail.gmail.com> <4A56FF32.2060303@vlnb.net> <4A570981.5080803@vlnb.net> <a0272b440907130512y60a757afqd5629f4ca3ac8e1b@mail.gmail.com> <20090713123621.GA31051@localhost> <4A5CD3EB.50402@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5CD3EB.50402@vlnb.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 02:52:27AM +0800, Vladislav Bolkhovitin wrote:
> 
> Wu Fengguang, on 07/13/2009 04:36 PM wrote:
> >> Test done with XFS on both the target and the initiator. This confirms
> >> your findings, using files instead of block devices is faster, but
> >> only when using the io_context patch.
> > 
> > It shows that the one really matters is the io_context patch,
> > even when context readahead is running. I guess what happened
> > in the tests are:
> > - without readahead (or readahead algorithm failed to do proper
> >   sequential readaheads), the SCST processes will be submitting
> >   small but close to each other IOs.  CFQ relies on the io_context
> >   patch to prevent unnecessary idling.
> > - with proper readahead, the SCST processes will also be submitting
> >   close readahead IOs. For example, one file's 100-102MB pages is
> >   readahead by process A, while its 102-104MB pages may be
> >   readahead by process B. In this case CFQ will also idle waiting
> >   for process A to submit the next IO, but in fact that IO is being
> >   submitted by process B. So the io_context patch is still necessary
> >   even when context readahead is working fine. I guess context
> >   readahead do have the added value of possibly enlarging the IO size
> >   (however this benchmark seems to not very sensitive to IO size).
> 
> Looks like the truth. Although with 2MB RA I expect CFQ to do idling >10 
> times less, which should bring bigger improvement than few %%.
> 
> For how long CFQ idles? For HZ/125, i.e. 8 ms with HZ 250?

Yes, 8ms by default. Note that the 8ms idle time is armed when the
last IO from current process completes. So it would be definitely a
waste if the cooperative process submitted the next read/readahead
IO within this 8ms idle window (without cfq_coop.patch).

Thanks,
Fengguang

