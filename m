Return-Path: <linux-kernel-owner+w=401wt.eu-S1759650AbZFJXGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650AbZFJXGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 19:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757953AbZFJXGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 19:06:36 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:48145 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206AbZFJXGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 19:06:36 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Thu, 11 Jun 2009 01:07:22 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906082233490.19072-100000@netrider.rowland.org> <200906102338.35183.oliver@neukum.org> <200906110001.20718.rjw@sisk.pl>
In-Reply-To: <200906110001.20718.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906110107.23023.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 11. Juni 2009 00:01:20 schrieb Rafael J. Wysocki:
> We have queued up resume requests for the device's parent, its parent etc.,
> the topmost one goes first.  The workqueue is singlethread, so
> pm_autoresume() is going to be run for all parents before the device
> itself, so if that were the only resume mechanism, it would be enough to
> check if the parent is RPM_ACTIVE.

            A (IDLE)
    /                                \
B (SUSPENDED)         C (SUSPENDED)

Suppose C is to be resumed. This means first in case of A the request
to suspend would be cancelled. Here you drop the locks:

+           && (dev->parent->power.runtime_status == RPM_IDLE
+             || dev->parent->power.runtime_status == RPM_SUSPENDING
+             || dev->parent->power.runtime_status == RPM_SUSPENDED)) {
+               spin_unlock_irqrestore(&dev->power.lock, flags);
+               spin_unlock_irqrestore(&dev->parent->power.lock, parent_flags);
+
+               /* We have to resume the parent first. */
+               pm_request_resume(dev->parent);

But after pm_request_resume() returns there's no means to make sure
nothing alters it back to RPM_SUSPENDED. The workqueue doesn't help
you because you've scheduled nothing by that time. The suspension will
work because C is still in RPM_SUSPENDED.

	Regards
		Oliver

