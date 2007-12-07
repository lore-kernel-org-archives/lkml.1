Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbXLGN3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbXLGN3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 08:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbXLGN25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 08:28:57 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:22283 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbXLGN25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 08:28:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uDdVQR6B4yt5Njh78Ac/2DO//fJUZM9KreMULePJ0DGvuxyt5VD5yRu9ZZaY+LGycNnuDO+9EpoEAKsHOcc8eTYq8v7LbZ3piO+r6jMSFzRQit/QflTLhkZK7rj2LhS+ncnUyKsW42dMCAgYBP3KibM1nTuBAWvpgWMBxjdACk4=
Message-ID: <851fc09e0712070528w6701505cr999371ca5ac77307@mail.gmail.com>
Date: Fri, 7 Dec 2007 21:28:55 +0800
From: "huang ying" <huang.ying.caritas@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 3/4 -mm] kexec based hibernation -v7 : kexec hibernate/resume
Cc: "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Pavel Machek" <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jeremy Maitin-Shepard" <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       "Kexec Mailing List" <kexec@lists.infradead.org>
In-Reply-To: <200712071352.34475.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1197042820.24045.63.camel@caritas-dev.intel.com>
	 <200712071352.34475.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 7, 2007 8:52 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, 7 of December 2007, Huang, Ying wrote:
> > This patch implements kexec based hibernate/resume. This is based on
> > the facility provided by kexec_jump. The states save/restore code of
> > ordinary kexec_jump is overridden by hibernate/resume specific
> > code.
>
> Can you explain in more details how this works?

Two blocking notifier chain named kjump_chain_pre and kjump_chain_post
are defined, the basic procedure of kexec jump is as follow:

call functions in kjump_chain_pre
jump to peer kernel
call functions in kjump_chain_post

A command is the first parameter of functions in chain. If A command
is processed in a function, the function will execute and stop the
chain (return NOTIFY_STOP), otherwise it will do nothing (return
NOTIFY_DONE). If no function has interest in the command, the default
behavior will be executed (kexec_vcall_pre, kexec_vcall_post).

So for each command the procedure is as follow:

KJUMP_CMD_HIBERNATE_WRITE_IMAGE:
[chain] kexec_snapshot
jump to kexeced kernel
[chain] kexec_prepare_write_image /* in kexeced kernel */

KJUMP_HIBERNATE_RESUME:
[chain] kexec_prepare_resume /* in kexeced kernel */
jump to kexec kernel
[chain] kexec_resume

> > The ACPI methods are called at specified environment to conform
> > the ACPI specification. A new reboot command is added to go to ACPI S4
> > state from user space.
>
> Well, I still don't like the amount of duplicated code introduced by this patch.

Yes, there are too many duplicated code. They should be merged. But I
want to delay the merging until the kexec based hibernation code goes
more stable.

> Also, IMO it should be using the mutual exclusion mechanisms used by the
> existing hibernation code, ie. pm_mutex and the snapshot_device_available
> atomic variable.

Now the kexec_lock is used as a mutex between kexec related
operations. It seems reasonable to use pm_mutex and maybe
snapshot_device_available to eliminate potential conflict between
kexec based hibernation and u/swsusp.

Best Regards,
Huang Ying
