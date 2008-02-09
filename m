Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbYBINuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbYBINuQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 08:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbYBINuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 08:50:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49704 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750AbYBINt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 08:49:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Date: Sat, 9 Feb 2008 14:48:03 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       Sam Ravnborg <sam@ravnborg.org>
References: <20080205190600.GB11613@elf.ucw.cz> <200802090118.50418.rjw@sisk.pl> <47ACF488.7070502@zytor.com>
In-Reply-To: <47ACF488.7070502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802091448.04439.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 9 of February 2008, H. Peter Anvin wrote:
> Rafael J. Wysocki wrote:
> > 
> > Consolidated patch is appended.  I'll test it tomorrow on x86-64.
> > 
> > I'd like to add the cleaned up beeping code to it and perhaps try to push it
> > for -mm testing without any further changes.  We can still do more cleanups in
> > followup patches.
> > 
> 
> The other thing to figure out is to what extent we can clean up the 
> conditionals in the video mode code by refactoring.  All they really do 
> here is save space by removing functionality not needed for wakeup, 
> because I didn't know how much space was realistic.

OK, I have an idea.

For now, below is a patch that adds your beeping code to wakemain.c (on top of
the previous one). ;-)

Rafael

---
 arch/x86/kernel/acpi/realmode/wakemain.c |   69 ++++++++++++++++++++++++++++---
 1 file changed, 63 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/acpi/realmode/wakemain.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/realmode/wakemain.c
+++ linux-2.6/arch/x86/kernel/acpi/realmode/wakemain.c
@@ -3,20 +3,77 @@
 
 extern volatile struct wakeup_header wakeup_header;
 
+static void udelay(int loops)
+{
+	while (loops--)
+		io_delay();	/* Approximately 1 us */
+}
+
+static void beep(unsigned int hz)
+{
+	u8 enable;
+
+	if (!hz) {
+		enable = 0x00;		/* Turn off speaker */
+	} else {
+		u16 div = 1193181/hz;
+
+		outb(0xb6, 0x43);	/* Ctr 2, squarewave, load, binary */
+		io_delay();
+		outb(div, 0x42);	/* LSB of counter */
+		io_delay();
+		outb(div >> 8, 0x42);	/* MSB of counter */
+		io_delay();
+
+		enable = 0x03;		/* Turn on speaker */
+	}
+	inb(0x61);		/* Dummy read of System Control Port B */
+	io_delay();
+	outb(enable, 0x61);	/* Enable timer 2 output to speaker */
+	io_delay();
+}
+
+#define DOT_HZ		880
+#define DASH_HZ		587
+#define US_PER_DOT	125000
+
+/* Okay, this is totally silly, but it's kind of fun. */
+static void send_morse(const char *pattern)
+{
+	char s;
+
+	while ((s = *pattern++)) {
+		switch (s) {
+		case '.':
+			beep(DOT_HZ);
+			udelay(US_PER_DOT);
+			beep(0);
+			udelay(US_PER_DOT);
+			break;
+		case '-':
+			beep(DASH_HZ);
+			udelay(US_PER_DOT * 3);
+			beep(0);
+			udelay(US_PER_DOT);
+			break;
+		default:	/* Assume it's a space */
+			udelay(US_PER_DOT * 3);
+			break;
+		}
+	}
+}
+
 void main(void)
 {
 	/* Kill machine if structures are wrong */
 	if (wakeup_header.real_magic != 0x12345678)
 		while(1);
 
-	if (wakeup_header.realmode_flags & 4) {
-		asm volatile("inb	$97, %al; 		outb	%al, $0x80; 		movb	$3, %al; 		outb	%al, $97; 		outb	%al, $0x80; 		movb	$-74, %al; 		outb	%al, $67; 		outb	%al, $0x80; 		movb	$-119, %al; 		outb	%al, $66; 		outb	%al, $0x80; 		movb	$15, %al; 		outb	%al, $66");
-	}
+	if (wakeup_header.realmode_flags & 4)
+		send_morse("...-");
 
-	if (wakeup_header.realmode_flags & 1) {
+	if (wakeup_header.realmode_flags & 1)
 		asm volatile("lcallw   $0xc000,$3");
-//		("movw    %cs, %ax;	movw    %ax, %ds;	movw	%ax, %es; movw    %ax, %ss");
-	}
 
 	if (wakeup_header.realmode_flags & 2) {
 		/* Need to call BIOS */
