Return-Path: <linux-kernel-owner+w=401wt.eu-S1758853AbXGICdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbXGICdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 22:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757970AbXGICcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 22:32:52 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:11675 "EHLO
	asav02.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904AbXGICcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 22:32:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkZADg7kUZKhRO4R2dsb2JhbACBTIVdiAMBARsNBhEB
From: Dmitry Torokhov <dtor@insightbb.com>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Fix use-after-free oops in Bluetooth HID.
Date: Sun, 8 Jul 2007 22:32:52 -0400
User-Agent: KMail/1.9.3
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Marcel Holtmann <marcel@holtmann.org>, Jiri Kosina <jkosina@suse.cz>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
References: <468A7D14.1050505@googlemail.com> <alpine.LFD.0.999.0707071135090.31544@woody.linux-foundation.org> <1183834720.3066.83.camel@shinybook.infradead.org>
In-Reply-To: <1183834720.3066.83.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707082232.54034.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 July 2007 14:58, David Woodhouse wrote:
> When cleaning up HIDP sessions, we currently close the ACL connection
> before deregistering the input device. Closing the ACL connection
> schedules a workqueue to remove the associated objects from sysfs, but
> the input device still refers to them -- and if the workqueue happens to
> run before the input device removal, the kernel will oops when trying to
> look up PHYSDEVPATH for the removed input device.
> 
> Fix this by deregistering the input device before closing the
> connections.

I think it will work ok for 2.6.22 but I don't think this is a final
solution: input_unregister_device might not free the device right away.
If there is a process that hangs on to one of the input interfaces
(evdev or mousedev) then freeing of the device structure may be delayed
and we may still run into the case when session is wiped out before
device is freed.

-- 
Dmitry
