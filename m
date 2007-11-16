Return-Path: <linux-kernel-owner+w=401wt.eu-S1761130AbXKPRaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761130AbXKPRaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 12:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbXKPRaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 12:30:04 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:43041 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbXKPRaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 12:30:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WBLVE5Rbb+VaxvDTg8eE5cnd94aNPuRli3gLOQV3Nk3x4Qmb3wQkUS3POO0GhyBawbeC0x/s25C/3XXQBHbAjsaBaWR4qdHOubjJBjzbJAtS2dfoKhgXHZgkBy+abUuJG2Mx5Pd7A7HJVVkgnFTD7/J1smC15zFiFDBBei/bF80=
Message-ID: <cda58cb80711160929i4dbac6b7xb9d1bcc9223ddd7b@mail.gmail.com>
Date: Fri, 16 Nov 2007 18:29:56 +0100
From: "Franck Bui-Huu" <vagabon.xyz@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: apm emulation driver broken ?
Cc: linux-pm@lists.linux-foundation.org, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200711161720.50313.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cda58cb80711160706l2cfac2b1p81c7a1090f228f2e@mail.gmail.com>
	 <200711161720.50313.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 16, 2007 5:20 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> The freezer doesn't regard the current task as freezable.
>


Hmm, I don't get your point.

If I understood this driver correctly, several processes can be
waiting for a suspend event by reading /dev/apm_bios, apmd (the _user_
space daemon) can be one of them.

Then another process asks to suspend the system by calling 'apm -s',
which results in a apm_ioctl() call. This process will basically
execute:

	err = queue_suspend_event(APM_USER_SUSPEND, as);
	flags = current->flags;
	wait_event_interruptible(apm_suspend_waitqueue,
			as->suspend_state == SUSPEND_DONE);

It's basically waiting for the waiters to ack the event. But it won't
be the process that is going to suspend the system, right ?

So now all waiting processes are waken up and need to acknolwedge the
event for the system to actually suspend. So they need to call
apm_ioctl(). They'll basically do:

	flags = current->flags;
	wait_event(apm_suspend_waitqueue,
			as->suspend_state == SUSPEND_DONE);

Except for the last acknowledging process which will do instead:

	apm_suspend();

It's a call to pm_suspend().

So you can see that the process which initiates the suspend, the one
that calls 'apm -s', is not the current process but is going to be
waken up by the fake signal sent by freeze_task().

One of the consequence I can see is at this time 'as->result' won't be
setup, so the return value of apm_ioctl() may be wrong.

As I said, I'm not familiar with this code, so please correct me if
I'm wrong.

BTW, how does try_to_freeze_tasks() deal with user land thread waiting
in the UNINTERRUPTIBLE state ?

Thanks.

               Franck
