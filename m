Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbYFATZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbYFATZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 15:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYFATZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 15:25:13 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:42985 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbYFATZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 15:25:11 -0400
Message-ID: <4842F857.9060309@keyaccess.nl>
Date: Sun, 01 Jun 2008 21:28:23 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [patch 00/15] PNP: convert resource options to unified dynamic
 list, v1
References: <20080530224853.976744229@ldl.fc.hp.com>
In-Reply-To: <20080530224853.976744229@ldl.fc.hp.com>
Content-Type: multipart/mixed;
 boundary="------------020704090009030109060604"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020704090009030109060604
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 31-05-08 00:48, Bjorn Helgaas wrote:

> This patch series converts the PNP resource option structures
> to a unified linked list.  This preserves resource order, which
> is important for some devices.  There's more detail in the
> comments for the last patch.
> 
> Any comments would be welcome.
> 
> This depends on some patches that are in -mm, but not yet
> upstream.  In mmotm, these would probably go after
> pnp-dont-sort-by-type-in-sys-resources.patch

Will look at this in more detail but as first testing feedback -- I need 
this on top.

Both ISAPnP and PnPBIOS for some or other reason set the priority to 
0x100 | prio after which that 0x100 is immediately masked of again in 
pnp_build_option() leaving just the prio. Your new scheme reserves 16 
bits for the priority though meaning the 0x100 survives causing it to be 
considered "invalid" by at least pnp_option_priority_name() for example.

There cannot be any currently valid reason for the 0x100 it seems given 
that it's immediately masked of again in pnp_build_option() so let's 
just get rid of it...

--------------020704090009030109060604
Content-Type: text/plain;
 name="pnp_priority.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pnp_priority.diff"

diff --git a/drivers/pnp/isapnp/core.c b/drivers/pnp/isapnp/core.c
index d4c6b19..7556887 100644
--- a/drivers/pnp/isapnp/core.c
+++ b/drivers/pnp/isapnp/core.c
@@ -648,10 +648,10 @@ static int __init isapnp_create_device(struct pnp_card *card,
 		case _STAG_STARTDEP:
 			if (size > 1)
 				goto __skip;
-			priority = 0x100 | PNP_RES_PRIORITY_ACCEPTABLE;
+			priority = PNP_RES_PRIORITY_ACCEPTABLE;
 			if (size > 0) {
 				isapnp_peek(tmp, size);
-				priority = 0x100 | tmp[0];
+				priority = tmp[0];
 				size = 0;
 			}
 			option_flags = pnp_dependent_option(dev, priority);
diff --git a/drivers/pnp/pnpbios/rsparser.c b/drivers/pnp/pnpbios/rsparser.c
index e0bea09..a6c9539 100644
--- a/drivers/pnp/pnpbios/rsparser.c
+++ b/drivers/pnp/pnpbios/rsparser.c
@@ -393,9 +393,9 @@ pnpbios_parse_resource_option_data(unsigned char *p, unsigned char *end,
 		case SMALL_TAG_STARTDEP:
 			if (len > 1)
 				goto len_err;
-			priority = 0x100 | PNP_RES_PRIORITY_ACCEPTABLE;
+			priority = PNP_RES_PRIORITY_ACCEPTABLE;
 			if (len > 0)
-				priority = 0x100 | p[1];
+				priority = p[1];
 			option_flags = pnp_dependent_option(dev, priority);
 			break;
 

--------------020704090009030109060604--
