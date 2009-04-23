Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbZDWCDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbZDWCDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 22:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZDWCDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 22:03:39 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:64134 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbZDWCDi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 22:03:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=txqGSvfs/v/MJD6L8EYRT0gONptVJqvs63KZROB5vTGrdTZJ+/E4YI3+ZJrm00sbHZ
         Ar/J9pc4VqKjN6zsrinJy0XcW7+Nqujjhjk+N6kAvEcl1QiWmmDeWMg9qecYDe+rKfU/
         k1vzVZaJkgX+wWjQ35j2a6jedskIMTEpzQsAU=
MIME-Version: 1.0
In-Reply-To: <20090422180505.2518e837@hobbes>
References: <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain>
	 <20090419090208.GA30211@elte.hu> <20090419090615.GA30631@elte.hu>
	 <20090420223305.GA15340@jurassic.park.msu.ru>
	 <49ED0EBC.4070901@kernel.org>
	 <20090421105629.GB17904@jurassic.park.msu.ru>
	 <49EF9C10.6090107@kernel.org> <20090422154900.08f8f366@hobbes>
	 <49EFBB0E.3030401@kernel.org> <20090422180505.2518e837@hobbes>
Date: Wed, 22 Apr 2009 19:03:33 -0700
Message-ID: <86802c440904221903p5667bbf9y642d671942555958@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] pci: don't assume pref memio are 64bit -v3
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 6:05 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Wed, 22 Apr 2009 17:49:18 -0700
> Yinghai Lu <yinghai@kernel.org> wrote:
>
>> Jesse Barnes wrote:
>> > On Wed, 22 Apr 2009 15:37:04 -0700
>> > Yinghai Lu <yinghai@kernel.org> wrote:
>> >
>> >> one system with 4g installed ( there is 1g hole)
>> >>
>> >> when 4G installed.
>> >> BIOS put ACPI etc need the hole
>> >> [    0.000000] BIOS-provided physical RAM map:
>> >> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009bc00
>> >> (usable) [    0.000000]  BIOS-e820: 000000000009bc00 -
>> >> 00000000000a0000 (reserved) [    0.000000]  BIOS-e820:
>> >> 00000000000e3000 - 0000000000100000 (reserved) [    0.000000]
>> >> BIOS-e820: 0000000000100000 - 00000000bffa0000 (usable)
>> >> [    0.000000]  BIOS-e820: 00000000bffa0000 - 00000000bffae000
>> >> (ACPI data) [    0.000000]  BIOS-e820: 00000000bffae000 -
>> >> 00000000bfff0000 (ACPI NVS) [    0.000000]  BIOS-e820:
>> >> 00000000bfff0000 - 00000000c0000000 (reserved) [    0.000000]
>> >> BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>> >> [    0.000000] BIOS-e820: 00000000ffb00000 - 0000000100000000
>> >> (reserved) [    0.000000]  BIOS-e820: 0000000100000000 -
>> >> 0000000140000000 (usable) so in kernel resource will be reserved
>> >> for 0xbffa0000 - 0xbfff0000 for ACPI 0x100000 -  0xbffa0000 for
>> >> RAM...
>> >>
>> >> and BIOS set
>> >> [    0.240007] pci 0000:00:01.0: bridge 64bit mmio pref:
>> >> [0xbdf00000-0xddefffff] [    0.237102] pci 0000:01:00.0: reg 10
>> >> 32bit mmio: [0xc0000000-0xcfffffff] that is conflict with reserved
>> >> res. so it can not be reserved Kernel.
>> >>
>> >> then Kernel try to get range from 0x140000000 ( above the RAM, 5G
>> >> and above 4g) and set let the bridge to use it, and ATI cards to
>> >> use it.
>> >>
>> >> but the problem is that ATI only support 32bit ...
>> >
>> > So Ivan's patch didn't work for you for this problem?  I was
>> > planning on applying it, but it would be nice to get some test
>> > results first.
>>
>> looks like Ivan patch still has some problem.
>
> Can you be more specific? :)  I'd like to get this resolved properly as
> well, and I think the principles Ivan outlined are the right ones to
> follow...
>

to check the BAR support 64bit or not should be read from
pci_read_bases and pci_bridge_read_bases...

aka Ivan's patch logic is some kind of wrong.

YH
