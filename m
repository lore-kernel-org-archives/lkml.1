Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbYHAHUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbYHAHUD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 03:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbYHAHTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 03:19:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:39617 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbYHAHTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 03:19:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=JnC+a+HXYqxmfr9Rl8OQYTJVelbHMBOsmR08CVKs6hkgxD5iAW8tstBVgQoEC8e/Pw
         1rfU3YCSIT61RYDGIbZIjbdWQG1TQ5OTio35ypDDldeayOdhA6H94P85efzzpRGtv8DX
         HYrrOblIUGhzxecovbzBogU/4Qic32+s59+1k=
Message-ID: <4892B8FE.1070400@gmail.com>
Date: Fri, 01 Aug 2008 16:19:26 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] libata: Implement disk shock protection support
References: <87prp1kvyy.fsf@denkblock.local> <20080726062142.29070.10413.stgit@denkblock.local>
In-Reply-To: <20080726062142.29070.10413.stgit@denkblock.local>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns wrote:
> On user request (through sysfs), the IDLE IMMEDIATE command with UNLOAD
> FEATURE as specified in ATA-7 is issued to the device and processing of
> the request queue is stopped thereafter until the speified timeout
> expires or user space asks to resume normal operation. This is supposed
> to prevent the heads of a hard drive from accidentally crashing onto the
> platter when a heavy shock is anticipated (like a falling laptop
> expected to hit the floor). This patch simply stops processing the
> request queue. In particular, it does not yet, for instance, defer an
> SRST issued in order to recover from an error on the other device on the
> interface.

For libata, the easiest way to achieve the above would be adding a
per-dev EH action, say, ATA_EH_UNLOAD and schedule EH w/ the action OR'd
to eh_info->action.  The EH_UNLOAD handler can then issue the command
wait for the specified number of seconds and continue.  This will be
pretty simple to implement as command exclusion and stuff are all
automatically handled by EH framework.

However, SATA or not, there simply isn't a way to abort commands in ATA.
 Issuing random command while other commands are in progress simply is
state machine violation and there will be many interesting results
including complete system lockup (ATA controller dying while holding the
PCI bus).  The only reliable way to abort in-flight commands are by
issuing hardreset.  However, ATA reset protocol is not designed for
quick recovery.  The machine is gonna hit the ground hard way before the
reset protocol is complete.

The only way to solve this nicely is either to build the accelerometer
into the drive and let the drive itself protect itself or implement a
sideband signal to tell it to duck for cover.  For SATA, this sideband
signal can be another OOB sequence.  If it's ever implemented this way,
it will be in SControl, I guess.

Well, short of that, all we can do is to wait for the currently
in-flight commands to drain and hope that it happens before the machine
hits the ground.  Also, that the harddrive is not going through one of
the longish EH recovery sequences when it starts to fall.  :-(

-- 
tejun
