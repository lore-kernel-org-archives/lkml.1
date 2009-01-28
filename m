Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbZA1WQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbZA1WQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842AbZA1WQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 17:16:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51042 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622AbZA1WQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 17:16:19 -0500
Message-ID: <4980D913.3000505@zytor.com>
Date: Wed, 28 Jan 2009 14:15:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] x86: do not expose CONFIG_BSWAP to userspace
References: <20090127222825.GA27097@elte.hu>	 <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>	 <1233106614.3256.6.camel@localhost.localdomain>	 <200901281337.52294.arnd@arndb.de>  <49809A65.2090501@kernel.org>	 <1233170532.6717.49.camel@brick>	 <alpine.LFD.2.00.0901281141510.3123@localhost.localdomain>	 <1233172994.6717.56.camel@brick>  <4980CD51.70601@zytor.com> <1233179884.6717.59.camel@brick>
In-Reply-To: <1233179884.6717.59.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> I'm afraid my knowledge of gcc compiler flags for various models is
> lacking, I used i486 as suggested, just wanted to make sure I understood
> you corectly.

You did, but I misremembered... instead of having the __i386__, 
__i486__, __i586__, __i686__ being an additive chain as would make 
sense, gcc just has __i386__ plus whichever corresponds to the -march= 
option.  I keep forgetting this because it's just so incredibly dumb.

Bloody hell.  This really f*cks thing up.

What's worse, they seem to simply be adding new options, so at this 
point you'd actually need something like:

# if defined(__i486__) || defined(__i586__) || defined(__i686__) || \
	defined(__core2__) || defined(__k8__) || defined(__amdfam10__)

Worse, there isn't any kind of macro that can be used to compare for a 
negative (i.e. not i386).

This obviously is screaming to be abstracted away into a header of its 
own, but it really can't be done cleanly as far as I can tell because of 
this particular piece of major gcc braindamage.

So, one ends up doing something like:

#ifdef __i486__
# define __CPU_HAVE_BSWAP
#endif
#ifdef __i586__
# define __CPU_HAVE_BSWAP
#endif

... and so on, and have to keep this up to date with the latest 
inventions of the gcc people.  *Sob.*

	-hpa

	-hpa

