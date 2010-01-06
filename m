Return-Path: <linux-kernel-owner+w=401wt.eu-S1755706Ab0AFLOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab0AFLOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 06:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608Ab0AFLOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 06:14:37 -0500
Received: from poutre.nerim.net ([62.4.16.124]:50279 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755594Ab0AFLOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 06:14:36 -0500
Date: Wed, 6 Jan 2010 12:14:34 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       linux-i2c@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: test off by one in {piix4,vt596}_transaction()
Message-ID: <20100106121434.5553d1cc@hyperion.delvare>
In-Reply-To: <4B43AD8F.2030809@gmail.com>
References: <4B3773F2.3010703@gmail.com>
	<20100105175511.39dc6c42@hyperion.delvare>
	<4B43AD8F.2030809@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Jan 2010 22:22:23 +0100, Roel Kluin wrote:
> With `while (timeout++ < MAX_TIMEOUT)' timeout reaches MAX_TIMEOUT + 1 after the loop
> This is probably unlikely to produce a problem.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> > That's right... but I'd rather change the loops to use "++timeout" and
> > leave the conditions as is (or maybe change it to "=="). I think it's
> > easier to read that way. Would that be OK with you?
> 
> Ok,
> 
>  drivers/i2c/busses/i2c-piix4.c  |    4 ++--
>  drivers/i2c/busses/i2c-viapro.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
> index 1e245e9..e56e4b6 100644
> --- a/drivers/i2c/busses/i2c-piix4.c
> +++ b/drivers/i2c/busses/i2c-piix4.c
> @@ -324,12 +324,12 @@ static int piix4_transaction(void)
>  	else
>  		msleep(1);
>  
> -	while ((timeout++ < MAX_TIMEOUT) &&
> +	while ((++timeout < MAX_TIMEOUT) &&
>  	       ((temp = inb_p(SMBHSTSTS)) & 0x01))
>  		msleep(1);
>  
>  	/* If the SMBus is still busy, we give up */
> -	if (timeout >= MAX_TIMEOUT) {
> +	if (timeout == MAX_TIMEOUT) {
>  		dev_err(&piix4_adapter.dev, "SMBus Timeout!\n");
>  		result = -ETIMEDOUT;
>  	}
> diff --git a/drivers/i2c/busses/i2c-viapro.c b/drivers/i2c/busses/i2c-viapro.c
> index e4b1543..a84a909 100644
> --- a/drivers/i2c/busses/i2c-viapro.c
> +++ b/drivers/i2c/busses/i2c-viapro.c
> @@ -165,10 +165,10 @@ static int vt596_transaction(u8 size)
>  	do {
>  		msleep(1);
>  		temp = inb_p(SMBHSTSTS);
> -	} while ((temp & 0x01) && (timeout++ < MAX_TIMEOUT));
> +	} while ((temp & 0x01) && (++timeout < MAX_TIMEOUT));
>  
>  	/* If the SMBus is still busy, we give up */
> -	if (timeout >= MAX_TIMEOUT) {
> +	if (timeout == MAX_TIMEOUT) {
>  		result = -ETIMEDOUT;
>  		dev_err(&vt596_adapter.dev, "SMBus timeout!\n");
>  	}

Applied, thanks.

-- 
Jean Delvare
