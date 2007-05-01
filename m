Return-Path: <linux-kernel-owner+w=401wt.eu-S1031635AbXEAJrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031635AbXEAJrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 05:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031632AbXEAJrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 05:47:10 -0400
Received: from ns.suse.de ([195.135.220.2]:53743 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031635AbXEAJrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 05:47:07 -0400
From: Neil Brown <neilb@suse.de>
To: bugme-daemon@bugzilla.kernel.org
Date: Tue, 1 May 2007 19:46:36 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17975.3196.435174.722895@notabene.brown>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: SCSI discover order strangeness [Bug 8412] New: CONFIG_MOUSE_PS2 makes RAID detection fail
In-Reply-To: message from bugme-daemon@bugzilla.kernel.org on Tuesday May 1
References: <200705010918.l419IC8B016596@fire-2.osdl.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[Please reply-to-all rather than replying through bugzilla so that
 people on cc list get to see replies...
 I hope bugzilla can pick the Bug number out of the middle of the
 subject line....]

On Tuesday May 1, bugme-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=8412
> 
>            Summary: CONFIG_MOUSE_PS2 makes RAID detection fail

Based on subsequent comments, I think you got that backwards - absense
of CONFIG_MOUSE_PS2 makes RAID detection fail, but no matter..


>     Kernel Version: 2.6.21
>             Status: NEW
>           Severity: low
>              Owner: io_md@kernel-bugs.osdl.org
>          Submitter: shutdown@brend.org
> 
> Problem Description: If a kernel without CONFIG_MOUSE_PS2 enabled is used, the
> kernel won't detect my RAID1 array, but the hard drives it consits of are
> properly detected and the partition type reads "FD - Linux Raid Autodetect" as well.
> No /dev/md0 is created while booting the kernel.
> I built 2.6.21 with the same .config except for CONFIG_MOUSE_PS2 twice for
> testing purposes and discovered this weird thing.
> I'm going to attach the .config (without CONFIG_MOUSE_PS2), the dmesg of this
> kernel as well as the CONFIG_MOUSE_PS2-enabled kernels dmesg.

In the failure case, the SCSI drives (sdb, sdc) on which your raid
resides are not getting detected until after md initialisation has
decided that there is nothing to assemble.

My first thought was that the new threaded device discovery was
allowing md init to happen before scsi discovery was complete.  Maybe
the presence of CONFIG_MOUSE_PS2 makes some bit go faster...

However 
  # CONFIG_SCSI_SCAN_ASYNC is not set

so maybe not...

Greg (or anyone else reading): you know about this threaded
discovery.. could it allow some discovery to complete after userspace
has started, and does CONFIG_SCSI_SCAN_ASYNC affect it?

I think you best bet is to not depend on raid-auto-detect but to run
mdadm to assemble your arrays instead.  As your root isn't on md/raid,
that should be trivial to arrange.

NeilBrown
