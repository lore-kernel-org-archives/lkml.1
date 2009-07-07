Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbZGGHe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbZGGHe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 03:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbZGGHeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 03:34:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38616 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbZGGHeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 03:34:19 -0400
Message-ID: <4A52FA7B.4020905@suse.de>
Date: Tue, 07 Jul 2009 09:34:19 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Alan.Brunelle@pobox.com
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cciss: Ignore stale commands after reboot
References: <20090702082313.F3754D340B@pentland.suse.de> <4A525FA8.80509@gmail.com>
In-Reply-To: <4A525FA8.80509@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Alan D. Brunelle wrote:
> Hannes Reinecke wrote:
>> When doing an unexpected shutdown like kexec the cciss
>> firmware might still have some commands in flight, which
>> it is trying to complete.
>> The driver is doing it's best on resetting the HBA,
>> but sadly there's a firmware issue causing the firmware
>> _not_ to abort or drop old commands.
>> So the firmware will send us commands which we haven't
>> accounted for, causing the driver to panic.
>>
>> With this patch we're just ignoring these commands as
>> there is nothing we could be doing with them anyway.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
> 
> Pardon my ignorance here, but don't you have a bigger problem: if the
> reset is not dropping or aborting old commands, doesn't this also mean
> that these old commands can still be _executing_? In which case any
> (old) reads being executed could be scribbling over memory? (Memory that
> may be being used for other purposes?)
> 
Yes and no.

This scenario is being observed whilst doing a kexec/kdump reboot.
IE a new kernel is started directly from the context of an
already running kernel, so there is a fair chance that IO is
still in flight.
In flight here means the kernel/driver has send the commands to the
firmware but not yet received a reply/completion to them.

So the kdump kernel boots and initializes the driver.
The driver itself tries to initializes the firmware, but due to the
abovementioned bug this initialization does _not_ clear out old
commands, so when the driver is up and running is receives
command completions.
But these completions are not associated with any commands the
driver has been sent, so we can as well drop them to the floor.
Which is what this patch is all about.

So yes, there is some sort of overwrite in the sense the 'old'
IO is being committed to disk by the time the new kernel starts.
But no, it doesn't really matter to us as we're starting out
with any operations only _after_ we have received these stale
IO.

HTH.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
