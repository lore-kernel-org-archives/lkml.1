Return-Path: <linux-kernel-owner+w=401wt.eu-S1757812AbZHGM3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbZHGM3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 08:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757746AbZHGM3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 08:29:35 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:54611 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932390AbZHGM3d convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 08:29:33 -0400
X-SpamScore: -11
X-BigFish: VPS-11(z34a4jz1432R98dNzz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KO0AOT-04-O88-01
Date: Fri, 7 Aug 2009 14:29:16 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: wan wei <onewayforever@gmail.com>
CC: dougthompson@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd64_edac: Rewrite unganged mode code of
 f10_early_channel_count
Message-ID: <20090807122916.GC29900@aftab>
References: <86bb1aef0908062236w1912a909yfa892d40f1776e08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <86bb1aef0908062236w1912a909yfa892d40f1776e08@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Aug 2009 12:29:15.0945 (UTC) FILETIME=[AD899190:01CA175A]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Aug 07, 2009 at 01:36:30PM +0800, wan wei wrote:
>      I rechecked the f10_early_channel_count function, and found more
> bugs in unganged mode. This patch will fix  bugs under following
> conditions,
>     a. only one DIMM in each channelof the node,
>     b. two DIMMs are populated in the same channel of the node,
>     c. there is no DIMM in a node(other than node 0),
>     a and b  mean both dbam should be checked in any condition,  and c
> means even channels==0 is ok.
> 
> the patch has been tested and works well in  this  4 ways machine:
>    node 0:  2 DIMMS on each channel
>    node11: no DIMMS
>    node2:  2 DIMM on the chanel 0
>    node3:  one DIMM on each channel

let me preface this by saying the I generally like the idea, this
function is rather clumsy (and buggy for that matter) and cleaning it up
is very welcome. However...

Please, write a proper commit message when sending patches. You need to
exactly and succintly explain what (and not how) are you changing and
why. See <Documentation/SubmittingPatches>.

> ---
>  drivers/edac/amd64_edac.c |   46 ++++++++++++++------------------------------
>  1 files changed, 15 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index e2a10bc..7a328fa 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -1200,6 +1200,7 @@ static int f10_early_channel_count(struct amd64_pvt *pvt)
>  {
>  	int err = 0, channels = 0;
>  	u32 dbam;
> +	int i;
> 
>  	err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCLR_0, &pvt->dclr0);
>  	if (err)
> @@ -1236,40 +1237,23 @@ static int f10_early_channel_count(struct
> amd64_pvt *pvt)

your patch is garbled here and cannot be applied as such. See section 7)
in <Documentation/SubmittingPatches> for more info on how to avoid that.

>  	if (err)
>  		goto err_reg;
> 
> -	if (DBAM_DIMM(0, dbam) > 0)
> -		channels++;
> -	if (DBAM_DIMM(1, dbam) > 0)
> -		channels++;
> -	if (DBAM_DIMM(2, dbam) > 0)
> -		channels++;
> -	if (DBAM_DIMM(3, dbam) > 0)
> -		channels++;
> -
> -	/* If more than 2 DIMMs are present, then we have 2 channels */
> -	if (channels > 2)
> -		channels = 2;
> -	else if (channels == 0) {
> -		/* No DIMMs on DCT0, so look at DCT1 */
> -		err = pci_read_config_dword(pvt->dram_f2_ctl, DBAM1, &dbam);
> -		if (err)
> -			goto err_reg;
> -
> -		if (DBAM_DIMM(0, dbam) > 0)
> +	for (i = 0; i < 4; i++) {
> +		if (DBAM_DIMM(i, dbam) > 0) {
>  			channels++;
> -		if (DBAM_DIMM(1, dbam) > 0)
> -			channels++;
> -		if (DBAM_DIMM(2, dbam) > 0)
> -			channels++;
> -		if (DBAM_DIMM(3, dbam) > 0)
> -			channels++;
> -
> -		if (channels > 2)
> -			channels = 2;
> +			break;
> +		}
>  	}
> 
> -	/* If we found ALL 0 values, then assume just ONE DIMM-ONE Channel */
> -	if (channels == 0)
> -		channels = 1;
> +	err = pci_read_config_dword(pvt->dram_f2_ctl, DBAM1, &dbam);
> +	if (err)
> +		goto err_reg;
> +
> +	for (i = 0; i < 4; i++) {
> +		if (DBAM_DIMM(i, dbam) > 0) {
> +			channels++;
> +			break;
> +		}
> +	}

combine the two loops together like so:

        for (j = 0; j < ARRAY_SIZE(regs_dbam); j++) {
                err = pci_read_config_dword(pvt->dram_f2_ctl, regs_dbam[j],
                                            &dbam);

                for (i = 0; i < 4; i++) {
                        if (DBAM_DIMM(i, dbam) > 0) {
                                channels++;
                                break;
                        }
                }
        }

where regs_dbam[] is:

	int regs_dbam[] = { DBAM0, DBAM1 };


This way this function is finally starting to look ok.

Please redo your patch and resubmit.

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

