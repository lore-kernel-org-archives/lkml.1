Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbXGVFoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbXGVFoJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 01:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbXGVFn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 01:43:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43442 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbXGVFn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 01:43:58 -0400
Date: Sun, 22 Jul 2007 06:43:56 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org, sam@ravnborg.org
Subject: [RFC] Kconfig fun with sparc32/sparc64 rtc drivers
Message-ID: <20070722054356.GO21668@ftp.linux.org.uk>
References: <7157.1184937882@laptop13.inf.utfsm.cl> <20070720161154.GA17382@infradead.org> <20070721.192251.122832397.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070721.192251.122832397.davem@davemloft.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	We have a problem - there are two rtc drivers for sparc; sbus and
ebus+isa respectively (drivers/sbus/char/rtc.c and drivers/char/rtc.c).  They
can be built into the kernel at the same time just fine; one that doesn't
find the hardware will STFU and bugger off, leaving the other free to register
misc device, etc.   As the matter of fact, that's what sparc64 defconfig
has.

	However, building both as modules runs into fun problems with
kbuild - we get
	drivers/char/rtc.o
	drivers/sbus/char/rtc.o
	drivers/sbus/char/rtc.mod.c
but no
	drivers/char/rtc.mod.c
and anything that depends on exports from the latter will get buggered.
E.g. we get
WARNING: "rtc_control" [sound/core/snd-rtctimer.ko] undefined!
WARNING: "rtc_unregister" [sound/core/snd-rtctimer.ko] undefined!
WARNING: "rtc_register" [sound/core/snd-rtctimer.ko] undefined!
on sparc64 allmodconfig build because of that.

	Aside of kbuild problems, how is userland supposed to deal with
two modules with the same name, anyway?

	There's another interesting question -
config SUN_MOSTEK_RTC
        tristate "Mostek real time clock support"
        help
          The Mostek RTC chip is used on all known Sun computers except
          some JavaStations. For a JavaStation you need to say Y both here
          and to "Enhanced Real Time Clock Support".
seems to imply that CONFIG_RTC has no business whatsoever on sparc64 builds,
let alone in defconfig - JavaStation had never gone sparc64.  OTOH, we
have explicit scanning ISA bus in addition to EBUS in drivers/char/rtc.c
in case of __sparc_v9__, so it looks like help above ought to be changed.
OTTH, the isa-scanning code looks odd - for comparison, FreeBSD has
the same logics for ebus (looks for node called "rtc"), but the isa probe
in the same driver (sys/sparc64/sparc64/rtc.c) is

static struct isa_pnp_id rtc_isa_ids[] = {
        { 0x000bd041, "AT realtime clock" }, /* PNP0B00 */
        { 0 }
};

static int
rtc_isa_probe(device_t dev)
{

        if (ISA_PNP_PROBE(device_get_parent(dev), dev, rtc_isa_ids) == 0) {
                device_set_desc(dev, "Real Time Clock");
                return (0);
        }

        return (ENXIO);
}

and they claim to find that one on Netra X1, where we seemed to get rtc_init:
no PC rtc found, if the boot logs I've been able to google are to be trusted.

Comments?  Sparc64 box I've got is sbus-only, so I've never touched the
drivers/char/rtc.c stuff - it doesn't find anything ebus anyway, since the
damn thing is simply note there...
