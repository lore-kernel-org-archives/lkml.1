Return-Path: <linux-kernel-owner+w=401wt.eu-S964999AbXBEWfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964999AbXBEWfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 17:35:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965012AbXBEWfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 17:35:14 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36696 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964999AbXBEWfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 17:35:11 -0500
Date: Mon, 5 Feb 2007 14:35:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan <alan@lxorguk.ukuu.org.uk>
cc: David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
In-Reply-To: <20070205222123.16a51fe6@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0702051424020.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
 <20070205084523.GA21858@elte.hu> <1170682488.29759.795.camel@pmac.infradead.org>
 <20070205155627.GA8354@elte.hu> <1170692539.29759.856.camel@pmac.infradead.org>
 <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu>
 <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
 <1170710272.29759.894.camel@pmac.infradead.org>
 <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org>
 <1170711587.29759.909.camel@pmac.infradead.org>
 <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org>
 <20070205222123.16a51fe6@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Feb 2007, Alan wrote:
> 
> It works both ways. If I don't need to know that I must select SCSI then
> it turns on easily. If I want to turn SCSI off then it causes mayhem. Two
> sides of the same coin.

They are not really symmetric, though.

There's two big issues:

 - tuning things "on" is more likely to cause a working kernel.

   This is pretty fundamental. It's almost always simply more correct to 
   add features than remove them. At worst, it won't be used.

   This argues that you should have to "work less" to turn something on, 
   and in particular, you should need to _know_ less. To turn something 
   off, you not only need to know how to turn it off, you fundamentally 
   need to know something much bigger: you need to know that you 
   really don't need it in the first place.

   The interaction of CONFIG_ATA/CONFIG_SCSI is an example of the latter. 
   You really *do* need to know more to turn off SCSI - because you need 
   to know that the ATA layer depends on it.

   So in the absense of knowledge, turning things on is better.

 - A developer who really wants to turn things off, and knows enough that 
   that is actually safe, can really just do a "grep" for it. If you're 
   _extremely_ knowledgeable, you can do something like

	git grep 'select.*\<SCSI\>' -- '*onfig*'

   and that easily finds you the (currently single) place that turns on 
   SCSI (and yes, you can try it with I2C too, and try to recursively 
   figure out what it is that turns on I2C even though you *tried* to turn 
   it off. I2C - the option that just wouldn't die! ;)

So I agree that they are two facets of the same coin, but I claim that 
there's a huge reason why they are not mirror-images - there are often 
reasons to prefer one over the other.

That said: I really don't think "depends on" should just always be 
"select" either. There's a balance:

 - you use "depends on" when you can ask a simple question like "what kind 
   of machine do you have" or "do you want to support USB" or "do you have 
   SCSI devices". 

   But even then, you might end up having some devices that are 
   *technically* USB, but people don't think of them that way (for 
   example, some laptop add-ons are literally USB devices that are "built 
   into" the laptop - you might well decide to show those choices even if 
   somebody said "no USB", and if he then says "yeah, I have one of those 
   things", you just know he wasn't clueful enough, and you enable USB 
   behind his back _anyway_. Exact same thing as with SATA support)

 - you use "select" when the question more naturally went the other way 
   (because the infrastructure isn't obvious)

So they are two similar things, and which one to choose mainly depends on 
how you want to phrase the question - not on technical issues per se.

So neither is "wrong". They both have their downsides. 

		Linus
