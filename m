Return-Path: <linux-kernel-owner+w=401wt.eu-S1759201AbYHULSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201AbYHULSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 07:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756797AbYHULSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 07:18:25 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:34647 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560AbYHULSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:18:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Q7D1PVuDrifhSIrgqN55UE/99Vto4bEeUmxrZaAWDILoBnSyeglDvkHfNLYphkSA9z
         cEzUdTGuLHpUUVmuKWvyLioSjXELa6yFfjvRnMxPD6u9T4b/9g07sS6eSbqrHcSvUTgU
         gN+sEclhxNblRFAyys9ycEsVRzHq4p87xe138=
Message-ID: <19f34abd0808210418w39341d05p43712356b352cdc9@mail.gmail.com>
Date: Thu, 21 Aug 2008 13:18:23 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: 2.6.27-rc3: 'APIC error on CPU1: 00(40)', but only on resume!
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Frans Pop" <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, "Andi Kleen" <andi@firstfloor.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.55.0808211023020.22938@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808202106.41058.elendil@planet.nl>
	 <200808202138.13302.rjw@sisk.pl>
	 <200808202226.45655.elendil@planet.nl>
	 <200808202356.33036.rjw@sisk.pl>
	 <Pine.LNX.4.55.0808211023020.22938@cliff.in.clinika.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 11:27 AM, Maciej W. Rozycki
<macro@linux-mips.org> wrote:
> On Wed, 20 Aug 2008, Rafael J. Wysocki wrote:
>
>> On my box I see many "APIC error on CPU1: 00(40)" messages that don't seem
>> to be related to anything obviously bad and I've alwas been seeing them.
>
>  Barring a hardware erratum, this is a bug in the kernel.  It should be
> moderately easy to track down with some debugging added to writes
> accessing LVT and redirection table entries.

Hi,

I've also seen this a lot, so I have now written (I think) such a
debug patch (it's very crude) and tested it on my laptop, which
exhibits this problem.

The patch and full dmesg (with debug output) can be found here:

http://userweb.kernel.org/~vegard/bugs/20080821-apic/

The output looks like this (with register annotations by me; CPU id is
the second column)

APIC error on CPU0: 00(40)
Last 16 APIC writes:
0: 1: [00000380] = 00001f79
1: 1: [000000b0] = 00000000
2: 1: [00000380] = 00001f7e
3: 1: [000000b0] = 00000000
4: 1: [00000380] = 00001fa5
5: 1: [000000b0] = 00000000
6: 1: [00000380] = 00001f8c
7: 1: [000000b0] = 00000000
8: 1: [000000b0] = 00000000
9: 1: [00000380] = 00001e4e
10: 1: [000000b0] = 00000000
11: 1: [00000380] = 00001fa5
12: 1: [000000b0] = 00000000
13: 1: [00000380] = 00001f87 # Initial Count Register (for Timer)
14: 0: [00000280] = 00000000 # Error Status Register
15: 0: [000000b0] = 00000000 # EOI Register

The order is from oldest (0) to newest (15) write. I don't see any
writes to ICR in there, which means that IPIs can be ruled out? It
seems that it is the write to Timer that causes it. In another place,
we have this:

13: 1: [00000320] = 000100ef # LVT Timer Register
14: 0: [00000280] = 00000000
15: 0: [000000b0] = 00000000

This would be APIC_LVT_MASKED | LOCAL_TIMER_VECTOR.

The APIC error is seen approximately every 3 minutes.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
