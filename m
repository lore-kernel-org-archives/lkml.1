Return-Path: <linux-kernel-owner+w=401wt.eu-S1752882AbXKVKmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbXKVKmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 05:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbXKVKlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 05:41:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64621 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbXKVKlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 05:41:52 -0500
Subject: MMC/SDIO sub-system: block mode versus byte mode
From: Dean Jenkins <djenkins@mvista.co.uk>
Reply-To: djenkins@mvista.co.uk
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: MontaVista
Date: Thu, 22 Nov 2007 10:41:43 +0000
Message-Id: <1195728103.20691.125.camel@libdev3.libertesoft.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.0.1.el5) 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18kGn1rIEXwHeilrgym0bAAIW6d9vYwsUAZnYb
 MY9KoyCToIT+697g31ZWkxWm4O35MzOgwsCMQeKNDG/9wZYgyS
 w6wtwKbsu5EJd+Y3c0R3Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

I've been checking my SDIO CMD53 data transfers and I notice the
following:

block size = 256 bytes for my SDIO card.

transfers of 256 bytes uses byte mode ( I expected block mode )
transfers of 512 bytes uses block mode ( because blocks = 2 )

>From the SD spec a single block transfer seems to be valid.

I notice the function mmc_io_rw_extended() in sdio_ops.c seems to select
byte mode when the transfer size is 512 or less when the blocks
parameter variable is 1. In fact blocks is never 0.

Therefore is this a feature or a bug that prevents 256 bytes being sent
in block mode when it is a single complete 1 block of data ?

If it is a bug then I suggest the sdio_io_rw_ext_helper() in sdio_io.c
be able to select byte mode by setting blocks to 0 and then blocks can
be set to 1 to select block mode for a single block.

Have I missed something ?

Technically, there is a bug in sdio_io_rw_ext_helper() in sdio_io.c

211		while (remainder > func->cur_blksize) {

should be, = missing

211		while (remainder >= func->cur_blksize) {

however the resulting call to mmc_io_rw_extended() is the same as blocks
= 1 for both the "block mode" while loop (with the "fix") and the "byte
mode" while loop (without the "fix"). The "byte mode" while loop has a
hard coded value of 1 for the blocks parameter. So the bug is masked. As
I said above, I think the "byte mode" should use a value of 0 for the
blocks parameter.

What do you think ?

Regards,
Dean. 

-- 
Dean Jenkins
Embedded Software Engineer
MontaVista Software (UK)
Professional Services Division

