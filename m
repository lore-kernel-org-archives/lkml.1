Return-Path: <linux-kernel-owner+w=401wt.eu-S1759485AbZFYTu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485AbZFYTu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbZFYTuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:50:21 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:57534 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbZFYTuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:50:20 -0400
Subject: Re: kmemleak false positive?
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Dave Jones <davej@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@parisplace.org>, Kaigai Kohei <kaigai@ak.jp.nec.com>,
       James Morris <jmorris@namei.org>
In-Reply-To: <20090625154014.GA7866@redhat.com>
References: <20090625001137.GB22755@redhat.com>
	 <1245921918.26218.19.camel@pc1117.cambridge.arm.com>
	 <20090625145600.GA6654@redhat.com>
	 <1245943539.26218.70.camel@pc1117.cambridge.arm.com>
	 <20090625154014.GA7866@redhat.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 25 Jun 2009 15:49:21 -0400
Message-Id: <1245959361.5217.16.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 11:40 -0400, Dave Jones wrote:
> On Thu, Jun 25, 2009 at 04:25:39PM +0100, Catalin Marinas wrote:
>  > > Hmm, it's pretty noisy, and everything it's found so far looks to be
>  > > a false positive.
>  > 
>  > In this case, it would make sense to enable task stacks scanning by
>  > default:
>  > 
>  > diff --git a/mm/kmemleak.c b/mm/kmemleak.c
>  > index 17096d1..a38418a 100644
>  > --- a/mm/kmemleak.c
>  > +++ b/mm/kmemleak.c
>  > @@ -194,7 +194,7 @@ static unsigned long jiffies_min_age;
>  >  /* delay between automatic memory scannings */
>  >  static signed long jiffies_scan_wait;
>  >  /* enables or disables the task stacks scanning */
>  > -static int kmemleak_stack_scan;
>  > +static int kmemleak_stack_scan = 1;
> 
> heh, I just did the same patch for the rawhide kernel builds.
>  
>  > >  > You can mount debugfs on /sys/kerne/debug and read the kmemleak file in
>  > >  > there (it triggers a new scan as well).
>  > > 
>  > > Currently prints the acpi traces I already posted.
>  > 
>  > If they are still consistently shown with stack=on, it could be a leak.
> 
> Could be, though as you mentioned, with ACPI it's really hard to tell.
> 
> Here's another case (with stack scanning on btw) which looks odd..
> 
>  kmemleak: unreferenced object 0xd86ba000 (size 16):
>  kmemleak:   comm "init", pid 1, jiffies 4294683556
>  kmemleak:   backtrace:
>  kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
>  kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
>  kmemleak:     [<c05cdfdc>] avtab_insertf+0xd6/0x140
>  kmemleak:     [<c05ce3d7>] avtab_read_item+0x26a/0x284
>  kmemleak:     [<c05ce5a5>] avtab_read+0x82/0xe5
>  kmemleak:     [<c05d0618>] policydb_read+0x40c/0x1028
>  kmemleak:     [<c05d459d>] security_load_policy+0x57/0x37c
>  kmemleak:     [<c05c9995>] sel_write_load+0xb2/0x54a
>  kmemleak:     [<c0500186>] vfs_write+0x9f/0x10f
>  kmemleak:     [<c05002e1>] sys_write+0x58/0x8d
>  kmemleak:     [<c040a8eb>] sysenter_do_call+0x12/0x38
>  kmemleak:     [<ffffffff>] 0xffffffff
> 
> I looked over the SELinux code, and couldn't see an obvious leak.
> Eric Paris came to the same conclusion.

I suspect it is a false positive caused by the current odd way in which
we update the policydb.  So I would expect it to go away when we get
around to rewriting that code, already on our todo list.

However, KaiGai Kohei noticed that /sys/kernel/slab/avtab_node/objects
seems to grow upon repeated load_policy invocations (of the same policy)
for some kernels (e.g. F11 kernel) while remaining constant for the
rawhide kernel.

# for i in `seq 1 100`
> do
> load_policy
> cat /sys/kernel/slab/avtab_node/objects
> done

-- 
Stephen Smalley
National Security Agency

