Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbYHEESj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbYHEESj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 00:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYHEERI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 00:17:08 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:8218 "EHLO
	pd2mo1so-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751346AbYHEERF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 00:17:05 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=jhrdAO46H8QUmAiQozUA:9 a=kvlU4ITS6p_DKRPUyWMA:7 a=cIob7Qa1YVcGeiqqxJGBfXfL2j0A:4 a=sXK_jVTNJE0A:10 a=FtvRe-9FhVEA:10
Message-ID: <4897D433.5040409@shaw.ca>
Date: Mon, 04 Aug 2008 22:16:51 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Elias Oltmanns <eo@nebensachen.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] libata: Implement disk shock protection support
References: <fa.nx0yFPJm+aNXPHgykUrOzZXvvIs@ifi.uio.no> <fa.NfEr7Ik6e8oextyWICW/jR5emeE@ifi.uio.no> <fa.zGvATZImeUo0tHJe4hzlk5+mTiM@ifi.uio.no>
In-Reply-To: <fa.zGvATZImeUo0tHJe4hzlk5+mTiM@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Elias Oltmanns wrote:
>> On user request (through sysfs), the IDLE IMMEDIATE command with UNLOAD
>> FEATURE as specified in ATA-7 is issued to the device and processing of
>> the request queue is stopped thereafter until the speified timeout
>> expires or user space asks to resume normal operation. This is supposed
>> to prevent the heads of a hard drive from accidentally crashing onto the
>> platter when a heavy shock is anticipated (like a falling laptop
>> expected to hit the floor). This patch simply stops processing the
>> request queue. In particular, it does not yet, for instance, defer an
>> SRST issued in order to recover from an error on the other device on the
>> interface.
> 
> For libata, the easiest way to achieve the above would be adding a
> per-dev EH action, say, ATA_EH_UNLOAD and schedule EH w/ the action OR'd
> to eh_info->action.  The EH_UNLOAD handler can then issue the command
> wait for the specified number of seconds and continue.  This will be
> pretty simple to implement as command exclusion and stuff are all
> automatically handled by EH framework.
> 
> However, SATA or not, there simply isn't a way to abort commands in ATA.
>  Issuing random command while other commands are in progress simply is
> state machine violation and there will be many interesting results
> including complete system lockup (ATA controller dying while holding the
> PCI bus).  The only reliable way to abort in-flight commands are by
> issuing hardreset.  However, ATA reset protocol is not designed for
> quick recovery.  The machine is gonna hit the ground hard way before the
> reset protocol is complete.

How long does hardreset have to take? I only see a 1ms delay in the 
COMRESET process (sata_link_hardreset). I'd think it would be feasible 
to do something like:

-stop the queue to prevent new commands from being issued
-wait a certain amount of time (20ms or so?) for existing command(s) to 
complete, if they do then issue the idle command
-if time runs out, trigger a hardreset and then issue the idle command

The drive is going to take a little while to actually unload the heads 
anyway, so a few milliseconds delay doesn't seem like a big deal..

> 
> The only way to solve this nicely is either to build the accelerometer
> into the drive and let the drive itself protect itself or implement a
> sideband signal to tell it to duck for cover.  For SATA, this sideband
> signal can be another OOB sequence.  If it's ever implemented this way,
> it will be in SControl, I guess.
> 
> Well, short of that, all we can do is to wait for the currently
> in-flight commands to drain and hope that it happens before the machine
> hits the ground.  Also, that the harddrive is not going through one of
> the longish EH recovery sequences when it starts to fall.  :-(

Well, Lenovo (and others?) have implemented this in Windows somehow.. It 
would be interesting to know what solution they used there (either 
hardreset, issue the command even when busy, or just wait for the 
commands to hopefully finish in time).

