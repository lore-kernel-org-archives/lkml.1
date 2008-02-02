Return-Path: <linux-kernel-owner+w=401wt.eu-S1760947AbYBBLwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760947AbYBBLwe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 06:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756891AbYBBLw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 06:52:27 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:40409 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768AbYBBLw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 06:52:26 -0500
Date: Sat, 2 Feb 2008 12:52:25 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Pavel Machek <pavel@ucw.cz>
cc: Laurent Vivier <Laurent.Vivier@bull.net>, Paul.Clements@steeleye.com,
       nbd-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow NBD to be used locally
In-Reply-To: <20080202112336.GB5362@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0802021243300.18790@fbirervta.pbzchgretzou.qr>
References: <1201872332265-git-send-email-Laurent.Vivier@bull.net>
 <20080202112336.GB5362@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 2 2008 12:23, Pavel Machek wrote:
>On Fri 2008-02-01 14:25:32, Laurent Vivier wrote:
>> This patch allows Network Block Device to be mounted locally.
>
>What is local nbd good for? Use loop instead...

Local NBD is good for when the content you want to make available
through the block device is dynamic (generated on-the-fly),
non-linear or supersparse.

Take for example VMware virtual disks. Just a guess, but
they roughly can look like this:

  kilobytes  0.. 1: header
  kilobytes  1..10: correspond to LBA 0..20
  kilobytes 11..20: correspond to LBA 40..60
  kilobytes 21..22: correspond to LBA 22..23

So what we have is non-linearity -- LBA 22 comes after LBA 40 -- loop
does not deal with that.

And there is supersparsity -- the VMDK file itself is complete, but
unallocated regions like LBA 24..40 are sparse/zero when projected
onto a file/block device, respectively; loop cannot deal with that
either.

In fact, VMware uses local nbd today for its vmware-loop helper
utility, most likely because of the above-mentioned reasons. (Though
it quite often hung last time I tried.)
