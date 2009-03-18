Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbZCRH1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbZCRH1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 03:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbZCRH1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 03:27:38 -0400
Received: from pyxis.i-cable.com ([203.83.115.105]:52097 "HELO
	pyxis.i-cable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752970AbZCRH1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 03:27:37 -0400
Date: Wed, 18 Mar 2009 15:27:21 +0800
From: Zhang Le <r0bertz@gentoo.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org, alan@redhat.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] filp->f_pos not correctly updated in proc_task_readdir
Message-ID: <20090318072720.GA20593@adriano.hkcable.com.hk>
References: <1237185871-3343-1-git-send-email-r0bertz@gentoo.org> <m17i2okogv.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17i2okogv.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:12 Tue 17 Mar     , Eric W. Biederman wrote:
> Zhang Le <r0bertz@gentoo.org> writes:
> 
> > filp->f_pos only get updated at the end of the function. Thus d_off of those
> > dirents who are in the middle will be 0, and this will cause a problem in
> > glibc's readdir implementation, specifically endless loop. Because when overflow
> > occurs, f_pos will be set to next dirent to read, however it will be 0, unless
> > the next one is the last one. So it will start over again and again.
> >
> > There is a sample program in man 2 gendents. This is the output of the program
> > running on a multithread program's task dir before this patch is applied:
> >
> > $ ./a.out /proc/3807/task
> > --------------- nread=128 ---------------
> > i-node#  file type  d_reclen  d_off   d_name
> >   506442  directory    16          1  .
> >   506441  directory    16          0  ..
> >   506443  directory    16          0  3807
> >   506444  directory    16          0  3809
> >   506445  directory    16          0  3812
> >   506446  directory    16          0  3861
> >   506447  directory    16          0  3862
> >   506448  directory    16          8  3863
> >
> > This is the output after this patch is applied
> >
> > $ ./a.out /proc/3807/task
> > --------------- nread=128 ---------------
> > i-node#  file type  d_reclen  d_off   d_name
> >   506442  directory    16          1  .
> >   506441  directory    16          2  ..
> >   506443  directory    16          3  3807
> >   506444  directory    16          4  3809
> >   506445  directory    16          5  3812
> >   506446  directory    16          6  3861
> >   506447  directory    16          7  3862
> >   506448  directory    16          8  3863
> 
> I'm trying to understand what the problem that glibc
> runs into.  Is this the glibc seekdir madness?
> 
> Under which conditions have you seen this problem?

Please see my explanation at the bottom.

> 
> The reason I ask is if this is triggered by seekdir and people really
> care then the current proc_task_readdir for the /proc/<pid>/task/
> directories is not quite sufficient.  As threads come and go the d_off
> associated with a specific thread will change.
> 
> Which means we probably should be returning:
> 
> $ ./a.out /proc/3807/task
> --------------- nread=128 ---------------
> i-node#  file type  d_reclen  d_off   d_name
>   506442  directory    16          1  .
>   506441  directory    16          2  ..

Without my patch here, d_off will be 0. And so will be the following d_off
except the last one.

>   506443  directory    16          3809  3807
>   506444  directory    16          3811  3809
>   506445  directory    16          3814  3812
>   506446  directory    16          3863  3861
>   506447  directory    16          3864  3862
>   506448  directory    16          3865  3863
> 
> Which is slightly better unfortunately it doesn't give us the
> guarantee that the d_off will be continually increasing.

Unfortunately, unlike directories on normal filesystem, there will never be any
other files in /proc/xxxx/task. So, to my understanding, d_off should be
increasing continuously, no?

OK, here is what is going on in glibc. I left it out intentionally so as not to
make the discuss unnecessarily complicated. So here it is:

First of all, we can see that the d_off does not get correctly updated.

Then, let's take a look at glibc's __GETDENTS function. In this function, there
are 3 implementations:
http://sources.redhat.com/git/gitweb.cgi?p=glibc.git;a=blob;f=sysdeps/unix/sysv/linux/getdents.c;h=b33d1789adff11a04cbb1f6f5616bc8eed59418f;hb=cvs/master
Two of them will detect overflow, and lseek if necessary.

This means, although d_off in /proc/xxxx/task does not get updated correctly
everywhere, the problem of endless loop only occurs on certain platforms.
One of them is MIPS N32 ABI system.

Of course, there are other ways to work around this. However, to me, fixing this
would be the easiest and the most straight forward one. :)

Zhang, Le
http://zhangle.is-a-geek.org
