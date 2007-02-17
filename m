Return-Path: <linux-kernel-owner+w=401wt.eu-S2992426AbXBQPQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992426AbXBQPQl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 10:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992427AbXBQPQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 10:16:41 -0500
Received: from web36703.mail.mud.yahoo.com ([209.191.85.37]:23845 "HELO
	web36703.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2992426AbXBQPQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 10:16:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=iU2dFvpsnqZT5MEoMFzyQrB6/9DQtPlGsn1bY/+++QZWHcUgE9IOdzrpGhi6FgZR3AmamsFoypD58Pb1G/ROYYRocAMptiJGxPgyViGpGk0ZOM2gshXmqDNj8V0VHpq2cUbG1I3Pq7jewyrvh9mKecfbkeboaW2hys35rD476DU=;
X-YMail-OSG: sJngdhYVM1lvZtLRKnLhBALfYCyd85xoecJEO6R7FFp5KnsZENXDKSy19vWMUUu_m63agJbOpF60yljojXfQOxdoUVLixfG9r6s.2ssUulXmHaw7sGWK5iQkayigQZe25nxykwgImABe.XM-
Date: Sat, 17 Feb 2007 07:16:39 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: [mmc] incorrect behavior on resume
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45CF5AB0.6080309@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <77095.44448.qm@web36703.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

And today: yet another problem with mmc.
It so happens that after resume mmc layer issues requests to the device before mmc_resume_host is
called at all. Moreover, this prevents the machine from resuming, unless worked around, because
software timer does not work at this stage of the resume and interrupts may not be delivered (if
card was removed, for example).
And here are some logs (condition: card is present when machine is suspended and removed before it
is resumed).
Normally, only this is seen in the log:
---------
Feb 18 01:42:09 mortug usbdev3.1_ep00: PM: resume from 0, parent usb3 still 2
Feb 18 01:42:09 mortug usbdev3.1_ep81: PM: resume from 0, parent 3-0:1.0 still 2
Feb 18 01:42:09 mortug tifm_sd0:3 : controller failed to reset
Feb 18 01:42:09 mortug tifm_sd tifm_sd0:3: resume initialize -19
Feb 18 01:42:09 mortug mmcblk0: unable to set block size to 512: 1
---------
Here, the controller failed to reset because card disappeared, so mmc_resume_host will not be
called - however mmc layer already complains that it can not set the block size. To get a better
log, I commented out the mmc_remove_host and left the card in place:

--------
Feb 18 01:02:58 mortug usbdev3.1_ep00: PM: resume from 0, parent usb3 still 2
Feb 18 01:02:58 mortug usbdev3.1_ep81: PM: resume from 0, parent 3-0:1.0 still 2
Feb 18 01:02:58 mortug tifm_sd tifm_sd0:3: resume initialize 0
Feb 18 01:02:58 mortug tifm_sd tifm_sd0:3: executing opcode 0x7, arg: 0xe6240000, mask: 0x2140
Feb 18 01:02:58 mortug tifm_sd tifm_sd0:3: host event: host_status 80, flags 0
Feb 18 01:02:58 mortug tifm_sd tifm_sd0:3: executing opcode 0x7, arg: 0xe6240000, mask: 0x2140
Feb 18 01:02:58 mortug tifm_sd tifm_sd0:3: host event: host_status 80, flags 0
Feb 18 01:02:58 mortug tifm_sd tifm_sd0:3: executing opcode 0x7, arg: 0xe6240000, mask: 0x2140
Feb 18 01:02:58 mortug tifm_sd tifm_sd0:3: host event: host_status 80, flags 0
Feb 18 01:02:58 mortug tifm_sd tifm_sd0:3: executing opcode 0x7, arg: 0xe6240000, mask: 0x2140
Feb 18 01:02:58 mortug tifm_sd tifm_sd0:3: host event: host_status 80, flags 0
Feb 18 01:02:58 mortug tifm_sd tifm_sd0:3: executing opcode 0x10, arg: 0x200, mask: 0x2140
Feb 18 01:02:58 mortug tifm_sd tifm_sd0:3: host event: host_status 80, flags 0
Feb 18 01:02:58 mortug tifm_sd tifm_sd0:3: executing opcode 0x10, arg: 0x200, mask: 0x2140
Feb 18 01:02:58 mortug tifm_sd tifm_sd0:3: host event: host_status 80, flags 0
Feb 18 01:02:58 mortug tifm_sd tifm_sd0:3: executing opcode 0x10, arg: 0x200, mask: 0x2140
Feb 18 01:02:58 mortug tifm_sd tifm_sd0:3: host event: host_status 80, flags 0
Feb 18 01:02:58 mortug tifm_sd tifm_sd0:3: executing opcode 0x10, arg: 0x200, mask: 0x2140
Feb 18 01:02:58 mortug tifm_sd tifm_sd0:3: host event: host_status 80, flags 0
Feb 18 01:02:58 mortug tifm_sd tifm_sd0:3: executing opcode 0x10, arg: 0x200, mask: 0x2140
Feb 18 01:02:58 mortug tifm_sd tifm_sd0:3: host event: host_status 80, flags 0
Feb 18 01:02:58 mortug tifm_sd tifm_sd0:3: executing opcode 0x10, arg: 0x200, mask: 0x2140
Feb 18 01:02:58 mortug tifm_sd tifm_sd0:3: host event: host_status 80, flags 0
Feb 18 01:02:58 mortug mmcblk0: unable to set block size to 512: 1
-----

It appears to me that mmc_block resumes and starts issuing requests all by itself, which is
incorrect.

For reference - correct resume sequence (card remains in place, mmc_resume_host called):

------
Feb 18 01:41:34 mortug usbdev3.1_ep00: PM: resume from 0, parent usb3 still 2
Feb 18 01:41:34 mortug usbdev3.1_ep81: PM: resume from 0, parent 3-0:1.0 still 2
Feb 18 01:41:34 mortug tifm_sd tifm_sd0:3: resume initialize 0
Feb 18 01:41:34 mortug tifm_sd tifm_sd0:3: ios: clock = 0, vdd = 15, bus_mode = 1, chip_select =
0, power_mode = 1, bus_width = 0
Feb 18 01:41:34 mortug tifm_sd tifm_sd0:3: ios: clock = 333333, vdd = 15, bus_mode = 1,
chip_select = 0, power_mode = 2, bus_width = 0
Feb 18 01:41:34 mortug tifm_sd tifm_sd0:3: ios: clock = 333333, vdd = 15, bus_mode = 1,
chip_select = 1, power_mode = 2, bus_width = 0
Feb 18 01:41:34 mortug tifm_sd tifm_sd0:3: executing opcode 0x0, arg: 0x0, mask: 0x40
Feb 18 01:41:34 mortug tifm_sd tifm_sd0:3: host event: host_status 1, flags 0
Feb 18 01:41:34 mortug tifm_sd tifm_sd0:3: ios: clock = 333333, vdd = 15, bus_mode = 1,
chip_select = 0, power_mode = 2, bus_width = 0
Feb 18 01:41:34 mortug tifm_sd tifm_sd0:3: executing opcode 0x37, arg: 0x0, mask: 0x2140
Feb 18 01:41:34 mortug tifm_sd tifm_sd0:3: host event: host_status 1, flags 0
Feb 18 01:41:34 mortug tifm_sd tifm_sd0:3: executing opcode 0x29, arg: 0x0, mask: 0x1340
Feb 18 01:41:34 mortug tifm_sd tifm_sd0:3: host event: host_status 1001, flags 0
Feb 18 01:41:34 mortug tifm_sd tifm_sd0:3: ios: clock = 333333, vdd = 14, bus_mode = 1,
chip_select = 0, power_mode = 2, bus_width = 0
-------

My really simple resume function:
-------
static int tifm_sd_resume(struct tifm_dev *sock)
{
        struct mmc_host *mmc = tifm_get_drvdata(sock);
        struct tifm_sd *host = mmc_priv(mmc);
        int rc;

        rc = tifm_sd_initialize_host(host);
        dev_dbg(&sock->dev, "resume initialize %d\n", rc);

        if (!rc) {
                host->eject = 0;
                rc = mmc_resume_host(mmc);
        }

        return rc;
}




 
____________________________________________________________________________________
Need Mail bonding?
Go to the Yahoo! Mail Q&A for great tips from Yahoo! Answers users.
http://answers.yahoo.com/dir/?link=list&sid=396546091
