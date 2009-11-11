Return-Path: <linux-kernel-owner+w=401wt.eu-S1758432AbZKKUU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432AbZKKUU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 15:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757250AbZKKUUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 15:20:25 -0500
Received: from senator.holtmann.net ([87.106.208.187]:50186 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbZKKUUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 15:20:24 -0500
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on
 resume (was: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related
 to preempt_count leakage in keventd)
From: Marcel Holtmann <marcel@holtmann.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>,
       linux-bluetooth@vger.kernel.org
In-Reply-To: <alpine.LFD.2.01.0911111202490.31845@localhost.localdomain>
References: <200911091250.31626.rjw@sisk.pl>
	 <alpine.LFD.2.01.0911101343590.31845@localhost.localdomain>
	 <20091111161348.GA27394@redhat.com> <200911112100.16561.rjw@sisk.pl>
	 <alpine.LFD.2.01.0911111202490.31845@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Nov 2009 21:20:28 +0100
Message-ID: <1257970828.21467.6.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> > I applied the patch and this is the result of 'dmesg | grep ERR' after 10-or-so
> > consecutive suspend-resume and hibernate-resume cycles:
> > 
> > [  129.008689] ERR!! btusb_waker+0x0/0x27 [btusb]
> > [  166.477373] ERR!! btusb_waker+0x0/0x27 [btusb]
> > [  203.983665] ERR!! btusb_waker+0x0/0x27 [btusb]
> > [  241.636547] ERR!! btusb_waker+0x0/0x27 [btusb]
> > 
> > which kind of confirms my previous observation that the problem was not
> > reproducible without Bluetooth.
> 
> .. and that btusb thing matches my observation that only a few BT drivers 
> seem to use workqueues, and btusb_disconnect() isn't doing any work 
> cancel.
> 
> > I'm going to test the appended patch, then.
> 
> Hmm. the USB disconnect doesn't call hci_dev_put(), it calls 
> hci_free_dev() and doesn't seem to call the ->destruct thing. 
> 
> Although again, maybe that gets called indirectly.
> 
> So I'd put the cancel work in the actual disconnect routine. But maybe 
> thar's just me.

see my other email, I think we have to cancel the waker in btusb_close()
to fix this. However the suspend/resume and auto-suspend has been done
mostly by Oliver and I like to see what he thinks about this.

Regards

Marcel


