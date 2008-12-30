Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbYL3XyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbYL3XyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 18:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbYL3XyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 18:54:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbYL3XyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 18:54:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, ebiederm@xmission.com, bastian@waldi.eu.org,
       gregkh@suse.de, daniel@hozac.com, xemul@openvz.org,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [RFC][PATCH] SI_ASYNCIO: should be a kernel signal ?
In-Reply-To: Sukadev Bhattiprolu's message of  Saturday, 20 December 2008 17:04:14 -0800 <20081221010414.GA5284@us.ibm.com>
References: <20081221010414.GA5284@us.ibm.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20081230235327.063F0FC278@magilla.sf.frob.com>
Date: Tue, 30 Dec 2008 15:53:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The value of SI_ASYNCIO is part of the user ABI already, so you
can't really change it anyway.  But, there is a logic why it was
correct for it to be SI_FROMUSER (not just an old choice we are
stuck with, which it also is).

The real purpose of the SI_FROMUSER/SI_FROMKERNEL distinction is not
an abstract idea of "kernel-generated or not".  In fact, it's purely
to distinguish "forgeable" from "guaranteed exact kernel semantics".
SI_ASYNCIO is a notification about something the user asked for
specially, not one about any kernel-enforced sort of event.  If the
user wants to send himself signals with si_code=SI_ASYNCIO, then fine.
Noone's going to be fooled about who instigated such a signal.

In fact, the main use of SI_ASYNCIO signals in practice is for a user
to send them to himself.  That's what glibc (-lrt) does to implement
the POSIX aio_* calls.  The only uses in the kernel are in the USB
code related to some magic ioctls.

Those in-kernel cases call kill_pid_info_as_uid precisely for the same
issue of current vs instigating-process.  These are the only calls to
that function.  It really could be called something else like
"kill_self_from_interrupt", because its only use is this case that's
considered to be, "I'm sending it to myself, delayed."  That is, it
caches the uid/euid along with the struct pid to itself, in case of
instigating it, changing uids, and then having the interrupt deliver
the signal to the same process that is now differently-privileged.

It's not real clear you care about the old vs new pid namespace the
same way we care about the old vs new current_cred.  Since the sender
can only be "myself" or "my former self", maybe just call it "myself"
and be done with it--you just don't need any check in this path.


Thanks,
Roland
