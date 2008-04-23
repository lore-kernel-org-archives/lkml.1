Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYDWML0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYDWML0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 08:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYDWMLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 08:11:18 -0400
Received: from smtp.seznam.cz ([77.75.72.43]:33461 "HELO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751984AbYDWMLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 08:11:17 -0400
From: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
To: linux-kernel@vger.kernel.org
Date: Wed, 23 Apr 2008 14:19:25 +0200
MIME-Version: 1.0
Subject: Re: What pokes the ISA IO port of 0x211 ?
Message-ID: <480F456D.3680.ACD58B03@localhost>
In-reply-to: <480CFA42.20408@keyaccess.nl>
References: <480CF3A5.8080104@keyaccess.nl>
X-mailer: Pegasus Mail for Windows (4.21c)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Smtpd: 1.0.36@12969
X-Seznam-User: frantisek.rysanek@post.cz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 Apr 2008 at 19:40, H. Peter Anvin wrote:
> It might be easiest to put in a hack in the kernel by hacking
> outb/outw/outl and print stack trace when called when trying to poke
> this port. 

On 21 Apr 2008 at 22:34, Rene Herman wrote:
> Ah, it's the old analog gameport: ns558_init.

Well my immediate initial idea was indeed the game port, 
IO port 0x201 immediately started jumping up and down 
in the dark recesses of my memory from teenage years,
when I was trying this and that in Borland C in DOS...

So even before I wrote to LKML, I went into "make menuconfig"
and made sure that any entries related to the game port
were disabled:

Device Drivers -->
 Input device support -->
  Joystick interface = disabled
  Joysticks/Gamepads = disabled

I've been having all of that disabled in my kernel for ages,
I haven't met a game port since I abandoned my 486+SB16.

So, after Rene's response and HPA's responses, I resorted to
the suggested hacking on include/asm/io.h . 

After some grepping through the kernel sources, I could come up
with a simple call to dump_stack(). I added
  if (port == 0x211) dump_stack();\
into <asm/io.h>, on a second line below
  #define BUILDIO(bwl,bw,type)
into the definition of
  static inline void out##bwl##_local()
That gave me a linker error in the final stages of "make bzImage".
Clearly arch/i386/boot/compressed/misc.c doesn't get linked
directly to the rest of the kernel binary image, so it doesn't
have access to the kernel's symbols.
I solved that by making a clipboard copy of the whole huge BUILDIO 
"template" macro definition and wrapping the first copy in an 
  #ifndef SKIP_STACK_DUMP 
and I only defined SKIP_STACK_DUMP in compressed/misc.c
to avoid the linking problem...

Much to my amazement, this time it worked, 
and I was even more amazed to find out, that in fact 
Rene Herman was right :-)))

The poke is indeed performed by a function called ns558_init
and it's indeed related to the generic game port.

What I missed in the menuconfig was this entry:

Device Drivers -->
 Input device support -->
  Hardware I/O ports -->
   Gameport support -->
    Classic ISA and PnP gameport support

Also known as CONFIG_GAMEPORT_NS558, which enables compilation of 
drivers/input/gameport/ns558.c

It's always fun to learn about multiple menuconfig entries
for the same piece hardware or functionality in general :-)

Thanks to all those who replied, thanks for your time,
and have a nice, productive day :-)

Frank Rysanek

