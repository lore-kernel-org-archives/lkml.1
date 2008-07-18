Return-Path: <linux-kernel-owner+w=401wt.eu-S1757136AbYGRJR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbYGRJR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbYGRJRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:17:21 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:54219 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbYGRJRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:17:20 -0400
Message-ID: <48806017.1040307@keyaccess.nl>
Date: Fri, 18 Jul 2008 11:19:19 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Ingo Molnar <mingo@elte.hu>, Jaroslav Kysela <perex@perex.cz>,
       LKML <linux-kernel@vger.kernel.org>,
       ALSA development <alsa-devel@alsa-project.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rene Herman <rene.herman@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [boot crash, bisected] in 9f240a55 "ALSA: opti93x: use cs4231
 lib"
References: <Pine.LNX.4.61.0807141105150.7676@tm8103-a.perex-int.cz>	<20080717170657.GA14593@elte.hu> <s5h3am8jqvy.wl%tiwai@suse.de> <487F9B9B.2010905@keyaccess.nl> <487F9FA1.7020101@keyaccess.nl>
In-Reply-To: <487F9FA1.7020101@keyaccess.nl>
Content-Type: multipart/mixed;
 boundary="------------070007060903020506000905"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070007060903020506000905
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 17-07-08 21:38, Rene Herman wrote:

> On 17-07-08 21:20, Rene Herman wrote:
> 
>> On 17-07-08 20:40, Takashi Iwai wrote:
>>
>>> Could you try the patch below?
>>
>> No, please hang on, it's much simpler. Above commit isn't actually 
>> itself guilty. Have a patch ready, but am testing a bit.
> 
> I retract that. Your patch should fix things.

It does. Acked/Tested-by: Rene Herman <rene.herman@gmail.com>

> I would like to place something on top to make the init isa/pnp choice 
> look more generic but I'll submit that tomorrow.

This bug was uncovered by !CONFIG_PNP and we had trouble in this driver 
due to that before so was rewriting the init to be a generic multi-card 
ALSA init but, actually, not much point.

The hardware fundamentally doesn't support more than one card per system 
due to the fixed chip->mc_base and the bug was in this case not _caused_ 
but only uncovered by !CONFIG_PNP (it triggers for CONFIG_PNP after 
supplying "isapnp=0" as a module param) so I'll just wait for the next 
time this ifdeffed together mess breaks on !CONFIG_PNP to make the init 
look generic ;-)

In fact, in the meantime I'll look at splitting 92x and 93x again. It's 
much better now that Krzysztof made it use the generic library code but 
I still hate this driver. It's also poking at ports without being told 
something is there by either system or user.

Trivial remainder of init rewrite that's still applicable:

Rene.


--------------070007060903020506000905
Content-Type: text/plain;
 name="0001-ALSA-opti9xx-no-isapnp-param-for-CONFIG_PNP.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-ALSA-opti9xx-no-isapnp-param-for-CONFIG_PNP.patch"

>From fc64af262b44d41cd45fbe96be301e4662ba1c1a Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Fri, 18 Jul 2008 11:15:12 +0200
Subject: [PATCH] ALSA: opti9xx: no isapnp param for !CONFIG_PNP

"isapnp" needs CONFIG_PNP to be useful.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
---
 sound/isa/opti9xx/opti92x-ad1848.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/sound/isa/opti9xx/opti92x-ad1848.c b/sound/isa/opti9xx/opti92x-ad1848.c
index e5d9028..5dfead9 100644
--- a/sound/isa/opti9xx/opti92x-ad1848.c
+++ b/sound/isa/opti9xx/opti92x-ad1848.c
@@ -68,7 +68,9 @@ MODULE_SUPPORTED_DEVICE("{{OPTi,82C924 (AD1848)},"
 static int index = SNDRV_DEFAULT_IDX1;	/* Index 0-MAX */
 static char *id = SNDRV_DEFAULT_STR1;		/* ID for this card */
 //static int enable = SNDRV_DEFAULT_ENABLE1;	/* Enable this card */
+#ifdef CONFIG_PNP
 static int isapnp = 1;			/* Enable ISA PnP detection */
+#endif
 static long port = SNDRV_DEFAULT_PORT1; 	/* 0x530,0xe80,0xf40,0x604 */
 static long mpu_port = SNDRV_DEFAULT_PORT1;	/* 0x300,0x310,0x320,0x330 */
 static long fm_port = SNDRV_DEFAULT_PORT1;	/* 0x388 */
@@ -85,8 +87,10 @@ module_param(id, charp, 0444);
 MODULE_PARM_DESC(id, "ID string for opti9xx based soundcard.");
 //module_param(enable, bool, 0444);
 //MODULE_PARM_DESC(enable, "Enable opti9xx soundcard.");
+#ifdef CONFIG_PNP
 module_param(isapnp, bool, 0444);
 MODULE_PARM_DESC(isapnp, "Enable ISA PnP detection for specified soundcard.");
+#endif
 module_param(port, long, 0444);
 MODULE_PARM_DESC(port, "WSS port # for opti9xx driver.");
 module_param(mpu_port, long, 0444);
-- 
1.5.5


--------------070007060903020506000905--
