Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbZKJMBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbZKJMBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 07:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbZKJMBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 07:01:43 -0500
Received: from web32605.mail.mud.yahoo.com ([68.142.207.232]:48694 "HELO
	web32605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750976AbZKJMBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 07:01:42 -0500
Message-ID: <707547.6272.qm@web32605.mail.mud.yahoo.com>
X-YMail-OSG: oFluw98VM1nBxYZRy3Hs8bVaVtS21mJIiAo8YUd2aca_HX2ieet61Y1QV7q.NJqA0gKNP3QkxZv4bbnXeOXKPnQAhxmrDk95Uuzat51FWDeGICt9N7pq2Onp3KY0Yql6D5zYaeG_URXkjoMjMuvU82gsNm791UtgF.dcFXDXXga3RbgCobslGxpfUXXv3d4w0HaCwZmWnnnsVxgJ2bqBBDvVTnbBQxk5yQbuCmjYNEdGUNq6f7rfBa_E791CyCLbCOZReuuABnbw.dAI0x8J8Wwzk4EkQG4TNss5tUhFhO_mHtQ0rbypCU6_QH2n0LvTvb1jKDtwxoRhb28uN_t1l0xATzUbxyIe5qw4vXt5
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/211.6 YahooMailWebService/0.7.361.4
References: <799070.68490.qm@web32608.mail.mud.yahoo.com> <1257780393.4108.343.camel@laptop> <20091110020858.GA5749@localhost>
Date: Tue, 10 Nov 2009 04:01:47 -0800 (PST)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: Likley stupid question on "throttle_vm_writeout"
To: Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20091110020858.GA5749@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Wu Fengguang <fengguang.wu@intel.com>
> To: Peter Zijlstra <peterz@infradead.org>
> Cc: Martin Knoblauch <spamtrap@knobisoft.de>; linux-kernel@vger.kernel.org
> Sent: Tue, November 10, 2009 3:08:58 AM
> Subject: Re: Likley stupid question on "throttle_vm_writeout"
> 
> On Mon, Nov 09, 2009 at 04:26:33PM +0100, Peter Zijlstra wrote:
> > On Mon, 2009-11-09 at 07:15 -0800, Martin Knoblauch wrote:
> > > Hi, (please CC me on replies)
> > > 
> > >  I have a likely stupid question on the function "throttle_vm_writeout". 
> Looking at the code I find:
> > > 
> > >                 if (global_page_state(NR_UNSTABLE_NFS) +
> > >                         global_page_state(NR_WRITEBACK) <= dirty_thresh)
> > >                                 break;
> > >                 congestion_wait(WRITE, HZ/10);
> > > 
> > > Shouldn't the NR_FILE_DIRTY pages be considered as well?
> > 
> > Ha, you just trod onto a piece of ugly I'd totally forgotten about ;-)
> > 
> > The intent of throttle_vm_writeout() is to limit the total pages in
> > writeout and to wait for them to go-away.
> 
> Like this:
> 
>         vmscan fast => large NR_WRITEBACK => throttle vmscan based on it
> 
> > Everybody hates the function, nobody managed to actually come up with
> > anything better.
> 
> btw, here is another reason to limit NR_WRITEBACK: I saw many
> throttle_vm_writeout() waits if there is no wait queue to limit
> NR_WRITEBACK (eg. NFS). In that case the (steadily) big NR_WRITEBACK
> is _not_ caused by fast vmscan..
> 

 That is exactely what made me look again into the code. My observation is that when doing something like:

dd if=/dev/zero of=fast-local-disk bs=1M count=15000

most of the "dirty" pages are in NR_FILE_DIRTY with some relatively small amount (10% or so) in NR_WRITEBACK. If I do:

dd if=/dev/zero of=some-nfs-mount bs=1M count=15000

NR_WRITEBACK almost immediatelly goes up to dirty_ratio, with NR_UNSTABLE_NFS small. Over time NR_UNSTABLE_NFS grows, but is always lower than NR_WRITEBACK (maybe 40/60).

 But don't ask what happens if I do both in parallel.... The local IO really slows to a crawl and sometimes the system just becomes very unresponsive. Have we heard that before? :-)

 Somehow I have the impression that NFS writeout is able to absolutely dominate the dirty pages to an extent that the system is unusable.

Cheers
Martin

