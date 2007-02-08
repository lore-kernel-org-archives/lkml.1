Return-Path: <linux-kernel-owner+w=401wt.eu-S1423431AbXBHWUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423431AbXBHWUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 17:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423433AbXBHWUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 17:20:24 -0500
Received: from 1wt.eu ([62.212.114.60]:2294 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423431AbXBHWUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 17:20:23 -0500
Date: Thu, 8 Feb 2007 23:19:59 +0100
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?iso-8859-1?B?Si5BLiBNYWdhbGzDs24=?= <jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
Message-ID: <20070208221959.GI24090@1wt.eu>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org> <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr> <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org> <20070208221317.5beedaeb@werewolf-wl> <Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org> <Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 02:03:06PM -0800, Linus Torvalds wrote:
> 
> 
> On Thu, 8 Feb 2007, Linus Torvalds wrote:
> > 
> > But THE CALLER CANNOT AND MUST NOT CARE! Because the sign of "char" is 
> > implementation-defined, so if you call "strcmp()", you are already 
> > basically saying: I don't care (and I _cannot_ care) what sign you are 
> > using.
> 
> Let me explain it another way.
> 
> Say you use
> 
> 	signed char *myname, *yourname;
> 
> 	if (strcmp(myname,yourname) < 0)
> 		printf("Ha, I win!\n")
> 
> and you compile this on an architecture where "char" is signed even 
> without the explicit "signed".
> 
> What should happen?
> 
> Should you get a warning? The types really *are* the same, so getting a 
> warning sounds obviously insane. But on the other hand, if you really care 
> about the sign that strcmp() uses internally, the code is wrong *anyway*, 
> because with another compiler, or with the *same* compiler on another 
> architecture or some other compiler flags, the very same code is buggy.
> 
> In other words, either you should get a warning *regardless* of whether 
> the sign actually matches or not, or you shouldn't get a warning at all 
> for the above code. Either it's buggy code, or it isn't.
> 
> Warning only when the sign doesn't _happen_ to match is crap. In that 
> case, it's not a warning about bad code, it's a warning about a bad 
> *compiler*.
> 
> My suggestion is that if you *really* care about the sign so much that you 
> want the sign warning, make it really obvious to the compiler. Don't ever 
> call functions that have implicit signs. Make even "int" arguments (which 
> is well-defined in its sign) use "signed int", and then you can make the 
> compiler warn if anybody ever passes it an "unsigned int".
> 
> Never mind even a pointer - if somebody actually took the time and effort 
> to spell out "signed int" in a function prototype, and you pass that 
> function an unsigned integer, maybe a warning is perfectly fine. Clearly 
> the programmer really cared, and if he didn't care about the sign that 
> much, he could have used just "int".
> 
> Conversely, if somebody has a function with a "unsigned int" prototype, 
> and you pass it a regular "int", a compiler shouldn't complain, because an 
> "int" will just silently promote to unsigned. But perhaps the programmer 
> passes it something that he had _explicitly_ marked with "signed int". 
> Would it make sense to warn then? Makes sense to me.
> 
> And no, none of this is about "strict C standards". All of it is about 
> "what makes sense". It simply doesn't make sense to complain about the 
> sign of "char", because it's not something that has a very hard 
> definition. Similarly, you shouldn't complain about regular "int" 
> conversions, because they are normal, and the standard defines them, but 
> maybe you can take a hint when the programmer gives you a hint by doing 
> something that is "obviously unnecessary", like explicitly saying that 
> "signed int" thing.
> 
> Just an idea. 
>
> 			Linus

I perfectly agree with your analysis here. I'm used to specify "signed"
or "unsigned" when I really expect such a sign, whether it's an int or
char, and because of this, I've spent a lot of time stuffing useless
casts everywhere to shut stupid warning with common functions such as
strcmp(), or even my functions when I don't care about the sign. IOW,
the compiler's excessive warnings discourage you from being strict on
your types. That could be called "funny" if it did not make us waste
so much time.

I would really like to get the "I don't care" possibility by default.

Willy

