Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbYAYOJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbYAYOJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 09:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbYAYOIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 09:08:54 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:4572 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbYAYOIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 09:08:53 -0500
Date: Fri, 25 Jan 2008 15:07:14 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
In-Reply-To: <1201142334.6383.40.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0801251349120.17507@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 23 Jan 2008, john stultz wrote:

> This difference in calculation was causing the clocksource correction
> code to apply a correction factor to the clocksource so the two
> intervals were the same, however this results in the actual frequency of
> the clocksource to be made incorrect. I believe this difference would
> affect all clocksources, although to differing degrees depending on the
> clocksource resolution.

Let's look at why the correction is done in first place. The update steps 
don't add up precisely to 1sec (LATCH*HZ != CLOCK_TICK_RATE), so a small 
addjustment is used to make up for it. The problem here is that if the 
update frequency changes, the addjustment isn't correct anymore.
The simple fix is to just omit the addjustment in these cases in ntp.c:

#if NTP_INTERVAL_FREQ == HZ
...
#else
#define CLOCK_TICK_ADJUST	0
#endif

bye, Roman
