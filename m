Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340Ab0ARDQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab0ARDQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 22:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300Ab0ARDQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 22:16:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:32862 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755269Ab0ARDQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 22:16:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,292,1262592000"; 
   d="scan'208";a="765021636"
From: "Wu, Fengguang" <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Eric Paris <eparis@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andi Kleen <andi@firstfloor.org>,
       David Howells <dhowells@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Date: Mon, 18 Jan 2010 11:15:38 +0800
Subject: RE: [PATCH 6/6] vfs: introduce FMODE_NEG_OFFSET for allowing
 negative f_pos
Thread-Topic: [PATCH 6/6] vfs: introduce FMODE_NEG_OFFSET for allowing
 negative f_pos
Thread-Index: AcqX5qw+mLzTMuV6StmMRGyKpSDsxAABEjyL
Message-ID: <6CADD16F56BC954D8E28F3836FA7ED7112A9CD50F6@shzsmsx501.ccr.corp.intel.com>
References: <20100115013954.311049665@intel.com>
	<20100115014422.959401729@intel.com>	<87bpgurz00.fsf@devron.myhome.or.jp>
	<20100118091527.7a0e2c6e.kamezawa.hiroyu@jp.fujitsu.com>
	<87y6jwnrcz.fsf@devron.myhome.or.jp>
	<20100118102544.3e897525.kamezawa.hiroyu@jp.fujitsu.com>
	<87pr58kx9o.fsf@devron.myhome.or.jp>
	<20100118110019.c55ad88a.kamezawa.hiroyu@jp.fujitsu.com>
	<87y6jwjh3j.fsf@devron.myhome.or.jp>,<20100118113026.4c6efd26.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100118113026.4c6efd26.kamezawa.hiroyu@jp.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[replying from webmail, sorry for top-posting]

memory_lseek() calls force_successful_syscall_return() to force success on negative vals.
However that is a no-op for x86.

My experiment shows that lseek() does return negative pos. However,
manual says that "a value of (off_t) -1 is returned" on error. So it's OK
as long as your program is written as "err == -1" instead of "err < 0".

code:
        err = lseek64(fd, addr, SEEK_SET);
        if (err == -1)
                perror("seek " FILENAME);

output:
  # kmem-rw 0xffffffffa0094000
  addr=0xffffffffa0094000 val=0x441f0fe5894855

strace:
  open("/dev/kmem", O_RDWR)               = 3
  lseek(3, 18446744072099545088, SEEK_SET) = 18446744072099545088
  read(3, "UH\211\345\17\37D\0"..., 8)    = 8

Thanks,
Fengguang
________________________________________
From: KAMEZAWA Hiroyuki [kamezawa.hiroyu@jp.fujitsu.com]
Sent: Monday, January 18, 2010 10:30 AM
To: OGAWA Hirofumi
Cc: Wu, Fengguang; Andrew Morton; Al Viro; Heiko Carstens; Christoph Hellwig; LKML; Eric Paris; Nick Piggin; Andi Kleen; David Howells; Jonathan Corbet; linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 6/6] vfs: introduce FMODE_NEG_OFFSET for allowing negative f_pos

On Mon, 18 Jan 2010 11:13:04 +0900
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
>
> > On Mon, 18 Jan 2010 10:38:27 +0900
> > OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:
> >
> >> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
> >>
> >> >> So, lseek() returns (uses) it?
> >> >
> >> > lseek can return negative value, as far as I know.
> >>
> >> Umm..., how do you know the difference of -EOVERFLOW and fpos == -75?
> >>
> >
> > Ah, sorry. I read wrong.
> >
> > For /dev/mem, it uses its own lseek function which allows negative f_pos
> > value. Other usual file system doesn't allow negative f_pos.
> >
> > It's ok not to return -EOVEFLOW for /dev/mem because there is no file end.
>
> No, no. I think it has the problem.
>
> E.g. /dev/mem returns -75 as fpos, so, lseek(2) returns -75 to
> userland. Then the userland (e.g. glibc) convert it as
> error. I.e. finally, errno == -75, and lseek(3) returns -1, right?
>
Maybe possible.

Hmm. Then, /dev/mem's llseek need some fix not to return pos < -PAGESIZE.
Wu-san, could you add additional bug fix to lseek()'s f_pos handling in
/dev/mem ?

Thanks,
-Kame


