Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbXL2LW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbXL2LW2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 06:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbXL2LWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 06:22:18 -0500
Received: from [194.117.236.238] ([194.117.236.238]:34887 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbXL2LWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 06:22:17 -0500
Date: Sat, 29 Dec 2007 13:19:40 +0200
From: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Richard Harman <richard@richardharman.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071229131940.31d82752@linux360.ro>
In-Reply-To: <47760ED5.6060207@richardharman.com>
References: <47754735.1050009@richardharman.com>
	<20071229095242.1300e19c@linux360.ro>
	<47760ED5.6060207@richardharman.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Dec 2007 04:09:41 -0500
Richard Harman <richard@richardharman.com> wrote:

> Right now, with your patch and the 'noirqdebug' option or disabling
> nohz the system appears to be stable.  This laptop otherwise locks up
> trying to configure apic/lapic, or locks up solid later with NO
> oops/bug and nothing will bring it out of it (eg, sysrq has no
> effect).  NMI watchdog was also inoperable, which I believe was due
> to the apic/lapic being disabled.
> 
> With your patch, the lapic is used:
> 
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)

The kernel should display these messages even without my patch.
 
> These kernel dmesg logs are hand-transcribed, and are from 2.6.22.5,
> but this shows where the kernel would lock up good and solid:
> 
> http://www.richardharman.com/pavilion/2.6.22.5/dmesg.txt

I doubt it is my patch that makes your laptop work. C1E detection was
added by the following commit:

$ git-describe fb79d22e1d4b06385796cc0db0084a2e07beccee
v2.6.23-2294-gfb79d22

Try building a 2.6.24-rc6 without my patch and see if it still works
(apply it again in reverse mode, for example). I guess it will work,
because the kernel shouldn't use the LAPIC as a timer at all (except as
a dummy one), with or without dynticks support.

When I started investigating the "nohz is not working problem", I
stumbled across a few threads on LKML where a few people had
similar problems with their laptops and they where instructed to pass
"nolapic" or something similar as a boot parameter to the kernel. I
guess the problem disappeared after the commit I mentioned previously,
since such reports weren't that recent. IIRC, that was on kernels
previous to 2.6.24-*, where x86 and x86-64 weren't unified and there
were no dynticks on the latter.

To be more clear, my patch disables C1E instead of disabling the
LAPIC, as these two don't agree with each other.
