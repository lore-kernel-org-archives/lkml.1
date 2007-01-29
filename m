Return-Path: <linux-kernel-owner+w=401wt.eu-S933278AbXA2JBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278AbXA2JBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 04:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933277AbXA2JBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 04:01:09 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:41845 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933280AbXA2JBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 04:01:07 -0500
X-Originating-Ip: 74.109.98.130
Date: Mon, 29 Jan 2007 03:59:29 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: finding "dead" CONFIG variables -- an exercise for the reader
Message-ID: <Pine.LNX.4.64.0701290328001.12980@CPE00045a9c397f-CM001225dbafb6>
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


  FYI, the majority of patches i've submitted lately related to
potentially "dead" CONFIG variables in the source tree were identified
by a short script "dead_config.sh" i wrote you can find here:

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Dead_CONFIG_variables

  that script scans the source tree (or whatever subdirectory you pass
as an argument), collects all of the "CONFIG_" type macros in
conditional preprocessor statements, then spits out any of them that
aren't defined in *any* Kconfig in the entire source tree.

  as a random example, let's check the subdirectory drivers/media/dvb:

$ dead_config.sh drivers/media/dvb
========== DVB_DIBCOM_DEBUG ==========
drivers/media/dvb/frontends/dib3000mb.c:#ifdef CONFIG_DVB_DIBCOM_DEBUG
drivers/media/dvb/frontends/dib3000mb.c:#ifdef CONFIG_DVB_DIBCOM_DEBUG
drivers/media/dvb/frontends/dib3000mb_priv.h:#ifdef CONFIG_DVB_DIBCOM_DEBUG

  so there's a single CONFIG macro somewhere in that tree that is
being tested (three times) for which there is no Kconfig entry.  that
doesn't mean this macro is necessarily wrong -- it might be defined in
a Makefile, perhaps -- but it at least deserves closer examination.

  another random example:

$ dead_config.sh arch/ppc/8xx_io
========== FEC_PACKETHOOK ==========
arch/ppc/8xx_io/fec.c:#ifdef CONFIG_FEC_PACKETHOOK
arch/ppc/8xx_io/fec.c:#ifdef CONFIG_FEC_PACKETHOOK
arch/ppc/8xx_io/fec.c:#ifdef CONFIG_FEC_PACKETHOOK
arch/ppc/8xx_io/fec.c:#ifdef CONFIG_FEC_PACKETHOOK
arch/ppc/8xx_io/fec.c:#endif /* CONFIG_FEC_PACKETHOOK */
arch/ppc/8xx_io/fec.c:#ifdef CONFIG_FEC_PACKETHOOK
arch/ppc/8xx_io/fec.c:#ifdef CONFIG_FEC_PACKETHOOK
arch/ppc/8xx_io/fec.c:#ifdef CONFIG_FEC_PACKETHOOK
arch/ppc/8xx_io/fec.c:#ifdef CONFIG_FEC_PACKETHOOK
arch/ppc/8xx_io/fec.c:#ifdef CONFIG_FEC_PACKETHOOK
arch/ppc/8xx_io/fec.c:#ifdef CONFIG_FEC_PACKETHOOK
arch/ppc/8xx_io/fec.c:#ifdef CONFIG_FEC_PACKETHOOK
arch/ppc/8xx_io/fec.c:#ifdef CONFIG_FEC_PACKETHOOK
arch/ppc/8xx_io/fec.c:#ifdef CONFIG_FEC_PACKETHOOK
arch/ppc/8xx_io/fec.c:#ifdef CONFIG_FEC_PACKETHOOK

  feel free to run the script on the subtree of your choice.  when i
first ran this script against the entire tree, i identified 347 unique
macros like this.

rday

p.s.  in some cases, the macro doesn't appear in any Kconfig file
since it's meant only for internal use by the maintainer, as you can
see by the suffix "_DEBUG".  but if that's the case, it's my feeling
that macros like that should *not* start with the "CONFIG_" prefix,
which should be reserved for user-configurable selections only.

  but that's just my $0.02.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
