Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbZHEWex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbZHEWex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 18:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbZHEWev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 18:34:51 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:32985 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416AbZHEWet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 18:34:49 -0400
Message-ID: <4A7A08FE.5000909@mnementh.co.uk>
Date: Wed, 05 Aug 2009 23:34:38 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Magnus Damm <magnus.damm@gmail.com>,
       pHilipp Zabel <philipp.zabel@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Subject: Re: MMC: Make the configuration memory resource optional
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>  <aec7e5c30907290608i43a80fe1xe4ef0f3847855709@mail.gmail.com>  <4A7053E8.8050303@mnementh.co.uk>  <20090729201702.GA28202@linux-sh.org>  <74d0deb30907291355n39df7db0v1d7afc93917adc14@mail.gmail.com>  <4A716F1C.2050805@mnementh.co.uk>  <Pine.LNX.4.64.0907301246330.4462@axis700.grange>  <4A71F2A5.4060206@mnementh.co.uk>  <aec7e5c30908021952j7947b513w7d62f2c4d87bd3c5@mail.gmail.com>  <4A787C2C.5070000@mnementh.co.uk> <aec7e5c30908041908p568f413albef7dede3fd2cb83@mail.gmail.com> <4A798A4B.4000901@mnementh.co.uk> <Pine.LNX.4.64.0908051702180.5802@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0908051702180.5802@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:

> How do we verify this? Do I need some "very fast" card, so that sd would 
> try to drive the clock beyond pdata->hclk / 2, which should then fail? 

One way would be a 'scope on the card pins, but since you havent said I 
am assuming you have not altered the clock-speed setting routine.

Here you can see why I didnt like the silently-drop-conf-accesses 
version of the patch.  If you had not made conf area accesses silently 
succeed, you'd have found one lurking in the set_clock function.

Since your controller has no CNF area, it was discarding the write to 
the 1:1 clock bit (that isnt  in its none-existant conf area) and thus 
you got the next lowest clock as a result (/2)

> Currently I'm using 24MHz (copied from the original driver), and the only 
> thing I know about the controller is its "Maximum operating frequency: 25 
> MHz."

Thats the HCLK frequency, not the card clock.

the TMIO MFD devices can divide this HCLK by anything from 512 to 2, and 
  MFD devices have a facility to disable the divider, yielding full HCLK 
speed as the card clock.

If you havent already found a 1:1 clock enable bit on your device, you 
might try looking for it - it'd yield a near linear factor-of-two speed 
increase.

-Ian
