Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbXD1LXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbXD1LXq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 07:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbXD1LXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 07:23:46 -0400
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:38922 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754114AbXD1LXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 07:23:45 -0400
In-Reply-To: <20070427144434.970de79f.akpm@linux-foundation.org>
References: <200704271742.l3RHgPTH019561@fire-2.osdl.org> <20070427144434.970de79f.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <18bbbf39d8da8a578ab7eab477f500c1@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       Truxton Fulton <trux@truxton.com>, linux-kernel@vger.kernel.org,
       lee-in-berlin@web.de
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [Bugme-new] [Bug 8378] New: Averatec 3156X laptop doesn't reboot with kernels > 2.6.13.5 (responsible commit found)
Date: Sat, 28 Apr 2007 13:23:17 +0200
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

That patch says

> +               outb(0x60, 0x64);       /* write Controller Command 
> Byte */
> +               udelay(50);
> +               kb_wait();
> +               udelay(50);
> +               outb(0x14, 0x60);       /* set "System flag" */

so the comment doesn't agree with the code: it sets
all flags in the command byte, not just the system
flag.  Perhaps importantly, it disables the keyboard
clock.  Why not do a read-modify-write sequence instead?
Something like

                outb(0x20, 0x64);       /* read Controller Command Byte 
*/
                udelay(50);
                kb_wait();
                udelay(50);
                u8 cmd = inb(0x60);
                udelay(50);
                kb_wait();
                udelay(50);
                outb(0x60, 0x64);       /* write Controller Command Byte 
*/
                udelay(50);
                kb_wait();
                udelay(50);
                outb(cmd | 0x04, 0x60); /* set "System flag" */

Segher

