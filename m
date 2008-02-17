Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbYBQR7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbYBQR7M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbYBQR6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:58:55 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58042 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbYBQR6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:58:53 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47B875CA.8070900@s5r6.in-berlin.de>
Date: Sun, 17 Feb 2008 18:58:34 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] ieee1394: sbp2: fix rescan-scsi-bus
References: <tkrat.e8f3d31fb5f9fe01@s5r6.in-berlin.de>	 <tkrat.e66f8acfe9d89925@s5r6.in-berlin.de> <1203264186.3082.33.camel@localhost.localdomain>
In-Reply-To: <1203264186.3082.33.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Sun, 2008-02-17 at 14:57 +0100, Stefan Richter wrote:
>> rescan-scsi-bus used to add SBP-2 targets which weren't there.
...
>> +++ linux/drivers/ieee1394/sbp2.c
>> @@ -1974,6 +1974,9 @@ static int sbp2scsi_slave_alloc(struct s
>>  {
>>  	struct sbp2_lu *lu = (struct sbp2_lu *)sdev->host->hostdata[0];
>>  
>> +	if (sdev->lun != 0 || sdev->id != lu->ud->id || sdev->channel != 0)
>> +		return -ENODEV;
>> +
> 
> It's hard to know what to say about this.  The infrastructure for
> scanning did move to separate scanned (old parallel and a few other)
> busses from hotplug ones (which is what sbp2 is).  You really need to
> look at the scan_finished and user_scan callbacks.  Unfortunately the
> latter is a transport class function and how all the modern busses (FC,
> SAS and the like do this).

We add SBP-2 devices when they are detected on the FireWire bus.

The status with sbp2 (after the patch) is:
  - sbp2 calls scsi_add_device and scsi_remove_device when an SBP-2
    logical unit comes and goes away.
  - In between those, the user may call scsi_remove_device and
    optionally scsi_add_device via SCSI core's userspace interfaces
    and will get the device removed and re-added, respectively.
However, the latter is an utter useless pastime.  And so would be
scsi_transport_template.user_scan().

Implementing scsi_host_template.scan_finished() is logged to be done as
a possible feature addition.  It has ultra-low priority on my to-do list
though because the drivers have only little more knowledge than
userspace has about when all existing devices at a point in time might
have been discovered.
-- 
Stefan Richter
-=====-==--- --=- =---=
http://arcgraph.de/sr/
