Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbZHTMZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbZHTMZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 08:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbZHTMZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 08:25:44 -0400
Received: from mail.gmx.net ([213.165.64.20]:59995 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754033AbZHTMZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 08:25:43 -0400
Cc: rusty@rustcorp.com.au, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, John David Anglin <dave.anglin@nrc.ca>
Content-Type: text/plain; charset="iso-8859-1"
Date: Thu, 20 Aug 2009 14:25:37 +0200
From: "Helge Deller" <deller@gmx.de>
In-Reply-To: <20090820115122.123520@gmx.net>
Message-ID: <20090820122537.29410@gmx.net>
MIME-Version: 1.0
References: <4A89CC4D.5040801@gmx.de>	 <1250549376.7858.96.camel@mulgrave.site>
	 <200908181248.52572.rusty@rustcorp.com.au>	
 <20090818050637.4C3E74730F@magilla.sf.frob.com>
 <1250640565.15079.3.camel@mulgrave.site> <20090820115122.123520@gmx.net>
Subject: Re: kernel segv with 2.6.31-rc6 ?
To: "Helge Deller" <deller@gmx.de>, roland@redhat.com,
       James.Bottomley@HansenPartnership.com
X-Authenticated: #1045983
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+thlNiVKytNs8NXCE5Rxe0SU7w1msw98EqQ4Q6DM
 9HcJ+/A/lVNhrkDakhsOBOmReo4AmwMrg2hQ== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: 9ni4fjZBRkkNEauPfGRq94hudWkvKBNW
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Mon, 2009-08-17 at 22:06 -0700, Roland McGrath wrote:
> > > > I'd be happy to fail to load it.  There might be sysfs issues with
> it
> > too.
> > > 
> > > That sounds reasonable to me.  And I'd be happy to at least look a
> > little
> > > and maybe give some advice to anybody who finds themself building such
> a
> > > (free) module, doesn't know why or how it got that way, and wants to
> > ask.
> > 
> > Actually, for parisc, its not reasonable.  It's expected that our
> > modules have multiple text sections (we have to use -ffunction-sections
> > to generate them in order that the PCREL17 jump stubs can be
> > interleaved).
> > 
> > The problem looks to be that some linker error gave the one of the named
> > function text sections a duplicate name.  Helge, can you post he objdump
> > info that shows which section had a duplicate name?
> > 
> > Even with the duplicate name, though, the module should be perfectly
> > loadable.
> 
> 
> It's the ac97_bus kernel module:
> -rw-r--r-- 1 root root 3.0K 2009-08-19 12:25 ac97_bus.ko 

That's actually a problem of all kernel modules on hppa when using a newer compiler, not only the ac97_bus module.

The reason seems to be, that something in the newer gcc compilers changed to generate multiple sections all named ".text" for the PCREL17 relocations.
Older compilers named those sections ".text.1", ".text.2", ".text.3" and so forth.

"objdump -x ac97_bus.ko" with current (newer) compiler gives:
> Sections:
> Idx Name          Size      VMA       LMA       File off  Algn
>   0 .note.gnu.build-id 00000024  00000000  00000000  00000034  2**2
>                   CONTENTS, ALLOC, LOAD, READONLY, DATA            
>   1 .text         00000000  00000000  00000000  00000058  2**0     
>                   CONTENTS, ALLOC, LOAD, READONLY, CODE            
>   2 .text.ac97_bus_match 0000001c  00000000  00000000  00000058  2**2
>                   CONTENTS, ALLOC, LOAD, READONLY, CODE              
>   3 .exit.text    00000030  00000000  00000000  00000074  2**2       
>                   CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE       
>   4 .init.text    00000030  00000000  00000000  000000a4  2**2       
>                   CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE       
>   5 .text         00000000  00000000  00000000  000000d4  2**0       
>                   CONTENTS, ALLOC, LOAD, READONLY, CODE              
>...

older compiler produced:
Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000000  00000000  00000000  00000034  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .text.ac97_bus_match 0000001c  00000000  00000000  00000034  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  2 .exit.text    00000030  00000000  00000000  00000050  2**2
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
  3 .init.text    00000030  00000000  00000000  00000080  2**2
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
  4 .text.1       00000000  00000000  00000000  000000b0  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
...

Helge
-- 
Neu: GMX Doppel-FLAT mit Internet-Flatrate + Telefon-Flatrate
für nur 19,99 Euro/mtl.!* http://portal.gmx.net/de/go/dsl01
