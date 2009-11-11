Return-Path: <linux-kernel-owner+w=401wt.eu-S1758502AbZKKUM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502AbZKKUM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 15:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757304AbZKKUM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 15:12:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757261AbZKKUMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 15:12:55 -0500
Date: Wed, 11 Nov 2009 12:11:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on
 resume (was: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related
 to preempt_count leakage in keventd)
In-Reply-To: <200911112100.16561.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.01.0911111202490.31845@localhost.localdomain>
References: <200911091250.31626.rjw@sisk.pl> <alpine.LFD.2.01.0911101343590.31845@localhost.localdomain> <20091111161348.GA27394@redhat.com> <200911112100.16561.rjw@sisk.pl>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Nov 2009, Rafael J. Wysocki wrote:
> 
> I applied the patch and this is the result of 'dmesg | grep ERR' after 10-or-so
> consecutive suspend-resume and hibernate-resume cycles:
> 
> [  129.008689] ERR!! btusb_waker+0x0/0x27 [btusb]
> [  166.477373] ERR!! btusb_waker+0x0/0x27 [btusb]
> [  203.983665] ERR!! btusb_waker+0x0/0x27 [btusb]
> [  241.636547] ERR!! btusb_waker+0x0/0x27 [btusb]
> 
> which kind of confirms my previous observation that the problem was not
> reproducible without Bluetooth.

.. and that btusb thing matches my observation that only a few BT drivers 
seem to use workqueues, and btusb_disconnect() isn't doing any work 
cancel.

> I'm going to test the appended patch, then.

Hmm. the USB disconnect doesn't call hci_dev_put(), it calls 
hci_free_dev() and doesn't seem to call the ->destruct thing. 

Although again, maybe that gets called indirectly.

So I'd put the cancel work in the actual disconnect routine. But maybe 
thar's just me.

		Linus
