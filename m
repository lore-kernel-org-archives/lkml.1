Return-Path: <linux-kernel-owner+w=401wt.eu-S1758029AbYEIVNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbYEIVNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 17:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbYEIVNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 17:13:45 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53519 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbYEIVNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 17:13:44 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 9 May 2008 23:13:41 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Clean patch to fix not working spindown over Firewire
To: Tino Keitel <tino.keitel@gmx.de>
cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20080509201635.GA20189@dose.home.local>
Message-ID: <tkrat.606fe302c67e64b4@s5r6.in-berlin.de>
References: <20080429232606.GA14261@dose.home.local>
 <481874BD.5010807@s5r6.in-berlin.de> <481875E4.6040606@s5r6.in-berlin.de>
 <20080509201635.GA20189@dose.home.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On  9 May, Tino Keitel wrote:
> On Wed, Apr 30, 2008 at 15:36:36 +0200, Stefan Richter wrote:
>> If it works for all RBC devices (it should according to the spec...) &&
>> your ICY Box exposes itself as RBC device (it should do so), then we
>> don't need any changes to struct scsi_device and to sbp2/ firewire-sbp2.
> 
> Do you mean something like in the attached (untested) patch?
> 
> Regards,
> Tino
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 01cefbb..6b927f6 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1787,8 +1787,13 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>  	struct scsi_device *sdp = sdkp->device;
>  	int res;
>  
> -	if (start)
> +	if (start) {
>  		cmd[4] |= 1;	/* START */
> +		/* active power condition */
> +		cmd[4] |= (sdp->type == TYPE_RBC) ? (1 << 4) : 0; 
> +	} else
> +		/* standby power condition */
> +		cmd[4] |= (sdp->type == TYPE_RBC) ? (3 << 4) : 0 ; 
>  
>  	if (!scsi_device_online(sdp))
>  		return -ENODEV;

Yes, that's what I meant.  Would you test it on your disks and, if it
works, repost to LSML with your Signed-off-by line?
(See linux/Documentation/SubmittingPatches.)

Or write it as

 	if (start)
 		cmd[4] |= 1;	/* START */
+
+	if (sdp->type == TYPE_RBC)
+		cmd[4] |= start ? 1 << 4 : 3 << 4;	/* POWER CONDITION */


Alas the test for TYPE_RBC is not ideal.  As I wrote in my other mail,
there are some SBP-2 disks which pose as TYPE_DISK.  It's not a big
problem though because almost all of them also work with POWER
CONDITION = 0.  The only exception is DViCO Momobay CX-1 which goes
belly-up POWER CONDITION = 0 and START = 0.  Maybe I should simply
overwrite the CX-1's sdp->type by TYPE_RBC.  I suspect that this is what
it implements anyway.  The firmwares of the later Momobay models FX-3A
and IIRC CX-2 do so.
-- 
Stefan Richter
-=====-==--- -=-= -=--=
http://arcgraph.de/sr/

