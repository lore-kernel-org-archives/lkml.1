Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbXJZQCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbXJZQCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763109AbXJZQCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:02:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35445 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760376AbXJZQCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:02:14 -0400
Date: Fri, 26 Oct 2007 16:56:48 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Regression: commit "ide: constify struct ide_port_info" causes breakage
Message-ID: <20071026155648.GB4321@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 8562043606430185cad26d085d46adcc7ad67fd1 is broken, causing:

  CC      drivers/ide/pci/cmd64x.o
  CC      drivers/ide/pci/hpt366.o
drivers/ide/pci/hpt366.c:1428: error: hpt366_chipsets causes a section type conflict

and therefore should be reverted.

The problem arises because hpt366 has other data marked with __devinitdata,
so the compiler tries to define the initdata section with read-write
attributes at one point, and read-only attributes when encountering the
const-but-devinitdata declaration:

static struct hpt_info hpt36x __devinitdata = {
static struct hpt_info hpt370 __devinitdata = {
static struct hpt_info hpt370a __devinitdata = {
...
static const struct ide_port_info hpt366_chipsets[] __devinitdata = {

If we want ide_port_info to be read-only initdata, then we need
__devroinitdata and __roinitdata tags.

Note: it doesn't show up in cmd64x.c because that file contains no other
data marked as initdata or devinitdata.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
