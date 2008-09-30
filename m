Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbYI3Uro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbYI3Uro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 16:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbYI3Ure
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 16:47:34 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:38045 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbYI3Urc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 16:47:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KtcXnpXCRunBqtWPlPnqKuTnWhdok9CdU/ZEGPxCNW2SW8V7FE1G6raBB2Lca7PGYD
         sLiGjTsmXR0TFbN1zS6T5SLDWpqbrNIS6kLSZQlQRTmqZa3WOzn9DxncyZyaVoxYNBfi
         KqO0EoU2Tq3Yibtrklw6lVddaNTS8NMqAKyC0=
Message-ID: <a52a95e30809301347s70b57ebfh280a6871329afd72@mail.gmail.com>
Date: Tue, 30 Sep 2008 14:47:23 -0600
From: "Tom Mortensen" <tmmlkml@gmail.com>
To: "Tejun Heo" <tj@kernel.org>
Subject: Re: exception Emask 0x0 SAct 0x1 / SErr 0x0 action 0x2 frozen
Cc: "Bill Davidsen" <davidsen@tmr.com>, "Gwendal Grignou" <gwendal@google.com>,
       "Justin Piszcz" <jpiszcz@lucidpixels.com>,
       "Brian Rademacher" <rad@radfiles.net>, linux-ide@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Bruce Allen" <ballen@gravity.phys.uwm.edu>
In-Reply-To: <48E08E2D.6050905@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3E6D0C24877245C3A5A327129A7B4CA7@909927SOSLA>
	 <alpine.DEB.1.10.0809220828490.23159@p34.internal.lan>
	 <5419A02543384E69AF2BA82FF6E66C14@909927SOSLA>
	 <alpine.DEB.1.10.0809220903400.23159@p34.internal.lan>
	 <4B1ABD0393EF40FFB0A12242FE8356AF@909927SOSLA>
	 <alpine.DEB.1.10.0809220915470.23159@p34.internal.lan>
	 <alpine.DEB.1.10.0809220926240.23159@p34.internal.lan>
	 <e7510f760809231114y6cbaf13aqf7c63bd48a73c978@mail.gmail.com>
	 <48DBAB81.8050900@tmr.com> <48E08E2D.6050905@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't know if this is the original poster's problem, but if the drive
is spun down, then enabling SMART or trying to read SMART attributes
causes the drive to spin up and the command is delayed until this has
occurred.

The fix is to increase the timeout given to scsi_execute() in
drivers/ata/libata-scsi.c.

ie, current code (2.6.26.5) is:

        /* Good values for timeout and retries?  Values below
           from scsi_ioctl_send_command() for default case... */
        cmd_result = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
                                  sensebuf, (10*HZ), 5, 0);

Should be changed to:

        /* Good values for timeout and retries?  Values below
           from scsi_ioctl_send_command() for default case... */
        cmd_result = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
                                  sensebuf, (30*HZ), 5, 0);

Using a 1TB Hitachi hard drive, this command times out because it
takes this drive about 15 seconds to spin up.  Virtutally all hard
drives spin up in less than 30 sec, but perhaps make this higher in
case there are slower drives out there?

Cheers,
Tom

On Mon, Sep 29, 2008 at 2:13 AM, Tejun Heo <tj@kernel.org> wrote:
> Bill Davidsen wrote:
>> Gwendal Grignou wrote:
>>> About ata1:0 problem, as reported in the bugzilla bug: I would try to
>>> disable NCQ to see if it helps. Your disks firmware might not fully
>>> support it.
>>>
>>> You can either add the parameter "libata.force=noncq" when loading
>>> your kernel, or set queue_depth to 1 for all the Seagate drives behind
>>> the Marvell MV88SX6081 controller.
>>>
>>> About ata5:0 , someone - in user space probably - is trying to do a
>>> SMART ENABLE operation, but the device ignores it. I don't know which
>>> device you are using, but I assume it does not support ATA SMART
>>> feature set. Timeout is an acceptable but not a nice way to answer, a
>>> cancel would have been better; check if there is a firmware upgrade
>>> for your device.
>>>
>>
>> You certainly called the SMART issue, I was wondering why a new
>> distribution install on some older hardware was getting all the errors,
>> clearly the Fedora "smartd" doesn't check SMART capability before trying
>> to enable the feature. Oddly the drive on which I see this does reply to
>> SMART requests, so the firmware must be "semi-functional." Not a
>> problem, in my case the drive is just used for testing handling of hot
>> swap, and has no data of any value.
>
> Can you post full kernel log including the boot messages and the error
> messages?  Also, please attach the output of hdparm -I on the drive
> which fails the smart command.
>
> (cc'ing Bruce, hi!) Bruce, this is the second report I see about drive
> timing out SMART ENABLE OPERATIONS.  Does anything ring a bell?
>
> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
