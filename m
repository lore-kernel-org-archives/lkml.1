Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbXICSdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbXICSdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 14:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbXICSdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 14:33:10 -0400
Received: from gg.genua.de ([151.136.100.2]:30251 "EHLO gg.genua.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbXICSdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 14:33:09 -0400
Date: Mon, 3 Sep 2007 20:32:38 +0200
From: Christian Ehrhardt <lk@c--e.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: New x86-Setup code breaks HVM-XEN boot
Message-ID: <20070903183237.GA1208@genua.de>
References: <20070830141528.GA307@lisa.in-ulm.de> <46D6D8F6.2040201@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D6D8F6.2040201@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thu, Aug 30, 2007 at 07:49:26AM -0700, H. Peter Anvin wrote:
> Christian Ehrhardt wrote:
> >
> >Note the the xm console command terminates on its own, i.e. the guest
> >machine seems to halt and not hang somewhere.
> >
> >I could verify that the real mode code up to the assembly code in
> >pmjump.S is in fact executed. The problem appears to occur while
> >enabling protected mode. I tried to put endless loops into the 32-bit
> >setup code but these were apparently not reached. As far as I understand
> >this, the protected mode jump in pmjump.S seems to jump into nowhere.
> >
> >I am willing to do tests with the XEN guest and send any additional
> >information that might be helpful. However, I cannot change the XEN host
> >at this time.
> >
> >Any suggestions? 
> >
> 
> All of this point to a bug in the Xen emulation host.  You're not saying 
>  if you're on an Intel or AMD host, but on Intel, hardware 
> virtualization doesn't actually kick in until you're in protected mode 
> with all segments configured properly.  This means all of pmjump.S runs 
> in an interpreter.  A bug in that interpreter would cause what you observe.

I took the trouble to bisect (manually) exactly which change in the new
boot code triggers this problem.

The problem is with the lgdt instruction. Apparently XEN does not keep
the contents of the 48-bit gdt_48 data structure that is passed to lgdt
in the XEN machine state. Instead it appears to save the _address_ of the
48-bit descriptor somewhere. Unfortunately this data happens to reside on the
stack and is probably no longer availiable at the time of the actual
protected mode jump.

This is most likely a XEN-bug but given that there is a on line patch
to work around this problem, the linux kernel should probably do this.
My fix is to make the gdt_48 description in setup_gdt static (in
setup_idt this is already the case). This allows the kernel to boot under
XEN-hvm again.

Sometimes it is a bit disappointing if quite some debuggin work results
in a on line patch :-) Pleae consider applying.

    regards   Christian

Signed-off-by: Christian Ehrhardt <lk@c--e.de>

diff --git a/arch/i386/boot/pm.c b/arch/i386/boot/pm.c
index 6be9ca8..f7958f1 100644
--- a/arch/i386/boot/pm.c
+++ b/arch/i386/boot/pm.c
@@ -122,7 +122,7 @@ static void setup_gdt(void)
 		/* DS: data, read/write, 4 GB, base 0 */
 		[GDT_ENTRY_BOOT_DS] = GDT_ENTRY(0xc093, 0, 0xfffff),
 	};
-	struct gdt_ptr gdt;
+	static struct gdt_ptr gdt;
 
 	gdt.len = sizeof(boot_gdt)-1;
 	gdt.ptr = (u32)&boot_gdt + (ds() << 4);

