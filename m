Return-Path: <linux-kernel-owner+w=401wt.eu-S1756479AbYBHVJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbYBHVJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYBHVJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:09:00 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43619 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752454AbYBHVI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:08:58 -0500
Date: Fri, 8 Feb 2008 22:09:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Message-ID: <20080208210905.GB12923@elf.ucw.cz>
References: <20080205190600.GB11613@elf.ucw.cz> <47AB975C.1010902@zytor.com> <20080208070419.GA4544@ucw.cz> <200802081723.16354.rjw@sisk.pl> <20080208210004.GA12923@elf.ucw.cz> <47ACC381.9070601@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47ACC381.9070601@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-02-08 13:02:57, H. Peter Anvin wrote:
> Pavel Machek wrote:
>> On Fri 2008-02-08 17:23:15, Rafael J. Wysocki wrote:
>>> On Friday, 8 of February 2008, Pavel Machek wrote:
>>>> Hi!
>>> Hi,
>>>
>>>>>> I really need the entry point to be at offset 0, so that I can get
>>>>>> pointers to my data. I could not figure out how to do it any other
>>>>>> way. And if 0 is taken, I thought I'd put header at the end.
>>>>>>
>>>>> Why not just put the structure at 0, and put pointers in the structure 
>>>>> to everything else you need?
>>>> segments:offsets rear its ugly head here. I need %ds to point to my
>>>> data, and the way to do it is copy it from %cs; that needs start to be
>>>> at 0.
>>> Hm, why exactly is that necessay?
>>
>> It is not _neccessary_. Try to come up with another method that gets
>> relocations right. I could not :-(.
>>
>> (Actually, putting table at the offset 0 and short jump at beggining
>> of the table would probably do the trick. But that still keeps code at
>> offset 0 :-).
>
> Why not just put a pointer to the start of the code in the table, and make 
> an indirect call to it?

Indirect call from where?

BIOS jumps to address you provide.

> Where is this code?

arch/x86/kernel/acpi/realmode/wakeup.S

BIOS jumps to wakeup_code. With CS=something, IP=0. If wakeup code is
at other address than zero, I'll not be able to easily address data
below it.
								Pavel

		.globl	wakeup_header
wakeup_header:
...
realmode_flags:	.long	0
signature:	.long	0x51ee1111
...
	.text
	.globl	_start
	.code16
wakeup_code:
_start:
	cli
	cld

	/* Set up segments */
	movw	%cs,%ax
	movw	%ax,%ds
	movw	%ax,%es
	movw	%ax,%ss

...
	/* Check header signature... */
	movl	signature, %eax
	cmpl	$0x51ee1111, %eax
	jne	bogus_real_magic



									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
