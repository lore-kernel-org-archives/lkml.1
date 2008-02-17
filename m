Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbYBQV43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbYBQV43 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 16:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbYBQV4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 16:56:20 -0500
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:11174 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbYBQV4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 16:56:19 -0500
Date: Sun, 17 Feb 2008 16:56:17 -0500 (EST)
Message-Id: <6gr00g$g7cm6f@smtp01.lnh.mail.rcn.net>
From: "David P. Reed" <dpreed@reed.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] x86: cleanup primary motherboard chip port access delays
X-Junkmail-Status: score=10/50, host=mr02.lnh.mail.rcn.net
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A010204.47B8AD81.0093,ss=1,fgs=0,
	ip=207.172.4.11,
	so=2007-10-30 19:00:17,
	dmn=5.4.3/2007-11-16
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cleanup motherboard chip io port delays.  inb_p and outb_p have traditionally
used a write to port 80 (a non-existent port) as a delay.  Though there is an
argument that that is a good delay for devices on the ISA or PCI expansion buses
it is not a good mechanism for devices in the processor chipset or on the
"motherboard".  The write to port 80 at best causes an abort on the ISA or LPC
bus, and on some machines (like many of the HP laptops manufactured by Quanta)
actually writes data to real i/o devices.  For example, the ENE Embedded
Controller chip family defaults to provide a register at port 80 that 
can be written, and which can cause an interrupt in the Embedded Controller.

This has been shown to cause hangs on some machines, especially in accessing
the CMOS RTC during bootup.

This patch series addresses three of the places where these are used in common
kernel code - in particular the three uses that affect the HP laptops mentioned
above, modifying the delays to match the worst known delay issues for the
specific chips.

The patch set is complementary to the iodelay= kernel parameter added in 2.6.25,
since it means fewer users will need to add that parameter to run linux "out of the box" without hanging.

-- 
