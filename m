Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbXLWWlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbXLWWlU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 17:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbXLWWlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 17:41:11 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1838 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752045AbXLWWlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 17:41:10 -0500
Message-ID: <476EE3E1.5060200@myri.com>
Date: Sun, 23 Dec 2007 17:40:33 -0500
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Tony Camuso <tcamuso@redhat.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <20071220173528.GE29690@parisc-linux.org> <476AAE99.7090301@redhat.com> <20071220181603.GF29690@parisc-linux.org> <476EC218.6030000@myri.com> <20071223205555.GV29690@parisc-linux.org>
In-Reply-To: <20071223205555.GV29690@parisc-linux.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2007 3:55 PM, Matthew Wilcox wrote:
> On Sun, Dec 23, 2007 at 03:16:24PM -0500, Loic Prylli wrote:
>   
>> I just realized one thing: the bar sizing code in pci_read_bases() (that
>> writes 0xffffffff in the bars) does not seem to disable the
>> PCI_COMMAND_MEM/PCI_COMMAND_IO bits in the cmd register before
>> manipulating the BARs. And it seems nobody else ensures they are
>> disabled at this point either (or am I missing something?).
>>     
>
> Right, we don't.  Ivan and Greg are convinced that doing so can break
> some machines.  
>   



 It might indeed be scary to suddenly change the command bits on some
old "Host bridges" and maybe other classes of bridges. I was too
optimistic about the triviality of the fix.


Still an obvious improvement to the pci_read_bases() code would be to
not try sizing non-existings BARs (that way if a device has no memory
bars, we never need to touch the mem-enable bit). In addition, if you
exclude Host bridges and other bridges from temporary mem-disabling
while sizing their BARs, then doing temp disabling for the remaining
devices looks less scary than the alternative (messing live with the
bars decoding range especially for regular devices integrated to the
main chipset).


It seems to me worth making that init code safer independantly of the
mmconfig issues.



> Now that contradicts some information we've been told before; can you
> post those traces?  That would argue in favour of disabling memspace
> when configuring BARs.
>   



Here is a trace where COMMAND/STATUS and 0x10 and 0x14 registers
accesses were captured. Comments in brackets are my interpretation of
what's happening. That was with windows 2003 64bit.


Loic



[ reset at 607 second]

[BIOS: read-status, COMMAND = 0 ]

626.442718:cfg-read:0x6.w=0x10
626.442805:cfg-write:0x4.w=0x0

[BIOS: sizing BAR0]

626.448325:cfg-read:0x10.l=0x8
626.448365:cfg-write:0x10.l=0xfffffffe
626.448439:cfg-read:0x10.l=0xff000008
626.448493:cfg-write:0x10.l=0x8

[BIOS: sizing non-existent BAR1]

626.448552:cfg-read:0x14.l=0x0
626.448591:cfg-write:0x14.l=0xfffffffe
626.448647:cfg-read:0x14.l=0x0
626.448687:cfg-write:0x14.l=0x0

[BIOS: sizing BAR0]

626.449596:cfg-read:0x10.l=0x8
626.449635:cfg-write:0x10.l=0xfffffffe
626.449710:cfg-read:0x10.l=0xff000008
626.449764:cfg-write:0x10.l=0x8

[BIOS: sizing non-existent BAR1]

626.449832:cfg-read:0x14.l=0x0
626.449872:cfg-write:0x14.l=0xfffffffe
626.449928:cfg-read:0x14.l=0x0
626.449967:cfg-write:0x14.l=0x0

[BIOS: sizing BAR0]


626.451822:cfg-read:0x10.l=0x8
626.451862:cfg-write:0x10.l=0xfffffffe
626.451936:cfg-read:0x10.l=0xff000008
626.451990:cfg-write:0x10.l=0x8

[BIOS: sizing non-existent BAR1]

626.452058:cfg-read:0x14.l=0x0
626.452098:cfg-write:0x14.l=0xfffffffe
626.452154:cfg-read:0x14.l=0x0
626.452194:cfg-write:0x14.l=0x0


[BIOS: sizing and assigning BAR0]

