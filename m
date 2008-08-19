Return-Path: <linux-kernel-owner+w=401wt.eu-S1758873AbYHSUjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbYHSUjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbYHSUjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:39:12 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:56739 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbYHSUjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:39:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YXPhI7z+T6InqEl80O5t2XwzJ6altzSNvR6wzOVJ9SICAuySJMcWIFuP2kPUHpYrML
         KitPiJ/Q/IFqklCmgJhoBZR2vdMoS3R2q4xlk/R6plFfv9GyWkLgRde/dD2N0FGuxXW9
         FjiCPOe6a31VDik0pKUhCe0+BPuK71k6ucBvg=
Message-ID: <9e4733910808191339s28a05f90pef57961e8d24fbdb@mail.gmail.com>
Date: Tue, 19 Aug 2008 16:39:09 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Anton Vorontsov" <avorontsov@ru.mvista.com>
Subject: Re: [PATCH 1/2] rtc: rtc-ds1374: fix 'no irq' case handling
Cc: "Alessandro Zummo" <a.zummo@towertech.it>,
       "Andrew Morton" <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
In-Reply-To: <20080812161733.GA32164@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080812161733.GA32164@oksana.dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/08, Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> On a PowerPC board with ds1374 RTC I'm getting this error while
>  RTC tries to probe:
>
>  rtc-ds1374 0-0068: unable to request IRQ
>
>  This happens because I2C probing code (drivers/of/of_i2c.c) is
>  specifying IRQ0 for 'no irq' case, which is correct.

Shouldn't this be

>  -       if (client->irq <= NO_IRQ)

instead of

>  -       if (client->irq < 0)
>  +       if (client->irq <= 0)

Since NO_IRQ can vary by platform (0 or -1)? Work is underway to get
everyone onto NO_IRQ=0 but I don't know if it is finished yet. It is
much cleaner to use the NO_IRQ define.

In of_i2c.c shouldn't there be an error check?

		info.irq = irq_of_parse_and_map(node, 0);

if (info.irq < NO_IRQ) {report error; continue }


>
>  The driver handles this incorrectly, though. This patch fixes it.
>
>  Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
>  ---
>   drivers/rtc/rtc-ds1374.c |   10 +++++-----
>   1 files changed, 5 insertions(+), 5 deletions(-)
>
>  diff --git a/drivers/rtc/rtc-ds1374.c b/drivers/rtc/rtc-ds1374.c
>  index 640acd2..a150418 100644
>  --- a/drivers/rtc/rtc-ds1374.c
>  +++ b/drivers/rtc/rtc-ds1374.c
>  @@ -173,7 +173,7 @@ static int ds1374_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
>         int cr, sr;
>         int ret = 0;
>
>  -       if (client->irq < 0)
>  +       if (client->irq <= 0)
>                 return -EINVAL;
>
>         mutex_lock(&ds1374->mutex);
>  @@ -212,7 +212,7 @@ static int ds1374_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
>         int cr;
>         int ret = 0;
>
>  -       if (client->irq < 0)
>  +       if (client->irq <= 0)
>                 return -EINVAL;
>
>         ret = ds1374_read_time(dev, &now);
>  @@ -381,7 +381,7 @@ static int ds1374_probe(struct i2c_client *client,
>         if (ret)
>                 goto out_free;
>
>  -       if (client->irq >= 0) {
>  +       if (client->irq > 0) {
>                 ret = request_irq(client->irq, ds1374_irq, 0,
>                                   "ds1374", client);
>                 if (ret) {
>  @@ -401,7 +401,7 @@ static int ds1374_probe(struct i2c_client *client,
>         return 0;
>
>   out_irq:
>  -       if (client->irq >= 0)
>  +       if (client->irq > 0)
>                 free_irq(client->irq, client);
>
>   out_free:
>  @@ -414,7 +414,7 @@ static int __devexit ds1374_remove(struct i2c_client *client)
>   {
>         struct ds1374 *ds1374 = i2c_get_clientdata(client);
>
>  -       if (client->irq >= 0) {
>  +       if (client->irq > 0) {
>                 mutex_lock(&ds1374->mutex);
>                 ds1374->exiting = 1;
>                 mutex_unlock(&ds1374->mutex);
>
> --
>  1.5.6.3
>
>  _______________________________________________
>  Linuxppc-dev mailing list
>  Linuxppc-dev@ozlabs.org
>  https://ozlabs.org/mailman/listinfo/linuxppc-dev
>


-- 
Jon Smirl
jonsmirl@gmail.com
