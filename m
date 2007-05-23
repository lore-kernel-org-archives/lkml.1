Return-Path: <linux-kernel-owner+w=401wt.eu-S1760299AbXEWXvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299AbXEWXvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 19:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756722AbXEWXvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 19:51:13 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:51373 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439AbXEWXvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 19:51:12 -0400
X-IronPort-AV: i="4.14,571,1170662400"; 
   d="scan'208"; a="156834776:sNHT59884740"
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIE
X-Message-Flag: Warning: May contain useful information
References: <46543045.3030904@gmail.com> <20070523155958.GA5282@kroah.com>
	<4654AB40.6060208@gmail.com> <adaejl79rh0.fsf@cisco.com>
	<4654BC10.2000808@gmail.com> <adazm3v89hv.fsf@cisco.com>
	<4654C85B.6060505@gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 23 May 2007 16:51:10 -0700
In-Reply-To: <4654C85B.6060505@gmail.com> (Manu Abraham's message of "Thu, 24 May 2007 03:03:55 +0400")
Message-ID: <adatzu385g1.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 May 2007 23:51:10.0974 (UTC) FILETIME=[3D6F49E0:01C79D95]
Authentication-Results: sj-dkim-7; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim7002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > It looks so, from the logs. The only problem is i can't disable the
 > interrupts, if i write "0" to 0x500, the interrupt/enable register, it
 > gives me a solid freeze. If i read from the handler, commenting out the
 > disable interrupts in init, that read also gives me a solid freeze. This
 > lead me to think that there could be some problem with the MMIO block
 > access.

OK, this looks reasonable:

 > #define saa716x_write(dat, addr)	writel((dat), (saa716x->mmio)+(addr))

although

  a) your driver has no hope of working on a system with more than one
     device of this type; and
  b) there's really no point in obfuscating a simple use of writel()
     this way.

Why does the device come up in a state where it generates a stream of
interrupts as soon as you enable the PCI device?  That's somewhat
unusual behavior, although certainly not unheard of.

This really has the feel of a typical driver bug to me, not anything
related to general PCIe access.  I've definitely wedged my system many
times while trying to poke a device the right way.

Also, where are you getting the offset of 0x500 from?  Is it possible
that the offset is really being given to you in bits (so you should
use 0x500 / 8) or 32-bit words (so you should use an offset of 0x500 *
4)?  Are the datasheet / programming docs available for this device?
I actually have:

  02:00.0 Multimedia controller: Philips Semiconductors Unknown device 7162

in one of my systems so I'd be somewhat interested in getting a driver
working too.

 - R.
