Return-Path: <linux-kernel-owner+w=401wt.eu-S1753072AbZHCJIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbZHCJIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 05:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbZHCJIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 05:08:09 -0400
Received: from mail-px0-f201.google.com ([209.85.216.201]:41444 "EHLO
	mail-px0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbZHCJII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 05:08:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=CV2G5p2li9BmvGTUk37O6ar1glzRKaqg1ogdo83iN+kq/UfY0fZ+PzP8iLE9o7NuOz
         fa0ABU8XpHQHK12Bki2wk4kW0TC7kV3XjhNbyjOLbB9Rkz2YHWInx+RUW5xKfS1xdsek
         uk/vgeMG/0KcLgdYZeMPy4ZrEIdnqyQtCr+Jo=
Date: Mon, 3 Aug 2009 17:10:19 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, Mike Smith <scgtrp@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][PATCH 1/3] fix vread/vwrite to be aware of memory hole
Message-ID: <20090803091019.GC6016@cr0.nay.redhat.com>
References: <bug-13850-10286@http.bugzilla.kernel.org/> <20090728160527.1da52682.akpm@linux-foundation.org> <20090729084825.1363c880.kamezawa.hiroyu@jp.fujitsu.com> <525c5a6c0907281946t249ef288v77ee94edd16f054@mail.gmail.com> <20090729123209.690baa48.kamezawa.hiroyu@jp.fujitsu.com> <20090731160748.279845da.kamezawa.hiroyu@jp.fujitsu.com> <20090731161128.347216e6.kamezawa.hiroyu@jp.fujitsu.com> <20090731095705.GD5048@cr0.nay.redhat.com> <65d1a0e3dc0e5fa357f392f0552b4519.squirrel@webmail-b.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <65d1a0e3dc0e5fa357f392f0552b4519.squirrel@webmail-b.css.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 07:32:15PM +0900, KAMEZAWA Hiroyuki wrote:
>Amerigo Wang さんは書きました：
>> On Fri, Jul 31, 2009 at 04:11:28PM +0900, KAMEZAWA Hiroyuki wrote:
>>>From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>>
>>>vread/vwrite access vmalloc area without checking there is a page or not.
>>>
>>>In old ages, the caller of get_vm_ara() is only IOREMAP and there is no
>>>memory hole within vm_struct's [addr...addr + size - PAGE_SIZE]
>>>( -PAGE_SIZE is for a guard page.)
>>>
>>>After per-cpu-alloc patch, it uses get_vm_area() for reserve continuous
>>>virtual address but remap _later_. There tend to be a hole in valid
>>> vmalloc
>>>area in vm_struct lists.
>>>Then, skip the hole (not mapped page) is necessary.
>>>This patch updates vread/vwrite() for avoiding memory hole.
>>>
>>>Routines which access vmalloc area without knowing for which addr is used
>>>are
>>>  - /proc/kcore
>>>  - /dev/kmem
>>>
>>>kcore checks IOREMAP, /dev/kmem doesn't. After this patch, IOREMAP is
>>>checked and /dev/kmem will avoid to read/write it.
>>>Fixes to /proc/kcore will be in the next patch in series.
>>>
>>>And, this itself fixes the bug as
>>># dd if=/dev/kmem of=/dev/null bs=1024 count=1048576 skip=3145728
>>>can cause panic.
>>
>>
>> What panic? :-) Would you mind to put it here?
>>
>It directly reboot ;( and no log.
>plz try.


I tried it on an x86_64 machine, no panic, just:

 dd: reading `/dev/kmem': Bad address

Only appears on i386? :)

>>>-	return buf - buf_start;
>>>+
>>>+	if (buf == buf_start)
>>>+		return 0;
>>>+	/* zero-fill memory holes */
>>>+	if (buf != buf_start + buflen)
>>>+		memset(buf, 0, buflen - (buf - buf_start));
>>
>>
>> Is this necessary?
>>
>I wrote "filled by zero" and thinks it's sane, then does this.
>Now, /proc/kcore allocates memory by kzalloc(), this is redundant.
>/dev/kmem doesn't do that.

OK.


>ouch..
>
>Thank you for review.
>I'm sorry that new version will not appear until next week.
>I can't access x86-32 in the weekend.

No problem, feel free to do it at any time that is convinient
for you.

Thanks.

