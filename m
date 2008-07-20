Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbYGTXG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbYGTXG7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 19:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbYGTXGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 19:06:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57497 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbYGTXGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 19:06:50 -0400
From: Neil Brown <neilb@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Date: Mon, 21 Jul 2008 09:06:36 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18563.50428.659101.868745@notabene.brown>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Simon Arlott <simon@fire.lp0.eu>, Daniel Walker <dwalker@mvista.com>,
       Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 3/4] fastboot: make the raid autodetect code wait for all
 devices to init
In-Reply-To: message from Arjan van de Ven on Sunday July 20
References: <20080720151140.4aa7c682@infradead.org>
	<20080720151339.6f4a83d8@infradead.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(wondering why I wasn't Cc:ed on this...)

On Sunday July 20, arjan@infradead.org wrote:
> 
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sun, 20 Jul 2008 13:07:09 -0700
> Subject: [PATCH] fastboot: make the raid autodetect code wait for all devices to init
> 
> The raid autodetect code really needs to have all devices probed before
> it can detect raid arrays; not doing so would give rather messy situations
> where arrays would get detected as degraded while they shouldn't be etc.
> 
> This is in preparation of removing the "wait for everything to init"
> code that makes everyone pay, not just raid users.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  init/do_mounts_md.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
> index 693d246..c0412a9 100644
> --- a/init/do_mounts_md.c
> +++ b/init/do_mounts_md.c
> @@ -267,9 +267,16 @@ __setup("md=", md_setup);
>  void __init md_run_setup(void)
>  {
>  	create_dev("/dev/md0", MKDEV(MD_MAJOR, 0));
> +
>  	if (raid_noautodetect)
>  		printk(KERN_INFO "md: Skipping autodetection of RAID arrays. (raid=noautodetect)\n");
>  	else {
> +		/*
> +		 * Since we don't want to detect and use half a raid array, we
> +		 * need to wait for the known devices to complete their probing
> +		 */
> +		while (driver_probe_done() != 0)
> +			msleep(100);
>  		int fd = sys_open("/dev/md0", 0, 0);
>  		if (fd >= 0) {
>  			sys_ioctl(fd, RAID_AUTORUN, raid_autopart);

I must say that I think this is pretty horrible.   But then it is a
pretty horrible problem and I don't think there is a clean solution.

If md in a module, this code won't run so there will be no change.  If
md is compiled in, this code will silently slow down boot even if
there are no raid arrays to assemble.  I think the "silently" is a
problem.  I'm not looking forward to "my computer boots slower if I
compile md into the kernel" reports on linux-raid@vger.

What would you think of

    if (driver_probe_done() != 0) {
	printk("md: Waiting for all devices to be available before autodetect\n"
               "md:  If you don't boot off raid, use raid=noautodetect\n");
        do
           msleep(100);
	while (driver_probe_done() != 0);
    }

??

Also, the "driver_probe_done() != 0" bothers me.

If driver_probe_done is a boolean, it should be
	while (! drive_probe_done() ) msleep ....

and if it returns a negative error, then it should be
        while ( drive_probe_done() < 0) msleep ....

The != 0 confuses me about the expected return type.


The "real" solution here involves assembling arrays in userspace using
"mdadm --incremental" from udevd, and using write-intent-bitmaps so
that writing to an array before all the component devices are
available can be done without requiring a full resync.  There is still
a bit more code needed to make that work really smoothly.

NeilBrown
