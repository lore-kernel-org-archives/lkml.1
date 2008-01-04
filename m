Return-Path: <linux-kernel-owner+w=401wt.eu-S1752091AbYADKOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbYADKOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 05:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbYADKOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 05:14:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54574
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750799AbYADKOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 05:14:38 -0500
Date: Fri, 04 Jan 2008 02:14:37 -0800 (PST)
Message-Id: <20080104.021437.238302886.davem@davemloft.net>
To: matthias@goebl.net
Cc: linux-kernel@vger.kernel.org, kkeil@suse.de, kai.germaschewski@gmx.de
Subject: Re: [PATCH] isdn/i4l: Fix DLE handling for i4l-audio
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080103220003.GU19071@night.goebl.net>
References: <20080103220003.GU19071@night.goebl.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthias Goebl <matthias@goebl.net>
Date: Thu, 3 Jan 2008 23:00:03 +0100

> --- linux-2.6.23.12.orig/drivers/isdn/i4l/isdn_tty.c	2007-12-22 21:13:49.000000000 +0100
> +++ linux-2.6.23.12/drivers/isdn/i4l/isdn_tty.c	2007-12-26 11:37:18.000000000 +0100
> @@ -85,6 +85,8 @@
>  								tty_insert_flip_char(tty, DLE, 0);
>  							tty_insert_flip_char(tty, *dp++, 0);
>  						}
> +						if (*dp == DLE)
> +							tty_insert_flip_char(tty, DLE, 0);
>  						last = *dp;
>  					} else {
>  #endif

I'm not sure this part is correct.

Here, *dp will be assigned to 'last'.

The rest of the code (after the else block) then reads:

					if (info->emu.mdmreg[REG_CPPP] & BIT_CPPP)
						tty_insert_flip_char(tty, last, 0xFF);
					else
						tty_insert_flip_char(tty, last, TTY_NORMAL);

which should push that character out to the TTY.

With your change we will push a DLE out twice in such a case,
and that doesn't seem right.

