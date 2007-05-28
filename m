Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbXE1M0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbXE1M0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 08:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbXE1M0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 08:26:42 -0400
Received: from ppsw-4.csi.cam.ac.uk ([131.111.8.134]:44955 "EHLO
	ppsw-4.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbXE1M0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 08:26:41 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <1180353095.4242.57.camel@lov.localdomain>
References: <200705272229.21263.rjw@sisk.pl> <20070527220412.GC22687@srcf.ucam.org> <1180304166.3131.66.camel@lov.localdomain> <200705280943.54312.rjw@sisk.pl> <20070528111554.GF18807@elf.ucw.cz> <1180351493.4242.31.camel@lov.localdomain> <6BFA837E-47D4-487F-9D71-FA83D6D865E5@cam.ac.uk> <1180353095.4242.57.camel@lov.localdomain>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <BDEF3C8A-D237-44C4-84E0-2218DFAE0E77@cam.ac.uk>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Alan Stern <stern@rowland.harvard.edu>
Content-Transfer-Encoding: 7bit
From: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Date: Mon, 28 May 2007 13:26:37 +0100
To: Kay Sievers <kay.sievers@vrfy.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 May 2007, at 12:51, Kay Sievers wrote:

> Either the whole idea of userspace firmware-loading should be  
> considered
> as a problem impossible to do right because of its unsolvable side
> effects. Or at least releasing loaded firmware should be the exception
> for drivers which can be sure, that the firmware is not needed in
> situations we try to work around here.

I don't believe that it is impossible. What is needed is some  
thought, and maybe a loose spec.

We need to think about safe ways of solving a simple problem: what to  
do when userspace is unable to respond to a kernel uevent request. We  
now have a timeout, whether it be handled synchronously or in the  
background. I don't think either solution is good enough.

[RFC] Possible Plan:

1) request_firmware() should stick around unmodified but be marked  
__deprecated.

2) request_firmware_nowait() as it stands should probably be removed.  
After all, it only has 2 in-kernel users at the moment.

3) uevent interface should be notified when userspace handlers are /  
are not available so that events can be queued to be handled when  
userspace does turn up and re-register a hotplug event handler.

4) request_firmware_async() introduced: asynchronous firmware loading  
interface built on basis of 3, such that problems at early boot and  
suspend / resume are avoided. Also request_firmware_async() taught to  
retain firmware in memory by default such that subsequent calls do  
not require a call to userspace if userspace is unavailable.

6) Documentation on correct firmware loading behaviour for driver  
authors written, together with migration notes for existing users of  
request_firmware().

7) Existing uses of request_firmware() converted.

*Grumble ahead*
Unfortunately, I don't properly understand the uevent interface, so  
some of the above may be inaccurate. This is *not* my fault as there  
is no decent documentation (and btw, telling me to write the  
documentation is not the answer to that problem).

Michael-Luke
