Return-Path: <linux-kernel-owner+w=401wt.eu-S1751914AbZKJGzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbZKJGzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 01:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbZKJGzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 01:55:23 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51856 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbZKJGzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 01:55:21 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: Likley stupid question on "throttle_vm_writeout"
Cc: kosaki.motohiro@jp.fujitsu.com, Peter Zijlstra <peterz@infradead.org>,
       Martin Knoblauch <spamtrap@knobisoft.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20091110020858.GA5749@localhost>
References: <1257780393.4108.343.camel@laptop> <20091110020858.GA5749@localhost>
Message-Id: <20091110154929.3618.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 10 Nov 2009 15:55:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Nov 09, 2009 at 04:26:33PM +0100, Peter Zijlstra wrote:
> > On Mon, 2009-11-09 at 07:15 -0800, Martin Knoblauch wrote:
> > > Hi, (please CC me on replies)
> > > 
> > >  I have a likely stupid question on the function "throttle_vm_writeout". Looking at the code I find:
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

btw, this explanation point out why we should remove other bare congestion_wait()
in reclaim path.
At least, I observed the congestion_wait() in do_try_to_free_pages() decrease
reclaim performance very much.




