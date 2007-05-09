Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbXEIJOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbXEIJOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbXEIJOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:14:09 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2978 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbXEIJOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:14:08 -0400
Date: Wed, 9 May 2007 10:13:58 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Timur Tabi <timur@freescale.com>,
       Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
Subject: select is evil: another reason
Message-ID: <20070509091358.GA29994@flint.arm.linux.org.uk>
Mail-Followup-To: Linux Kernel List <linux-kernel@vger.kernel.org>,
	Timur Tabi <timur@freescale.com>,
	Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/net/Kconfig:2279:warning: 'select' used by config symbol 'UCC_GETH' refers to undefined symbol 'UCC_FAST'
drivers/input/keyboard/Kconfig:170:warning: 'select' used by config symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
drivers/input/mouse/Kconfig:161:warning: 'select' used by config symbol 'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'

The select statements are in generic Kconfig files.  The symbols they
are selecting are in arch-private Kconfig files.  Don't do that -
those symbols are undefined for other architectures.

If you must do that then do:

 config ATARI_KBD_CORE
 	bool
+	default y if KEYBOARD_ATARI || MOUSE_ATARI

in our m68k Kconfig file, and in arch/powerpc/sysdev/qe_lib/Kconfig:

config UCC_FAST
	bool
-	default n
+	default y if UCC_GETH

and kill those three select statements in the generic Kconfig files.

Note also that the select in:

config UCC_FAST
        bool
        default n
        select UCC

config UCC
        bool
        default y if UCC_FAST || UCC_SLOW

is absolutely absurd.  Either use select in UCC_FAST _or_ default y if ...
in UCC but not both.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
