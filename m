Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbYAYRhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbYAYRhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 12:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbYAYRhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 12:37:08 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:38286 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbYAYRhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 12:37:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L6w5FMfr7XrCeYqJNwVFs+w8+7MiEvgCD1Tj8Nb41fdgFD9DZes9mBZdftHnnJjG1wkeR2VLiebznqyE3FV/Rw4pFWaMWQookAlj8dH8Exo+QxXX35q0lPdTrcBAXoDKZu6an4srBZuWC1pHGxHEQEVPNuJmWOsGLWB8CCEN7Tk=
Message-ID: <9d9c4a330801250937q5ad177c1i2aafba47fb029991@mail.gmail.com>
Date: Fri, 25 Jan 2008 12:37:05 -0500
From: "Brett Dikeman" <brett.dikeman@gmail.com>
To: linux-poweredge@lists.us.dell.com, linux-kernel@vger.kernel.org
Subject: Re: 2850 drive bays not hot-swap?
In-Reply-To: <4798F69B.8060805@emmanuelcomputerconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9d9c4a330801241215l188115f1wcb5904e1b5ad208a@mail.gmail.com>
	 <4798F69B.8060805@emmanuelcomputerconsulting.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 24, 2008 3:35 PM, William Warren
<hescominsoon@emmanuelcomputerconsulting.com> wrote:

> http://lists.us.dell.com/pipermail/linux-poweredge/2003-July/008898.html

An update: I don't know whether it is a kernel problem or a hardware
problem, but the instructions  pertaining to removing and adding SCSI
devices live above doesn't work on a PE2850 (which uses "LSI Logic /
Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 08)",
aka Dell's PERC controller 4e/Di, driven by the mpt* drivers.)

  It *appears* to work, but the bus seems to grind to a near halt.
This may be an inaccurate conclusion, but I'm leaning toward kernel
issues, since iowait didn't skyrocket.

ID's 2-5 on a U320 bus off a PERC controller are in a RAID10 array.
IDs 0&1 are in a separate mirror.

1)echoed "scsi remove-single-device 0 0 5 0" > /proc/scsi/scsi

2)Pull the drive and issued mdadm /dev/md0 --remove detached

4)Re-inserted the same drive and issued echo "scsi add-single-device 0
0 5 0" > /proc/scsi/scsi
(and the kernel gave it /dev/sdg instead of /dev/sdf, as a side-note.)

5)issued mdadm /dev/md0 --re-add /dev/sdg1

No messages indicating anything afoul.

I then fired up watch -n 5 /proc/mdstat and noticed that the rebuild
rate was a fraction of what it should have been; hovering at a very
constant number- I believe 2339KB/sec.  It should be 74,000KB/sec
(drops to as low as 45,000KB/sec at the tail end of the drives.)  Load
average jumped to 2+, yet nothing showed up in top as taking any CPU
time, even with a 10 second average.  No iowait indicated.  I
increased sync_speed_min to 20000 with no change.

Then I noticed that the system drive mirror (first two drives) looked
to have quite a bit of disk activity, but I couldn't find what was
causing it.  Now I realize that it wasn't "quite a bit"- I think it
was disk I/O grinding to a near halt.

I shut down the system, and after power-up and booting, the RAID10
array is rebuilding at full speed...

I'm happy to provide additional info and try things for interested
parties to troubleshoot or fix this problem.  Being able to hot-swap
drives is pretty critical here.

Brett
