Return-Path: <linux-kernel-owner+w=401wt.eu-S1761117AbYCFIWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761117AbYCFIWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 03:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYCFIWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 03:22:10 -0500
Received: from rn-out-0910.google.com ([64.233.170.190]:31348 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbYCFIWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 03:22:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=I9iPg/nHbI4MJNtbomLVRgkuigh7KwzuDC05uMqQVLmji4U+cW0Ux3SXRZFGCY0dUhWRF9/ejepAQuyPx6HwQTHZoHqnsNV0H8TzHT2KfoC1qA7eYBXJk0301iV7657WOHNgG8dAvsCxUAcESzndH+/yw1fo1jfiNyRVXY4O4iw=
Message-ID: <47CFA9A6.2040506@gmail.com>
Date: Thu, 06 Mar 2008 17:21:58 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Matthew Wilcox <matthew@wil.cx>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: ata_ram driver
References: <20080222200951.GI16995@parisc-linux.org> <47BF3E54.9050609@rtr.ca>
In-Reply-To: <47BF3E54.9050609@rtr.ca>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Matthew Wilcox wrote:
>> I've ported the scsi_ram driver [1] to libata.  It could use a lot more
>> work -- there's a lot of stuff in the identify page that I haven't
>> filled in, and there's a lot of commands it doesn't even try to execute.
>>
>> For example, when you unload the driver, you get the mildly disturbing
>> messages:
>>
>> sd 12:0:0:0: [sdb] Stopping disk
>> sd 12:0:0:0: [sdb] START_STOP FAILED
>> sd 12:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
>> driverbyte=DRIVER_OK,SUGGEST_OK
>>
> ..
> 
> I see messages like those with *established* libata drivers from time to
> time.
> It could just be a bug in the shutdown sequence, somewhere between libata,
> SCSI, block layer, and the device model in general.  Or not.

It's because of the sequence of events.  Currently, driver unload
sequence is the same as when the device is hot unplugged.  libata
detects that the device is gone and disables it and report it to SCSI
layer.  SCSI layer takes over and tries to kill the SCSI device and tell
sd to shutdown and sd issues START_STOP to shutdown which fails w/
DID_BAD_TARGET because the matching ATA device is already gone.  I've
left it that way because I'm not sure whether spinning down the drive on
driver unload is the correct thing to do.  The message is annoying tho.

Thanks.

-- 
tejun
