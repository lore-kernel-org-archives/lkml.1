Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYGZGUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYGZGUz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 02:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbYGZGUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 02:20:46 -0400
Received: from nebensachen.de ([195.34.83.29]:52123 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbYGZGUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 02:20:44 -0400
X-Hashcash: 1:20:080726:alan@lxorguk.ukuu.org.uk::Dpdf+zqmp17oUzko:00000000000000000000000000000000000002k98
X-Hashcash: 1:20:080726:jeff@garzik.org::bCDXHAT4MtxPzQca:0022iy
X-Hashcash: 1:20:080726:bzolnier@gmail.com::xpZLJFzjdqvibpan:00000000000000000000000000000000000000000008j/o
X-Hashcash: 1:20:080726:james.bottomley@hansenpartnership.com::yN8j6nSASXdo/NuG:0000000000000000000000001sfK
X-Hashcash: 1:20:080726:pavel@ucw.cz::J4C8JFUA5Wnxr4Vj:000001mEZ
X-Hashcash: 1:20:080726:linux-ide@vger.kernel.org::NKGF8tLnxTDzEDWT:0000000000000000000000000000000000004deK
X-Hashcash: 1:20:080726:linux-kernel@vger.kernel.org::4soZXyGX5ybaDmf9:0000000000000000000000000000000006qpf
From: Elias Oltmanns <eo@nebensachen.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [RFC] Disk shock protection in GNU/Linux
Date: Sat, 26 Jul 2008 08:20:21 +0200
Message-ID: <87prp1kvyy.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

yet again, I'm trying to get this feature into the Linux kernel. This
time, I have tried to arrange the code in such a way that hardly
anything not strictly belonging to the libata or ide subsystem is
touched at all. Since former attempts to design this in a more generic
way involving the block and scsi layer have proven very difficult and
since this is all about an ATA specific feature anyway, I think the best
solution (for now at least) is to stick to those two subsystems as far
as possible.

Nevertheless, I'd welcome James' opinion on the third patch in the
series with regard to the use of vendor specific cdbs. If it is
acceptable in principle, the question remains whether we sould reserve
part of the range 0xf800 - 0xffff of vendor specific service actions for
the exclusive use by LLDDs (in much the way I did it here), or whether
all these codes should be unique in the kernel and defined in scsi.h.

Also, we have to agree upon a suitable way to deal with devices that
actually do support the UNLOAD FEATURE but don't report that capability
in their ID as specified in ATA-7. Perhaps we even want to fall back to
STANDBY IMMEDIATE on devices that definitely don't support IDLE
IMMEDIATE with UNLOAD FEATURE; this has been the case for the original
hdaps / disk-protect patch but I'm not quite sure whether anybody
actually relies on this feature and whether it would be advisable in the
first place. Regarding devices that support head unloading but don't
report it properly, there seem to be the following options:

a) Provide an attribute in sysfs for the user to indicate that the
   device really does support the UNLOAD FEATURE.
b) Issue the command (for the first time) anyway and check whether the
   device responds as specified in ATA-7. Make a note of the result and
   act accordingly from there on.

The second option looks appealing because no user intervention is
required and it is known to work at least for some devices. On the other
hand, it may be dangerous on old hardware and I don't even know whether
all pre-ATA-7 devices supporting the UNLOAD FEATURE really do return the
correct data in the command registers.

Here is a short description of the patches in this series applying
cleanly on top of next-20080725:

1. This is a trivial patch making things slightly easier for #3. More
   importantly though, it also fixes a potential memory leak and should
   probably be applied regardless of the rest of the series (Jeff?).
2. This is a small patch to ata.h in order to provide a simple check for
   support of the UNLOAD FEATURE as indicated in a device's ID.
3. Here disk head unloading is implemented in the libata subsystem. See
   the changelog entry for current shortcomings of this patch.
4. The same for ide.
5. A little bit of documentation.

There are some questions I need your advice on that have been inserted
as FIXME comments into the code. However, here is a more general
question that interests me even though it could turn out to be a good
idea (or at least acceptable) to merge these patches before that
question has been fully resolved. Alan once mentioned that it might be
desirable to abort commands currently in progress and issue IDLE
IMMEDIATE straight away. My question is whether this is at all possible
for non SATA command protocols. In volume 2 of the ATA-7 specification I
haven't found a well defined way to abort or shor circuit, say, a DMA or
PIO command in progress. It even says that after the host has aborted
data transfer when DMA was in progress, it is supposed to initiate a
SRST. Obviously, I'd like to avoid that at all costs.

Thank you in advance for your cooperation,

Elias
