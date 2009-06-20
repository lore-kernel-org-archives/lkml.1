Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbZFTQ7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbZFTQ7P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 12:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756630AbZFTQ6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 12:58:54 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:51352 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273AbZFTQ6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 12:58:52 -0400
Date: Sat, 20 Jun 2009 10:58:53 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: jim owens <jowens@hp.com>
Cc: Martin Knoblauch <knobi@knobisoft.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>, efault@gmx.de,
       viro@zeniv.linux.org.uk, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, mike.miller@hp.com, linux-pci@vger.kernel.org
Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
Message-ID: <20090620165853.GL19977@parisc-linux.org>
References: <488605.71443.qm@web32605.mail.mud.yahoo.com> <20090527133125.c36381b5.akpm@linux-foundation.org> <ac3eb2510905271356n1b01f273jca1f7aa8fc65c78b@mail.gmail.com> <170150.72851.qm@web32604.mail.mud.yahoo.com> <20090616122547.1323d2d4@jbarnes-g45> <971371.70253.qm@web32604.mail.mud.yahoo.com> <4A3D104E.9060105@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3D104E.9060105@hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 20, 2009 at 12:37:34PM -0400, jim owens wrote:
> Martin Knoblauch wrote:
>> ----- Original Message ----
>>
>>> From: Jesse Barnes <jbarnes@virtuousgeek.org>
>>> To: Martin Knoblauch <knobi@knobisoft.de>
>>> Cc: Kay Sievers <kay.sievers@vrfy.org>; Andrew Morton <akpm@linux-foundation.org>; efault@gmx.de; viro@zeniv.linux.org.uk; rjw@sisk.pl; linux-kernel@vger.kernel.org; shemminger@vyatta.com; matthew@wil.cx; mike.miller@hp.com
>>> Sent: Tuesday, June 16, 2009 9:25:47 PM
>>> Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
>>  Not sure about the VPD thing. Anyway, no real news. Still happens in 2.6.30. But it only happens on a certain HW platform (HP/DL380G4). The folks at HP try to reproduce in their environment.
>
> I reproduced this and verified Martin's analysis.  Conclusions:
>
>    - >>> | none /sys sysfs rw 0 0
>
> is because the initrd "umount /sys" fails with EBUSY
>
>    |commit 1120f8b8169fb2cb51219d326892d963e762edb6
>    |Author: Stephen Hemminger <shemminger@vyatta.com>
>    |Date:   Thu Dec 18 09:17:16 2008 -0800
>    |
>    |    PCI: handle long delays in VPD access
>
> does not have a bug.  The longer timeout makes the problem visible.
>
> /sys is busy because udev is trying to read the vpd and the
> cciss pci device always fails the vpd with ETIMEOUT.  If all
> timeouts are before or after the umount, no firmware load problem.
>
> IMO there is either a vpd read bug on this platform or it is
> unsupported and ETIMEOUT is the wrong error.
>
> ... now I punt this to the HP platform/driver people.

OK, let's add the PCI list in on this too ...

There are a bunch of PCI devices with buggy VPD.  I've got one (it's a prototype card, I think, so I shan't name the vendor).  lspci reports:

        Capabilities: [84] Vital Product Data
                Unknown small resource type 00
[last line repeated about 32768 times]

and it takes for-freaking-ever.  I posted a patch to pciutils on May
13th to fix this:

---

I have several cards which report more-or-less garbage in their VPD.
It can take an extraordinarily long time to read all their VPD and none
of it is of interest.  Instead, if we find an unknown resource type,
just stop trying to read any more.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/ls-vpd.c b/ls-vpd.c
index f50d7a4..1ba917f 100644
--- a/ls-vpd.c
+++ b/ls-vpd.c
@@ -204,7 +204,7 @@ cap_vpd(struct device *d)
 	default:
 	  printf("\t\tUnknown %s resource type %02x\n",
 		 (tag & 0x80) ? "large" : "small", tag & ~0x80);
-	  break;
+	  return;
 	}
 
       res_addr += res_len;

-----

but I don't know what udev is doing.  The udev source doesn't seem to
read PCI vpd itself:

udev-0.141$ find -type f |xargs grep -il vpd
./extras/volume_id/lib/adaptec_raid.c
./extras/scsi_id/scsi_id.8
./extras/scsi_id/scsi.h
./extras/scsi_id/scsi_id.config
./extras/scsi_id/scsi_serial.c

so there must be some script that it's invoking which is doing that.
Anyone familiar with udev?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
