Return-Path: <linux-kernel-owner+w=401wt.eu-S1759948AbYGON0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948AbYGON0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 09:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756225AbYGON0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 09:26:20 -0400
Received: from lopsy-lu.misterjones.org ([62.4.18.26]:43770 "EHLO
	young-lust.wild-wind.fr.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756133AbYGON0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 09:26:19 -0400
Message-ID: <487CA577.5090602@misterjones.org>
Date: Tue, 15 Jul 2008 15:26:15 +0200
From: Marc Zyngier <maz@misterjones.org>
Organization: Metropolis -- Nowhere
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-kernel@vger.kernel.org
Subject: [BUG][PATCH][pcmcia] cisinfo_t removal prevents card detection
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 81.255.32.141
X-SA-Exim-Rcpt-To: linux@dominikbrodowski.net, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on young-lust.wild-wind.fr.eu.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dominik,

The commit

c5081d5f4775b2a3f858f91151bbf9163e473075 (pcmcia: simplify pccard_validate_cis)

that entered mainline yesterday introduced a bug that prevents card detection
on my platform (PXA255 based), and possibly others :

   @@ -1490,11 +1491,13 @@ int pccard_validate_cis(struct pcmcia_socket *s, unsigned int function, cisinfo_
               ((tuple->TupleCode > 0x90) && (tuple->TupleCode < 0xff)))
               reserved++;
        }
   -    if ((info->Chains == MAX_TUPLES) || (reserved > 5) ||
   -       ((!dev_ok || !ident_ok) && (info->Chains > 10)))
   -       info->Chains = 0;
   +    if ((count) || (reserved > 5) ||
   +       ((!dev_ok || !ident_ok) && (count > 10)))
   +       count = 0;

Since count starts at 1, condition is now always true, and count then
reset to 0. Restoring the comparaison to MAX_TUPLES makes everybody
happy...

	M.

Signed-off-by: Marc Zyngier <marc.zyngier@altran.com>

diff --git a/drivers/pcmcia/cistpl.c b/drivers/pcmcia/cistpl.c
index 9fcff0c..65129b5 100644
--- a/drivers/pcmcia/cistpl.c
+++ b/drivers/pcmcia/cistpl.c
@@ -1490,7 +1490,7 @@ int pccard_validate_cis(struct pcmcia_socket *s, unsigned int function, unsigned
  	    ((tuple->TupleCode > 0x90) && (tuple->TupleCode < 0xff)))
  	    reserved++;
      }
-    if ((count) || (reserved > 5) ||
+    if ((count == MAX_TUPLES) || (reserved > 5) ||
  	((!dev_ok || !ident_ok) && (count > 10)))
  	count = 0;

-- 
A rat a day keeps the plague away.
