Return-Path: <linux-kernel-owner+w=401wt.eu-S933541AbYD3Vxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541AbYD3Vxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760442AbYD3VxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:53:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757024AbYD3VxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:53:22 -0400
Date: Wed, 30 Apr 2008 14:53:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@queued.net>
Cc: cbou@mail.ru, linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 2/4] power_supply: add eeprom dump file to
 olpc_battery's sysfs
Message-Id: <20080430145311.a6c35ed7.akpm@linux-foundation.org>
In-Reply-To: <20080430163008.4be68cb3@ephemeral>
References: <20080430163008.4be68cb3@ephemeral>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 16:30:08 -0400
Andres Salomon <dilinger@queued.net> wrote:

> 
> This allows you to dump 0x60 bytes from the battery's EEPROM (starting
> at address 0x20).  Note that it does an EC command for each byte, so
> it's pretty slow.  OTOH, if you want to grab just a single byte from
> somewhere in the EEPROM, you can do something like:
> 
> dd bs=1 count=1 skip=16 if=/sys/class/power_supply/olpc-battery/eeprom | od -x
> 
> Userspace battery collection/logging information needs this.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> ---
>  drivers/power/olpc_battery.c |   49 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 49 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
> index 9d9dd09..e5ecf27 100644
> --- a/drivers/power/olpc_battery.c
> +++ b/drivers/power/olpc_battery.c
> @@ -283,6 +283,48 @@ static enum power_supply_property olpc_bat_props[] = {
>  	POWER_SUPPLY_PROP_SERIAL_NUMBER,
>  };
>  
> +/* EEPROM reading goes completely around the power_supply API, sadly */
> +
> +#define EEPROM_START	0x20
> +#define EEPROM_END	0x80
> +#define EEPROM_SIZE	(EEPROM_END - EEPROM_START)
> +
> +static ssize_t olpc_bat_eeprom_read(struct kobject *kobj,
> +		struct bin_attribute *attr, char *buf, loff_t off, size_t count)
> +{
> +	uint8_t ec_byte;
> +	int ret, end;
> +
> +	if (off >= EEPROM_SIZE)
> +		return 0;

loff_t is signed.

Happily, the VFS prevents negative loff_t's from being passed into read()
handlers.

> +	if (off + count > EEPROM_SIZE)
> +		count = EEPROM_SIZE - off;

But the vfs doesn't check for (offset+len) going negative (I think?)

However you got lucky (or smart ;)) - size_t is unsigned so the comparison
will dtrt.

Plus the first `if' will prevent us getting here with huge-nearly-negative
`off'.

This stuff is harder than it should be :(

