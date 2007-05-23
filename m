Return-Path: <linux-kernel-owner+w=401wt.eu-S1765061AbXEWSoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765061AbXEWSoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 14:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758026AbXEWSoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 14:44:24 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:59636 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757868AbXEWSoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 14:44:23 -0400
Message-ID: <46548ADB.60207@gmail.com>
Date: Wed, 23 May 2007 20:41:31 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] CDROM: replace jiffies busyloop with msleep
References: <1179829525.12708.118.camel@chaos>
In-Reply-To: <1179829525.12708.118.camel@chaos>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2007 12:25 PM, Thomas Gleixner wrote:

> From: Ingo Molnar <mingo@elte.hu>
> 
> The SJCD driver uses a jiffies busy loop. Replace it with msleep.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>

Okay, that's just waiting for a reset to complete, which seems perfectly 
fine with a sleeping loop like that, but...

I re-started working on a rewrite of the mitsumi legacy cdrom driver that 
Pekka Enberg and I have been doing this afternoon again and I ran into not 
being able to use sleeping loops there an hour ago!

The trouble there is that unless you poll the bloody thing like mad too much 
of the Q subchannels passes below you and you need a huge number of retries 
to get anything out of it. I noticed when I started adding audio bits that 
the driver took full seconds to complete some audio requests while the old 
driver was snappy in that regard. When I replaced our sleeping loop with a 
busy-wait same as the original the snappyness returned and moreover, reading 
the TOC from the CD went from something close to a minute to approximately a 
second. Thought that minute was just because I was dealing with an old junk 
1-speed drive...

Now, as said, this looks to be fine since it's just waiting for a reset to 
complete, but unless you have the hardware to actually test, be careful in 
there.

Or in fact, maybe even decide there's not much point. The current plan is to 
do mitsumi, sony and panasonic and then throw the rest away (that trio is 
special in so far that controllers for them are still available on a lot of 
old ISA soundcards). Or do you actually have the hardware?

Rene.
