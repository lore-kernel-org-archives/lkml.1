Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbZKTU3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbZKTU3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 15:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbZKTU3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 15:29:20 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:58313 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbZKTU3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 15:29:16 -0500
Date: Fri, 20 Nov 2009 20:29:09 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: David Zeuthen <david@fubar.dk>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, linux-hotplug@vger.kernel.org
Subject: Re: [PATCH] [RFC] Add support for uevents on block device idle
	changes
Message-ID: <20091120202909.GA31117@srcf.ucam.org>
References: <20091118213355.GA16630@srcf.ucam.org> <ac3eb2510911190309y6d0d8445wd907fc5664595c6f@mail.gmail.com> <20091119130107.GB20949@srcf.ucam.org> <ac3eb2510911190529p6810508fve4941f3077dfd3d9@mail.gmail.com> <20091119141634.GA311@srcf.ucam.org> <ac3eb2510911190625i7432644aod6e99829b8a03dc4@mail.gmail.com> <20091119143008.GA719@srcf.ucam.org> <ac3eb2510911190634m20947c86w78340d22eff290ca@mail.gmail.com> <20091119144853.GA1398@srcf.ucam.org> <ac3eb2510911190700o6f4e80cm172c14dc0f28451d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510911190700o6f4e80cm172c14dc0f28451d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 04:00:46PM +0100, Kay Sievers wrote:

> Yeah, it would not be as simple as your patch. It probably involves a
> way to get a file descriptor per listener, to let the kernel know if
> anybody is interested, and to auto-cleanup when the listener dies, and
> to have per instance timers.

This would seem to involve a lot of extra locking in the block 
submission and completion code. I don't think it's ideal. How about 
this:

* idle_hysteresis contains a value. If it's greater than 0, attempting 
to increase it will give -EINVAL. It can be polled.

* On idle state transition, applications listening to the stat sysfs 
node will get woken. The stat output will include the number of msecs 
that the disk has been idle. If this is less than the application 
requested, it can set a timer to wake it up again in the future and 
recheck.

* When an application exits, if (and only if) it wrote a value to 
idle_hysteresis, it should set this back to 0. This will notify any 
other apps, which may then set their own wakeup time.

It's not beautiful but it satisfies the constraints. There's a minimum 
of extra wakeups, it doesn't complicate the block path any further and 
multiple applications can take advantage of it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
