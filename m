Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbZCOAb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbZCOAb0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 20:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbZCOAbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 20:31:11 -0400
Received: from n64.bullet.mail.sp1.yahoo.com ([98.136.44.189]:39590 "HELO
	n64.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753624AbZCOAbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 20:31:07 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Mar 2009 20:31:07 EDT
X-Yahoo-Newman-Id: 878729.56400.bm@omp418.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=EsWRh+hYcC63ezwuklecMRnJrmzYfsxeQY72I5FpdNqQallE1htBcAbnGutWVsviFbOJTkUTvk5FVoutANeNJIW6eYx0hRu6J+b/aehKkN6vq+6fj6qZdq/qFNm1TBnnRXfs0cmNlL/dVxUkMmisJXqTBW6ORpuu04U0lKRLmT8=  ;
X-YMail-OSG: DS7lbJEVM1nRNY5EjNOu2OI_RLUvBjU2FaHOVLII5AzVhE6zBcGIsBp5nE8pkYGJYJy419OucJFhTa9n5HwdUANDZg3QTVXpUP_DiNEb4M0V0.lVZfOxLxyn5xIsadRIwhn2P2qyM77hUmuoHo54TmsLWCnlnHfESkZnDIKH.zVQ2F1knByOsH5fydwIMzHqrSUnhnHyCBjdvR_hJPgEqGAg9Is2SHX42La0Gg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [patch 2.6.29-rc8 regulator-next] regulator: init fixes (v4)
Date: Sat, 14 Mar 2009 17:25:35 -0700
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>, OMAP <linux-omap@vger.kernel.org>
References: <200903111743.34708.david-b@pacbell.net> <200903111932.16317.david-b@pacbell.net> <20090312120119.GB24376@sirena.org.uk>
In-Reply-To: <20090312120119.GB24376@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903141725.35541.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Make the regulator setup code cope more consistently with
regulators left enabled by the bootloader ... making it act
as if the "boot_on" flag were being set by the boot loader
(as needed) instead of by Linux board init code (always).

This eliminates the other half of the bug whereby regulators
that were enabled during the boot sequence would be enabled
with enable count of zero ... preventing regulator_disable()
from working when called from drivers.  (The first half was
fixed by the "regulator: refcount fixes" patch, and related
specifically to the "boot_on" flag.)

One open issue involves systems that need to force a regulator
off at boot time -- the converse of today's "boot_on" flag. 
There can be arbitrarily long delays between system startup
and when a driver can be loaded to turn off the regulator,
during which power is being wasted.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/regulator/core.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -815,6 +815,14 @@ static int set_machine_constraints(struc
 			goto out;
 		}
 		rdev->use_count = 1;
+	} else if (ops->is_enabled) {
+		/* ... if the bootloader left it on, drivers need a
+		 * nonzero enable count else it can't be disabled.
+		 */
+		ret = ops->is_enabled(rdev);
+		if (ret > 0)
+			rdev->use_count = 1;
+		ret = 0;
 	}
 
 	print_constraints(rdev);

