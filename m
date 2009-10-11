Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbZJKOhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbZJKOhL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 10:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbZJKOhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 10:37:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48815 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753977AbZJKOhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 10:37:06 -0400
Date: Sun, 11 Oct 2009 15:37:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vincent Sanders <vince@simtec.co.uk>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC] [PATCH] drivers/scsi/ch.c: Remove BKL in ch_open
Message-ID: <20091011153709.4438cf9c@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0910111443400.3587@localhost.localdomain>
References: <alpine.LFD.2.00.0910111443400.3587@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Oct 2009 15:45:16 +0200 (CEST)
John Kacur <jkacur@redhat.com> wrote:

[linux-scsi cc'd]

> Locking in ch_open is covered by the spin_lock, it serializes the calls
> to idr_find and scsi_device_get. The BKL appears redundant to me here.

I'm not so sure. In fact there are some quite umm interesting questions
about this code, and some of them are shared with other modules too.

Consider the following sequence

		CPU1				CPU2
	register_chrdev
		ok
						open device
						takes lock
	scsi_register_driver
		error

	unregister_chrdev
	error
	unload
						??????

We don't allocate any idr entries in open so the paths don't seem to leak
and the module itself looks correct. Looking at the bigger picture
however I am not sure what the module loader is trying to do in
kernel/module.c with the code at

     if (ret < 0) {
                /* Init routine failed: abort.  Try to protect us from
                   buggy refcounters. */
                mod->state = MODULE_STATE_GOING;
                synchronize_sched();
                module_put(mod);
                blocking_notifier_call_chain(&module_notify_list,

but it doesn't seem to be sufficient for what may go on ?

Rusty ?
