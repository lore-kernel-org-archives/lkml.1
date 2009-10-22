Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbZJVWQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbZJVWQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 18:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbZJVWQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 18:16:05 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:38261 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755146AbZJVWQD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 18:16:03 -0400
From: Bela Lubkin <blubkin@vmware.com>
To: "'Corey Minyard'" <minyard@acm.org>
CC: "'Matt Domsch'" <Matt_Domsch@dell.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "discuss@LessWatts.org" <discuss@LessWatts.org>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Date: Thu, 22 Oct 2009 15:16:20 -0700
Subject: RE: [Openipmi-developer] [Discuss] [PATCH] ipmi: use	round_jiffies
 on timers to reduce timer overhead/wakeups
Thread-Topic: [Openipmi-developer] [Discuss] [PATCH] ipmi: use	round_jiffies
 on timers to reduce timer overhead/wakeups
Thread-Index: AcpTUrYoJVF+/Yy7ShyaxGiLAmtSSAADNEsg
Message-ID: <E0AA796A7E3F4C4E8F1065D15FE4786183AF694A@EXCH-MBX-4.vmware.com>
References: <20091021102822.5b32b2dc.randy.dunlap@oracle.com>
 <20091021114210.4d7e1ea9@linux.intel.com>	<4ADF57D7.7010808@intel.com>
 <20091021130348.cd521b0c.randy.dunlap@oracle.com>	<4ADF6D76.7070409@acm.org>
 <4ADF75A2.50202@linux.intel.com>
 <20091022025013.GB20467@auslistsprd01.us.dell.com>
 <E0AA796A7E3F4C4E8F1065D15FE4786183AF6948@EXCH-MBX-4.vmware.com>
 <4AE0BA6B.50805@acm.org>
In-Reply-To: <4AE0BA6B.50805@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey Minyard wrote:

> Bela Lubkin wrote:
>
> > Why does everyone use KCS when BT is obviously better?  Can
> > you have your team look into that as well?  (Among the various
> > goals here, I assume that BT -- with a single interrupt and a
> > DMA transfer instead of shuffling bytes over I/O ports -- would
> > cost less power.  Not that the members of that list will
> > receive this message: it bounces nonmembers.)

> This is an industry where pennies matter, apparently.

Well yeah.  Also an industry where a small leg up on some competitor can
turn into a big deal.  So that goes both ways.

> My personal preference would be to use the I2C based standard 
> interface.  That actually doesn't perform too badly, it's probably 
> cheaper than KCS since you already have I2C, anyway, and the I2C 
> interfaces are generally tied to an interrupt.  The trouble 
> is that the only hardware implementation of this I know of seems
> to be poorly done, but that mostly affects trying to use the
> ethernet interface and the local interface at the same time.
>
> Of course, the driver for I2C is not yet in the standard kernel as it 
> requires a fairly massive I2C driver rewrite to allow the 
> IPMI driver to do it's panic-time operations.

That seems like a fairly compelling argument against.  It's not in the
"standard kernel" (i.e. of Linux); it's probably not in other OSes.  So
now you're asking the software side of the industry to spend another
several years playing catchup.

> BT would be better for performance, I guess, but it's yet another 
> interface to tie in, and hanging this off an existing bus 
> seems like a sensible thing to do.  And performance is really not
> an issue for IPMI.

BT is already supported by existing code (e.g. OpenIPMI driver).  It can
almost certainly be presented on a PCI card (at PCI-mediated addresses
not some legacy ISA port range).  So what do you mean "yet another
interface to tie in"?  It's just a blob of behavior to be situated on a
PCI card (or mboard implementation in PCI space).

I2C?  Volunteering to put it on I2C is like volunteering to put the new
branch office on a 1200 baud modem because you're suspicious of all that
newfangled fiber stuff.  Huh?

Regarding performance, we've had real struggles with IPMI performance
aspects.  There were situations where kipmid failed to start or didn't
do its job correctly, resulting in very slow IPMI operations.  Seemingly
harmless -- except that some OEM management agent daemon was making
decisions based on feedback from IPMI.  The delays caused it to get into
some watchdog code that decided the system was hung and issued a reboot.   

On other systems, the OEM management agents poll IPMI so persistently
that kipmid ends up taking a significant fraction of a CPU (nearly
100% of a CPU in bursts, long term average of 40%+).  Since the Linux 
"Console OS" in COS-bearing versions of ESX is by design limited to a
single CPU, and since it does have other tasks to do, this causes some
bad bottlenecks.             

These things I mention are our bugs, should be fixed, are not
necessarily the "fault" of IPMI.  Yet they would have no noticable
impact if the BMC hardware was speaking BT.  The slow operations which
(when magnified by 1000s of calls) took up most of a CPU would instead
take up a barely measurable portion of a CPU.

I don't suppose my viewpoint on this is going to be popular on lkml,
but it is rather parochial to base hardware design decisions on "that's
OK because it will be dealt with in some nebulous near-future version
of the Linux kernel".  That's great for people who will be running a
bleeding edge Linux kernel.  Not so good for people running stodgier
Linux distros, other *ix OSes, Windows, QNX, who knows what else.
It's great that Linux is [or intends to be] on top of this.  It's not
the whole world.  The Dells of this world necessarily have to design
systems that will work adequately with e.g. RHEL5.4 (2.6.18 + a zillion
patches), not to mention Win2K3 SP${current}, etc.

If you're designing a phone handset, router, set-top box, etc. --
something where you own the entire project from hardware up to the top
of the software stack -- _then_ you can make decisions on such criteria.
General purpose hardware designs have to support general purpose OSes,
including lots of weird little backwaters.

>Bela<