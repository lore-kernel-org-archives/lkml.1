Return-Path: <linux-kernel-owner+w=401wt.eu-S1760514AbXK0XwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760514AbXK0XwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbXK0Xv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:51:56 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:53037 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbXK0Xvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:51:55 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 27 Nov 2007 15:51:52 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mtk-manpages@gmx.net, tglx@linutronix.de,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2/4] Timerfd v3 - new timerfd API
In-Reply-To: <20071127133919.71e9bc00.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0711271529540.28962@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.18989.1196028860.2>
 <20071127010254.133e222f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0711271246400.28962@alien.or.mcafeemobile.com>
 <20071127133919.71e9bc00.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007, Andrew Morton wrote:

> On Tue, 27 Nov 2007 12:47:46 -0800 (PST)
> Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > On Tue, 27 Nov 2007, Andrew Morton wrote:
> > 
> > > On Sun, 25 Nov 2007 14:14:19 -0800 Davide Libenzi <davidel@xmailserver.org> wrote:
> > > 
> > > > +static struct file *timerfd_fget(int fd)
> > > > +{
> > > > +	struct file *file;
> > > > +
> > > > +	file = fget(fd);
> > > > +	if (!file)
> > > > +		return ERR_PTR(-EBADF);
> > > > +	if (file->f_op != &timerfd_fops) {
> > > > +		fput(file);
> > > > +		return ERR_PTR(-EINVAL);
> > > > +	}
> > > > +
> > > > +	return file;
> > > > +}
> > > 
> > > I suppose we could use fget_light() in here sometime.  It is significantly
> > > quicker in microbenchmarks.  Or it was - nobody has checked that in a few
> > > years afaik.
> > 
> > Should I now?
> 
> No great rush.  It'd be fun to see if it actually makes any measurable
> difference on modern hardware (hint ;)).

I was going to say BS, given that at the time of the tests, the files 
struct was protected by an rwlock whereas now there's a rcu one.
But that seems not the case:

http://www.xmailserver.org/fget-light-test.c


$ fget-light-test -r 900000000   
warming up ...
testing non-shared ...
time = 314.354000 ms
testing shared ...
time = 390.781000 ms



And here is the oprofile output:

[SHARED CASE]
samples  %        app name                 symbol name
7436     28.9339  vmlinux                  __clear_user
2369      9.2179  vmlinux                  system_call
1710      6.6537  vmlinux                  fget_light
1244      4.8405  vmlinux                  inotify_dentry_parent_queue_event
1128      4.3891  vmlinux                  sys_read
1041      4.0506  libpthread-2.6.1.so      __read_nocancel
1027      3.9961  Xorg                     (no symbols)
978       3.8054  vmlinux                  read_zero
755       2.9377  vmlinux                  vfs_read
545       2.1206  vmlinux                  inotify_inode_queue_event
507       1.9728  vmlinux                  sysret_check
414       1.6109  vmlinux                  rw_verify_area
405       1.5759  vmlinux                  unix_poll
371       1.4436  nvidia                   (no symbols)
333       1.2957  vmlinux                  acpi_pm_read
311       1.2101  nvidia_drv.so            (no symbols)
290       1.1284  vmlinux                  do_select
288       1.1206  vmlinux                  dnotify_parent
253       0.9844  libc-2.6.1.so            (no symbols)
232       0.9027  bash                     (no symbols)
216       0.8405  libpthread-2.6.1.so      __pthread_enable_asynccancel


[UNSHARED CASE]
samples  %        app name                 symbol name
6542     27.6922  vmlinux                  __clear_user
4074     17.2452  vmlinux                  vfs_read
1266      5.3590  vmlinux                  inotify_inode_queue_event
1091      4.6182  Xorg                     (no symbols)
1059      4.4827  vmlinux                  system_call
937       3.9663  libpthread-2.6.1.so      __read_nocancel
544       2.3027  vmlinux                  clear_user
484       2.0488  vmlinux                  dnotify_parent
445       1.8837  vmlinux                  read_zero
438       1.8540  vmlinux                  sysret_check
414       1.7525  vmlinux                  unix_poll
407       1.7228  nvidia                   (no symbols)
389       1.6466  vmlinux                  acpi_pm_read
315       1.3334  nvidia_drv.so            (no symbols)
312       1.3207  vmlinux                  inotify_dentry_parent_queue_event
312       1.3207  vmlinux                  sys_read
305       1.2911  vmlinux                  rw_verify_area
304       1.2868  vmlinux                  do_select
222       0.9397  libc-2.6.1.so            (no symbols)
214       0.9059  bash                     (no symbols)
196       0.8297  fget-light-test          read_test
185       0.7831  vmlinux                  fget_light



You can clearly notice the fget_light() drop out of the relevance window.
BTW, are all those "notify" noises supposed to be there?




- Davide


