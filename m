Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbYIIN2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbYIIN2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 09:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbYIIN2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 09:28:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35969 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbYIIN2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 09:28:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48C679B6.4080009@s5r6.in-berlin.de>
Date: Tue, 09 Sep 2008 15:27:18 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Sebastian Siewior <lkml@ml.breakpoint.cc>
CC: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
       Christoph Bartelmus <lirc@bartelmus.de>,
       Mario Limonciello <superm1@ubuntu.com>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-2-git-send-email-jwilson@redhat.com> <20080909074018.GA26076@Chamillionaire.breakpoint.cc>
In-Reply-To: <20080909074018.GA26076@Chamillionaire.breakpoint.cc>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Siewior wrote:
>> --- /dev/null
>> +++ b/drivers/input/lirc/lirc_dev.c
...
>> +#include <linux/ioctl.h>
>> +#include <linux/fs.h>
>> +#include <linux/poll.h>
>> +#include <linux/smp_lock.h>
> if you need this than you use the BKL back. As far as I remember
> the ioctl() handler in kernel core no longer takes the BKL and I don't
> see any locking in irctl_ioctl(). 

Really?  .open() has been changed to be called without the BKL held, but 
.ioctl() is still called with BKL protection.  Currently, many .ioctl() 
implementations are replaced by .unlocked_ioctl() which take the BKL 
themselves if necessary or if it is not yet clear whether they would 
work without BKL protection.

...
>> +static struct file_operations fops = {
>> +	.read		= irctl_read,
>> +	.write		= irctl_write,
>> +	.poll		= irctl_poll,
>> +	.ioctl		= irctl_ioctl,
>> +	.open		= irctl_open,
>> +	.release	= irctl_close
>> +};

This should be audited for the following aspects:

   - Could there be a race condition between irctl_open() and
     lirc_dev_init()?  If yes, try to rework them to eliminate the race,
     or as a last resort take the BKL in irctl_open().

   - Does irctl_ioctl() require BKL protection, i.e. does it have to be
     serialized against itself and against irctl_open()?  If not, replace
     it by .unlocked_ioctl.  If yes, preferably convert it to
     .unlocked_ioctl too and add a local mutex for the necessary
     serialization.

(Added Cc: Jonathan Corbet to correct me if I'm wrong.)
-- 
Stefan Richter
-=====-==--- =--= -=--=
http://arcgraph.de/sr/
