Return-Path: <linux-kernel-owner+w=401wt.eu-S1761546AbXHGK5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761546AbXHGK5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 06:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758151AbXHGK5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 06:57:41 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:29092 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758063AbXHGK5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 06:57:40 -0400
Date: Tue, 7 Aug 2007 12:58:44 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Javier Pello <javier.pello@urjc.es>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not
 notified
Message-ID: <20070807125844.4d756b04@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <46B7832B.6010808@urjc.es>
References: <46B37CF7.2020803@urjc.es>
	<20070806142451.5d28d41c@gondolin.boeblingen.de.ibm.com>
	<46B7832B.6010808@urjc.es>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Aug 2007 22:23:07 +0200,
Javier Pello <javier.pello@urjc.es> wrote:

> > > 2. The second part changes _request_firmware in
> > > drivers/base/firmware_class.c to actually check the return value
> > > of kobject_uevent and skip the loading_timeout delay if the
> > > loading event was not delivered to userspace at all.
> > 
> > Note that kobject_uevent() returns 0 if the event has been filtered.
> 
> Oops, yes, I had not noticed. This brings another point: When should
> kobject_uevent return a "failure"? The code, as it is, only returns a
> failure when things are really wrong (out of memory, etc.), and
> returns success when the event was simply dropped. This is reasonable
> behaviour, but it prevents callers from knowing whether the event was
> actually delivered (which is what request_firmware needs). On the
> other hand, my patch tries to make nondelivery an error, but on
> second thoughts that could prevent the caller from telling hard
> errors from simple nondelivery.

You could say that not delivering is caused by a hard error when trying
to deliver, though. OTOH, filtering an event is certainly not an error.

> I can think of two possibilities
> to sort this out:
> 
> - kobject_uevent returns an error code both on a hard error and
> on nondelivery; the error codes for both situations are different,
> so the caller can tell them apart.

Tough. For example, both today's kobject_uevent() and
call_usermodehelper() may return -ENOMEM.

> 
> - kobject_uevent returns an error code (<0) only on a hard error,
> returns 0 on nondelivery and 1 on delivery; this makes things
> even clearer.

Hm, I have an aversion against tri-state return values :( OTOH, a)
callers generally don't care and b) it is in line with how
kobject_uevent() is defined if !CONFIG_HOTPLUG.

- Use an extra parameter in which successful delivery can be indicated.
Make this
int kobject_uevent_env_check(struct kobject *kobject,
			     enum kobject_action action,
			     char *envp[], int delivered);
so existing callers that don't care don't have to be changed.

> 
> I am biased towards the latter. Of course, we can do anything as
> the return value is actually never used, but I would still like
> to know other opinions about what the right thing is.
