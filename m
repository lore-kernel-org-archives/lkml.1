Return-Path: <linux-kernel-owner+w=401wt.eu-S932588AbZDAOux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbZDAOux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764529AbZDAOul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:50:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:53602 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764097AbZDAOuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:50:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <kpc.mtd@gmail.com>
Subject: Re: [PATCHv4] MTD: New ioctl calls for >4GiB device support
Date: Wed, 1 Apr 2009 16:50:22 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org
References: <a95a62fe0903301814k75ce56f5xef0a04c5c188012@mail.gmail.com> <200903311251.04746.arnd@arndb.de> <a95a62fe0903311129g7ecf6997k2f06f6d9a2abe2c@mail.gmail.com>
In-Reply-To: <a95a62fe0903311129g7ecf6997k2f06f6d9a2abe2c@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904011650.22928.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19TZRJ784MlOGeegrPGXbVZpnr+PVB8eKtorVt
 ByfnisHxnpa9mVoH3OySZzG8NihlWzuCN6/j4XLahiwWGD8hRr
 ZVVr/MFHFvkauPqGDImvQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 March 2009, Kevin Cernekee wrote:
> On Tue, Mar 31, 2009 at 3:51 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday 31 March 2009, Kevin Cernekee wrote:
> >> +struct mtd_oob_buf64 {
> >> +       uint64_t start;
> >> +       uint32_t res0;
> >> +       uint32_t length;
> >> +       unsigned char __user *ptr;
> >> +       uint32_t res1[8];
> >> +};
> >
> > Does this have to use an indirect pointer? We normally try to avoid
> > ioctl interfaces like this, because they are hard to trace and you
> > need a compat wrapper. You might be able to at least avoid the wrapper
> > by defining the data structure with a __u64 to take the pointer.
> 
> Could you please point out another ioctl that is set up this way, so
> that I can follow the same conventions?

struct signalfd_siginfo uses __u64 to store pointers, and so does
the sg_io_v4 ioctl. Some of the ioctls in kvm.h also use __u64
for addresses.

> Are we ever worried about pointers that are larger than 64 bits, or
> ints that are larger than 32 bits?  Or is it generally OK to assume
> this will never happen?

None of these is a worry, as we already rely on the size of int, long
and pointer in a lot of ways.

> > If you leave the data structure the way it is, you should at least
> > move the compat_ioctl handling into mtdchar.c from compat_ioctl.c.
> > It will simplify your code and help reduce the size of the common
> > ioctl handling.
> 
> Is this what you are recommending?
> 
> 1) Leave existing MTD COMPATIBLE_IOCTLs in fs/compat_ioctl.c
> 
> 2) Implement compat_ioctl handler in mtdchar.c for MEMREADOOB64_32 and
> MEMWRITEOOB64_32
> 
> 3) For all other commands, the new handler should return -ENOIOCTLCMD
> and let fs/compat_ioctl.c handle them

Yes, that would be good.

> Would it be a good idea to move MTDREADOOB32 / MEMWRITEOOB32 out of
> fs/compat_ioctl.c at the same time, so that everything is in one
> place?

Yes, I'd like to see this as a separate patch either before or
after the other one. I have the long-term goal of getting rid of
all the wrapper functions in fs/compat_ioctl.c, but it's stalled
for some time.

> If the compat wrappers are moved to mtdchar.c , does that imply that
> they should be reimplemented "natively" instead of using
> compat_alloc_user_space(), copy_in_user(), and sys_ioctl() to cause
> them to reinvoke the 64-bit versions?

Right, that is what I mean with 'simplify your code'.

Thanks,

	Arnd <><
