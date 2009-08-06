Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbZHFO6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbZHFO6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 10:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbZHFO6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 10:58:21 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:32375 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZHFO6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 10:58:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TqKhe5htv26rYSn99PwvWvFOWP1E1aJuKAZD399VfmWyb1AjJ8BN8bHbiam8bumRgO
         b7Y0wid0mVJZYn53JXenc5U8ffI1xELT3jrT/8ck++nmXPsrlWOY6Du9CleLNXpmYtIW
         zGg5I4ePzv6pH/FAnJrgkcqbLVIXXtG4iZep4=
MIME-Version: 1.0
In-Reply-To: <20090806144240.GB19878@aftab>
References: <86bb1aef0908060344h37f304c1jf1138b4cb865cbe2@mail.gmail.com>
	 <20090806144240.GB19878@aftab>
Date: Thu, 6 Aug 2009 22:58:21 +0800
Message-ID: <86bb1aef0908060758x349a7996i730dc11113441904@mail.gmail.com>
Subject: Re: [PATCH] check-dbam1-if-there-is-only-one-DIMM-on-dbam0 in 
	unganged mode
From: wan wei <onewayforever@gmail.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: dougthompson@xmission.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, It's just the same

On Thu, Aug 6, 2009 at 10:42 PM, Borislav Petkov<borislav.petkov@amd.com> wrote:
> On Thu, Aug 06, 2009 at 06:44:34PM +0800, wan wei wrote:
>>
>>     When I populated just one DIMM for each of the two channels  of
>> the cpu node in unganged mode,   there was only one channel found by
>> edac.
>>     In counting the channels, if there is only one DIMM found by
>> dbam0,  i think dbam1 should be checked for the other one  also.
>>     Below is the patch
>>
>> Signed-off-by: Wan Wei<wanwei@dawning.com.cn>
>>
>> ---
>>  drivers/edac/amd64_edac.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
>> index e2a10bc..afd210a 100644
>> --- a/drivers/edac/amd64_edac.c
>> +++ b/drivers/edac/amd64_edac.c
>> @@ -1248,7 +1248,7 @@ static int f10_early_channel_count(struct amd64_pvt *pvt)
>>         /* If more than 2 DIMMs are present, then we have 2 channels */
>>         if (channels > 2)
>>                 channels = 2;
>> -       else if (channels == 0) {
>> +       else if (channels <= 1) {
>
> This is correct, we're missing the one DIMM per DCT case. Can you try
> the patch below instead - it should be equivalent to yours while making
> the code a bit more understandable.
>
> Thanks.
>
> --
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index e2a10bc..71c215b 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -1245,11 +1245,8 @@ static int f10_early_channel_count(struct amd64_pvt *pvt)
>        if (DBAM_DIMM(3, dbam) > 0)
>                channels++;
>
> -       /* If more than 2 DIMMs are present, then we have 2 channels */
> -       if (channels > 2)
> -               channels = 2;
> -       else if (channels == 0) {
> -               /* No DIMMs on DCT0, so look at DCT1 */
> +       /* check whether DCT1 has also a channel enabled */
> +       if (channels < 2) {
>                err = pci_read_config_dword(pvt->dram_f2_ctl, DBAM1, &dbam);
>                if (err)
>                        goto err_reg;
> @@ -1262,11 +1259,11 @@ static int f10_early_channel_count(struct amd64_pvt *pvt)
>                        channels++;
>                if (DBAM_DIMM(3, dbam) > 0)
>                        channels++;
> -
> -               if (channels > 2)
> -                       channels = 2;
>        }
>
> +       if (channels > 2)
> +               channels = 2;
> +
>        /* If we found ALL 0 values, then assume just ONE DIMM-ONE Channel */
>        if (channels == 0)
>                channels = 1;
>
> --
> Regards/Gruss,
> Boris.
>
> Operating | Advanced Micro Devices GmbH
>  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
>  Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
>  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
>  (OSRC)  | Registergericht München, HRB Nr. 43632
>
>
