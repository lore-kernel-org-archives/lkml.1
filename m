Return-Path: <linux-kernel-owner+w=401wt.eu-S1758203AbYBSGVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbYBSGVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 01:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbYBSGVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 01:21:12 -0500
Received: from n21.bullet.mail.mud.yahoo.com ([68.142.200.112]:34461 "HELO
	n21.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753178AbYBSGVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 01:21:11 -0500
X-Yahoo-Newman-Id: 996939.7507.bm@omp402.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=b0x1tGRYiy8voH4Xt/E8LvTo1BTjh0UPtqLst9c0mUWf7IPqCcwt3uWei5xo+JHZmAMr9H1SyyGU0ExKwLxcJ8QfGcb58zrE805vtc/dCdZzv33wZ5FUJ9kKH/Wq5EI/Q6WRxX7MwTbR07OiNiLMHUCS6Px18L5Qt9tcOoEli78=  ;
X-YMail-OSG: I8N09nwVM1kCJnrau7us8wJoJMnHONeb4.q20z_tFVQaeky5IN1.tp76o.3_BpC3G0rBON8Ipg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 1/3] Fix Unlikely(x) == y
Date: Tue, 19 Feb 2008 17:20:48 +1100
User-Agent: KMail/1.9.5
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       Roel Kluin <12o3l@tiscali.nl>, geoffrey.levand@am.sony.com,
       linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       lkml <linux-kernel@vger.kernel.org>
References: <47B70A61.9030306@tiscali.nl> <200802191333.53607.nickpiggin@yahoo.com.au> <20080219055806.GA8404@1wt.eu>
In-Reply-To: <20080219055806.GA8404@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802191720.49210.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008 16:58, Willy Tarreau wrote:
> On Tue, Feb 19, 2008 at 01:33:53PM +1100, Nick Piggin wrote:
> > > Note in particular the last predictors; assuming branch ending
> > > with goto, including call, causing early function return or
> > > returning negative constant are not taken. Just these alone
> > > are likely 95+% of the unlikelies in the kernel.
> >
> > Yes, gcc should be able to do pretty good heuristics, considering
> > the quite good numbers that cold CPU predictors can attain. However
> > for really performance critical code (or really "never" executed
> > code), then I think it is OK to have the hints and not have to rely
> > on gcc heuristics.
>
> in my experience, the real problem is that gcc does what *it* wants and not
> what *you* want. I've been annoyed a lot by the way it coded some loops
> that could really be blazingly fast, but which resulted in a ton of
> branches due to its predictors. And using unlikely() there was a real mess,
> because instead of just hinting the compiler with probabilities to write
> some linear code for the *most* common case, it ended up with awful
> branches everywhere with code sent far away and even duplicated for some
> branches.
>
> Sometimes, for performance critical paths, I would like gcc to be dumb and
> follow *my* code and not its hard-coded probabilities. For instance, in a
> tree traversal, you really know how you want to build your loop. And these
> days, it seems like the single method of getting it your way is doing asm,
> which obviously is not portable :-(

Probably all true.


> Maybe one thing we would need would be the ability to assign probabilities
> to each branch based on what we expect, so that gcc could build a better
> tree keeping most frequently used code tight.

I don't know if that would *directly* lead to gcc being smarter. I
think perhaps they probably don't benchmark on code bases that have
much explicit annotation (I'm sure they wouldn't seriously benchmark
any parts of Linux as part of daily development). I think the key is
to continue to use annotations _properly_, and eventually gcc should
go in the right direction if enough code uses it.

And if you have really good examples like it sounds like above, then
I guess that should be reported to gcc?

