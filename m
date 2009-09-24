Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbZIXMX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbZIXMX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZIXMX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:23:28 -0400
Received: from cmpxchg.org ([85.214.51.133]:52144 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbZIXMX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:23:27 -0400
Date: Thu, 24 Sep 2009 14:22:49 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [origin tree boot hang] [PATCH] Revert "early_printk: Allowmorethan one early console"
Message-ID: <20090924122249.GA8425@cmpxchg.org>
References: <20090923135539.GA6542@kroah.com> <20090923173709.GA18056@elte.hu> <4ABA6182.1000106@windriver.com> <20090923190239.GC24251@elte.hu> <20090923191756.GA25163@elte.hu> <20090923210555.GA13492@elte.hu> <4ABA90C6.3000600@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABA90C6.3000600@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 04:19:02PM -0500, Jason Wessel wrote:
> Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >
> >
> >   
> >> The commit point to which the attached config and bootlog belongs is:
> >>
> >>   2.6.31-07863-gb64ada6
> >>
> >> Reverting:
> >>
> >>   c953094: early_printk: Allow more than one early console
> >>
> >> solves it.
> >>     
> >
> > btw., the boot options are:
> >
> > Command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 debug
> > initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel 
> > selinux=0 nmi_watchdog=0 panic=1 3
> >
> >   
> 
> AH HA!
> 
> earlyprintk=serial,ttyS0,115200
> 
> You are invoking the same device twice which is why you are having
> infinite recursion.  It was not obvious to me why the earlyprintk
> code would allow "serial" or "ttyS", but perhaps we need to protect
> for that?

That is how it's documented, quoting kernel-parameters.txt:

	earlyprintk=vga
	earlyprintk=serial[,ttySn[,baudrate]]
	earlyprintk=dbgp

so ttySn is actually an option to the 'serial' mode.  This has been
working before because we parsed only one mode but now we parse

	serial,ttyS0,115200

correctly and then advance character-wise, looking for another
console:

	erial,ttyS0,...
	rial,ttyS0...
	...

until we hit 'ttyS0,115200' which again we parse as a stand-alone
console definition, yielding twice the same one.

> Your boot line should be:
> 
> earlyprintk=serial,115200

Sure this works?  I haven't tried it, but the code looks like it would
misinterpret the baudrate as the port number, fail and advance to the
end of the string, and not set the baudrate at all.  You can specify
ttyS0 standalone, but not serial alone.

It would probably make sense to skip what is successfully parsed
completely, perhaps like the (untested) diff below?  The other init
functions would need to be converted too, so that we know how much
they peeked into the buffer.

---

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 2acfd3f..62e1853 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -105,12 +105,12 @@ static void early_serial_write(struct console *con, const char *s, unsigned n)
 
 #define DEFAULT_BAUD 9600
 
-static __init void early_serial_init(char *s)
+static __init void early_serial_init(char **sp)
 {
 	unsigned char c;
 	unsigned divisor;
 	unsigned baud = DEFAULT_BAUD;
-	char *e;
+	char *e, *s = *sp;
 
 	if (*s == ',')
 		++s;
@@ -143,6 +143,9 @@ static __init void early_serial_init(char *s)
 		baud = simple_strtoul(s, &e, 0);
 		if (baud == 0 || s == e)
 			baud = DEFAULT_BAUD;
+		s += strcspn(s, ",");
+		if (*s == ',')
+			s++;
 	}
 
 	divisor = 115200 / baud;
@@ -151,6 +154,8 @@ static __init void early_serial_init(char *s)
 	outb(divisor & 0xff, early_serial_base + DLL);
 	outb((divisor >> 8) & 0xff, early_serial_base + DLH);
 	outb(c & ~DLAB, early_serial_base + LCR);
+
+	*sp = s;
 }
 
 static struct console early_serial_console = {
@@ -201,12 +206,16 @@ static int __init setup_early_printk(char *buf)
 
 	while (*buf != '\0') {
 		if (!strncmp(buf, "serial", 6)) {
-			early_serial_init(buf + 6);
+			buf += 6;
+			early_serial_init(&buf);
 			early_console_register(&early_serial_console, keep);
+			continue;
 		}
 		if (!strncmp(buf, "ttyS", 4)) {
-			early_serial_init(buf + 4);
+			buf += 4;
+			early_serial_init(&buf);
 			early_console_register(&early_serial_console, keep);
+			continue;
 		}
 		if (!strncmp(buf, "vga", 3) &&
 		    boot_params.screen_info.orig_video_isVGA == 1) {
