Return-Path: <linux-kernel-owner+w=401wt.eu-S933700AbXCQKHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700AbXCQKHS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 06:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933761AbXCQKHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 06:07:17 -0400
Received: from www17.your-server.de ([213.133.104.17]:3095 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933700AbXCQKHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 06:07:15 -0400
Message-ID: <45FBBDEA.9060708@m3y3r.de>
Date: Sat, 17 Mar 2007 11:07:38 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_RISS?= <frederic.riss@gmail.com>,
       Milan Broz <mbroz@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] clockevents: Fix suspend/resume to disk hangs
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>	 <200703162134.14265.rjw@sisk.pl>	 <1174078066.13341.279.camel@localhost.localdomain> <1174087552.13341.332.camel@localhost.localdomain>
In-Reply-To: <1174087552.13341.332.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner schrieb:
> I finally found a dual core box, which survives suspend/resume without
> crashing in the middle of nowhere. Sigh, I never figured out from the
> code and the bug reports what's going on.
>
> The observed hangs are caused by a stale state transition of the clock
> event devices, which keeps the RCU synchronization away from completion,
> when the non boot CPU is brought back up.
>
> The suspend/resume in oneshot mode needs the similar care as the
> periodic mode during suspend to RAM. My assumption that the state
> transitions during the different shutdown/bringups of s2disk would go
> through the periodic boot phase and then switch over to highres resp.
> nohz mode were simply wrong.
>
> Add the appropriate suspend / resume handling for the non periodic
> modes.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>   

Excellent work. Now suspend to disk is working again. But:

1.) The quirk added in commit a417a21e10831bca695b4ba9c74f4ddf5a95ac06
for the appletouch driver doesn't seem to work after resume.

2.) The first suspend to disk works with no problems, but the second
suspend to disk in a row results in an oops:
 ->resume_device ->
pci_device_resume->ata_host_resume->ahci_pci_device_resume->ata_pci_device_do_resume->pci_restore_state

