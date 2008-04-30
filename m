Return-Path: <linux-kernel-owner+w=401wt.eu-S1760866AbYD3Nhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866AbYD3Nhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 09:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbYD3Nhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 09:37:43 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:33617 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185AbYD3Nhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 09:37:42 -0400
Message-ID: <481875E4.6040606@s5r6.in-berlin.de>
Date: Wed, 30 Apr 2008 15:36:36 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Hack to fix not working spindown over Firewire
References: <20080429232606.GA14261@dose.home.local> <481874BD.5010807@s5r6.in-berlin.de>
In-Reply-To: <481874BD.5010807@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Tino Keitel wrote:
>> @@ -1788,8 +1788,16 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>>  	struct scsi_device *sdp = sdkp->device;
>>  	int res;
>>  
>> -	if (start)
>> +	if (start) {
>>  		cmd[4] |= 1;	/* START */
>> +		if(!strncmp(sdp->vendor, "WDC WD32", 8)) {
>> +			cmd[4] |= (1 << 4); /* power condition */
>> +		}
>> +	} else {
>> +		if(!strncmp(sdp->vendor, "WDC WD32", 8)) {
>> +			cmd[4] |= (2 << 4); /* power condition */
>> +		}
>> +	}
>>  
>>  	if (!scsi_device_online(sdp))
>>  		return -ENODEV;
> 
[...]
> The traditional way to handle things like this is:
> 
>    - Implement this as a workaround in sd.
> 
>    - Make this workaround conditional on a quirks flag in
>      struct scsi_device.
> 
>    - Switch this flag on in a place where it can be reliably
>      detected that this device needs it.  There is an interface
>      to do this in userspace.  But in this particular case, the
>      best place is the sbp2 driver (ond firewire-sbp2 driver),
>      because it can detect PL-3507 firmwares by means of firmware
>      identifiers.
[...]
> On the other hand, perhaps we can enable the workaround unconditional
> for all firewire disks (switch in the flag in sbp2 and firewire-sbp2
> without looking at the device) or for all RBC disks (switch on the flag
> in sd.c if sdev->type == TYPE_RBC).

PS:
If it works for all RBC devices (it should according to the spec...) &&
your ICY Box exposes itself as RBC device (it should do so), then we
don't need any changes to struct scsi_device and to sbp2/ firewire-sbp2.
-- 
Stefan Richter
-=====-==--- -=-- ====-
http://arcgraph.de/sr/
