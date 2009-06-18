Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbZFRFll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbZFRFll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 01:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbZFRFld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 01:41:33 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45940 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbZFRFlc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 01:41:32 -0400
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Tao Ma <tao.ma@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [Patch BUGFIX] kcore: fix its wrong size on x86_64
References: <2375c9f90906081743p77934f47n8ba1a018d333b95b@mail.gmail.com>
	<m1ab4i11zx.fsf@fess.ebiederm.org>
	<20090611050929.GA2706@cr0.nay.redhat.com>
	<m11vpqvozl.fsf@fess.ebiederm.org> <20090613040958.GA2959@cr0>
	<m17hzdhkr8.fsf@fess.ebiederm.org>
	<2375c9f90906160829g3d605836yb4c5b9beeac50c5f@mail.gmail.com>
	<m1my88568n.fsf@fess.ebiederm.org>
	<20090618030051.GA6133@cr0.nay.redhat.com>
	<m1tz2ei54r.fsf@fess.ebiederm.org>
	<20090618044055.GB6133@cr0.nay.redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 17 Jun 2009 22:41:32 -0700
In-Reply-To: <20090618044055.GB6133@cr0.nay.redhat.com> (Amerigo Wang's message of "Thu\, 18 Jun 2009 12\:40\:55 +0800")
Message-ID: <m1prd2rtdf.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: xiyou.wangcong@gmail.com, adobriyan@gmail.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tao.ma@oracle.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <xiyou.wangcong@gmail.com> writes:

> On Wed, Jun 17, 2009 at 08:37:40PM -0700, Eric W. Biederman wrote:
>>Amerigo Wang <xiyou.wangcong@gmail.com> writes:
>>
>>> On Tue, Jun 16, 2009 at 12:27:36PM -0700, Eric W. Biederman wrote:
>>>>Américo Wang <xiyou.wangcong@gmail.com> writes:
>>>>>> I think a case can be made either way.  In practice neither answer
>>>>>> gives us a dense offset space on x86_64 so I think I prefer the
>>>>>> current definition which sets or clears the high bits as opposed
>>>>>> to something that mangles the address more.
>>>>>>
>>>>>
>>>>> I am trying to dig more... There must be something wrong there.
>>>>
>>>>How so?
>>>
>>> See what you will get for kc_vaddr_to_offset(__va(0))?
>>> It is supposed to be 0.
>>
>>I see: 0x0000880000001000  That extra 0x1000 looks suspicous.
>
>
> huh? 0x0000880000000000 not?
>
>>
>>It MUST NOT be 0. That is where the ELF header lives in the file.
>
> Of course I knew this.
>
> Just read the code:
>
>      phdr->p_offset = kc_vaddr_to_offset(m->addr) + dataoff;
>
> So it should be 0, 'dataoff' is there...

Sorry.  The naming then is horrible.  It is really
kc_vaddr_to_something_like_the_offset.

I still don't see the need for a flat offset space.

I can see a real point of only having a single kc_vaddr_to_offset
function.  Instead of the 3 in existence.

No point in cluttering the whole world with the oddities of the kcore
code.  Especially when it should get cleaned up.

My real point earlier is that kc_vaddr_to_offset and
kc_offset_to_vaddr actually on x86_64 aren't broken.  They are just
peculiar.  There is some small point to their oddities, in that if
something is in the upper half of the address space (like xen) but
below PAGE_OFFSET you have a chance of accessing it with /proc/kcore.
But that is a very minor benefit.

Eric


