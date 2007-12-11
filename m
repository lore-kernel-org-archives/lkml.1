Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbXLKNSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbXLKNSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 08:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXLKNSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 08:18:30 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:47551 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbXLKNS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 08:18:29 -0500
Message-ID: <475E8D91.20201@keyaccess.nl>
Date: Tue, 11 Dec 2007 14:16:01 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: David Newall <david@davidnewall.com>
CC: Paul Rolland <rol@as2917.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com>	<p733auekcly.fsf@bingen.suse.de>	<20071207160439.71b7f46a@the-village.bc.nu>	<20071209125458.GB4381@ucw.cz>	<20071209165908.GA15910@one.firstfloor.org>	<20071209212513.GC24284@elf.ucw.cz>	<475CBDD7.5050602@keyaccess.nl>	<m3bq8y23de.fsf@maximus.localdomain>	<475DE37F.20706@davidnewall.com>	<475DE6F4.80702@zytor.com>	<475DEB23.1000304@davidnewall.com> <20071211084059.3d03e11d@tux.DEF.witbe.net> <475E5D4B.8020101@keyaccess.nl> <475E7DC2.4060509@davidnewall.com>
In-Reply-To: <475E7DC2.4060509@davidnewall.com>
Content-Type: multipart/mixed;
 boundary="------------070308090803060406050900"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070308090803060406050900
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 11-12-07 13:08, David Newall wrote:

> Rene Herman wrote:
>> On 11-12-07 08:40, Paul Rolland wrote:
>>
>>> Well, if the delay is so much unspecified, what about _reading_ port 
>>> 0x80 ?
>>> Will the delay be shorter ?
>>
>> The delay is completely and fully specified in terms of the ISA/LPC clock
> 
> That would be the delay on the i386 (sic) architecture.  In general, 
> though, the delay is:

This particular discussion isn't about anything in general but solely about 
the delay an outb_p gives you on x86 since what is under discussion is not 
using an output to port 0x80 on that platform to generate it.

> Thinking that _p gives a pause is perhaps too PC-centric. Why, if a delay
> is needed, wouldn't you use a real delay; one that says how long it
> should be?

Because any possible outb_p delay should be synced to the bus-clock, not to 
any wall-clock. Drivers that want to sync to wall-clock need to use an outb, 
delay pair as you'd expect.

In the real world, driver authors aren't perfect and will have used outb_p 
as a wall-clock delay which they have gotten away with since it's a nicely 
specified delay in terms of the ISA/LPC clock and the ISA/LPC clock being 
fairly (old) to very (new) constant.

The delay it gives is very close to 1 us on a spec ISA/LPC bus (*) and as 
such, even though it may not be the right thing to do from an theoretical 
standpoint, generally a udelay(1) is going to be a fine replacement from a 
practical one -- as soon as we _can_ use udelay(), as I also wrote.

Rene.

(*) some local testing shows it to be almost exactly that for both out and 
in on my own PC -- a little over. If anyone cares, see attached little test 
program. The "little over" I don't worry about. 0 us delay is also fine for 
me and if any code was _that_ fragile it would have broken long ago.

--------------070308090803060406050900
Content-Type: text/plain;
 name="port80.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="port80.c"

#include <stdlib.h>
#include <stdio.h>

#include <sys/io.h>

int main(void)
{
	unsigned long cycles;

	if (iopl(3) < 0) {
		perror("iopl");
		return EXIT_FAILURE;
	}

	asm (	"cli			\n\t"	
		"rdtsc			\n\t"
		"movl	%%eax, %%ecx	\n\t"	
		"outb	%%al, $0x80	\n\t"
		"rdtsc			\n\t"
		"subl	%%ecx, %%eax	\n\t"
		"sti			"			

		: "=a" (cycles) : : "ecx", "edx");

	printf("out = %lu\n", cycles);

	asm (	"cli			\n\t"	
		"rdtsc			\n\t"
		"movl	%%eax, %%ecx	\n\t"	
		"inb	$0x80, %%al	\n\t"
		"rdtsc			\n\t"
		"subl	%%ecx, %%eax	\n\t"
		"sti			"			

		: "=a" (cycles) : : "ecx", "edx");

	printf("in  = %lu\n", cycles);

	return EXIT_FAILURE;
}

--------------070308090803060406050900--
