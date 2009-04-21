Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbZDUOLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbZDUOLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZDUOLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:11:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:40725 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbZDUOLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:11:05 -0400
Date: Tue, 21 Apr 2009 16:11:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Oliver Neukum <oliver@neukum.org>,
       Johannes Berg <johannes@sipsolutions.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input <linux-input@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: lockdep report at resume
In-Reply-To: <200904211559.43497.oliver@neukum.org>
Message-ID: <alpine.LNX.2.00.0904211609220.13028@wotan.suse.de>
References: <1234022517.4175.107.camel@johannes.local> <1238578840.5970.178.camel@johannes.local> <alpine.LNX.2.00.0904211550280.13028@wotan.suse.de> <200904211559.43497.oliver@neukum.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009, Oliver Neukum wrote:

> > [ thanks for the analysis Johannes ... involving also Oliver here; really
> >   seems like a false positive to me ]
> I think he's right. But as a matter of principle I'd like to see 
> flush_scheduled_work() avoided where possible, hence the patch.

I am not entirely sure that this is the same issue as the one from #13136 
of kernel.org bugzilla.

Anyway, for reference, the patch Oliver mentioned here is below.

>From oliver@neukum.org Tue Apr 21 15:38:41 2009
Date: Tue, 21 Apr 2009 15:38:12 +0200
From: Oliver Neukum <oliver@neukum.org>
To: Andrew Morton <akpm@linux-foundation.org>, casteyde.christian@free.fr
Cc: Jiri Kosina <jkosina@suse.cz>, Rafael J. Wysocki <rjw@sisk.pl>
Subject: Re: [Bugme-new] [Bug 13136] New: possible circular locking dependency detected while suspending laptop to S3

Am Dienstag 21 April 2009 01:01:13 schrieb Andrew Morton:
> On Sat, 18 Apr 2009 11:17:47 GMT
>
> bugzilla-daemon@bugzilla.kernel.org wrote:
> > http://bugzilla.kernel.org/show_bug.cgi?id=13136
>
> Looks like a post-2.6.29 regression in usb-hid.  usbhid_close() holding
> hid_open_mut while doing flush_scheduled_work().
>
> Could you gents please work out where the problem is and suitably
> assign the report?

Please test this patch.

	Regards
		Oliver

---

commit 4bdc818cca662000cf195b1e83e8a0f8a3f0b9c6
Author: Oliver Neukum <oneukum@linux-d698.(none)>
Date:   Tue Apr 21 15:33:41 2009 +0200

    avoid deadlock in usbhid_close by cancelling workqueues

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 4306cb1..900ce18 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -662,8 +662,8 @@ void usbhid_close(struct hid_device *hid)
 	spin_lock_irq(&usbhid->lock);
 	if (!--hid->open) {
 		spin_unlock_irq(&usbhid->lock);
+		hid_cancel_delayed_stuff(usbhid);
 		usb_kill_urb(usbhid->urbin);
-		flush_scheduled_work();
 		usbhid->intf->needs_remote_wakeup = 0;
 	} else {
 		spin_unlock_irq(&usbhid->lock);

Thanks,

-- 
Jiri Kosina
SUSE Labs
