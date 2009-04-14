Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbZDNHQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbZDNHQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 03:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZDNHQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 03:16:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41328 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbZDNHQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 03:16:22 -0400
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: dm-multipath and write request ordering
From: Andi Kleen <andi@firstfloor.org>
References: <e2e108260904130422k2ac92e64jb5aff1cc2adc8da0@mail.gmail.com>
Date: Tue, 14 Apr 2009 09:16:18 +0200
In-Reply-To: <e2e108260904130422k2ac92e64jb5aff1cc2adc8da0@mail.gmail.com> (Bart Van Assche's message of "Mon, 13 Apr 2009 13:22:49 +0200")
Message-ID: <878wm3903h.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche <bart.vanassche@gmail.com> writes:

> - Is it correct that round-robin load balancing can only work
> correctly in such a setup with proper support for write barriers in
> the device mapper ?

No opinion on that one.

> - Did I understand it correctly that the current dm implementation
> only supports barriers when remapping a single underlying device ?

And also only for dm_linear, so probably it doesn't work on dm_mp (haven't
tested) even if it has only a single device.

Barriers over multiple devices are very difficult, at least as long as
the underlying protocol doesn't support shared barriers or the Linux
barrier concept be extended.  The problem is that you cannot express
to the underlying device that some of its requests are dependent on
requests going to other devices.

> - Are there any plans to add barrier support to dm-multipath ?

[note I'm not very familiar with Linux's dm_mp finer details, some 
details here might be wrong]

I doubt it's really doable with RR. It might be possible if you
do the IO primary on one device and only on error fall back to another
device. Then during the fallback you could just synchronize all
IO and solve the barrier problem this way and otherwise do barriers
on the single active device only. But with multiple devices you
would have the problem described above.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
