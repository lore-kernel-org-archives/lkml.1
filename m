Return-Path: <linux-kernel-owner+w=401wt.eu-S1759439AbXGXIKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439AbXGXIKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbXGXIKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:10:23 -0400
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:64678 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752163AbXGXIKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:10:21 -0400
Date: Tue, 24 Jul 2007 10:10:20 +0200
From: Jean Delvare <khali@linux-fr.org>
To: =?ISO-8859-1?B?SGFucy1K/HJnZW4=?= Koch <hjk@linutronix.de>
Cc: Adrian Bunk <bunk@stusta.de>, "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] drivers/hwmon/lm93.c: array overruns
Message-ID: <20070724101020.0f1bf458@hyperion.delvare>
In-Reply-To: <200707230936.58135.hjk@linutronix.de>
References: <20070723005453.GS26212@stusta.de>
	<200707230936.58135.hjk@linutronix.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Mon, 23 Jul 2007 09:36:57 +0200, Hans-Jürgen Koch wrote:
> Am Montag 23 Juli 2007 02:54 schrieb Adrian Bunk:
> > The Coverity checker spotted the following array overruns
> > in drivers/hwmon/lm93.c:
> > 
> > <--  snip  -->
> > 
> > ...
> > struct lm93_data {
> > ...
> >         struct {
> >                 u8 min;
> >                 u8 max;
> >         } temp_lim[3];
> > ...
> > };
> > ...
> > static void lm93_update_client_common(struct lm93_data *data,
> >                                       struct i2c_client *client)
> > {
> > ...
> >         for (i = 0; i < 4; i++) {
> >                 data->temp_lim[i].min =
> >                         lm93_read_byte(client, LM93_REG_TEMP_MIN(i));
> >                 data->temp_lim[i].max =
> >                         lm93_read_byte(client, LM93_REG_TEMP_MAX(i));
> >         }
> > ...
> > 
> > <--  snip  -->
> 
> This patch should fix it. Thanks a lot, Adrian!
> 
> ----
> This fixes an array overflow bug. We have 4 pairs of min/max temperature 
> limits, not 3.
> 
> Signed-off-by: Hans J. Koch <hjk@linutronix.de>
> 
> --
> Index: linux-2.6.23-rc/drivers/hwmon/lm93.c
> ===================================================================
> --- linux-2.6.23-rc.orig/drivers/hwmon/lm93.c	2007-07-23 09:22:56.000000000 +0200
> +++ linux-2.6.23-rc/drivers/hwmon/lm93.c	2007-07-23 09:29:37.000000000 +0200
> @@ -234,7 +234,7 @@
>  	struct {
>  		u8 min;
>  		u8 max;
> -	} temp_lim[3];
> +	} temp_lim[4];
>  
>  	/* vin1 - vin16: low and high limits */
>  	struct {

This will do as a quick fix, so:

Acked-by: Jean Delvare <khali@linux-fr.org>

However, I see that temp4 (which isn't a real temperature channel) is
not exposed in sysfs. Reading and storing register values you never use
doesn't seem particularly interesting, so something needs to be done
here: either drop support for temp4 entirely, or expose the temp4
values in sysfs.

-- 
Jean Delvare
