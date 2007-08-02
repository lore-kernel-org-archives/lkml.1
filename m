Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbXHBJPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbXHBJPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 05:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbXHBJPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 05:15:38 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:48289 "EHLO
	outbound2-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898AbXHBJPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 05:15:36 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: "Michael Chan" <mchan@broadcom.com>
Subject: Re: [REGRESSION] tg3 dead after s2ram
Date: Thu, 2 Aug 2007 11:15:05 +0200
User-Agent: KMail/1.9.7
cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "lkml List" <linux-kernel@vger.kernel.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "netdev" <netdev@vger.kernel.org>, linux-acpi@vger.kernel.org
References: <20070731174522.b141178a.akpm@linux-foundation.org>
 <1186002023.18322.7.camel@dell>
 <200708021005.45773.joachim.deguara@amd.com>
In-Reply-To: <200708021005.45773.joachim.deguara@amd.com>
MIME-Version: 1.0
Message-ID: <200708021115.10812.joachim.deguara@amd.com>
X-OriginalArrivalTime: 02 Aug 2007 09:15:18.0542 (UTC)
 FILETIME=[A512CAE0:01C7D4E5]
X-WSS-ID: 6AAF7F231A43316253-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 August 2007 10:05:44 Joachim Deguara wrote:
> On Wednesday 01 August 2007 23:00:23 Michael Chan wrote:
> > On Wed, 2007-08-01 at 10:47 -0700, Michael Chan wrote:
> > The problem is that memory enable and bus master were not set in PCI
> > register 4 after resume.  This also explains the register access
> > failures.

Found it! I did the instrumentation and found pci_restore was not being 
called. Why, because this code failed:

	printk(KERN_INFO "tg3_resume: entered\n");
	if (!netif_running(dev))
		return 0;
	printk(KERN_INFO "tg3_resume: before restore\n");

Bad dmesg:
[    0.581236] PM: Writing back config space on device 0000:07:00.0 at offset 
4
(was 4, writing d0200004)
[    0.581259] tg3_resume: entered
[    0.581276] PM: Writing back config space on device 0000:08:09.0 at offset 
f
(was c001ff, writing 1c0010b)

why is this, oh damn it is because I was calling openSUSE's "powersave -u" and 
not s2ram directly.  powersave is disabling the network and the tg3 will not 
restore the pci device like this! right?

here is a good dmesg with by calling s2ram:
[    0.577085] PM: Writing back config space on device 0000:07:00.0 at offset 
4
(was 4, writing d0200004)
[    0.577108] tg3_resume: entered
[    0.577109] tg3_resume: before restore
[    0.577140] PM: Writing back config space on device 0000:08:04.0 at offset 
c
(was 0, writing ffff0000)
[    0.577171] PM: Writing back config space on device 0000:08:04.0 at offset 
1
(was 2b00000, writing 2b00006)
[    0.577304] tg3_resume: after set_power_state
[    0.579119] tg3: eth0: Link is down.
[    0.786266] ata2: SATA link down (SStatus 0 SControl 310)
[    0.848176] tg3_resume: after tg3_restart_hw
[    0.848265] PM: Writing back config space on device 0000:08:09.0 at offset 
f
(was c001ff, writing 1c0010b)

Seams like even if powersave shuts down the network that the device should 
still work after a suspend to ram, so who is at fault here?

-Joachim


