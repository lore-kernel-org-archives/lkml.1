Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbYGEHpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbYGEHpH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 03:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYGEHo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 03:44:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:59703 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYGEHo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 03:44:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rvo7Ue/VeBk52lQbqJqvhnvx2yBDkc64Z5H5jkK9et9c5fXV6CVI6nTOHiAwp7V/iC
         YizoZezueQe1fTV8ZwfYrmHaZFMkR0UHRJIsj15DGpsbzn6sjYqqj6tkdJoR/RoQmT/X
         vNY4oKeSn14nPnTUZxlBU1AHslZaAPsXCytjU=
Message-ID: <b6fcc0a0807050044g7a34a688s903e74848ab14b92@mail.gmail.com>
Date: Sat, 5 Jul 2008 11:44:54 +0400
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: *sigh* /proc/*/pagemap
Cc: torvalds@linuxfoundation.org, akpm@linuxfoundation.org, mpm@selenic.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080704185312.052e7145.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6fcc0a0807041807p24cce461m419d7b54fce72d34@mail.gmail.com>
	 <20080704185312.052e7145.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/5/08, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sat, 5 Jul 2008 05:07:02 +0400 "Alexey Dobriyan" <adobriyan@gmail.com>
> wrote:

>> 3) unstatic struct pagemap_walk, so two threads won't fsckup each other
>>    (including those started by root, including flipping ->mm when you
>> don't have permissions),
>
> Below

Below.

>> 4) remove second ptrace_may_attach(), and
>
> Can't find what you're referring to here.

pagemap_read() contains two calls to ptrace_may_attach(),
second one looks unneeded.

>> 5) check with microscope allocation there -- page-aligned address and size
>> == 0
>>     should allocate 0 bytes, and
>
> Where?

kmalloc() in pagemap_read(). kmalloc(0)  and integer wraparound look possible.

>> 6) actually check that it works.
>
> Will have a shot.

Ha-ha!

> - unstatic struct pagemap_walk, so two threads won't fsckup each other
>   (including those started by root, including flipping ->mm when you don't
>   have permissions)

> --- a/fs/proc/task_mmu.c~pagemap-fixes-to-pagemap_read
> +++ a/fs/proc/task_mmu.c
> @@ -641,6 +636,7 @@ static ssize_t pagemap_read(struct file
>  	struct pagemapread pm;
>  	int pagecount;
>  	int ret = -ESRCH;
> +	static struct mm_walk pagemap_walk;

No, can't have static here, two threads doing pagemap_read() will overwrite
each other's .mm and "out" at least. Like "pm" it shouldn't be global.

It doesn't oops here for unknown reasons, though.

> @@ -684,6 +681,11 @@ static ssize_t pagemap_read(struct file
>  	pm.out = (u64 *)buf;
>  	pm.end = (u64 *)(buf + count);
>
> +	pagemap_walk.pmd_entry = pagemap_pte_range;
> +	pagemap_walk.pte_hole = pagemap_pte_hole;
> +	pagemap_walk.mm = mm;
> +	pagemap_walk.private = &pm;
