Return-Path: <linux-kernel-owner+w=401wt.eu-S936157AbXGZSHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936157AbXGZSHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934576AbXGZSGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:06:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46429 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765458AbXGZSGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:06:52 -0400
Date: Thu, 26 Jul 2007 11:05:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Frank Kingswood <frank@kingswood-consulting.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ray Lee <ray-lk@madrabbit.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       ck list <ck@vds.kolivas.org>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge plans
 for 2.6.23]
Message-Id: <20070726110549.da3a7a0d.akpm@linux-foundation.org>
In-Reply-To: <1185454019.6449.12.camel@Homer.simpson.net>
References: <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
	<46A57068.3070701@yahoo.com.au>
	<2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>
	<46A58B49.3050508@yahoo.com.au>
	<2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>
	<46A6CC56.6040307@yahoo.com.au>
	<p73abtkrz37.fsf@bingen.suse.de>
	<46A85D95.509@kingswood-consulting.co.uk>
	<20070726092025.GA9157@elte.hu>
	<20070726023401.f6a2fbdf.akpm@linux-foundation.org>
	<20070726094024.GA15583@elte.hu>
	<20070726030902.02f5eab0.akpm@linux-foundation.org>
	<1185454019.6449.12.camel@Homer.simpson.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 14:46:58 +0200 Mike Galbraith <efault@gmx.de> wrote:

> On Thu, 2007-07-26 at 03:09 -0700, Andrew Morton wrote:
> 
> > Setting it to zero will maximise the preservation of the vfs caches.  You
> > wanted 10000 there.
> > 
> > <bets that nobody will test this>
> 
> drops caches prior to both updatedb runs.

I think that was the wrong thing to do.  That will leave gobs of free
memory for updatedb to populate with dentries and inodes.

Instead, fill all of memory up with pagecache, then do the updatedb.  See
how much pagecache is left behind and see how large the vfs caches end up.

> root@Homer: df -i
> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> /dev/hdc3            12500992 1043544 11457448    9% /
> udev                  129162    1567  127595    2% /dev
> /dev/hdc1              26104      87   26017    1% /boot
> /dev/hda1             108144   90676   17468   84% /windows/C
> /dev/hda5              11136    3389    7747   31% /windows/D
> /dev/hda6                  0       0       0    -  /windows/E
> 
> vfs_cache_pressure=10000, updatedb freshly completed:
> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
>  1  0     48  76348 420356 104748    0    0     0     0 1137  912  3  1 97  0
> 
> ext3_inode_cache  315153 316274    524    7    1 : tunables   54   27    8 : slabdata  45182  45182      0
> dentry_cache      224829 281358    136   29    1 : tunables  120   60    8 : slabdata   9702   9702      0
> buffer_head       156624 159728     56   67    1 : tunables  120   60    8 : slabdata   2384   2384      0
> 
> vfs_cache_pressure=100 (stock), updatedb freshly completed:
> 
> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
> 1  0    148  83824 270088 116340    0    0     0     0 1095  330  2  1 97  0
>  
> ext3_inode_cache  467257 502495    524    7    1 : tunables   54   27    8 : slabdata  71785  71785      0
> dentry_cache      292695 408958    136   29    1 : tunables  120   60    8 : slabdata  14102  14102      0
> buffer_head       118329 184384     56   67    1 : tunables  120   60    8 : slabdata   2752   2752      1
> 
> Note:  updatedb doesn't bother my box, not running enough leaky apps I
> guess.
> 

So you ended up with a couple hundred MB of pagecache preserved.

Capturing before-and-after /proc/meminfo would be nice - it's a useful
summary.

