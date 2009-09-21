Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbZIUPa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbZIUPa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 11:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756617AbZIUPa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 11:30:59 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:37528 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198AbZIUPa5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 11:30:57 -0400
X-Greylist: delayed 4389 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2009 11:30:57 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=U88/W0Pjb6N5vxuMwRR5USlar7/7LowDxtZn3blP/MrNjrei/WYlB9MROFAaDndth9
         vSfJjz5IaPkkzu2xvzBKw4ueyIjzD4nQhtjPO2bgEUbDGCUfQP/nJLPt1ZKBDVqWQcjw
         fUA5Bn6ESyaynMc+gRAq04CyRa/Imb3mIRPAU=
MIME-Version: 1.0
In-Reply-To: <20090921143857.GE14381@ZenIV.linux.org.uk>
References: <E1MpiJo-0005fv-2y@pomaz-ex.szeredi.hu> <E1MpiMo-0005h9-DG@pomaz-ex.szeredi.hu> 
	<20090921140220.GD14381@ZenIV.linux.org.uk> <8bd0f97a0909210710h5bb75bcdwb666b51a9155a70a@mail.gmail.com> 
	<20090921143857.GE14381@ZenIV.linux.org.uk>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 21 Sep 2009 11:30:41 -0400
Message-ID: <8bd0f97a0909210830j80df616m1fee64108c0125a7@mail.gmail.com>
Subject: Re: [PATCH 2/2] vfs: fix d_path() for unreachable paths
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu, agruen@suse.de, hch@lst.de,
       hugh.dickins@tiscali.co.uk, matthew@wil.cx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 10:38, Al Viro wrote:
> On Mon, Sep 21, 2009 at 10:10:17AM -0400, Mike Frysinger wrote:
>> it works without having to copy & paste the same exact structures over
>> and over.  a suggestion as how to do it cleanly without bloating the
>> code is certainly welcome.  it doesnt really matter that it's on the
>> stack as the usage is small and d_path() is given the size of the
>> buffer, so it isnt going to overflow.
>
> Umm...  Surely, you can put a CPU number + one bit into PDE->data?  As in
>        proc_create_data("icplb", ....., (void *)(cpu * 2))
>        proc_create_data("dcplb", ....., (void *)(cpu * 2 + 1))
> and
>        struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
>        unsigned long n = (unsigned long) pde->data;
>        ...
>        cpu = n / 2;
>        is_D = n & 1;

if i'd known this route, i'd have used it ;).  i'll look into changing
it, thanks.

>> > ??For another... locking in that loop
>> > over processes and VMAs of each looks very suspicios, while we are at it.
>>
>> we've reviewed it several times and exercised it in multiple ways.  so
>> unless you have a real idea of something being wrong, the code has
>> been vetted heavily.
>
> write_lock_irq tasklist_lock
> loop over processes
>        get_task_mm [now VM is pinned down, but not locked]
>        walk the VMA list without any locking
>
> Something on another CPU (you have SMP systems, judging by the previously
> discussed code, right?) does munmap().

the SMP port is limited due to lack of hardware cache coherency, but
we'll check out this call path
-mike
