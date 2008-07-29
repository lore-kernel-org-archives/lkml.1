Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbYG2XW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbYG2XW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 19:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbYG2XWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 19:22:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754379AbYG2XWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 19:22:16 -0400
Date: Tue, 29 Jul 2008 16:21:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Fries <david@fries.net>
Cc: linux-kernel@vger.kernel.org, johnpol@2ka.mipt.ru
Subject: Re: [PATCH 5/30] W1: feature, enable hardware strong pullup
Message-Id: <20080729162130.8ab6de8f.akpm@linux-foundation.org>
In-Reply-To: <20080729021451.GE24452@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
	<20080729021451.GE24452@spacedout.fries.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 21:14:51 -0500
David Fries <david@fries.net> wrote:

> Add a strong pullup option to the w1 system.  This supplies extra
> power for parasite powered devices.  There is a w1_master_pullup sysfs
> entry and enable_pullup module parameter to enable or disable the
> strong pullup.
> 
> The one wire bus requires at a minimum one wire and ground.  The
> common wire is used for sending and receiving data as well as
> supplying power to devices that are parasite powered of which
> temperature sensors can be one example.  The bus must be idle and left
> high while a temperature conversion is in progress, in addition the
> normal pullup resister on larger networks or even higher temperatures
> might not supply enough power.  The pullup resister can't provide too
> much pullup current, because devices need to pull the bus down to
> write a value.  This enables the strong pullup for supported hardware,
> which can supply more current when requested.  Unsupported hardware
> will just delay with the bus high.
> 
> The hardware USB 2490 one wire bus master has a bit on some commands
> which will enable the strong pullup as soon as the command finishes
> executing.  To use strong pullup, call the new w1_next_pullup function
> to register the duration.  The next write command will call set_pullup
> before sending the data, and reset the duration to zero once it
> returns.
> 
> Signed-off-by: David Fries <david@fries.net>
> Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> ---
>  drivers/w1/w1.c     |   30 ++++++++++++++++++++++
>  drivers/w1/w1.h     |   12 +++++++++
>  drivers/w1/w1_int.c |   16 ++++++++++++
>  drivers/w1/w1_io.c  |   68 ++++++++++++++++++++++++++++++++++++++++++++++++---
>  4 files changed, 122 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
> index 9b5c117..76274ae 100644
> --- a/drivers/w1/w1.c
> +++ b/drivers/w1/w1.c
> @@ -270,6 +270,34 @@ static ssize_t w1_master_attribute_show_search(struct device *dev,
>  	return count;
>  }
>  
> +static ssize_t w1_master_attribute_store_pullup(struct device *dev,
> +						struct device_attribute *attr,
> +						const char *buf, size_t count)
> +{
> +	struct w1_master *md = dev_to_w1_master(dev);
> +
> +	mutex_lock(&md->mutex);
> +	md->enable_pullup = simple_strtol(buf, NULL, 0);
> +	mutex_unlock(&md->mutex);
> +	wake_up_process(md->thread);
> +
> +	return count;
> +}

checkpatch says:

WARNING: consider using strict_strtol in preference to simple_strtol
#49: FILE: drivers/w1/w1.c:280:
+       md->enable_pullup = simple_strtol(buf, NULL, 0);

for good reasons.  The code which you have implemented will treat the
value "45foo" as 45, which is sloppy.  strict_strtoul() (if
handled appropriately) will perform the necessary checking.

A simple_strtol->strict_strtol conversion is a non-backward-compatible
userspace interface change (albeit a pretty non-risky one) and should
be done with caution.

Please use checkpatch.
