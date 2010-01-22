Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253Ab0AVP43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab0AVP43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 10:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012Ab0AVP43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 10:56:29 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:59832 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab0AVP42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 10:56:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=NEnJgiwEuKWvyL1HwmpG+/ry6JEocrAOkAFlPSLxoNR9AhV0XVv39LNeVVzrYDRu7i
         FkY3jbIaFUusOe1oQnyVYCxrvyDuZ/nvvtOpgkxjWvrbUmwprLcFayumdsBZs62WYKIA
         5TlqSTbopaMdYoch5ShAIS6GmAkkgocQBYRMU=
Subject: [PATCH 0/6] MTD: Many fixes and preparation for SmartMedia support
 in nand subsystem
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 17:56:21 +0200
Message-ID: <1264175781.24012.42.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series add few fixes and changes to nand subsystem.

First patch, fixes the MTD_OOB_PLACE support in nand.
I want to use ->read_oob to read both raw oob and data and use ecc.
MTD_OOB_PLACE should do that, but due to a wrong check it will refuse to
work.

Second patch, probably the most important patch in this series.
I changed behavier of MTD_OOB_RAW to match the one of MTD_OOB_PLACE
minus ecc validation.
This way it is easy to use both modes in same code.
This mode is only used in one place, in scan_read_raw in nand_bbt.c
I edited this function to achieve exactly same effect as was before.

Third patch is another bugfix that I need to be able to write several
pages in one go. ->write_oob should do that, but it was incorrectly
implemented.
I need this and former patch to add support for 256 byte nand chips in
the smartmedia FTL very elegantly.

Fourth patch exports few functions from nand_base.c, so one can write
custom ->block_mark_bad, and ->block_is_bad functions.
I use these functions in next patch.

Fifth patch, adds small helper module for nand drivers for SmartMedia/xD
readers. It contains bad block handlers and ecc layer.

And last patch, adds some workarounds to nand core to make xD work with
it.

It adds new ID table (which is similiar to current ID table, but
dfferent in that it has IDS for readonly SmartMedia devices, and it has
special settings for new xD cards that share ID with regular nand
devices, but unfortunely don't report proper information in READ ID
command, and have other problems.)

It also adds a workaround for broken writeprotect status.
Older smartmedia devices had a special seal for writeprotect, aka a
additional connector. This should be handled by nand driver itself.
Newer xD cards have no write protect support at all.

Best regards,
Maxim Levitsky

