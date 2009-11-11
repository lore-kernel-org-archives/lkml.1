Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbZKKT7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbZKKT7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 14:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbZKKT7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 14:59:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37302 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbZKKT7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 14:59:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on resume (was: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related to preempt_count leakage in keventd)
Date: Wed, 11 Nov 2009 21:00:16 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc6-tst; KDE/4.3.1; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org
References: <200911091250.31626.rjw@sisk.pl> <alpine.LFD.2.01.0911101343590.31845@localhost.localdomain> <20091111161348.GA27394@redhat.com>
In-Reply-To: <20091111161348.GA27394@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911112100.16561.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 November 2009, Oleg Nesterov wrote:
> On 11/10, Linus Torvalds wrote:
> >
> > > In the meantime I got another trace, this time with a slab corruption involved.
> > > Note that it crashed in exactly the same place as previously.
> >
> > I'm leaving your crash log appended for the new cc's, and I would not be
> > at all surprised to hear that the slab corruption is related. The whole
> > 6b6b6b6b pattern does imply a use-after-free on the workqueue,
> 
> Yes, RCX = 6b6b6b6b6b6b6b6b, and according to decodecode the faulting
> instruction is "mov %rdx,0x8(%rcx)". Looks like the pending work was
> freed.
> 
> Rafael, could you reproduce the problem with the debugging patch below?
> It tries to detect the case when the pending work was corrupted and
> prints its work->func (saved in the previous item). It should work
> if the work_struct was freed and poisoned, or if it was re-initialized.
> See ck_work().

I applied the patch and this is the result of 'dmesg | grep ERR' after 10-or-so
consecutive suspend-resume and hibernate-resume cycles:

[  129.008689] ERR!! btusb_waker+0x0/0x27 [btusb]
[  166.477373] ERR!! btusb_waker+0x0/0x27 [btusb]
[  203.983665] ERR!! btusb_waker+0x0/0x27 [btusb]
[  241.636547] ERR!! btusb_waker+0x0/0x27 [btusb]

which kind of confirms my previous observation that the problem was not
reproducible without Bluetooth.

So, it looks like the bug is in btusb_destruct(), which should call
cancel_work_sync() on data->waker before freeing 'data'.  I guess it should
do the same for data->work.

I'm going to test the appended patch, then.

Thanks,
Rafael

---
 drivers/bluetooth/btusb.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/drivers/bluetooth/btusb.c
===================================================================
--- linux-2.6.orig/drivers/bluetooth/btusb.c
+++ linux-2.6/drivers/bluetooth/btusb.c
@@ -738,6 +738,9 @@ static void btusb_destruct(struct hci_de
 
 	BT_DBG("%s", hdev->name);
 
+	cancel_work_sync(&data->work);
+	cancel_work_sync(&data->waker);
+
 	kfree(data);
 }
 
