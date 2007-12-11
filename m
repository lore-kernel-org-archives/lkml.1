Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbXLKPbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbXLKPbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 10:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbXLKPa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 10:30:58 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:49731 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbXLKPa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 10:30:57 -0500
Message-ID: <475EACB8.7080608@keyaccess.nl>
Date: Tue, 11 Dec 2007 16:28:56 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Paul Rolland <rol@as2917.net>
CC: David Newall <david@davidnewall.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com>	<p733auekcly.fsf@bingen.suse.de>	<20071207160439.71b7f46a@the-village.bc.nu>	<20071209125458.GB4381@ucw.cz>	<20071209165908.GA15910@one.firstfloor.org>	<20071209212513.GC24284@elf.ucw.cz>	<475CBDD7.5050602@keyaccess.nl>	<m3bq8y23de.fsf@maximus.localdomain>	<475DE37F.20706@davidnewall.com>	<475DE6F4.80702@zytor.com>	<475DEB23.1000304@davidnewall.com>	<20071211084059.3d03e11d@tux.DEF.witbe.net>	<475E5D4B.8020101@keyaccess.nl>	<475E7DC2.4060509@davidnewall.com>	<475E8D91.20201@keyaccess.nl> <20071211143224.15900995@tux.DEF.witbe.net> <475E9B9B.2050709@keyaccess.nl>
In-Reply-To: <475E9B9B.2050709@keyaccess.nl>
Content-Type: multipart/mixed;
 boundary="------------060209040605000403070401"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060209040605000403070401
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 11-12-07 15:15, Rene Herman wrote:

> On 11-12-07 14:32, Paul Rolland wrote:
> 
>>> On 11-12-07 13:08, David Newall wrote:
>>>
>>>> Rene Herman wrote:
>>
>>> (*) some local testing shows it to be almost exactly that for both 
>>> out and in on my own PC -- a little over. If anyone cares, see 
>>> attached little test program. The "little over" I don't worry about. 
>>> 0 us delay is also fine for me and if any code was _that_ fragile it 
>>> would have broken long ago.
>>
>> Some results :
> 
> Okay, these vary to wildly for you and might I suppose be a serialising 
> artifact or some such. Give me a bit and I'll try to improve it...

This might be a bit more constant, I suppose. This serialises with cpuid. 
Don't see a difference locally, but perhaps you do.

On a Duron 1300 with an actual ISA bus, "out" is between 1300 and 1600 for 
me and "in" between 1200 and 1500 with a few flukes above that which will I 
suppose be caused by the bus (ISA _or_ PCI) being momentarily busy or some 
such...

Rene.

--------------060209040605000403070401
Content-Type: text/plain;
 name="port80.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="port80.c"

#include <stdlib.h>
#include <stdio.h>

#include <sys/io.h>

#define LOOPS 1000

unsigned long cycles[LOOPS];

int main(void)
{
	unsigned long overhead;
	unsigned long total;
	int i;

	if (iopl(3) < 0) {
		perror("iopl");
		return EXIT_FAILURE;
	}

	/* pull it in */
	for (i = 0; i < LOOPS; i++)
		cycles[i] = 0;

	asm volatile ("cli");
	for (i = 0; i < LOOPS; i++)
		asm (
			"xor	%%eax, %%eax	\n\t"
			"cpuid			\n\t"	
			"rdtsc			\n\t"
			"movl	%%eax, %%esi	\n\t"	
			"xor	%%eax, %%eax	\n\t"
			"cpuid			\n\t"
			"rdtsc			\n\t"
			"subl	%%esi, %%eax	\n\t"

			: "=a" (cycles[i]) : : "ecx", "edx", "ebx", "esi");
	asm volatile ("sti");

	overhead = 0;
	for (i = 0; i < LOOPS; i++)
		overhead += cycles[i];

	asm volatile ("cli");
	for (i = 0; i < LOOPS; i++)
		asm (
			"xor	%%eax, %%eax	\n\t"
			"cpuid			\n\t"	
			"rdtsc			\n\t"
			"movl	%%eax, %%esi	\n\t"	
			"outb	%%al, $0x80	\n\t"
			"xor	%%eax, %%eax	\n\t"
			"cpuid			\n\t"
			"rdtsc			\n\t"
			"subl	%%esi, %%eax	\n\t"

			: "=a" (cycles[i]) : : "ecx", "edx", "ebx", "esi");
	asm volatile ("sti");

	total = 0;
	for (i = 0; i < LOOPS; i++)
		total += cycles[i];
	total -= overhead;

	printf("out: %lu\n", total / LOOPS);

	asm volatile ("cli");
	for (i = 0; i < LOOPS; i++)
		asm (
			"xor	%%eax, %%eax	\n\t"
			"cpuid			\n\t"	
			"rdtsc			\n\t"
			"movl	%%eax, %%esi	\n\t"	
			"inb	$0x80, %%al	\n\t"
			"xor	%%eax, %%eax	\n\t"
			"cpuid			\n\t"
			"rdtsc			\n\t"
			"subl	%%esi, %%eax	\n\t"

			: "=a" (cycles[i]) : : "ecx", "edx", "ebx", "esi");
	asm volatile ("sti");

	total = 0;
	for (i = 0; i < LOOPS; i++)
		total += cycles[i];
	total -= overhead;

	printf("in : %lu\n", total / LOOPS);

	return EXIT_SUCCESS;
}

--------------060209040605000403070401--
