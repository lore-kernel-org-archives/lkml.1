Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbXLIJVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbXLIJVR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 04:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbXLIJVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 04:21:03 -0500
Received: from smtp101.plus.mail.re1.yahoo.com ([69.147.102.64]:28325 "HELO
	smtp101.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751750AbXLIJVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 04:21:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=vWwlwdF5crwITu7vfUZ4MVRq7Fevt2UTMBbwkkzmbJZ6/kZaLJh0jQorFq9XC9hCnqKzMXWTBYHClvWNjHXleZnIMtDOZtAQmJWaMalgLhpcTJWUQYiF0XmpD/Q0C9KvXRjcNlh4MJLg8gU/OqGOzCfsiS8mGeNlraIECOw6wbc=  ;
X-YMail-OSG: LgubjkwVM1ktIdsmpdKTOfekOt4jyUMVFk_0LaXx9g4HYTb6Bng_wRRISJwtuR2kjV.raXrzdA--
Date: Sun, 9 Dec 2007 10:19:47 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Andrew Morton <akpm@linux-foundation.org>, len.brown@intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc4-mm1: acpi reboots machine
Message-ID: <20071209091946.GA4501@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de,
	Andrew Morton <akpm@linux-foundation.org>, len.brown@intel.com,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20071209075001.GA4686@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071209075001.GA4686@gollum.tnic>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2007 at 08:50:02AM +0100, Borislav Petkov wrote:
> Hi Andrew,
> Hi Len,
> 
> after booting 2.6.24-rc4-mm1 (2.6.24-rc4-190-g94545ba, otoh, boots just
> fine) on my asus laptop, the machine reboots after claiming that
> "Critical temperature reached (255 C)." However, the degrees number
> is kinda hinting at 0xff all-ones field. Will try dump_stack in
> acpi_thermal_critical() to checkout the call path. For now here's the netconsole bootlog:

Here's what i got so far:

[   50.287939] Pid: 1, comm: swapper Not tainted 2.6.24-rc4-mm1 #14
[   50.287999]  [<c0104b65>] show_trace_log_lvl+0x12/0x25
[   50.288103]  [<c01053e7>] show_trace+0xd/0x10
[   50.288202]  [<c0105a6c>] dump_stack+0x57/0x5f
[   50.288303]  [<c021c991>] acpi_thermal_check+0x150/0x3bb
[   50.288415]  [<c021d4b3>] acpi_thermal_add+0x261/0x2cf
[   50.288515]  [<c0213549>] acpi_device_probe+0x3e/0xdb
[   50.288615]  [<c023f8f5>] driver_probe_device+0xaf/0x12a
[   50.288717]  [<c023fa88>] __driver_attach+0x6c/0xa5
[   50.288817]  [<c023ee5a>] bus_for_each_dev+0x3e/0x60
[   50.288916]  [<c023f77d>] driver_attach+0x14/0x16
[   50.289015]  [<c023f5a6>] bus_add_driver+0xa6/0x1a8
[   50.289114]  [<c023fc53>] driver_register+0x42/0x47
[   50.289214]  [<c02138c2>] acpi_bus_register_driver+0x3a/0x3c
[   50.289316]  [<c044306b>] acpi_thermal_init+0x57/0x76
[   50.289424]  [<c04344a7>] kernel_init+0x138/0x280
[   50.289525]  [<c01047df>] kernel_thread_helper+0x7/0x10
[   50.289625]  =======================
[   50.289680] ACPI: Critical trip point
[   50.289736] Critical temperature reached (255 C), shutting down.

so in acpi_thermal_get_temperature() called in acpi_thermal_add() the
tz->temperature thingy is not set properly (printk's added):

[   50.276607] Old temp: 4294967023
[   50.281890] Got temp: 255
[   50.282567] Old temp: 255
[   50.287882] Got temp: 255

What's also strange is that the tz acpi_thermal is alloc'd with kzalloc and
there's still garbage in it after reading it in acpi_thermal_get_temperature()
for the first time. Debugging continues...
-- 
Regards/Gruﬂ,
    Boris.
