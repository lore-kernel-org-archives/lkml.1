Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194AbZBOUP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbZBOUP1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 15:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbZBOUPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 15:15:09 -0500
Received: from mail-gx0-f222.google.com ([209.85.217.222]:62780 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZBOUPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 15:15:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rNcJXp+BiHV4GlrQBi9uQu6m4Mrd3PlUpPYTopraE/v+auFVDTNMWYlWsbvtbCuyjZ
         LQd9rcCFkwW9AQYWg84GBwhno6Avjw29EAtAtRMsVxkOg5uiKVHUh1cQY8/5nXDff0gV
         AjEx07haQFWAspdWprl1lnIk96qmrAPbqEAqw=
Message-ID: <499877C5.6090205@gmail.com>
Date: Sun, 15 Feb 2009 14:15:01 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Serguei Miridonov <mirsev@cicese.mx>
CC: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <tj@kernel.org>
Subject: Re: Intel ICH9M/M-E SATA error-handling/reset problems
References: <200902141206.06419.mirsev@cicese.mx> <200902151000.16688.mirsev@cicese.mx> <4998593D.2050300@gmail.com> <200902151141.44367.mirsev@cicese.mx>
In-Reply-To: <200902151141.44367.mirsev@cicese.mx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serguei Miridonov wrote:
> On Sunday 15 February 2009, Robert Hancock wrote:
>> Serguei Miridonov wrote:
>>> On Saturday 14 February 2009, Robert Hancock wrote:
>>>> Serguei Miridonov wrote:
>>> ... something like 10
>>> errors per 2GB transfer can not be the reason to give up. Vista,
>>> at least, recovers and continues the data transfer. Linux simply
>>> can not return the interface or connected device into operating
>>> mode. Do you think it is normal?
>> Could be that Linux is being a bit more aggressive on error
>> handling. In your case, it looks like an error occurred, triggering
>> a hard reset of the device, and the controller seemed unable to
>> talk to the device afterwards. If the command had just been
>> retried, maybe it would have worked better. However, doing that in
>> general can cause issues since you don't know what the state of the
>> link may be..
> 
> Hmm... I was sure there are general recommendations from chipset 
> vendors regarding recovery procedures.
> 
> What is the behavior expected from a SATA connected device if it 
> detects parity error in received data? I'm not familiar with PATA/SATA 
> protocols but I suppose that it just doesn't send data to the physical 
> disk for recording, asserts the error line and waits next command from 
> the controller. If the data block was too big to keep it in the drive 
> cache memory, it may also set number of successfully (physically) 
> written bytes to prevent the software to send it again.

In the case of a CRC error the error flag gets set and the transfer is 
aborted by whichever side detects it. In this case the entire transfer 
gets retried.

> 
> If the above is correct then the kernel should only log the error, do 
> some housekeeping work for the controller and attempt to send data 
> again. There is no need for hard reset right after first error.

Right now interface CRC error is considered an ATA bus error which 
always triggers a reset. It's possible this could be relaxed in some 
cases, but the issue is that if CRC errors are occurring the link may be 
in an invalid state which simply retrying the command will not clear.

Tejun, any thoughts?

> 
> Another question is how the drive reacts to hard reset... My error log 
> shows that both drives do not like it for some reason - they stop 
> responding sometimes, so may be some additional programming of drives 
> is necessary after hard reset... Something which is done in BIOS after 
> power on... I don't know...

The same hard reset is done (and generally has to be done) on driver 
initialization and when a drive is hot plugged, so it should work. 
However, if the link is having problems (and it obviously is, from the 
CRC errors) the drive may not receive the reset either.

> 
> Well, it becomes interesting... I've got datasheet for ICH9 but don't 
> have a kernel driver source to check what messages in log file really 
> mean. Could you point me a link to the uncompressed kernel tree where 
> I can see source files?
> 

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git is 
likely the easiest place to view..
