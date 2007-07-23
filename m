Return-Path: <linux-kernel-owner+w=401wt.eu-S1757782AbXGWHhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbXGWHhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 03:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbXGWHhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 03:37:06 -0400
Received: from www.osadl.org ([213.239.205.134]:35726 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752227AbXGWHhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 03:37:05 -0400
From: =?utf-8?q?Hans-J=C3=BCrgen_Koch?= <hjk@linutronix.de>
Organization: Linutronix
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: drivers/hwmon/lm93.c: array overruns
Date: Mon, 23 Jul 2007 09:36:57 +0200
User-Agent: KMail/1.9.5
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
References: <20070723005453.GS26212@stusta.de>
In-Reply-To: <20070723005453.GS26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707230936.58135.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 23 Juli 2007 02:54 schrieb Adrian Bunk:
> The Coverity checker spotted the following array overruns
> in drivers/hwmon/lm93.c:
> 
> <--  snip  -->
> 
> ...
> struct lm93_data {
> ...
>         struct {
>                 u8 min;
>                 u8 max;
>         } temp_lim[3];
> ...
> };
> ...
> static void lm93_update_client_common(struct lm93_data *data,
>                                       struct i2c_client *client)
> {
> ...
>         for (i = 0; i < 4; i++) {
>                 data->temp_lim[i].min =
>                         lm93_read_byte(client, LM93_REG_TEMP_MIN(i));
>                 data->temp_lim[i].max =
>                         lm93_read_byte(client, LM93_REG_TEMP_MAX(i));
>         }
> ...
> 
> <--  snip  -->

This patch should fix it. Thanks a lot, Adrian!

----
This fixes an array overflow bug. We have 4 pairs of min/max temperature 
limits, not 3.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

--
Index: linux-2.6.23-rc/drivers/hwmon/lm93.c
===================================================================
--- linux-2.6.23-rc.orig/drivers/hwmon/lm93.c	2007-07-23 09:22:56.000000000 +0200
+++ linux-2.6.23-rc/drivers/hwmon/lm93.c	2007-07-23 09:29:37.000000000 +0200
@@ -234,7 +234,7 @@
 	struct {
 		u8 min;
 		u8 max;
-	} temp_lim[3];
+	} temp_lim[4];
 
 	/* vin1 - vin16: low and high limits */
 	struct {



