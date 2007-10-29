Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbXJ2Dgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbXJ2Dgj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 23:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXJ2Dgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 23:36:31 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:63280 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbXJ2Dga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 23:36:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mDwHIIzJnAbc+qum24QrQwXpU9NQdbkOv49WQmw6kEKkZk721G0pB0VaYXja9nizVjCOJjrbQshRngeWIhPbpuYFbjtGnfJI8P9qCbDOSswSN01H33MxAN7EU+uz72BUrnrLWwQTHcrSWRnTHwUHbXLJ3mCK2pe4eMh+jUqqiUg=
Message-ID: <a8e1da0710282036g6720803fj10647316a4144cef@mail.gmail.com>
Date: Mon, 29 Oct 2007 11:36:28 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: bluetooth: hci_sysfs work queue problem
Cc: bluez-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1191231956.6484.104.camel@aeonflux.holtmann.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0709291846x4abf50c8g32b02a9d40240b6@mail.gmail.com>
	 <1191231956.6484.104.camel@aeonflux.holtmann.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/1/07, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Dave,
>
> > The hci_sysfs uses work queue to finish the sysfs add/del fuction.
> > But when the same device connection failed, if another connection of
> > same device come in before the delete work finish, sysfs will warn
> > about duplicate filename creating.
>
> which kernel are we talking about. This problem should not exist
> anymore. However the usage of a work queue is unavoidable.

Recently, I encounted this issue again:
Oct 26 16:57:00 darkstar kernel: sysfs: duplicate filename
'acl00194FA4E517' can not be created
Oct 26 16:57:00 darkstar kernel: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Oct 26 16:57:00 darkstar kernel:  [<c01c0120>] sysfs_add_one+0xa0/0xe0
Oct 26 16:57:00 darkstar kernel:  [<c01c0d7b>] sysfs_create_link+0x9b/0x140
Oct 26 16:57:00 darkstar kernel:  [<c01c1671>] create_files+0x31/0x60
Oct 26 16:57:00 darkstar kernel:  [<c02b537b>] bus_add_device+0x5b/0xf0
Oct 26 16:57:00 darkstar kernel:  [<c02b391c>] device_add+0x11c/0x350
Oct 26 16:57:00 darkstar kernel:  [<f8879410>] add_conn+0x0/0x90 [bluetooth]
Oct 26 16:57:00 darkstar kernel:  [<f887941f>] add_conn+0xf/0x90 [bluetooth]
Oct 26 16:57:00 darkstar kernel:  [<c013baee>] run_workqueue+0x5e/0x110
Oct 26 16:57:00 darkstar kernel:  [<c013bc4c>] worker_thread+0xac/0x100
Oct 26 16:57:00 darkstar kernel:  [<c0140000>] autoremove_wake_function+0x0/0x50
Oct 26 16:57:00 darkstar kernel:  [<c0140000>] autoremove_wake_function+0x0/0x50
Oct 26 16:57:00 darkstar kernel:  [<c013bba0>] worker_thread+0x0/0x100
Oct 26 16:57:00 darkstar kernel:  [<c013fa39>] kthread+0x59/0xa0
Oct 26 16:57:00 darkstar kernel:  [<c013f9e0>] kthread+0x0/0xa0
Oct 26 16:57:00 darkstar kernel:  [<c0104f83>] kernel_thread_helper+0x7/0x14
Oct 26 16:57:00 darkstar kernel:  =======================
Oct 26 16:57:00 darkstar kernel: add_conn: Failed to register connection device

Seems same problem as before. This time, I just used  several rfcomm
connections.
I think if we can add an atomic variable 'going_away' like this:
in hci_conn_del_sysfs:
before INIT_WORK;
atomic_set(&going_away, 1)

in del_conn:
after deleting completed
atomic_set(&going_away, 0)

in add_conn:
busy waiting the going_away
while (atomic_read(&going_away))
        cpu_relax()

Regards
dave


> Regards
>
> Marcel
>
>
>
