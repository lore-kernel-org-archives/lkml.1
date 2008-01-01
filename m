Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbYAAWjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbYAAWjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 17:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbYAAWix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 17:38:53 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:39821 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbYAAWiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 17:38:52 -0500
Message-ID: <477AC02A.40108@keyaccess.nl>
Date: Tue, 01 Jan 2008 23:35:22 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       Rene Herman <rene.herman@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <4762C551.5070003@zytor.com>	<20071214210652.GB28793@elf.ucw.cz>	<4763001A.1070102@zytor.com>	<20071214232955.545ab809@the-village.bc.nu>	<20071215080831.404cdb32@tux.DEF.witbe.net>	<47638C8C.2090604@gmail.com>	<476438B4.2020600@zytor.com>	<476462BE.3030701@gmail.com>	<4764687D.6080609@zytor.com>	<476524DB.7020806@gmail.com>	<20071216152250.GA21245@elte.hu>	<4765D43E.1010800@gmail.com>	<4765D95C.4010404@zytor.com>	<4765DCB0.8030901@gmail.com>	<4765EE7F.80002@zytor.com>	<47667366.7010405@gmail.com>	<4766AE88.4080904@zytor.com>	<4766D175.7040807@reed.com>	<20071217212509.5edaa372@the-village.bc.nu>	<477A634C.8040000@reed.com> <20080101161557.3ce2d5f8@the-village.bc.nu> <477AAD7B.5040405@zytor.com> <477AB204.3070904@keyaccess.nl> <477AB433.5070506@zytor.com>
In-Reply-To: <477AB433.5070506@zytor.com>
Content-Type: multipart/mixed;
 boundary="------------080000030805000607030608"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080000030805000607030608
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 01-01-08 22:44, H. Peter Anvin wrote:

> Rene Herman wrote:
>> On 01-01-08 22:15, H. Peter Anvin wrote:
>>
>>> I have mentioned this before... I think writing zero to port 0xf0 
>>> would be an acceptable pause interface (to the extent where we need 
>>> an I/O port) except on 386 with 387 present; on those systems we can 
>>> fall back to 0x80.
>>
>> PII 400 / Intel 440 BX (PIIX4):
>>
>> rene@6bap:~/port80$ su -c ./portime
>> out 0x80: 544 cycles
>> in  0x80: 254 cycles
>> in  0x61: 254 cycles
>> out 0xf0: 544 cycles
>>
>> The Intel PIIX/PIIX3 datasheet specifically mentions that both reads 
>> and writes at 0xf0 "flow through to the ISA bus".
>>
>> However, more complete, it says:
>>
>> "Writing to this register causes the PIIX/PIIX3 to assert IGNNE#. The 
>> PIIX/PIIX3 also negates IRQ13 (internal to the PIIX). Note that IGNNE# 
>> is not asserted unless FERR# is active. Reads/writes flow through to 
>> the ISA bus".
>>
>> We don't want the side-effects, do we?
>>
> 
> Yes, we do.  It's exactly this side effect which makes this safer than 
> either 0x80 or 0xED -- it's a port that *guaranteed* can't be reclaimed 
> for other purposes without breaking MS-DOS compatibility.

I see that with CR0.NE set (*) we indeed don't care about IGNNE#...

However, I'm worried about this comment in arch/x86/kernel/i8259_32.c

===
/*
  * New motherboards sometimes make IRQ 13 be a PCI interrupt,
  * so allow interrupt sharing.
  */
===

Is it really safe to just blindly negate IRQ13 on everything out there, from 
regular PC through funky embedded thingies?

(*) bit 5:

rene@7ixe4:~/src/local$ ./smsw
msw: 0x3b

Rene.

--------------080000030805000607030608
Content-Type: text/plain;
 name="smsw.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="smsw.c"

/* gcc -W -Wall -o smsw smsw.c */

#include <stdio.h>
#include <stdint.h>

int main(void)
{
	uint16_t msw;

	asm ("smsw %0": "=r" (msw));
	printf("msw: %#hx\n", msw);
	return 0;
}

--------------080000030805000607030608--
