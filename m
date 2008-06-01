Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908AbYFAVXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbYFAVXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 17:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbYFAVXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 17:23:08 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:29425 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbYFAVXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:23:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=rBDBzZNJCCudy4jUwZmfaN6bMis9KGnV4ayIffiGabUE8fw/3cETlj8XDs1EFGpxqHH2xP2IgByt/xOoB6VFCxhMunlW9hPML7RaOZZfEuLlQ1+nKdGc5lMlvvMoI18o+FD6oCTdelHG34SW8BBG1qd54PdpIpTDNXYSYW5mEm8=
Message-ID: <6278d2220806011423o22e98f27qfd72fbd152d19d9f@mail.gmail.com>
Date: Sun, 1 Jun 2008 22:23:04 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: Re: Limits of the 965 chipset & 3 PCI-e cards/southbridge? ~774MiB/s peak for read, ~650MiB/s peak for write?
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 Jun, 10:50, Justin Piszcz <jpis...@lucidpixels.com> wrote:
> I have 12 enterprise-class seagate 1TiB disks on a 965 desktop board and
> it appears I have hit the limit, if I were able to get the maximum speed
> of all drives, ~70MiB/avg * 12 = 840MiB/s but it seems to stop aound 774
> MiB/s (currently running badblocks on all drives)..

Nice test. The Seagate 7200.11 drives deliver 120MB/s (outer zone,
raw) each, and there is an issue with CFQ dispatching requests; see:

http://groups.google.co.uk/group/linux.kernel/browse_thread/thread/b88264b084a2dfe0/a1bc0f67837bad00

A quick workaround tweak is:

# echo 0 >/sys/block/sda/queue/iosched/slice_idle

Does this help any? This gives the difference of ~68MB/s vs ~120MB/s
on my 7200.11 ;-) .

That said, the i965 chipset is fairly contemporary, but if that 2GB/s
DMI connection is the bidirectional bandwidth (likely), then maybe
you're hitting that limit: Intel's DMI bus is based on PCIe, thus will
use 128 byte PCI-e Max Payload packets (as in the rest of the
chipset), which IIRC theoretically maxes you out near 800MB/s.

The X48 chipset may allow you to crank the Max Payload to 256 (setpci
and the Intel chipset docs), if it doesn't default to 256, like in
5400 server chipsets. This chipset is where the fun really starts eg
hdparm -T giving >10GB/s, like in Itanium2s ;-) .

Thanks,
  Daniel
-- 
Daniel J Blueman
