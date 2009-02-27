Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbZB0F6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbZB0F6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 00:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbZB0F6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 00:58:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:34028 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbZB0F6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 00:58:37 -0500
Message-ID: <49A780E0.7020508@kernel.org>
Date: Fri, 27 Feb 2009 14:57:52 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, jeremy@goop.org, cpw@sgi.com
Subject: Re: [patch] x86: optimize __pa() to be linear again on 64-bit x86
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <20090223101741.GP9582@elte.hu> <20090223133804.GA20468@elte.hu> <200902240108.54892.nickpiggin@yahoo.com.au> <20090223145358.GB3377@elte.hu>
In-Reply-To: <20090223145358.GB3377@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 27 Feb 2009 05:57:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Ingo Molnar wrote:
> Yeah, we can do this complete conversion.
>
> I'll clean it up some more. I think the best representation of 
> this will be via a virt_to_sym() and sym_to_virt() space. That 
> makes it really clear when we are moving from the symbol space 
> to the linear space and back.

For arch code, maybe it's maintainable but with my driver developer
hat on I gotta say virt_to_page() not working on .data/.bss is quite
scary.  We can try to convert whatever which could be affected but

* They aren't clear at all not only when the code is being written but
  also when someone tries to use the code which can be buried several
  layers under.

* The failure cases can be hidden very well so that they can pass most
  tests unnoticed.  For example, buffer reserved for exception cases
  allocated statically which is usually used by PIO (no problem) but
  on a few selected controllers DMA is used.

* The failure mode is unobvious and very nasty.  With the debug code
  left out, the failure simply is mistranslated address or page
  pointer.  We might end up feeding the wrong address to controllers.
  The addresses are likely to be invalid but we really have no idea
  how the controllers would react.  If it ever happens, it's gonna be
  nasty.

* There isn't any point in trying to save a few cycles when we're deep
  in the IO path.  The cost simply is negligible compared to all the
  stuff necessary for programing devices.

So, I really think we should do what Nick suggested.  Make a fast
version and use it where the saved few cycles actually matter.  A
postfix which is more descriptive than _fast would be better tho.

Thanks.

-- 
tejun
