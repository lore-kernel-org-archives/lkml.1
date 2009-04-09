Return-Path: <linux-kernel-owner+w=401wt.eu-S1757825AbZDIA03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbZDIA03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 20:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755714AbZDIA0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 20:26:20 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42659 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbZDIA0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 20:26:19 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] sysfs poll should keep the poll rule of normal regular file.
Cc: kosaki.motohiro@jp.fujitsu.com, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>
In-Reply-To: <18909.15904.704697.734477@notabene.brown>
References: <20090408173935.8D7E.A69D9226@jp.fujitsu.com> <18909.15904.704697.734477@notabene.brown>
Message-Id: <20090409092302.8D8A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Thu,  9 Apr 2009 09:26:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wednesday April 8, kosaki.motohiro@jp.fujitsu.com wrote:
> > 
> > Currently, following test programs don't finished.
> > 
> > % ruby -e '
> > Thread.new { sleep }
> > File.read("/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies")
> > '
> > 
> > strace expose the reason.
> > 
> > ...
> > open("/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies", O_RDONLY|O_LARGEFILE) = 3
> > ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, 0xbf9fa6b8) = -1 ENOTTY (Inappropriate ioctl for device)
> > fstat64(3, {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
> > _llseek(3, 0, [0], SEEK_CUR)            = 0
> > select(4, [3], NULL, NULL, NULL)        = 1 (in [3])
> > read(3, "1400000 1300000 1200000 1100000 1"..., 4096) = 62
> > select(4, [3], NULL, NULL, NULL
> > 
> > 
> > Because Ruby (the scripting language) VM assume select system-call against regular file don't block.
> > (POSIX gurantee it.)
> > But sysfs_poll() don't keep this rule although sysfs file can read and write always.
> 
> It would be nice to include a reference to where POSIX (or SUS)
> guarantees it - though I suspect you are right.

Oh, very good opinion.

following explanation is better?

poll is requireed "Regular files shall always poll TRUE for reading and
writing." by SUSv3.
  see http://www.opengroup.org/onlinepubs/009695399/functions/poll.html


> I have one piece of code that this would break, but it isn't released
> yet and it is never too late to fix things..
> 
> However it should be pointed out that /proc/mounts has exactly the
> same problems (/proc/mdstat doesn't - I guess I was lucky enough to
> get that one right).  So we should "fix" /proc/mounts
> (fs/proc/base.c:mounts_poll) at the same time.  Assuming that won't
> break anything.
> 
> Al:  do you have an opinion about changing mounts_poll to always
> report 'readable' to poll??  What would break?
> 
> NeilBrown



