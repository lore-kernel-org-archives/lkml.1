Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbXDZRGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbXDZRGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbXDZRBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:01:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39606 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbXDZRAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:00:22 -0400
Date: Thu, 26 Apr 2007 09:56:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Andi Kleen <ak@suse.de>,
       Zwane Mwaikambo <zwane@infradead.org>
Subject: [patch 20/33] x86: Dont probe for DDC on VBE1.2
Message-ID: <20070426165631.GU1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-don-t-probe-for-ddc-on-vbe1.2.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Zwane Mwaikambo <zwane@infradead.org>

[PATCH] x86: Don't probe for DDC on VBE1.2

VBE1.2 doesn't support function 15h (DDC) resulting in a 'hang' whilst
uncompressing kernel with some video cards. Make sure we check VBE version
before fiddling around with DDC.

http://bugzilla.kernel.org/show_bug.cgi?id=1458

Opened: 2003-10-30 09:12 Last update: 2007-02-13 22:03

Much thanks to Tobias Hain for help in testing and investigating the bug.
Tested on;

i386, Chips & Technologies 65548 VESA VBE 1.2
CONFIG_VIDEO_SELECT=Y
CONFIG_FIRMWARE_EDID=Y

Untested on x86_64.

Signed-off-by: Zwane Mwaikambo <zwane@infradead.org>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/boot/video.S   |   14 ++++++++++++++
 arch/x86_64/boot/video.S |   14 ++++++++++++++
 2 files changed, 28 insertions(+)

--- a/arch/i386/boot/video.S
+++ b/arch/i386/boot/video.S
@@ -571,6 +571,16 @@ setr1:	lodsw
 	jmp	_m_s
 
 check_vesa:
+#ifdef CONFIG_FIRMWARE_EDID
+	leaw	modelist+1024, %di
+	movw	$0x4f00, %ax
+	int	$0x10
+	cmpw	$0x004f, %ax
+	jnz	setbad
+
+	movw	4(%di), %ax
+	movw	%ax, vbe_version
+#endif
 	leaw	modelist+1024, %di
 	subb	$VIDEO_FIRST_VESA>>8, %bh
 	movw	%bx, %cx			# Get mode information structure
@@ -1945,6 +1955,9 @@ store_edid:
 	rep
 	stosl
 
+	cmpw	$0x0200, vbe_version		# only do EDID on >= VBE2.0
+	jl	no_edid
+
 	pushw   %es				# save ES
 	xorw    %di, %di                        # Report Capability
 	pushw   %di
@@ -1987,6 +2000,7 @@ do_restore:	.byte	0	# Screen contents al
 svga_prefix:	.byte	VIDEO_FIRST_BIOS>>8	# Default prefix for BIOS modes
 graphic_mode:	.byte	0	# Graphic mode with a linear frame buffer
 dac_size:	.byte	6	# DAC bit depth
+vbe_version:	.word	0	# VBE bios version
 
 # Status messages
 keymsg:		.ascii	"Press <RETURN> to see video modes available, "
--- a/arch/x86_64/boot/video.S
+++ b/arch/x86_64/boot/video.S
@@ -571,6 +571,16 @@ setr1:	lodsw
 	jmp	_m_s
 
 check_vesa:
+#ifdef CONFIG_FIRMWARE_EDID
+	leaw	modelist+1024, %di
+	movw	$0x4f00, %ax
+	int	$0x10
+	cmpw	$0x004f, %ax
+	jnz	setbad
+
+	movw	4(%di), %ax
+	movw	%ax, vbe_version
+#endif
 	leaw	modelist+1024, %di
 	subb	$VIDEO_FIRST_VESA>>8, %bh
 	movw	%bx, %cx			# Get mode information structure
@@ -1945,6 +1955,9 @@ store_edid:
 	rep
 	stosl
 
+	cmpw	$0x0200, vbe_version		# only do EDID on >= VBE2.0
+	jl	no_edid
+
 	pushw   %es				# save ES
 	xorw    %di, %di                        # Report Capability
 	pushw   %di
@@ -1987,6 +2000,7 @@ do_restore:	.byte	0	# Screen contents al
 svga_prefix:	.byte	VIDEO_FIRST_BIOS>>8	# Default prefix for BIOS modes
 graphic_mode:	.byte	0	# Graphic mode with a linear frame buffer
 dac_size:	.byte	6	# DAC bit depth
+vbe_version:	.word	0	# VBE bios version
 
 # Status messages
 keymsg:		.ascii	"Press <RETURN> to see video modes available, "

-- 
