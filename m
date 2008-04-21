Return-Path: <linux-kernel-owner+w=401wt.eu-S1759076AbYDUTMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076AbYDUTMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbYDUTMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:12:09 -0400
Received: from outbound-mail-34.bluehost.com ([69.89.18.154]:57007 "HELO
	outbound-mail-34.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754174AbYDUTMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:12:07 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: PCI MSI breaks when booting with nosmp
Date: Mon, 21 Apr 2008 12:06:59 -0700
User-Agent: KMail/1.9.9
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Jean Delvare <jdelvare@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Tejun Heo <htejun@gmail.com>, Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jgarzik@pobox.com>
References: <200804172140.02311.jdelvare@suse.de> <200804211043.10410.jbarnes@virtuousgeek.org> <87d4oj6o9a.fsf@basil.nowhere.org>
In-Reply-To: <87d4oj6o9a.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804211207.00961.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 21, 2008 11:45 am Andi Kleen wrote:
> Jesse Barnes <jbarnes@virtuousgeek.org> writes:
> > Ok, I see this too on my desktop machine.  It looks like we're not
> > getting interrupts setup correctly in the nosmp case.  Still digging
> > through to see why though...
>
> NoSMP disables the io-apic and a lot of modern systems don't work without
> APIC.
>
> If you just want to run with a single cpu for testing etc. always use
> maxcpus=1 (not 0, that will disable the APIC too)

Right...  but it looks like the MSI code is buggy when noapic is specified via 
nosmp or maxcpus=0.  We should either fix it to work with noapic or disable 
it like we do the ioapic when nosmp or maxcpus=0:

index 99ce949..a0cd0ab 100644
--- a/init/main.c
+++ b/init/main.c
@@ -148,6 +148,7 @@ static int __init nosmp(char *str)
 {
        setup_max_cpus = 0;
        disable_ioapic_setup();
+       pci_no_msi();
        return 0;
 }

@@ -156,9 +157,10 @@ early_param("nosmp", nosmp);
 static int __init maxcpus(char *str)
 {
        get_option(&str, &setup_max_cpus);
-       if (setup_max_cpus == 0)
+       if (setup_max_cpus == 0) {
                disable_ioapic_setup();
-
+               pci_no_msi();
+       }
        return 0;
 }

