Return-Path: <linux-kernel-owner+w=401wt.eu-S1758978AbYJMVIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbYJMVIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbYJMVIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:08:46 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:54342 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbYJMVIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:08:46 -0400
Subject: Re: [patch 06/18] m68k: Disable Amiga serial console support if
	modular
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081013195915.659336491@mail.of.borg>
References: <20081013195846.674654386@mail.of.borg>
	 <20081013195915.659336491@mail.of.borg>
Content-Type: text/plain
Date: Mon, 13 Oct 2008 23:08:17 +0200
Message-Id: <1223932097.3619.51.camel@x41.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-13 at 21:58 +0200, Geert Uytterhoeven wrote:
> Apparently console_initcall() is not defined in the modular case.

Yes, see include/linux/init.h:
#ifndef MODULE
[...]
#define console_initcall(fn) \
        static initcall_t __initcall_##fn \
        __used __section(.con_initcall.init) = fn
[...]

> Any better alternative fix?

Well, (a number of) other serial consoles cannot be selected if the
corresponding serial driver is modular. Try:
grep -B 2 -E "depends on .*=y" drivers/serial/Kconfig | \
    grep -A 2 -E "^config .*CONSOLE"

For instance:
config SERIAL_8250_CONSOLE
	bool "Console on 8250/16550 and compatible serial port"
	depends on SERIAL_8250=y

Maybe this config entry (in arch/m68k/Kconfig) could be cleaned up (or
split into multiple entries):
config SERIAL_CONSOLE
        bool "Support for serial port console"
        depends on (AMIGA || ATARI || MAC || SUN3 || SUN3X || VME ||
APOLLO) && (ATARI_MFPSER=y || ATARI_MIDI=y || MAC_SCC=y ||
AMIGA_BUILTIN_SERIAL=y || GVPIOEXT=y || MULTIFACE_III_TTY=y || SERIAL=y
|| MVME147_SCC || SERIAL167 || MVME162_SCC || BVME6000_SCC || DN_SERIAL)
[...]

That "depends on" line seems likely to lead to problems like the one you
ran into. But your patch (which I didn't test) is probably simpler.


Paul Bolle

