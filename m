Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbYA0GCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbYA0GCA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 01:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYA0GBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 01:01:20 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38068 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754047AbYA0GBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 01:01:19 -0500
Date: Sat, 26 Jan 2008 22:01:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, gregkh@suse.de,
       kristen.c.accardi@intel.com
Subject: Re: [PATCH(v3) 2.6.24] Fix fakephp deadlock
Message-Id: <20080126220101.9e767f41.akpm@linux-foundation.org>
In-Reply-To: <479A0D1C.8080401@mev.co.uk>
References: <479A0D1C.8080401@mev.co.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 25 Jan 2008 16:23:56 +0000 Ian Abbott <abbotti@mev.co.uk> wrote:
> From: Ian Abbott <abbotti@mev.co.uk>
> 
> If the fakephp driver is used to emulate removal of a PCI device by
> writing text string "0" to the "power" sysfs attribute file, this causes
> its parent directory and its contents (including the "power" file) to be
> deleted before the write operation returns.  Unfortunately, it ends up
> in a deadlock waiting for itself to complete.

Thansk for working on this, but....

> The deadlock is as follows: sysfs_write_file calls flush_write_buffer
> which calls sysfs_get_active_two before calling power_write_file in
> pci_hotplug_core.c via the sysfs store operation. The power_write_file
> function calls disable_slot in fakephp.c via the slot operation.  The
> disable_slot function calls remove_slot which calls pci_hp_deregister
> (back in pci_hotplug_core.c) which calls fs_remove_slot which calls
> sysfs_remove_file to remove the "power" file. The sysfs_remove_file
> function calls sysfs_hash_and_remove which calls sysfs_addrm_finish
> which calls sysfs_deactivate. The sysfs_deactivate function sees that
> something has an active reference on the sysfs_dirent (from the
> previous call to sysfs_get_active_two back up the call stack somewhere)
> so waits for the active reference to go away, which is of course

     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^  <- this always wrong
> impossible.
> 
> The problem has been present since 2.6.21.
> 
> This patch breaks the deadlock by queuing work queue items on a single-
> threaded work queue to remove a slot from sysfs, and to rescan the PCI
> buses.  There is also some protection against disabling a slot that is
> already being removed.

Adding a deferred-work like this just because we can't get the locking and
refcounting correct is a really sad hack.

Can we get the locking and refcounting right please?  Start by making that
wait-for-refcount-to-go-away go away.
