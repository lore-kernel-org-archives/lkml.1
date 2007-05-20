Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbXETNKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbXETNKf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 09:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbXETNK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 09:10:28 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54008 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbXETNK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 09:10:27 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46504876.9040802@s5r6.in-berlin.de>
Date: Sun, 20 May 2007 15:09:10 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Simon Horman <horms@verge.net.au>, Adrian Bunk <bunk@stusta.de>
Subject: Re: RFC: kconfig select warnings bogus?
References: <20070519151523.GA26724@uranus.ravnborg.org>	 <20070519110944.2a52061e.akpm@linux-foundation.org>	 <a781481a0705191517n15eefe04i5458900c6ffe782d@mail.gmail.com>	 <a781481a0705191549h602d331flf93c9d6c0261458f@mail.gmail.com>	 <464F9A7B.1030708@s5r6.in-berlin.de>	 <a781481a0705191753r25e0cay82785ed56c04b6eb@mail.gmail.com>	 <a781481a0705191804u7f5a344cr92f2a1981c502bf7@mail.gmail.com>	 <4650074A.6000307@s5r6.in-berlin.de>	 <a781481a0705200438s634712e6v957d7085bca7407@mail.gmail.com>	 <46503542.50300@s5r6.in-berlin.de> <a781481a0705200457v70aae469n97be31fe55af4d91@mail.gmail.com>
In-Reply-To: <a781481a0705200457v70aae469n97be31fe55af4d91@mail.gmail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> I was only answering your *completely misplaced and
> incorrect* original comment against the patch where you claimed
> that the patch was "totally wrong" because of the way it removed
> the "select" ... etc ...

I believe I have explained why I labeled it as totally wrong.

> And remember, like I said already, the whole _idea_ is such arch-
> specific helper code be not mentioned from arch-agnostic Kconfig
> files. You may not like it, but this is the standard / most common way
> such cases are handled for tons of other cases in arch/...

The standard and maintainable way (for drivers at least) is

config A
	bool-or-tristate "option A"
	depends on !PLATFORM_X || HELPER_N_ON_PLATFORM_X

It is not a matter of me disliking something.  It's a matter of that we
can easily determine what A needs, but have a hard time to determine and
maintain the dependencies in the reverse way.

BTW, if A needs platform-specific helper N, then A is not
platform-agnostic.  If A is desired to be platform-agnostic, then either
A has to be implemented independently of N or N has to be made available
on all platforms.

> Which is why Adrian's way of solving this (shifting all such
> arch-specific helper symbols also to drivers/... and then using depends
> on select on it) is not viable.

I'm not advocating any specific fixes or pseudo-fixes.  I'm advocating
the notation of dependencies in the direction "A requires B".

Since you mention "select":  My opinion about the "select" dialect of
"depends on" is that the UIs should be improved and "select" should be
removed from the Kconfig language.  What do we "select"?  Typically we
"select" an option on which /n/ other options depend on but which itself
does depend on none or few options higher up.  The UIs could be able to
figure this out for themselves, or if necessary by a hint tacked onto
library-type options.  That is, instead of

	config A
		tristate "driver A"
		select L

	config B
		tristate "driver B"
		select L

	config L
		tristate "library L"

write

	config A
		tristate "driver A"
		depends on L

	config B
		tristate "driver B"
		depends on L

	config L
		tristate "library L"
		hint THIS_IS_A_LIBRARY

Now let UIs "make oldconfig", "make menuconfig", "make randconfig" deal
with the hint or ignore the hint --- according to the purpose and
usability requirements of the respective UI.  The "hint
THIS_IS_SOMETHING" isn't even necessary in many cases to detect roles of
options, because their position in the dependency graph is already
saying something about it.

These things really should be shifted into the UIs as much as possible,
because we can have a number of special-purpose UIs but we want
all-purpose Kconfig files.
-- 
Stefan Richter
-=====-=-=== -=-= =-=--
http://arcgraph.de/sr/
