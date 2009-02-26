Return-Path: <linux-kernel-owner+w=401wt.eu-S1757826AbZBZQDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826AbZBZQDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 11:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756458AbZBZQDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 11:03:22 -0500
Received: from 1wt.eu ([62.212.114.60]:2488 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502AbZBZQDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 11:03:21 -0500
Date: Thu, 26 Feb 2009 17:03:13 +0100
From: Willy Tarreau <w@1wt.eu>
To: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Failover Kernel
Message-ID: <20090226160311.GT5038@1wt.eu>
References: <49A659D0.2040903@turknet.net.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A659D0.2040903@turknet.net.tr>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 10:58:56AM +0200, Tarkan Erimer wrote:
> Hi all,
> 
> I'm thinking about a kernel feature called "Failover Kernel". The basic 
> idea is to put 2 kernels (One is running "Primary Kernel" and the next 
> one is "Backup Kernel") into the memory for disaster recovery of kernel 
> panic'ing/crashing.
> 
> This feature's working schema could be like this :
> 
> - "Backup Kernel" could be stated and loaded into the memory via a boot 
> line option like : "failover_kernel=/boot/vmlinuz-2.6.26"
> - Primary running kernel will send keepalives to the "Backup Kernel" to 
> state that it's alive.
> - Primary running kernel can write a journal (like the journaled 
> filesystems.) about needed infos for the backup kernel to recover.
> - When the primary kernel crashed and couldn't send anymore keepalives, 
> the backup kernel will recover from this journal to proceed to where the 
> primary kernel left and will become primary.
> - When "Backup Kernel" became "Primary" it will load the previous one as 
> "Backup Kernel" again or maybe it could be left to manual. User could 
> decide after the disaster recovery which kernel will be load as backup 
> via a utility like "kexec".
> - At kernel compile time, user can choose the the timing for failover 
> kernel. For example, "Recover After 10 MS. of inactivity (not receiving 
> keepalives). "
> 
> 
> The usage scenarios of this feature could be :
> 
> - For people whose Datacenter is remote, it's a big problem when you 
> compiled a new kernel and rebooting into a crashing/non-booting new 
> kernel. You left with a completely crashed and non-functioning system. 
> Hard reset and manual action is required. If there could be "Failover 
> Kernel feature, the system will simply switch back to the "Backup 
> Kernel" (This backup kernel will be the known stable kernel of the 
> system.) and the system will proceed to work without any manual action 
> required.
> 
> - Your system runs fine for the last several months and one day you hit 
> a bug and kernel crashed/panic'ed . With "Failover Kernel", the system 
> will switch to the "Backup Kernel" quickly (maybe some milliseconds or 
> few seconds.) to recover and the system could proceed to work normally.
> 
> So,I'm not a coder and I don't know it is really possible as technically 
> or not. You the kernel hackers, what's your opinion about it ? Could it 
> be really possible ? If so, how we really can implement it ?
> 
> Many thanks for reading this long (and maybe stupid) post! :-)

You forgot the most important thing : these two kernels will run on
the same machine. I'm not even considering how you intend to schedule
them. However, when a kernel crashes, it's often because of a hard
error : bug in a driver, memory corruption, etc...  You cannot sanely
recover from that. If the driver which crashed started to initiate a
multi-word command to the device, in a lot of situations you'll need
a reset to restore it in a known state. Memory corruption is even
worse, as you cannot even trust the backup kernel.

I'm currently using a backup kernel in our products, and do it with
the boot loader. Some BIOSes allow you to start a watchdog timer on
boot. Grub tries to load the first image, otherwise the second one.
If either image crashes during boot, the hardware watchdog triggers
and the machine reboots to the other image. That's extremely reliable,
and relatively simple.
 
And using this method, you don't have any compatibility problems between
your primary and secondary kernels.

Regards,
Willy

