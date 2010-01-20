Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043Ab0ATTTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab0ATTTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 14:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971Ab0ATTTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 14:19:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:1093 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab0ATTTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 14:19:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uxQ7l7IVg6lmxMx50gHQauxCf2Hbq0Q7jxLdX9bX4NIQijTNAlpzXaaeVD1Npo9jKn
         qP6VbZ2MhBBrCr9GOkRBjG9tz6X7HGVdVJlAsGCSF7tHq2oxI+vgcqI52imjqwpfMNem
         dBmE5DGlbQ+HngQPO38aA9yv5XiuiXj/wZPDc=
Message-ID: <4B575621.9050204@gmail.com>
Date: Wed, 20 Jan 2010 11:14:41 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Bastien Nocera <hadess@hadess.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
References: <1264011793.1735.3683.camel@localhost.localdomain>
In-Reply-To: <1264011793.1735.3683.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/10 10:23, Bastien Nocera wrote:
> As those computers never had any i8042 controllers, and the
> current lookup code could potentially lock up/hang/wait for
> timeout for long periods of time.
>
> Fixes intermittent hangs on boot on a MacbookAir1,1
>
> Signed-off-by: Bastien Nocera<hadess@hadess.net>
> ---
>   drivers/input/serio/i8042.c |   18 ++++++++++++++++++
>   1 files changed, 18 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
> index d84a36e..2be7207 100644
> --- a/drivers/input/serio/i8042.c
> +++ b/drivers/input/serio/i8042.c
> @@ -1438,12 +1438,30 @@ static struct platform_driver i8042_driver = {
>   	.shutdown	= i8042_shutdown,
>   };
>
> +static struct dmi_system_id __initdata dmi_system_table[] = {
> +	{
> +		.matches = {
> +			DMI_MATCH(DMI_BIOS_VENDOR, "Apple Computer, Inc.")
> +		},
> +	},
> +	{
> +		.matches = {
> +			DMI_MATCH(DMI_BIOS_VENDOR, "Apple Inc.")
> +		},
> +	},
> +	{}
> +};
> +
>   static int __init i8042_init(void)
>   {
>   	int err;
>
>   	dbg_init();
>
> +	/* Intel Apple Macs never have an i8042 controller */
> +	if (dmi_check_system(dmi_system_table)>  0)
> +		return -ENODEV;
> +
>   	err = i8042_platform_init();
>   	if (err)
>   		return err;


glad you submitted this. i.g. been looking at some dmi
blacklist thing over here(been racking my brain around
a bit, and seeing your idea simplified it a bit more for me).

as for what you have here, do you think individually
defining each machine is safer, or does it not matter?

I've been looking at this as well, to get a better idea:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7121413f2accf14cf05b38539fb7a8be77543370;hp=1a133e0c9dabda23e6693cabfdc1d5106dca5fc2

Justin P. Mattock



