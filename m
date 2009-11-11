Return-Path: <linux-kernel-owner+w=401wt.eu-S1758623AbZKKUcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623AbZKKUcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 15:32:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbZKKUcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 15:32:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290AbZKKUcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 15:32:05 -0500
Date: Wed, 11 Nov 2009 21:24:33 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on
	resume (was: Re: Help needed: Resume problems in 2.6.32-rc, perhaps
	related to preempt_count leakage in keventd)
Message-ID: <20091111202433.GA5714@redhat.com>
References: <200911091250.31626.rjw@sisk.pl> <alpine.LFD.2.01.0911101343590.31845@localhost.localdomain> <20091111161348.GA27394@redhat.com> <200911112100.16561.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911112100.16561.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, Rafael J. Wysocki wrote:
>
> On Wednesday 11 November 2009, Oleg Nesterov wrote:
> >
> > Rafael, could you reproduce the problem with the debugging patch below?
> > It tries to detect the case when the pending work was corrupted and
> > prints its work->func (saved in the previous item). It should work
> > if the work_struct was freed and poisoned, or if it was re-initialized.
> > See ck_work().
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

Great, thanks.

> So, it looks like the bug is in btusb_destruct(), which should call
> cancel_work_sync() on data->waker before freeing 'data'.  I guess it should
> do the same for data->work.

Or. btusb_suspend() and btusb_close() do cancel_work_sync(data->work),
perhaps they should cancel data->waker as well, I dunno.

I added Oliver to cc.

Oleg.

