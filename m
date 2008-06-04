Return-Path: <linux-kernel-owner+w=401wt.eu-S1762857AbYFDXMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762857AbYFDXMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 19:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757790AbYFDXMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 19:12:13 -0400
Received: from ns.suse.de ([195.135.220.2]:43141 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052AbYFDXMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 19:12:12 -0400
From: Neil Brown <neilb@suse.de>
To: Dave Jones <davej@redhat.com>
Date: Thu, 5 Jun 2008 09:12:02 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18503.8514.710121.995152@notabene.brown>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25 md oops during boot.
In-Reply-To: message from Dave Jones on Wednesday June 4
References: <20080604154137.GA26157@redhat.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday June 4, davej@redhat.com wrote:
> Hi Neil,
>  Here's an odd one.
> https://bugzilla.redhat.com/show_bug.cgi?id=442204
> 
> Slightly old (.25-rc8-git7), but I don't recall anything changing between
> then and .25 final that could explain this.
> 
> 	Dave

Hi Dave.

Yes, Odd.

It appear that sysfs_addrm_start is being called with parent_sd == NULL.

That implies that sysfs_create_dir is being given a kobj where
->parent is non-NULL, and ->parent->sd is NULL.

So kobject_add is being given a parent with a NULL ->sd.

So in bind_rdev_to_array,  mddev->kobj.sd is NULL.

So in md_probe, either kobject_init_and_add is failing
to set up ->sd properly (which should result in an error message
   "md: cannot register md0/md - name in use"
) or alloc_disk is failing.


The most likely scenario is that alloc_disk is failing, so the
md_probe call in autorun_devices (line 3804 of md.c) fails.
The following mddev_find creates a new mddev which is not properly
initialised and gets used.

I wouldn't say this is a likely scenario as it requires (I think)
kmalloc failure very early in boot.  But I cannot see any other
possible cause.

I'll see about getting the error paths handled better.

NeilBrown
