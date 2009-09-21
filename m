Return-Path: <linux-kernel-owner+w=401wt.eu-S1755007AbZIULHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbZIULHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 07:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbZIULH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 07:07:28 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:14857 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754179AbZIULHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 07:07:24 -0400
X-Trace: 261234743/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.63.13/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.63.13
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUFAHT7tkpQKT8N/2dsb2JhbACBU85AhBsF
X-IronPort-AV: E=Sophos;i="4.44,424,1249254000"; 
   d="scan'208";a="261234743"
Date: Mon, 21 Sep 2009 12:07:24 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: ngupta@vflare.org, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, linux-mm-cc <linux-mm-cc@laptop.org>,
       kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp
Subject: Re: [PATCH 2/4] send callback when swap slot is freed
In-Reply-To: <4AB487FD.5060207@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0909211149360.32504@sister.anvils>
References: <1253227412-24342-1-git-send-email-ngupta@vflare.org> 
 <1253227412-24342-3-git-send-email-ngupta@vflare.org> 
 <1253256805.4959.8.camel@penberg-laptop>  <Pine.LNX.4.64.0909180809290.2882@sister.anvils>
  <1253260528.4959.13.camel@penberg-laptop>  <Pine.LNX.4.64.0909180857170.5404@sister.anvils>
 <1253266391.4959.15.camel@penberg-laptop> <4AB3A16B.90009@vflare.org>
 <4AB487FD.5060207@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Sep 2009, Pekka Enberg wrote:
> Nitin Gupta wrote:
> > It is understood that this swap notify callback is bit of a hack. I think
> > we will not gain much trying to beautify this hack. However, I agree with
> > Hugh's suggestion to rename this notify callback related function/variables
> > to make it explicit that its completely ramzswap related. I will send a path
> > that affects these renames as reply to patch 0/4.
> 
> I don't quite agree and do think that my approach is a better long-term
> solution. That said, it's Hugh's call, not mine. Hugh?

Sorry, Pekka, I do prefer Nitin's more explicit hackery.

Yours of course looks nicer: but again this method is actually just
for the one single use, and it is "exporting" the swap_info_struct to
the block device, whereas I'd prefer to move in the opposite direction,
making that struct internal to swapfile.c.  (I'd have done so already,
but noticed TuxOnIce making use of it, and don't want to make life
awkward there.)

Is the main basis for your disgust at the way that Nitin installs the
callback, that loop down the swap_info_structs?  I should point out
that it was I who imposed that on Nitin: before that he was passing a
swap entry (or was it a swap type extracted from a swap entry?
I forget), which was the sole reference to a swp_entry_t in his
driver - I advised a bdev interface.

Would a compromise be to extend the #ifdef CONFIG_HIBERNATION around
swap_type_of() to cover ramzswap too, then Nitin use swap_type_of()
on his bdev to get a swap type to use to install the notifier?

I'm not saying that would be better, haven't even thought through
if it works: I'm just looking for a compromise, whereby you and I
don't keep sending Nitin scurrying off in opposite directions.

Hugh
