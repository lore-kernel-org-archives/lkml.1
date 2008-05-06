Return-Path: <linux-kernel-owner+w=401wt.eu-S932735AbYEFUsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735AbYEFUsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933083AbYEFUsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:48:14 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55205 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933059AbYEFUsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:48:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4820C3D8.6040403@s5r6.in-berlin.de>
Date: Tue, 06 May 2008 22:47:20 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Alistair John Strachan <alistair@devzero.co.uk>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc1
References: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org>	<20080504160904.GF19717@sgi.com>	<Pine.LNX.4.64.0805051656180.3218@bombadil.infradead.org>	<200805060902.25835.alistair@devzero.co.uk>	<20080506073134.424780a3@gaivota>	<48206C73.80509@s5r6.in-berlin.de>	<20080506161346.183f367c@gaivota>	<4820B524.5080100@s5r6.in-berlin.de> <20080506170623.53732e78@gaivota>
In-Reply-To: <20080506170623.53732e78@gaivota>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> For example, if you have a em28xx device with msp3400 and tvp5150 and another
> em28xx device with saa7113.
> 
> If you remove the select's for MSP3400, TVP5150 and SAA7113, at, em28xx, the
> module will compile without problems.
> 
> The only issue is that you won't be able to see any images (due to the lack of
> tvp5150 or saa7113 analog TV demoduler) or listen to the audio, if the device
> needs msp3400 to decode audio.
[...]
> It is much better for the user to just select EM28XX and let the Kconfig do the
> hard work of selecting what low-level driver applies for em28xx-based devices.
> 
> This causes lots of select, being very hard to maintain. The better would be to
> have a select-like clause that could check the dependencies automatically.
> 
> Another alternative would be some sort of script (checkpatch.pl?) that would
> check if all selected dependencies are ok.

Ah, now I understand.  You use "select" to enable options which aren't 
actually a build requirement for the selecting option.

Another example where "select" is used to fill a gap left by limitations 
regarding what can be presented in the "make ...config" UIs.  If you use 
"select" this way, well, then you have to cope with the implications.


Another workaround for this UI limitation:

config VIDEO_EM28XX
	tristate "Empia EM2800/2820/2840 USB video capture support"
	depends on WHATEVER_BUILD_REQUIREMENT_IS_LEFT
	select MAYBE_ANOTHER_BUILD_REQUIREMENT
	help
	  ...

comment "Empia EM28xx devices may require Philips SAA7113/4/5 video 
decoders"
	depends on VIDEO_EM28XX && VIDEO_SAA711X=n

comment "Empia EM28xx devices may require Texas Instruments TVP5150 
video decoder"
	depends on VIDEO_EM28XX && VIDEO_TVP5150=n

Still awkward, but now you don't have to copy VIDEO_SAA711X's and 
VIDEO_TVP5150's dependencies to VIDEO_EM28XX anymore.


Or another idea:

Copy _all_ dependencies of drivers which can be selected by "...if 
VIDEO_HELPER_CHIPS_AUTO" to VIDEO_HELPER_CHIPS_AUTO.

Of course all these issues go away as soon as somebody has implemented 
"select" with recursive dependency check.
-- 
Stefan Richter
-=====-==--- -=-= --==-
http://arcgraph.de/sr/
