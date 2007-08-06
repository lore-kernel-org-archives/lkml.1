Return-Path: <linux-kernel-owner+w=401wt.eu-S932733AbXHFUXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733AbXHFUXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761625AbXHFUXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:23:09 -0400
Received: from antonio.urjc.es ([193.147.184.24]:33805 "EHLO antonio.urjc.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761512AbXHFUXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:23:07 -0400
Message-ID: <46B7832B.6010808@urjc.es>
Date: Mon, 06 Aug 2007 22:23:07 +0200
From: Javier Pello <javier.pello@urjc.es>
Organization: Universidad Rey Juan Carlos
User-Agent: Thunderbird 2.0.0.0 (X11/20070503)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not 
	notified
References: <46B37CF7.2020803@urjc.es> 
	<20070806142451.5d28d41c@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070806142451.5d28d41c@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain;
	charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender DNS name whitelisted, not delayed by 
	milter-greylist-2.0.2 (antonio.urjc.es [193.147.184.24]); Mon, 06 Aug 2007 
	22:22:36 +0200 (CEST)
X-imss-version: 2.047
X-imss-result: Passed
X-imss-scanInfo: M:B L:E SM:2
X-imss-tmaseResult: TT:1 TS:-19.9525 TC:1F TRN:54 TV:3.6.1039(15346.003)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Aug 2007, Cornelia Huck wrote:
> > 1. The first part changes kobject_uevent_env in lib/kobject_uevent.c
> > to report a failure if both netlink_broadcast (if applicable) and
> > call_usermodehelper fail to send the event to userspace. Nothing
> > in the kernel seems to care about the return value of
> > kobject_uevent_env, so this should not break anything.
> 
> Famous last words ;) I recall that things broke when the driver core
> tried to care about the return code of kobject_uevent(), so this may
> work if you check just in your special case.

I have hunted down all calls to kobject_uevent/kobject_uevent_env and
they are all statements (return value discarded). My intention is to
only add a check in request_firmware.

> > 2. The second part changes _request_firmware in
> > drivers/base/firmware_class.c to actually check the return value
> > of kobject_uevent and skip the loading_timeout delay if the
> > loading event was not delivered to userspace at all.
> 
> Note that kobject_uevent() returns 0 if the event has been filtered.

Oops, yes, I had not noticed. This brings another point: When should
kobject_uevent return a "failure"? The code, as it is, only returns a
failure when things are really wrong (out of memory, etc.), and
returns success when the event was simply dropped. This is reasonable
behaviour, but it prevents callers from knowing whether the event was
actually delivered (which is what request_firmware needs). On the
other hand, my patch tries to make nondelivery an error, but on
second thoughts that could prevent the caller from telling hard
errors from simple nondelivery. I can think of two possibilities
to sort this out:

- kobject_uevent returns an error code both on a hard error and
on nondelivery; the error codes for both situations are different,
so the caller can tell them apart.

- kobject_uevent returns an error code (<0) only on a hard error,
returns 0 on nondelivery and 1 on delivery; this makes things
even clearer.

I am biased towards the latter. Of course, we can do anything as
the return value is actually never used, but I would still like
to know other opinions about what the right thing is.

> It would be better if you sent the patches seperately.
> [...]
> Maybe add a small comment here?

Thank you for your suggestions. I will prepare a new version of
the patch and send it as a followup to this message as soon as
I decide about the return value of kobject_uevent.

Javier



