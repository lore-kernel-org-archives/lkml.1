Return-Path: <linux-kernel-owner+w=401wt.eu-S1760878AbYA1NFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760878AbYA1NFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 08:05:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYA1NEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 08:04:55 -0500
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:50289 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155AbYA1NEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 08:04:54 -0500
Message-ID: <479DD2F3.6020209@rsk.demon.co.uk>
Date: Mon, 28 Jan 2008 13:04:51 +0000
From: richard kennedy <richard@rsk.demon.co.uk>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: bryan.wu@analog.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bryan Wu <cooloney.lkml@gmail.com>
Subject: Re: [rfc] exposing MMR's of on-chip peripherals for debugging purposes
References: <8bd0f97a0801280216x56d52028s2ea247dd969e85e2@mail.gmail.com>	 <1201516811.7547.46.camel@roc-laptop> <8bd0f97a0801280306k5dc4410eu208bc55f1975ceb8@mail.gmail.com>
In-Reply-To: <8bd0f97a0801280306k5dc4410eu208bc55f1975ceb8@mail.gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Jan 28, 2008 5:40 AM, Bryan Wu <bryan.wu@analog.com> wrote:
>> On Mon, 2008-01-28 at 05:16 -0500, Mike Frysinger wrote:
>>> the trouble is that this file currently weighs in at ~1.8 megs.  this
>>> is because it contains all the information for all Blackfin processors
>>> we support (which currently, is about ~23 variants).  it's only going
>>> to get bigger as we support more.  Bryan cringes at the thought of
>>> submitting it to LKML :).  so i'm fishing around for alternatives ...
>>> the code was originally developed against 2.6.21, so UIO was not a
>>> possibility.  i'm still not sure if it is ... i'd have to research it
>>> a bit more and play with things.
>> The main reason I am not willing to submit this to mainline is the file
>> size. It's almost the biggest file in the kernel source. And it will be
>> bigger and bigger when more and more new Blackfin processors supported
>> by Linux kernel.
> 
> a quick check of current git shows it is significantly larger than any other ;)
> 
>> My suggestion is:
>> Or more deeper thought:
>>  - we don't need all the MMR setup at the same time for debugging. for example, maybe for some developer, he/she only needs one driver MMR for debugging such as watchdog/usb/spi/i2c ....
> 
> splitting things up doesnt really address the original issue: there's
> a lot of info here to be kept in the kernel
> 
>>  - How about split the debug MMR table to each drivers or processors?
>>  - watchdog driver implements a debug FS interface for debugging watchdog MMR and other drivers implement their own things.
> 
> this had been mentioned before as a possibility but shot down.  you do
> not want to tie the creation of these debug files to anything as the
> prevents independent development of any other drivers/application that
> use the same peripheral.
> -mike

Hi Mike,
there is a lot of duplication in your file, but you could slim it down a
bit if thats the only objection.

for instance all the COUNTER element addresses have the same offsets
from CNT_CONFIG

CNT_IMASK    = CNT_CONFIG + 4
CNT_STATUS   = CNT_CONFIG + 8
CNT_COMMAND  = CNT_CONFIG + 12
CNT_DEBOUNCE = CNT_CONFIG + 16
CNT_COUNTER  = CNT_CONFIG + 20
CNT_MAX      = CNT_CONFIG + 24
CNT_MIN      = CNT_CONFIG + 28

so you could have a simple function to create all the COUNTER elements
from a given base address, then each variant only needs call that saving
you lots of LOC.

something like :-

make_counter_dir(top, base ) {
	parent = debugfs_create_dir("Counter", top);
	debugfs_create_x16("CNT_COMMAND", 0600, parent, base+12);
	debugfs_create_x16("CNT_CONFIG", 0600, parent, base);
	...
}

Hopefully all the other sections have similar levels of duplication, but
I haven't checked.

Cheers
Richard
