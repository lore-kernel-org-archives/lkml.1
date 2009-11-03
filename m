Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbZKCWC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbZKCWC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 17:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbZKCWCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 17:02:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755243AbZKCWCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 17:02:21 -0500
Date: Tue, 3 Nov 2009 14:01:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: svalentine@concentris-systems.com
Cc: rtc-linux@googlegroups.com, a.zummo@towertech.it, raph@8d.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RTC: v3020 driver bugfix
Message-Id: <20091103140116.5e03df08.akpm@linux-foundation.org>
In-Reply-To: <36176.167.216.14.194.1256001083.squirrel@www.concentris-systems.com>
References: <36176.167.216.14.194.1256001083.squirrel@www.concentris-systems.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Oct 2009 15:11:23 -1000 (HST)
"Scott Valentine" <svalentine@concentris-systems.com> wrote:

> v3020 read_bit always returns 0 when left_shift > 7
> 
> The v3020 read_bit function's return type is (unsigned char). The code
> returns a value masked by (1 << left_shift) that is casted to the return
> type. If left_shift is larger than 7, the cast will always result in a 0
> return value. The problem was discovered with left_shift = 16, and the
> included patch corrects the problem.
> 
> The bug was introduced in the last (Apr 3 2009) commit of the file, kernel
> versions 2.6.30 and later.
> 
> diff -uNr a/drivers/rtc/rtc-v3020.c b/drivers/rtc/rtc-v3020.c
> --- a/drivers/rtc/rtc-v3020.c   2009-10-15 14:41:50.000000000 -1000
> +++ b/drivers/rtc/rtc-v3020.c   2009-10-19 14:06:27.000000000 -1000
> @@ -96,7 +96,7 @@
> 
>  static unsigned char v3020_mmio_read_bit(struct v3020 *chip)
>  {
> -       return readl(chip->ioaddress) & (1 << chip->leftshift);
> +       return ((readl(chip->ioaddress) & (1 << chip->leftshift)) != 0);
>  }
> 
>  static struct v3020_chip_ops v3020_mmio_ops = {

OK.

It's strange that the function returns `unsigned char' instead of say
int or bool.

We may as well do this in the same way as v3020_gpio_read_bit():

--- a/drivers/rtc/rtc-v3020.c~rtc-v3020-fix-v3020_mmio_read_bit
+++ a/drivers/rtc/rtc-v3020.c
@@ -96,7 +96,7 @@ static void v3020_mmio_write_bit(struct 
 
 static unsigned char v3020_mmio_read_bit(struct v3020 *chip)
 {
-	return readl(chip->ioaddress) & (1 << chip->leftshift);
+	return !!(readl(chip->ioaddress) & (1 << chip->leftshift));
 }
 
 static struct v3020_chip_ops v3020_mmio_ops = {
_


You didn't include a Signed-off-by: for this patch.
