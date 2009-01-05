Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbZAEWAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbZAEWAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbZAEWAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:00:19 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:51607 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbZAEWAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:00:17 -0500
Date: Mon, 5 Jan 2009 23:01:56 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       sparclinux <sparclinux@vger.kernel.org>
Subject: Re: ftrace breaks sparc64 build
Message-ID: <20090105220156.GC8592@uranus.ravnborg.org>
References: <20090105181922.GA25622@uranus.ravnborg.org> <alpine.DEB.1.10.0901051428370.27085@gandalf.stny.rr.com> <20090105195415.GA6204@uranus.ravnborg.org> <alpine.DEB.1.10.0901051458460.25066@gandalf.stny.rr.com> <20090105213107.GA27293@uranus.ravnborg.org> <alpine.DEB.1.10.0901051649240.25066@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901051649240.25066@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 04:52:02PM -0500, Steven Rostedt wrote:
> 
> On Mon, 5 Jan 2009, Sam Ravnborg wrote:
> 
> > > 
> > > Probably the same issue. The problem is that the first use of a variable 
> > > is in the OR section of an if statement that does a return.
> > > 
> > > 	if (x || !(y = init_me())
> > > 		return;
> > > 
> > > 	use_me(y);
> > > 
> > 
> > More warnings:
> > fs/partitions/check.c: In function `rescan_partitions':
> > fs/partitions/check.c:511: warning: 'state' might be used uninitialized in this function
> > 
> > => follow same pattern
> > 
> > fs/compat_ioctl.c: In function `ppp_sock_fprog_ioctl_trans':
> > fs/compat_ioctl.c:859: warning: 'fptr32' might be used uninitialized in this function
> > fs/compat_ioctl.c: In function `do_fontx_ioctl':
> > fs/compat_ioctl.c:1082: warning: 'data' might be used uninitialized in this function
> > fs/compat_ioctl.c: In function `do_atmif_sioc':
> > fs/compat_ioctl.c:1302: warning: 'data' might be used uninitialized in this function
> > fs/compat_ioctl.c: In function `do_atm_ioctl':
> > fs/compat_ioctl.c:1272: warning: 'data' might be used uninitialized in this function
> > fs/compat_ioctl.c: In function `mtd_rw_oob':
> > fs/compat_ioctl.c:1421: warning: 'data' might be used uninitialized in this function
> > fs/compat_ioctl.c: In function `do_usbdevfs_discsignal':
> > fs/compat_ioctl.c:1650: warning: 'uctx' might be used uninitialized in this function
> > 
> > This is:
> >         if (get_user(flen, &u_fprog32->len) ||
> >             get_user(fptr32, &u_fprog32->filter))
> >                 return -EFAULT;
> 
> Is this all sparc cross compiler?  I'm trying to reproduce it on x86 with 
> no avail :-(
> 
> I would like to test other ways to change the macro, but to do so, I need 
> to get a compiler that will produce the warnings that you see. What 
> version of gcc are you using?

I used crosstool to build a 3.4.5 gcc:
set -ex
TARBALLS_DIR=$HOME/downloads
RESULT_TOP=/opt/crosstool
export TARBALLS_DIR RESULT_TOP
GCC_LANGUAGES="c"
export GCC_LANGUAGES

eval `cat sparc64.dat gcc-3.4.5-glibc-2.3.6-tls.dat` sh all.sh --notest

It is running on a 32 bit target.
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 8
model name      : Pentium III (Coppermine)
stepping        : 10
cpu MHz         : 851.970
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 mtrr pge mca cmov pat pse36 mmx fxsr sse
bogomips        : 1704.50
clflush size    : 32


	Sam
