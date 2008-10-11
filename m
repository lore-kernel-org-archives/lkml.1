Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbYJKNx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbYJKNx1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 09:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbYJKNxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 09:53:19 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:57640 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753045AbYJKNxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 09:53:18 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH 0/1] SIGWINCH problem with terminal apps still alive
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adam Tla?ka <atlka@pg.gda.pl>,
       linux-kernel@vger.kernel.org, torvalds@osdl.org
Reply-To: 7eggert@gmx.de
Date: Sat, 11 Oct 2008 16:04:07 +0200
References: <bjXel-4CU-17@gated-at.bofh.it> <bjYap-5Q0-25@gated-at.bofh.it> <bk30i-3Gx-1@gated-at.bofh.it> <bk6AV-8ms-7@gated-at.bofh.it> <bkrvO-1HF-49@gated-at.bofh.it> <blePJ-6rI-3@gated-at.bofh.it> <blmDC-7ZU-7@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1Kof4h-0005Q3-Ns@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> Adam Tla?ka <atlka@pg.gda.pl> wrote:

>> now we have 2.6.26.6 kernel and still terminal resize leads to
>> undesired effects. It is very inconvenient to wait for 2.6.27 for
>> corrections.

You'll have to wait some longer, since it still has this bug.

>> As Alan Cox previously said mutexes generally work but as we can
>> observe in case of kill_pgrp() call inside mutex lock we got
>> race because of rescheduling so lock is not working here.
>> Rearanging code so the variable change is placed before kill_pgrp()
>> call removes mentioned race situaction.

> NAK again
> 
> Moving the copies around simply moves the race, it might be that it fixes
> your box and unfixes other peoples.

This patch does not move around any race, but it works around a locking issue
by making sure you are the hedgehog racing the rabbit.

However, you are right in spotting that there must be something wrong with
the resulting code. It does (still) modify both tty and the real_tty while
only holding one lock. Besides that, it depends on tty->mutex to prevent
reading the old values because real_tty->mutex is held.

Adam, since you are working on this issue, I'd suggest you modify the source
to take both locks, one at a time, while setting the new values (lock
tty->mutex, compare tty->ws, possibly set ws, unlock, lock real_tty, ...).

Alan, do you agree? Or is it required to take both locks at the same time?
If it is, in which order?

