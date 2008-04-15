Return-Path: <linux-kernel-owner+w=401wt.eu-S1764664AbYDOMAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764664AbYDOMAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 08:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758696AbYDOMAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 08:00:12 -0400
Received: from science.horizon.com ([192.35.100.1]:19205 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753432AbYDOMAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 08:00:09 -0400
Message-ID: <20080415115326.9915.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
Date: Tue, 15 Apr 2008 07:53:26 -0400
To: len.brown@intel.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Cc: linux@horizon.com
Subject: 2.6.25 regression: 60417f5976df breaks Thinkpad suspend
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trying a recent 2.6.25 on a laptop, I discovered that it
completely breaks suspend to RAM.  It blanks the screen and lights up
the sleeping light, but judging by the noises the laptop makes (help,
low battery!) after being unplugged for a while, it doesn't actually
suspend a whole lot.

More interestingly, it gets the laptop into a state where the only ways
I can make it respond are disconnecting and connecting AC power (beep),
and holding the power button down for 4 seconds.

The really interesting part is that after that, it won't turn on again!
I have to disconnect power and remove the battery to reset it hard enough
that it will respond to furtherpresses of the power button.

This smells like a BIOS bug to me, but it's interesting that it gets tickled.

The patch is unfortunately one that fixes other machines:

>   ACPI suspend: Call _PTS before suspending devices
>   
>   The ACPI 1.0 specification wants us to put devices into low power
>   states after executing the _PTS global control method, while ACPI
>   2.0 and later want us to do that in the reverse order.  The current
>   suspend code follows ACPI 2.0 in that respect which causes some
>   ACPI 1.0x systems to hang during suspend (ref.
>   http://bugzilla.kernel.org/show_bug.cgi?id=9528).
>   
>   Make the suspend code execute _PTS before putting devices into low
>   power states (ie. in accordance with ACPI 1.0x) and provide a command
>   line option to override the default if need be.

Fortunately, the "acpi_new_pts_ordering" kernel parameter fixes it,
but I waded through a full bisect (actually two, owing to some mistakes
the first time) before finding out about it.

IBM Thinkpad T21, "type 2647".  biosdecode says "Machine Type/Model:
26478AU" and "BIOS Build ID: KZET22WW".  Early ACPI boot messages are

ACPI: RSDP 000F7160, 0014 (r0 PTLTD )
ACPI: RSDT 0FFF4D07, 002C (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 0FFFEB65, 0074 (r1 IBM    TP-T21    6040000             0)
ACPI: DSDT 0FFF4D33, 9E32 (r1 IBM    TP-T21    6040000 MSFT  100000C)
ACPI: FACS 0FFFF000, 0040
ACPI: BOOT 0FFFEBD9, 0027 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: PM-Timer IO Port: 0x1008

With the patch applied and (default) enabled, there is a final disk
access (O(1 second) long) after the "sleeping"LED turns on, and then
the machine refuses to wake up.  Indeed, it refuses to be power-cycled,
as described above.

I'm not quite sure what The Right Thing to do is here, but I'm posting
this just to document that the patch is not perfect, and to help anyone
else who is stuck in the situation.
