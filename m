Return-Path: <linux-kernel-owner+w=401wt.eu-S1757826AbYAZBPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826AbYAZBPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 20:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbYAZBO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 20:14:59 -0500
Received: from smtp.digitalpath.net ([65.164.104.14]:55150 "EHLO
	smtp.digitalpath.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbYAZBO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 20:14:57 -0500
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=digitalpath.net;
  b=Mibd0kqgR+egmgIw8hKwsrnZtw0jImz77vujO7lXKA6752UzZWVzMYLH09y6L4IOmG/rvK1UNE5+Ltpqx4aAGP8+r03YZufo3JT+Rn6QGFWtHNHtmGefte3tcnNnPPbx  ;
Message-ID: <2015.65.164.104.9.1201310097.squirrel@webmail.digitalpath.net>
Date: Fri, 25 Jan 2008 17:14:57 -0800 (PST)
Subject: Re: CS5536 mfgpt timer setup register hangs board
From: "Hasan Rashid" <hasan@digitalpath.net>
To: "Jordan Crouse" <jordan.crouse@amd.com>
Cc: "Hasan Rashid" <hasan@digitalpath.net>, linux-kernel@vger.kernel.org
Reply-To: hasan@digitalpath.net
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jordan,

Although, I am using TinyBios v.99 with MFGPT workaround disabled, and
upon a subsequent write I still run in to that system hang problem. To try
out that fix u mentioned, I thought I enable the workaround in the BIOS
and then apply the fix, It still hangs.

I am dumping this info from the module at load time, when setting up the
devive.

-------------------------------------------------
read 0 from: 6206
read 0 from: 620e
read 0 from: 6216
read 0 from: 621e
read 0 from: 6226
read 0 from: 622e
read 0 from: 6236
read 0 from: 623e
geode-mfgpt: MFGPT PCI device enabled
geode-mfgpt:  8 timers available.
geode-mfgpt:  Registered timer # 0
writting 306 to: 6206
[And then it hangs as if CS5536 is now mad]
-------------------------------------------------
I tried specifying a timer number, but the same behaviour with all.

In the code this is all I am doing
	/* Set up the timer */
	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP,
			  GEODEWDT_SCALE | (3 << 8) );
	geode_mfgpt_read(wdt_timer, MFGPT_REG_SETUP);

void
geode_mfgpt_write(int i, u16 r, u16 v)
{
	printk("writting %x to: %lx \n", v, (unsigned long)(mfgpt_iobase + (r +
(i * 8))));
	outl(v, (unsigned long)(mfgpt_iobase + (r + (i * 8))) );
}

u16
geode_mfgpt_read(int i, u16 r)
{
	u16 val;
	val = inl((unsigned long)mfgpt_iobase + (r + (i * 8)));
	printk("read %x from: %lx\n", val, (unsigned long)(mfgpt_iobase + (r + (i
* 8))) );
	return val;
}


Now, while experimenting, I set the Counter enable bit on the first write
and I don't touch the setup register again.

	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP,
			  GEODEWDT_SCALE | (3 << 8) | MFGPT_SETUP_CNTEN);

Before calling the above function, I set the reset event and initialized
CMP2 with 0x7530h. Therefore, on every "geode_ping" to the timer I only
re-write 0x0 in the Up Counter register. This works fine, except  the
reset event seems to get unhooked as the system never reboots as expected.

So, I figured its either that the event is unset or the counter gets
disabled. I tried setting the reset event on every ping but that didn't
solve the problem. Then I tried setting the Counter Enable bit
(MFGPT_SETUP_CNTEN), which as you might've guessed hung the system but,
interestingly though the system rebooted after 60 secs. That got me
thinking that it was the counter enable bit that gets unset.

Anyhow, that's where I am stuck. The Alix2c0 boards use AMD Geode LX700, I
looked in the databook to see if there are any GPIO registers that can be
used as an alternative to program a watchdog timer but I couldn't find
anything usable. And I can't think of anything different to try with the
MFGPTs.

Not sure, but does the kernel version make a difference in any of this? I
am using 2.4 I have yet to try this on 2.6?

> On 25/01/08 15:50 -0800, Hasan Rashid wrote:
>>
>> Hi,
>>
>> I have been working on a watchdog timer using the mfgpt on AMD Geode
>> CS5536. I initialize the setup register MFGPT0_SETUP (0x6206) with hex
>> value 0x306 (1100000110b). However, after this first initialization if I
>> ever read/write to the register it hangs the system.
>>
>> I have been through all the documentation, tried several different
>> methods
>> but all the efforts, frustratingly, to no avail.
>>
>> Does anyone have any idea as to why would this be? TIA!
>
> It looks like you are using TinyBIOS.  Make sure that if you are using
> v0.99
> that you do *not* enable the MFGPT workaround.  If you are using an older
> version, then you will need this patch:
>
> http://lkml.org/lkml/2008/1/23/372
>
> And enable mfgptfix on the command line.  There seems to be a problem with
> the MFGPT "workaround" that causes hangs exactly like you are seeing.
>
> Jordan
>
> --
> Jordan Crouse
> Systems Software Development Engineer
> Advanced Micro Devices, Inc.
>
>
>


-- 
Regards,
Hasan Rashid

