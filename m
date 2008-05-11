Return-Path: <linux-kernel-owner+w=401wt.eu-S1761566AbYEKVWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761566AbYEKVWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761806AbYEKVWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:22:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34469 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761722AbYEKVWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:22:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: 2.6.26-rc1 on x86: ld: warning: dot moved backwards before `.text'
Date: Sun, 11 May 2008 23:22:52 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>,
       Mikael Pettersson <mikpe@it.uu.se>, Pavel Machek <pavel@ucw.cz>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
References: <18470.787.498329.144701@harpo.it.uu.se> <48273A32.5020104@zytor.com> <20080511182905.GD6942@cvg>
In-Reply-To: <20080511182905.GD6942@cvg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805112322.53473.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 11 of May 2008, Cyrill Gorcunov wrote:
> [H. Peter Anvin - Sun, May 11, 2008 at 11:25:54AM -0700]
> > Cyrill Gorcunov wrote:
> >> Hi Peter,
> >> actually I only doubt about exactly position of this headers - I mean
> >> meguess it better should be _before_ "_end" not after. Since the others
> >> script uses (acpi/wakeup_rm.S):
> >> 	wakeup_code_start:
> >> 	.incbin	"arch/x86/kernel/acpi/realmode/wakeup.bin"
> >> 	wakeup_code_end:
> >> and kernel uses these wakeup_code_* marks to save/restore memory I think
> >> it should be like
> >> 	. = HEADER_OFFSET;
> >> 	.header : {
> >> 		...
> >> 	}
> >> 	. = ALIGN(16);
> >> 	_end = .;
> >> 	/DISCARD/ ...
> >
> > Yes, I believe that's correct.
> >
> > 	-hpa
> >
> 
> Thanks for review, Peter, I'll cook a patch and wait for
> Pavel's opinion ;-)

I've tested the appended one.  If that's what you mean, we'll ask Ingo to take
it.

Thanks,
Rafael


---
 arch/x86/kernel/acpi/realmode/wakeup.lds.S |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/kernel/acpi/realmode/wakeup.lds.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/realmode/wakeup.lds.S
+++ linux-2.6/arch/x86/kernel/acpi/realmode/wakeup.lds.S
@@ -12,11 +12,6 @@ ENTRY(_start)
 
 SECTIONS
 {
-	. = HEADER_OFFSET;
-	.header : {
-		 *(.header)
-	}
-
 	. = 0;
 	.text : {
 		 *(.text*)
@@ -50,6 +45,11 @@ SECTIONS
 		__bss_end = .;
 	}
 
+	. = HEADER_OFFSET;
+	.header : {
+		 *(.header)
+	}
+
 	. = ALIGN(16);
 	_end = .;
 
