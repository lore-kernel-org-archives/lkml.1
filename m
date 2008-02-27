Return-Path: <linux-kernel-owner+w=401wt.eu-S1757043AbYB0Vfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043AbYB0Vfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYB0VfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:35:21 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:1778 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbYB0VfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:35:19 -0500
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Mingarelli <thomas.mingarelli@hp.com>
Subject: Re: hpwdt oops in clflush_cache_range
X-Message-Flag: Warning: May contain useful information
References: <adad4qiwcmz.fsf@cisco.com>
	<alpine.LFD.1.00.0802271913050.7583@apollo.tec.linutronix.de>
	<ada1w6y1bzk.fsf@cisco.com>
	<alpine.LFD.1.00.0802272011130.7583@apollo.tec.linutronix.de>
	<20080227203655.GA30054@elte.hu>
	<alpine.LFD.1.00.0802272140050.7583@apollo.tec.linutronix.de>
	<alpine.LFD.1.00.0802272155190.7583@apollo.tec.linutronix.de>
	<ada3areyu7x.fsf@cisco.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 27 Feb 2008 13:35:08 -0800
In-Reply-To: <ada3areyu7x.fsf@cisco.com> (Roland Dreier's message of "Wed, 27 Feb 2008 13:17:54 -0800")
Message-ID: <adave4axeur.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Feb 2008 21:35:11.0362 (UTC) FILETIME=[A1974E20:01C87988]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > the ioremap there is trying to remap 0x7b6 bytes at an address of
 > 0x240047000ee000 -- either the BIOS data is bogus or the driver is
 > getting at it the wrong way.

Looking at the code, it seems that maybe only the low 32 bits of the
address are supposed to be used.  With a 32-bit kernel the address
in smbios_entry_point.table_address would be silently truncated to 32
bits, and on my 64-bit kernel, the patch below seems to make things
work... (ie the driver seems happy -- I didn't actually try the
watchdog, and in fact this whole exercise just started with me seeing
the new config option and saying "Hey I've got an HP box with ilo2!"
rather than any desire to actually use the feature)

I have to say this driver looks a little iffy -- a huge chunk of the
code is inside a big

#ifndef CONFIG_X86_64
...
#else
...
#endif

and the code where the crash happens has:

static int __devinit smbios_present(const char __iomem *p)
{
	struct smbios_entry_point *eps =
		(struct smbios_entry_point *) p;

and then blithely dereferences the eps pointer, which I guess works
fine on x86 but is not exactly how we encourage people to use __iomem
pointers.

 - R.

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index a2e174b..21efdfa 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -511,7 +511,7 @@ static int __devinit smbios_present(const char __iomem *p)
 		    (strncmp((char *)eps->intermediate_anchor, "_DMI_",
 		             sizeof(eps->intermediate_anchor)) == 0) &&
 		    (bios_checksum(p+0x10, 15))) {
-			buf = ioremap(eps->table_address, eps->table_length);
+			buf = ioremap(eps->table_address & 0xffffffff, eps->table_length);
 			if (buf == NULL)
 				return -ENODEV;
 
