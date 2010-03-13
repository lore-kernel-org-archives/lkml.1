Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385Ab0CMWeX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 17:34:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759356Ab0CMWeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 17:34:22 -0500
Date: Sat, 13 Mar 2010 14:32:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] base firmware: Fix BUG from sysfs attributes change in
 commit a2db6842873c8e5a70652f278d469128cb52db70
In-Reply-To: <4b9be956.x5+yAHXGDfXer810%Larry.Finger@lwfinger.net>
Message-ID: <alpine.LFD.2.00.1003131426480.3719@i5.linux-foundation.org>
References: <4b9be956.x5+yAHXGDfXer810%Larry.Finger@lwfinger.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 13 Mar 2010, Larry Finger wrote:
>
> Commit a2db6842873c8e5a70652f278d469128cb52db70 changed the way that
> sysfs attributes are handled. With lockdep checking enabled, a firmware
> loading request from b43 generates the following BUG:
> 
> BUG: key ffff8800b85f4870 not in .data!
> ------------[ cut here ]------------
> WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0x236/0x5d0()

I don't think we can fix these problems this way.

Lookie here:

	[torvalds@i5 linux]$ git grep sysfs_create_bin_file | wc
	     68     319    5999
	[torvalds@i5 linux]$ git grep sysfs_bin_attr_init | wc
	      8      24     522

and you sent in patches to fix _two_ of the remaining 60 cases.

Now, there may be some reason why it's not needed for the others, and 
those two are special, but I somewhat doubt it.

Eric - that patch of yours is obviously broken. Either I need to revert 
it, or you need to fix it. Not these kinds of "fix random 
sysfs_create_bin_file() drivers one by one" things.

		Linus

---
> Hardware name: HP Pavilion dv2700 Notebook PC
> Pid: 2283, comm: NetworkManager Not tainted 2.6.34-rc1-wl #320
> Call Trace:
> [<ffffffff81046068>] warn_slowpath_common+0x78/0xb0
> [<ffffffff810460af>] warn_slowpath_null+0xf/0x20
> [<ffffffff810765e6>] lockdep_init_map+0x236/0x5d0
> [<ffffffff811633aa>] sysfs_add_file_mode+0x6a/0xc0
> [<ffffffff8116340c>] sysfs_add_file+0xc/0x10
> [<ffffffff81165ae1>] sysfs_create_bin_file+0x21/0x30
> [<ffffffff8124f6b7>] _request_firmware+0x267/0x630
> [<ffffffff8124fb0e>] request_firmware+0xe/0x10
> [<ffffffffa04038d2>] b43_do_request_fw+0x92/0x230 [b43]
> (rest of dump snipped)
> 
> Fixed by initing the attribute.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Index: wireless-testing/drivers/base/firmware_class.c
> ===================================================================
> --- wireless-testing.orig/drivers/base/firmware_class.c
> +++ wireless-testing/drivers/base/firmware_class.c
> @@ -442,6 +442,7 @@ static int fw_setup_device(struct firmwa
>  	fw_priv = dev_get_drvdata(f_dev);
>  
>  	fw_priv->fw = fw;
> +	sysfs_bin_attr_init(&fw_priv->attr_data);
>  	retval = sysfs_create_bin_file(&f_dev->kobj, &fw_priv->attr_data);
>  	if (retval) {
>  		dev_err(device, "%s: sysfs_create_bin_file failed\n", __func__);
> 
