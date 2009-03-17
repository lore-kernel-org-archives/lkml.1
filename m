Return-Path: <linux-kernel-owner+w=401wt.eu-S1755706AbZCQSNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbZCQSNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 14:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbZCQSM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 14:12:56 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43101 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbZCQSMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 14:12:55 -0400
To: Zhang Le <r0bertz@gentoo.org>
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org, alan@redhat.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] filp->f_pos not correctly updated in proc_task_readdir
References: <1237185871-3343-1-git-send-email-r0bertz@gentoo.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 17 Mar 2009 11:12:48 -0700
In-Reply-To: <1237185871-3343-1-git-send-email-r0bertz@gentoo.org> (Zhang Le's message of "Mon\, 16 Mar 2009 14\:44\:31 +0800")
Message-ID: <m17i2okogv.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang Le <r0bertz@gentoo.org> writes:

> filp->f_pos only get updated at the end of the function. Thus d_off of those
> dirents who are in the middle will be 0, and this will cause a problem in
> glibc's readdir implementation, specifically endless loop. Because when overflow
> occurs, f_pos will be set to next dirent to read, however it will be 0, unless
> the next one is the last one. So it will start over again and again.
>
> There is a sample program in man 2 gendents. This is the output of the program
> running on a multithread program's task dir before this patch is applied:
>
> $ ./a.out /proc/3807/task
> --------------- nread=128 ---------------
> i-node#  file type  d_reclen  d_off   d_name
>   506442  directory    16          1  .
>   506441  directory    16          0  ..
>   506443  directory    16          0  3807
>   506444  directory    16          0  3809
>   506445  directory    16          0  3812
>   506446  directory    16          0  3861
>   506447  directory    16          0  3862
>   506448  directory    16          8  3863
>
> This is the output after this patch is applied
>
> $ ./a.out /proc/3807/task
> --------------- nread=128 ---------------
> i-node#  file type  d_reclen  d_off   d_name
>   506442  directory    16          1  .
>   506441  directory    16          2  ..
>   506443  directory    16          3  3807
>   506444  directory    16          4  3809
>   506445  directory    16          5  3812
>   506446  directory    16          6  3861
>   506447  directory    16          7  3862
>   506448  directory    16          8  3863

I'm trying to understand what the problem that glibc
runs into.  Is this the glibc seekdir madness?

Under which conditions have you seen this problem?

The reason I ask is if this is triggered by seekdir and people really
care then the current proc_task_readdir for the /proc/<pid>/task/
directories is not quite sufficient.  As threads come and go the d_off
associated with a specific thread will change.

Which means we probably should be returning:

$ ./a.out /proc/3807/task
--------------- nread=128 ---------------
i-node#  file type  d_reclen  d_off   d_name
  506442  directory    16          1  .
  506441  directory    16          2  ..
  506443  directory    16          3809  3807
  506444  directory    16          3811  3809
  506445  directory    16          3814  3812
  506446  directory    16          3863  3861
  506447  directory    16          3864  3862
  506448  directory    16          3865  3863

Which is slightly better unfortunately it doesn't give us the
guarantee that the d_off will be continually increasing.

Eric
