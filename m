Return-Path: <linux-kernel-owner+w=401wt.eu-S1751076AbXDKH7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751076AbXDKH7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 03:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbXDKH7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 03:59:48 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58833 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbXDKH7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 03:59:46 -0400
X-Originating-Ip: 74.109.98.130
Date: Wed, 11 Apr 2007 03:58:36 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: "menu" versus "menuconfig" -- they're *both* a bad idea
Message-ID: <Pine.LNX.4.64.0704110357200.9384@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  i can still remember the days when *i* was pushing for the idea of
using "menuconfig" instead of "menu" more in the config menus, but
i've finally realized they're *both* badly designed for what jan is
trying to do here.

  the best example of why "menuconfig" is a mess is in the menu entry
for:

  General setup
    [ ] Configure standard kernel features (for small systems)  --->

note how, even if you don't choose to configure features for small
systems, if you go under that menu entry, you're still presented with
a couple config options related to kallsyms.  that's simply wrong.
it's hideously non-intuitive to explicitly not select a top-level
choice, only to learn that there still exist selectable sub-choices.

  and the Kconfig structure defining that is also overly messy:

===========================
menuconfig EMBEDDED
	bool "Configure standard kernel features (for small systems)"
	...
===========================

  first, for submenu entries to show up if you select features for
"small systems," you need to tack "if EMBEDDED" onto every prompt,

...
bool "Sysctl syscall support" if EMBEDDED
bool "Load all symbols for debugging/ksymoops" if EMBEDDED
bool "Support for hot-pluggable devices" if EMBEDDED
...

and so on, which gets annoyingly repetitive after a while.

  worse, you have options that don't even depend on the menu that
they're a sub-entry for, as in:

...
config KALLSYMS_ALL
        bool "Include all symbols in kallsyms"
        depends on DEBUG_KERNEL && KALLSYMS
...

  what is really needed here is a new Kconfig structure, perhaps
called "selectablemenuconfig" (or something not quite so verbose),
which would, in one fell swoop:

1) be singly-clickable to activate or de-activate an entire submenu
and possibly further submenus, and

2) make all of those submenu entries *automatically* depend on the
config option that represents the submenu.

  at the moment, you can do pretty much the same thing with
"menuconfig" but it's downright messy.  rather than make all these
"menuconfig" changes right now, i would prefer to see a cleaner
structure introduced that does most of that work under the hood.

rday
--
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
