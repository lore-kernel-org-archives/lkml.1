Return-Path: <linux-kernel-owner+w=401wt.eu-S1752118AbZGaHXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbZGaHXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 03:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbZGaHXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 03:23:36 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47353 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZGaHXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 03:23:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 31 Jul 2009 16:21:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mike Smith <scgtrp@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][PATCH 0/3] fix bug for /proc/kcore causes panic  (Was:
 [Bugme-new] [Bug 13850] New: reading /proc/kcore causes oops
Message-Id: <20090731162146.0c211a1e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090731160748.279845da.kamezawa.hiroyu@jp.fujitsu.com>
References: <bug-13850-10286@http.bugzilla.kernel.org/>
	<20090728160527.1da52682.akpm@linux-foundation.org>
	<20090729084825.1363c880.kamezawa.hiroyu@jp.fujitsu.com>
	<525c5a6c0907281946t249ef288v77ee94edd16f054@mail.gmail.com>
	<20090729123209.690baa48.kamezawa.hiroyu@jp.fujitsu.com>
	<20090731160748.279845da.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009 16:07:48 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Wed, 29 Jul 2009 12:32:09 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Tue, 28 Jul 2009 22:46:56 -0400
> > Mike Smith <scgtrp@gmail.com> wrote:
> > 
> > > > What's layout of memory does your server have ?
> > > The log I gave was from my desktop, so I'll assume you wanted that
> > > instead of the server:
> > > [mike: mike in ~]$ grep "System RAM" /proc/iomem
> > > 00010000-0009efff : System RAM
> > > 00100000-1dedffff : System RAM
> > > 
> > From this, your kernel's valid direct-map address range will be
> > 
> > c0010000-c009efff
> > c0100000-ddedffff
> > 
> Ok, I reproduced the bug on x86-32 and here is a fix.
> 
> I reproduced the bug on x86-32 host with mem=512M boot option.
> 
> As I expected, the bug is from holes in vmalloc area.
> (This hole means thera are a memory hole withing [start ...start+size-PAGE_SIZE) 
>  of valid vm_struct.)
> 
> For review, I divided all into 3 patches. all series will be reply to this email.
> 
A memo.

[1/3] fixes the bug in /dev/kmem, also.
      This causes machine check on my host (and one of cpu was disabled)
      # dd if=/dev/kmem of=/dev/null bs=1024 count=1048576 skip=3145728
      I hope all users of kmem are sane people...but the patch fixes this.
      (If kmem has to access IOREMAP area, please teach me .)

[2/3] fix for this /proc/kcore bug based on [1/3]

[3/3] fix for vread/vwrite race conditions.
      not related to this reproducable bug itself but a fix for potential bug.

Thanks,
-Kame




> Thanks,
> -Kame
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

