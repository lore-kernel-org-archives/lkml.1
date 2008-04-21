Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbYDUUpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbYDUUpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 16:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbYDUUpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 16:45:36 -0400
Received: from outbound-mail-116.bluehost.com ([69.89.22.16]:41207 "HELO
	outbound-mail-116.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751925AbYDUUpg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:45:36 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jean Delvare <jdelvare@suse.de>
Subject: Re: PCI MSI breaks when booting with nosmp
Date: Mon, 21 Apr 2008 13:40:20 -0700
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Tejun Heo <htejun@gmail.com>, Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jgarzik@pobox.com>
References: <200804172140.02311.jdelvare@suse.de> <87d4oj6o9a.fsf@basil.nowhere.org> <200804212220.20577.jdelvare@suse.de>
In-Reply-To: <200804212220.20577.jdelvare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804211340.21713.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 21, 2008 1:20 pm Jean Delvare wrote:
> Hi Andi,
>
> Le lundi 21 avril 2008, Andi Kleen a écrit :
> > Jesse Barnes <jbarnes@virtuousgeek.org> writes:
> > > Ok, I see this too on my desktop machine.  It looks like we're not
> > > getting interrupts setup correctly in the nosmp case.  Still digging
> > > through to see why though...
> >
> > NoSMP disables the io-apic and a lot of modern systems don't work without
> > APIC.
> >
> > If you just want to run with a single cpu for testing etc. always use
> > maxcpus=1 (not 0, that will disable the APIC too)
>
> In my case, booting with noapic works fine, so I don't think that the
> problem is related to APIC being disabled.

One difference between noapic and nosmp is that in the nosmp case even the 
local APIC setup won't occur in native_smp_prepare_cpus(), due to 
smp_sanity_check() returning -1 in the setup_max_cpus == 0 case.

So we either need smp_sanity_check to do a little more APIC setup if max_cpus 
== 0 or shuffle things around in native_smp_prepare_cpus().  Since the former 
is already done for 32 bit builds for the NMI vector, maybe we should just 
make it unconditional so that MSI works?

Jesse
