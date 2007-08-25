Return-Path: <linux-kernel-owner+w=401wt.eu-S1762767AbXHYQsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762767AbXHYQsU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 12:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbXHYQsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 12:48:13 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:42491 "EHLO
	viefep24-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754370AbXHYQsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 12:48:12 -0400
From: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH] IdealTEK URTC1000 support for usbtouchscreen
Date: Sat, 25 Aug 2007 18:48:13 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200708232355.28628.linux@rainbow-software.org>
In-Reply-To: <200708232355.28628.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708251848.14866.daniel.ritz-ml@swissonline.ch>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	[ please don't send patches as attachment.. ]

On Thursday 23 August 2007 23:55:28 Ondrej Zary wrote:
> Hello,
> this patch adds support for IdealTEK URTC1000 touchscreen controllers.
> 

looks good, just a few minor things...

> Documentation can be downloaded at 
> http://projects.tbmn.org/cgi-bin/trac.cgi/wiki/urtc-1000
> 
> I'm not sure that the code is correct, especially because the .rept_size is 
> set to 8 bytes. I've tried 5, 6, 7, 8, 12 and 16. Only 8 and 16 work. Other 
> values resulted in -EOVERFLOW in usbtouch_irq() and infinite retries.
> 

8 is fine.

> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> 

+       if (pkt[0] == 1) {
+               /* response string - ignore it */
+               char *end = strchr(pkt, '\r');
+               end[0] = 0;
+               dbg("IdealTEK response: %s\n", &pkt[1]);
+               return 0;

just remove this block

+       } else if ((pkt[0] & 0x98) == 0x88) {
+               /* touch data in IdealTEK mode */
+               dev->x = (pkt[1] << 5) | (pkt[2] >> 2);
+               dev->y = (pkt[3] << 5) | (pkt[4] >> 2);
+               dev->touch = (pkt[0] & 0x40) ? 1 : 0;
+               return 1;
+       } else if ((pkt[0] & 0x98) == 0x98) {
+               /* touch data in MT emulation mode */
+               dev->x = (pkt[2] << 5) | (pkt[1] >> 2);
+               dev->y = (pkt[4] << 5) | (pkt[3] >> 2);
+               dev->touch = (pkt[0] & 0x40) ? 1 : 0;
+               return 1;
+       } else {
+               dbg("IdealTEK: invalid data\n");
+               return 0;
+       }

and this one as well...and do a 'return 0;' as last statement
outside the 'if'

+               .process_pkt    = usbtouch_process_multi,

so you're using the support for packets split across two
URBs? is it required? if so, you have to ensure that the function
is compiled in. ie. extend this statement in the driver with your
config option:

#if defined(CONFIG_TOUCHSCREEN_USB_EGALAX) || defined(CONFIG_TOUCHSCREEN_USB_ETURBO)
#define MULTI_PACKET
#endif

the rest looks fine.

rgds
-daniel
