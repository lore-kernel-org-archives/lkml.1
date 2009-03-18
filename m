Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbZCRKgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbZCRKgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 06:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbZCRKgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 06:36:43 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39124 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbZCRKgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 06:36:42 -0400
To: Zhang Le <r0bertz@gentoo.org>
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org, alan@redhat.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Al Viro <viro@ZenIV.linux.org.uk>
References: <1237185871-3343-1-git-send-email-r0bertz@gentoo.org>
	<m17i2okogv.fsf@fess.ebiederm.org>
	<20090318072720.GA20593@adriano.hkcable.com.hk>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 18 Mar 2009 03:36:35 -0700
In-Reply-To: <20090318072720.GA20593@adriano.hkcable.com.hk> (Zhang Le's message of "Wed\, 18 Mar 2009 15\:27\:21 +0800")
Message-ID: <m1mybjf77w.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: r0bertz@gentoo.org, viro@ZenIV.linux.org.uk, adobriyan@gmail.com, alan@redhat.com, torvalds@osdl.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Zhang Le <r0bertz@gentoo.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] filp->f_pos not correctly updated in proc_task_readdir
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang Le <r0bertz@gentoo.org> writes:

> Unfortunately, unlike directories on normal filesystem, there will never be any
> other files in /proc/xxxx/task. So, to my understanding, d_off should be
> increasing continuously, no?
>
> OK, here is what is going on in glibc. I left it out intentionally so as not to
> make the discuss unnecessarily complicated. So here it is:
>
> First of all, we can see that the d_off does not get correctly updated.

Linus has merged that fix and I have no problems with fixing d_off.
The fact that it was not set is a bug plain and simple.


> Then, let's take a look at glibc's __GETDENTS function. In this function, there
> are 3 implementations:
> http://sources.redhat.com/git/gitweb.cgi?p=glibc.git;a=blob;f=sysdeps/unix/sysv/linux/getdents.c;h=b33d1789adff11a04cbb1f6f5616bc8eed59418f;hb=cvs/master
> Two of them will detect overflow, and lseek if necessary.
>
> This means, although d_off in /proc/xxxx/task does not get updated correctly
> everywhere, the problem of endless loop only occurs on certain platforms.
> One of them is MIPS N32 ABI system.

Ok.  glibc is performing a conversion and if it doesn't have enough
space to convert all of the entries it read it does a seek, so it
will reread from the kernel the unread entries.

Not friendly (as seeks are notoriously hard to get right in directories)
but not the worst behavior in the world.

> Of course, there are other ways to work around this. However, to me, fixing this
> would be the easiest and the most straight forward one. :)

I'm not looking for other work arounds.  There is another bug, that I wondering if
we can fix.

The sequence:
opendir
readdir
readdir
readdir
closedir

Is supposed to guarantee that all directory entries that exist from
the time of openddir to the time of closedir are returned.

If threads are being created and destroyed between opendir and
closedir we can fail to show threads that exist the entire time.  A
seek is particularly bad.

So I am wondering if there is a way we can change first_tid and next_tid
so that we can do better.

The fact that people have large enough thread directories that they
are hitting an overflow case suggests that eventually we will also have
problems with missing threads, like we have saw with missing processes
in the root directory of /proc, before that problem was fixed.

One possibility is to encode the pid in the offset.  That is slightly
better but it doesn't fix the restart case where that pid has existed
as the thread list is not stored in pid order.  We add new threads
to the tail of the thread list.  Which seems like the right thing
to do.

The only way I can see to actually make this robust is to ignore
the thread list altogether.  Have an encoded form of the pid in
the offset, and then walk the pid bitmap.  Only returning
for entries that are in the proper thread group.  It will
likely be a bit slower but if we need to support seeks there
appears not helping it.

Eric
