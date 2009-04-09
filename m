Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbZDIAQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbZDIAQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 20:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757412AbZDIAPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 20:15:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757328AbZDIAPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 20:15:31 -0400
From: Neil Brown <neilb@suse.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 9 Apr 2009 10:15:28 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18909.15904.704697.734477@notabene.brown>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] sysfs poll should keep the poll rule of normal regular file.
In-Reply-To: message from KOSAKI Motohiro on Wednesday April 8
References: <20090408173935.8D7E.A69D9226@jp.fujitsu.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday April 8, kosaki.motohiro@jp.fujitsu.com wrote:
> 
> Currently, following test programs don't finished.
> 
> % ruby -e '
> Thread.new { sleep }
> File.read("/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies")
> '
> 
> strace expose the reason.
> 
> ...
> open("/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies", O_RDONLY|O_LARGEFILE) = 3
> ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, 0xbf9fa6b8) = -1 ENOTTY (Inappropriate ioctl for device)
> fstat64(3, {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
> _llseek(3, 0, [0], SEEK_CUR)            = 0
> select(4, [3], NULL, NULL, NULL)        = 1 (in [3])
> read(3, "1400000 1300000 1200000 1100000 1"..., 4096) = 62
> select(4, [3], NULL, NULL, NULL
> 
> 
> Because Ruby (the scripting language) VM assume select system-call against regular file don't block.
> (POSIX gurantee it.)
> But sysfs_poll() don't keep this rule although sysfs file can read and write always.

It would be nice to include a reference to where POSIX (or SUS)
guarantees it - though I suspect you are right.

I have one piece of code that this would break, but it isn't released
yet and it is never too late to fix things..

However it should be pointed out that /proc/mounts has exactly the
same problems (/proc/mdstat doesn't - I guess I was lucky enough to
get that one right).  So we should "fix" /proc/mounts
(fs/proc/base.c:mounts_poll) at the same time.  Assuming that won't
break anything.

Al:  do you have an opinion about changing mounts_poll to always
report 'readable' to poll??  What would break?

NeilBrown

> 
> This patch restore proper poll behavior to sysfs.
> /sys/block/md*/md/sync_action polling application and another sysfs updating sensitive
> application still can use POLLERR and POLLPRI.
> 
> 
> 
> Cc: Neil Brown <neilb@suse.de>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> --
>  fs/sysfs/file.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> index 289c43a..4a302f8 100644
> --- a/fs/sysfs/file.c
> +++ b/fs/sysfs/file.c
> @@ -446,11 +446,11 @@ static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
>  	if (buffer->event != atomic_read(&od->event))
>  		goto trigger;
>  
> -	return 0;
> +	return DEFAULT_POLLMASK;
>  
>   trigger:
>  	buffer->needs_read_fill = 1;
> -	return POLLERR|POLLPRI;
> +	return DEFAULT_POLLMASK|POLLERR|POLLPRI;
>  }
>  
>  void sysfs_notify_dirent(struct sysfs_dirent *sd)
> 
