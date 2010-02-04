Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab0BDGq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 01:46:59 -0500
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:50804 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753571Ab0BDGqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 01:46:19 -0500
Date: Wed, 03 Feb 2010 23:46:17 -0700
From: dougthompson@xmission.com
To: ptyser@xes-inc.com, bluesmoke-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/7] edac: mpc85xx fix bad page calculation
Message-ID: <4b6a6d39.Mk9/VOZRKY6QhvRO%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Tyser <ptyser@xes-inc.com>

Commit b4846251727a38a7f248e41308c060995371dd05 accidentally broke how a
chip select's first and last page addresses are calculated.  The page
addresses are being shifted too far right by PAGE_SHIFT.  This results
in errors such as:

  EDAC MPC85xx MC1: Err addr: 0x003075c0
  EDAC MPC85xx MC1: PFN: 0x00000307
  EDAC MPC85xx MC1: PFN out of range!
  EDAC MC1: INTERNAL ERROR: row out of range (4 >= 4)
  EDAC MC1: CE - no information available: INTERNAL ERROR

The vale of PAGE_SHIFT is already being taken into consideration during
the calculation of the 'start' and 'end' variables, thus it is not
necessary to account for it again when setting a chip select's first and
last page address.

Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
---
 drivers/edac/mpc85xx_edac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.33-rc4/drivers/edac/mpc85xx_edac.c
===================================================================
--- linux-2.6.33-rc4.orig/drivers/edac/mpc85xx_edac.c	2010-01-13 00:15:58.000000000 -0700
+++ linux-2.6.33-rc4/drivers/edac/mpc85xx_edac.c	2010-01-13 00:16:00.000000000 -0700
@@ -804,8 +804,8 @@ static void __devinit mpc85xx_init_csrow
 		end   <<= (24 - PAGE_SHIFT);
 		end    |= (1 << (24 - PAGE_SHIFT)) - 1;
 
-		csrow->first_page = start >> PAGE_SHIFT;
-		csrow->last_page = end >> PAGE_SHIFT;
+		csrow->first_page = start;
+		csrow->last_page = end;
 		csrow->nr_pages = end + 1 - start;
 		csrow->grain = 8;
 		csrow->mtype = mtype;
