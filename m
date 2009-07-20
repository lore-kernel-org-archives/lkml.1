Return-Path: <linux-kernel-owner+w=401wt.eu-S1753625AbZGTMdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbZGTMdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 08:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZGTMdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 08:33:42 -0400
Received: from mail-px0-f193.google.com ([209.85.216.193]:53098 "EHLO
	mail-px0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbZGTMdl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 08:33:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HSDw4CNbxTDZim0Scv0pQ5QTpTezesVlYkY/BGYGqY6VsBIoJchLY4YuyKiFP4LS0p
         OteMlSoDItZrMV5HkOQqB2C44AG2hs2XEUPJoAIe9aX0ALCF8243mtj/W0jJZjO/xLmq
         mONGKtC18vr2cF6XUmSYKyINUc7w1KHnT6wQ8=
MIME-Version: 1.0
In-Reply-To: <4A642458.6080008@nokia.com>
References: <Pine.LNX.4.64.0907191729580.16542@ask.diku.dk>
	 <4A642458.6080008@nokia.com>
Date: Mon, 20 Jul 2009 18:03:40 +0530
Message-ID: <c656a4d20907200533t1cbe1476l62d8a51fdb796c70@mail.gmail.com>
Subject: Re: [PATCH 9/10] drivers/mmc: Move a dereference below a NULL test
From: arun c <arun.edarath@gmail.com>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Julia Lawall <julia@diku.dk>,
       "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 1:31 PM, Adrian Hunter<adrian.hunter@nokia.com> wrote:
> Julia Lawall wrote:
>>
>> From: Julia Lawall <julia@diku.dk>
>>
>> If the NULL test is necessary, then the dereference should be moved below
>> the NULL test.
>>
>> The semantic patch that makes this change is as follows:
>> (http://www.emn.fr/x-info/coccinelle/)
>>
>> // <smpl>
>> @@
>> type T;
>> expression E,E1;
>> identifier i,fld;
>> statement S;
>> @@
>>
>> - T i = E->fld;
>> + T i;
>>  ... when != E=E1
>>      when != i
>>  BUG_ON (E == NULL||
>> -     i
>> +     E->fld
>>       == NULL || ...);
>> + i = E->fld;
>> // </smpl>
>>
>> Signed-off-by: Julia Lawall <julia@diku.dk>
>>
>> ---
>>  drivers/mmc/host/omap.c             |    5 +++--
>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
>> index e7a331d..89281ab 100644
>> --- a/drivers/mmc/host/omap.c
>> +++ b/drivers/mmc/host/omap.c
>> @@ -255,11 +255,12 @@ static void mmc_omap_slot_release_work(struct
>> work_struct *work)
>>   static void mmc_omap_release_slot(struct mmc_omap_slot *slot, int
>> clk_enabled)
>>  {
>> -       struct mmc_omap_host *host = slot->host;
>> +       struct mmc_omap_host *host;
>>        unsigned long flags;
>>        int i;
>>  -       BUG_ON(slot == NULL || host->mmc == NULL);
>> +       BUG_ON(slot == NULL || slot->host->mmc == NULL);
>> +       host = slot->host;
>>          if (clk_enabled)
>>                /* Keeps clock running for at least 8 cycles on valid freq
>> */
>> --
>
> If slot is NULL it will oops anyway, so the following is better IMHO:
>
> static void mmc_omap_release_slot(struct mmc_omap_slot *slot, int
> clk_enabled)
> {
>        struct mmc_omap_host *host = slot->host;
>        unsigned long flags;
>        int i;
>
>> -       BUG_ON(slot == NULL || host->mmc == NULL);
>> +       BUG_ON(host->mmc == NULL);
>
>        if (clk_enabled)
>                /* Keeps clock running for at least 8 cycles on valid freq */
> --

According to http://isc.sans.org/diary.html?storyid=6820&rss "NULL check"
must be done before assigning the values. Does Julia Lawall's version
is the more correct one??

Arun
