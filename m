Return-Path: <linux-kernel-owner+w=401wt.eu-S1761807AbXFJEue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761807AbXFJEue (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 00:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbXFJEu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 00:50:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:33272 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbXFJEuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 00:50:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ZM/fI6YOjHja1CAFV9+XnGL81wFkB4IvkiHkJyo3ud3NstsgYTuw0xvhArdbjfcoNQqLgVejirMP+hMxr7EV3eTYkTrkqZUgXEhKnz7gOozF3898LZgf55Qqh8EJQMuJL8f9QSry/SE9dZ2nmQQpFPzfEwM0n/jBf3n7f4FQuBQ=
Message-ID: <466B830B.5020007@gmail.com>
Date: Sun, 10 Jun 2007 13:50:19 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_it821x: sync with IDE it821x driver
References: <200706090223.20933.bzolnier@gmail.com> <466A417C.5090901@gmail.com> <200706092209.10636.bzolnier@gmail.com>
In-Reply-To: <200706092209.10636.bzolnier@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
>>> @@ -258,8 +259,14 @@ static void it821x_passthru_set_piomode(
>>>  	static const u8 pio_want[]    = { ATA_66, ATA_66, ATA_66, ATA_66, ATA_ANY };
>>>  
>>>  	struct it821x_dev *itdev = ap->private_data;
>>> +	struct ata_device *pair = ata_dev_pair(adev);
>>>  	int unit = adev->devno;
>>> -	int mode_wanted = adev->pio_mode - XFER_PIO_0;
>>> +	int mode_wanted = adev->pio_mode;
>>> +
>>> +	if (pair && adev->pio_mode > pair->pio_mode)
>>> +		mode_wanted = pair->pio_mode;
>>> +
>>> +	mode_wanted -= XFER_PIO_0;
>> I think this is better done by mode_filter callback which is guaranteed
>> to be called before any actual mode configuration is performed and in
>> device order (master then slave).
> 
> I was thinking about using ->mode_filter but since all other PATA host
> drivers are doing PIO filtering in ->set_piomode methods and also since it
> seemed that using ->mode_filter method would result in slightly more complex
> code I opted for coherency / simplicity.  However if you (or somebody else)
> want to make a follow-up change to this driver (and preferably other PATA
> host drivers ie. pata_sil680) to use ->mode_filter I'm also fine with that.

Hmmm... indeed.  Alan, is there any reason we do that in ->set_piomode
not ->mode_filter?  We end up with mismatching configuration between the
controller and the higher speed drive.

-- 
tejun
