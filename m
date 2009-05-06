Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbZEFIuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbZEFIuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 04:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbZEFIub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 04:50:31 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:40965 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbZEFIua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 04:50:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=BeRHRxiRocKlYgK2mKI8ZyGfnvnpUGid4EmmjD810U+2k6LNldVel8RVCES2/FVrZx
         DqvYujqpE6ed15XEDeDM/tc4JyUuUK+zGDC1KYCNSOQN9VBFFu0fXZsl1WP0xyAH08FF
         DeOljiljiO/x8E5VDQah9CmJ4fpynMnH28rH8=
Message-ID: <4A014F53.9000701@gmail.com>
Date: Wed, 06 May 2009 10:50:27 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.7 Thunderbird/3.0b2
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>
Subject: Re: kexec defunct -- sd-async-shutdown [mmotm 2009-04-30-17-55]
References: <200905010114.n411EV3X022247@imap1.linux-foundation.org> <4A000891.3070109@gmail.com> <20090506005101.GA25287@sli10-desk.sh.intel.com>
In-Reply-To: <20090506005101.GA25287@sli10-desk.sh.intel.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2009 02:51 AM, Shaohua Li wrote:
> On Tue, May 05, 2009 at 05:36:17PM +0800, Jiri Slaby wrote:
>> On 05/01/2009 02:55 AM, akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2009-04-30-17-55 has been uploaded to
>> ...
>>> sd-async-shutdown.patch
>> Hi,
>>
>> this one causes kexec to hang.
> Can you give more info about the hang, like the log? Is patch
> synchronize-device-shutdown.patch applied? kexec takes the same way
> to shutdown device, so does shutdown work in the system?

Ah, I though it silently hangs, but no, I had forgotten to switch a
logging console. There is nobody-cared interrupt 19 followed by plenty
of sata ports resets. The same happens on reboot.

According to /proc/interrupts, irq 19 is usb specific:
 19:          0          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb7

But ahci enables the legacy one at 19 too:
ahci 0000:00:1f.2: version 3.0
  alloc irq_desc for 19 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
  alloc irq_desc for 27 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
ahci 0000:00:1f.2: irq 27 for MSI/MSI-X
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports ? Gbps 0x3f impl SATA
mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pmp pio slum part ems
ahci 0000:00:1f.2: setting latency timer to 64


Is this that ahci frees msi and interrupts at all at the shutdown stage
and you "schedule" and wait for an interrupt afterwards? (And then the
interrupt comes, but usb says: no, it's not mine.)
