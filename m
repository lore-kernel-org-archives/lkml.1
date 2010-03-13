Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935330Ab0CMAak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:30:40 -0500
Received: from kroah.org ([198.145.64.141]:46574 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935272Ab0CMAa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:30:29 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:05 2010
Message-Id: <20100313002705.491180729@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:25:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Richard Guenther <rguenther@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [003/145] V4L/DVB: dvb: l64781.ko broken with gcc 4.5
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Richard Guenther <rguenther@suse.de>

commit c1db53b36633e6a7511dbec7c372f01a31528f0c upstream.

I'm trying to fix it on the GCC side (PR43007), but the module is
quite stupid in using ULL constants to operate on u32 values:

static int apply_frontend_param (struct dvb_frontend* fe, struct
dvb_frontend_parameters *param)
{
...
 static const u32 ppm = 8000;
 u32 spi_bias;
...

 spi_bias *= 1000ULL;
 spi_bias /= 1000ULL + ppm/1000;

which causes current GCC 4.5 to emit calls to __udivdi3 for i?86 again.

This patch fixes this issue.

Signed-off-by: Richard Guenther <rguenther@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

---
 drivers/media/dvb/frontends/l64781.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/dvb/frontends/l64781.c
+++ b/drivers/media/dvb/frontends/l64781.c
@@ -192,8 +192,8 @@ static int apply_frontend_param (struct
 	spi_bias *= qam_tab[p->constellation];
 	spi_bias /= p->code_rate_HP + 1;
 	spi_bias /= (guard_tab[p->guard_interval] + 32);
-	spi_bias *= 1000ULL;
-	spi_bias /= 1000ULL + ppm/1000;
+	spi_bias *= 1000;
+	spi_bias /= 1000 + ppm/1000;
 	spi_bias *= p->code_rate_HP;
 
 	val0x04 = (p->transmission_mode << 2) | p->guard_interval;


