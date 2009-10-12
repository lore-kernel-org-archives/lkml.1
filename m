Return-Path: <linux-kernel-owner+w=401wt.eu-S932815AbZJLRpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815AbZJLRpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932420AbZJLRpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:45:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932406AbZJLRpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:45:10 -0400
Date: Mon, 12 Oct 2009 10:43:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] panic.c: export panic_on_oops
In-Reply-To: <1255368557.27022.226.camel@localhost>
Message-ID: <alpine.LFD.2.01.0910121036330.3438@localhost.localdomain>
References: <1255241458-11665-1-git-send-email-dedekind1@gmail.com>  <20091012111545.GB8857@elte.hu> <1255346731.9659.31.camel@localhost>  <20091012113758.GB11035@elte.hu>  <20091012140149.6789efab@marrow.netinsight.se>  <20091012120951.GA16799@elte.hu> 
 <1255349748.10605.13.camel@macbook.infradead.org>  <20091012122023.GA19365@elte.hu>  <20091012150650.51a4b4dc@marrow.netinsight.se>  <20091012131528.GC25464@elte.hu>  <20091012153937.0dcd73e5@marrow.netinsight.se>  <alpine.LFD.2.01.0910120828390.3438@localhost.localdomain>
  <alpine.LFD.2.01.0910120837030.3438@localhost.localdomain> <1255368557.27022.226.camel@localhost>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Oct 2009, Artem Bityutskiy wrote:
> 
> But mtdoops tries to solves the following problem. What if we are
> oopsing in an interrupt, which interrupted the mtd driver, so we have
> all the locks held, and the mtd driver is in a unexpected stage ATM? Or
> what if we are oopsing in the mtd driver, or in something which was
> called by the MTD driver.?

Well, quite frankly, if you have an oops while holding a spinlock, then 
the machine is dead _anyway_. 

So what I would suggest is to just ignore the above problem. No amount of 
workqueue logic will help it - if the oops happened while an interrupt 
held a critical mtd lock, that lock will _never_ be released, so exactly 
what would be helped?

Now, I realize that _if_ you treat mtdoops as a 'console' layer, then you 
need to do that crazy thing, because you still want the oops to print out 
to the other consoles, and you're only getting data one line at a time. 
But since that was the wrong thing to do for a lot of other reasons 
anyway, that's not a very good argument.

Once you do the final flush in a controlled place _after_ you've printed 
out all the oops information, you simply don't care about locks any more. 
Because if you were holding critical locks, you're done anyway.

Sure, maybe you want to do a "trylock()" and skip the oops flush entirely 
in the mtd layer if you can't do it, but it's the "let's use a workqueue" 
or something that doesn't seem to make a lot of sense to me.

			Linus