626.454899:cfg-read:0x10.l=0x8
626.454939:cfg-write:0x10.l=0xfffffffe
626.455013:cfg-read:0x10.l=0xff000008

626.455068:cfg-write:0x10.l=0x8
626.455138:cfg-write:0x10.l=0xfa000000

[BIOS: sizing non-existent BAR1]

626.455211:cfg-read:0x14.l=0x0
626.455251:cfg-write:0x14.l=0xfffffffe
626.455307:cfg-read:0x14.l=0x0
626.455346:cfg-write:0x14.l=0x0


[BIOS: sizing and restoring BAR0]


628.024774:cfg-read:0x10.l=0xfa000008
628.024831:cfg-write:0x10.l=0xfffffffe
628.024908:cfg-read:0x10.l=0xff000008
628.024964:cfg-write:0x10.l=0xfa000008

[BIOS: sizing non-existent BAR1]

628.025049:cfg-read:0x14.l=0x0
628.025091:cfg-write:0x14.l=0xfffffffe
628.025149:cfg-read:0x14.l=0x0
628.025190:cfg-write:0x14.l=0x0

[BIOS: clear status ]

628.025714:cfg-write:0x6.w=0xffff

[BIOS: enable SERR/IO+MEMORY+MASTER+SPECIAL+INVALIDATE ]
628.025788:cfg-write:0x4.w=0x11f

[BIOS: enable MEMORY+MASTER (after seeing IO/special/invalidate were
read-only 0) ]
629.028114:cfg-read:0x4.b=0x6
629.028160:cfg-write:0x4.b=0x6

[BIOS: read status, clear PARITY/SERR status bits ]
629.028490:cfg-read:0x7.b=0x0
629.028536:cfg-write:0x7.b=0xc1

[BIOS: enable PARITY detection ]
629.028818:cfg-read:0x4.b=0x6
629.028863:cfg-write:0x4.b=0x46

[BIOS: enable SERR (already enabled anyway) ]
629.028920:cfg-read:0x5.b=0x1
629.028966:cfg-write:0x5.b=0x1
629.032338:cfg-read:0x6.w=0x10


[ WINDOWS starting ]

661.965932:cfg-read:0x4.l=0x100146
661.965986:cfg-read:0x10.l=0xfa000008
661.966040:cfg-read:0x14.l=0x0

662.112971:cfg-read:0x4.l=0x100146
662.113024:cfg-read:0x10.l=0xfa000008
662.113078:cfg-read:0x14.l=0x0

662.155903:cfg-read:0x4.l=0x100146

662.156066:cfg-read:0x4.l=0x100146
662.156120:cfg-read:0x10.l=0xfa000008
662.156174:cfg-read:0x14.l=0x0

662.156337:cfg-read:0x4.l=0x100146
662.156391:cfg-read:0x10.l=0xfa000008
662.156445:cfg-read:0x14.l=0x0

[ WINDOWS: disable MEMORY + MASTER ]
662.156519:cfg-write:0x4.l=0x140

[ WINDOWS: size BAR0 and BAR1]
662.156588:cfg-write:0x10.l=0xffffffff
662.156662:cfg-write:0x14.l=0xffffffff
662.156755:cfg-read:0x4.l=0x100140
662.156809:cfg-read:0x10.l=0xff000008
662.156863:cfg-read:0x14.l=0x0

[ WINDOWS: disable MEMORY + MASTER ]

662.156937:cfg-write:0x4.l=0x140

[ WINDOWS: restore BAR0 and non-existing BAR1]

662.157004:cfg-write:0x10.l=0xfa000008
662.157077:cfg-write:0x14.l=0x0

[ WINDOWS: enable  MEMORY + MASTER ]

662.157151:cfg-write:0x4.w=0x146

662.157453:cfg-read:0x4.l=0x100146
662.157506:cfg-read:0x10.l=0xfa000008
662.157560:cfg-read:0x14.l=0x0

662.157690:cfg-read:0x4.w=0x146

[ WINDOWS: disable MEMORY + MASTER ]

662.157738:cfg-write:0x4.w=0x140

[ WINDOWS: enter power-saving mode ]
662.157866:Entered L1

