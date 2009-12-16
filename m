Return-Path: <linux-kernel-owner+w=401wt.eu-S935537AbZLPVcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935537AbZLPVcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 16:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757997AbZLPVcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 16:32:14 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:50803 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbZLPVcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 16:32:13 -0500
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEACbgKEurR7H+/2dsb2JhbAC/KZcNhCsE
X-IronPort-AV: E=Sophos;i="4.47,408,1257120000"; 
   d="scan'208";a="280630720"
From: Roland Dreier <rdreier@cisco.com>
To: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
       kexec@lists.infradead.org
Subject: kexec reboot broken with ioatdma?
X-Message-Flag: Warning: May contain useful information
Date: Wed, 16 Dec 2009 13:32:11 -0800
Message-ID: <ada3a3a8v1g.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Dec 2009 21:32:12.0057 (UTC) FILETIME=[3A870890:01CA7E97]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a system with IOAT hardware, and rebooting with kexec fails with
the latest 2.6.32-git kernel.  I haven't really tried earlier kernels,
but I suspect the issue comes from the ioatdma driver being autoloaded now.

The reboot gets stuck at:

  ioatdma 0000:00:16.0: Self-test copy timed out, disabling
  ioatdma 0000:00:16.0: Freeing 2 in use descriptors!
  ioatdma 0000:00:16.0: Intel(R) I/OAT DMA Engine init failed

so presumably the IOAT hardware is left in a bad state that the ioatdma
driver in the kexec'ed new kernel can't handle.

I notice that long ago, there was a commit 428ed602 ("I/OAT: fix I/OAT
for kexec") that added a shutdown method to clean things up so kexec
worked, and then more recently there was 4fac7fa5 ("ioat: do not perform
removal actions at shutdown") that got rid of the shutdown hook.

I'm not sure what the correct fix is here: fix the shutdown order so
everyone drops all references to IOAT stuff before IOAT is shutdown, or
add some code to the ioatdma driver so it resets the hardware on startup
so the new kernel can deal with an unspecified state.

This is on a system with the following hardware:

00:16.0 System peripheral [0880]: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Devic
e [8086:3430] (rev 20)
00:16.1 System peripheral [0880]: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Devic
e [8086:3431] (rev 20)
00:16.2 System peripheral [0880]: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Devic
e [8086:3432] (rev 20)
00:16.3 System peripheral [0880]: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Devic
e [8086:3433] (rev 20)
00:16.4 System peripheral [0880]: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Devic
e [8086:3429] (rev 20)
00:16.5 System peripheral [0880]: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Devic
e [8086:342a] (rev 20)
00:16.6 System peripheral [0880]: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device [8086:342b] (rev 20)
00:16.7 System peripheral [0880]: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device [8086:342c] (rev 20)
80:16.0 System peripheral [0880]: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device [8086:3430] (rev 20)
80:16.1 System peripheral [0880]: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device [8086:3431] (rev 20)
80:16.2 System peripheral [0880]: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device [8086:3432] (rev 20)
80:16.3 System peripheral [0880]: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device [8086:3433] (rev 20)
80:16.4 System peripheral [0880]: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device [8086:3429] (rev 20)
80:16.5 System peripheral [0880]: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device [8086:342a] (rev 20)
80:16.6 System peripheral [0880]: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device [8086:342b] (rev 20)
80:16.7 System peripheral [0880]: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device [8086:342c] (rev 20)

Thanks,
  Roland
