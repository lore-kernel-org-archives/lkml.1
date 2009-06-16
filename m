Return-Path: <linux-kernel-owner+w=401wt.eu-S1761726AbZFPT1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761726AbZFPT1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761436AbZFPT1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:27:38 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57379 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761725AbZFPT1g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:27:36 -0400
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Tao Ma <tao.ma@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [Patch BUGFIX] kcore: fix its wrong size on x86_64
References: <4A2A7F33.4030807@oracle.com> <4A2CA96D.3090502@oracle.com>
	<2375c9f90906072341o2cded749m45bdddfdb499469@mail.gmail.com>
	<4A2CC52B.9010602@oracle.com>
	<2375c9f90906081743p77934f47n8ba1a018d333b95b@mail.gmail.com>
	<m1ab4i11zx.fsf@fess.ebiederm.org>
	<20090611050929.GA2706@cr0.nay.redhat.com>
	<m11vpqvozl.fsf@fess.ebiederm.org> <20090613040958.GA2959@cr0>
	<m17hzdhkr8.fsf@fess.ebiederm.org>
	<2375c9f90906160829g3d605836yb4c5b9beeac50c5f@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 16 Jun 2009 12:27:36 -0700
In-Reply-To: <2375c9f90906160829g3d605836yb4c5b9beeac50c5f@mail.gmail.com>
 (=?utf-8?Q?=22Am=C3=A9rico?= Wang"'s message of "Tue\, 16 Jun 2009
 23\:29\:18 +0800")
Message-ID: <m1my88568n.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: xiyou.wangcong@gmail.com, adobriyan@gmail.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tao.ma@oracle.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang <xiyou.wangcong@gmail.com> writes:

> On Mon, Jun 15, 2009 at 6:08 PM, Eric W. Biederman<ebiederm@xmission.com> wrote:
>> Amerigo Wang <xiyou.wangcong@gmail.com> writes:
>>
>>> Fix wrong /proc/kcore size on x86_64.
>>>
>>> x86_64 uses __va() macro to caculate the virtual address passed to kclist_add()
>>> but decodes it with its own macro kc_vadd_to_offset(). This is wrong.
>>
>> Ok.  I finally understand what is going on here, and no kc_vaddr_to_offset
>> is not wrong when applied to a virtual address.  In fact I expect the current
>> definition makes things a bit more predictable.
>>
>> And yes kclist_add is must be given a virtual address
>>
>>> Also, according to Documentation/x86/x86_64/mm.txt, kc_vaddr_to_offset()
>>> is wrong too.
>>
>> How so?  The file offset is a number space that is different from both
>> physical and virtual addresses.
>
> Why? They _do_ have some calculated relations.

Sure.  The offset is what you give to read/write.  The virtual
addresses are what the kernel uses.  In general in a core file they
are only tied together with the elf header.   We do something a little
more pragmatic in the kernel.

>>> So just remove them, use the generic macro.
>>
>> I think a case can be made either way.  In practice neither answer
>> gives us a dense offset space on x86_64 so I think I prefer the
>> current definition which sets or clears the high bits as opposed
>> to something that mangles the address more.
>>
>
> I am trying to dig more... There must be something wrong there.

How so?

>> It uses get_kcore_size and (size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
>> The second definition being bogus as it has nothing to do with which
>> offsets are accepted.
>
> Agreed. Maybe we can just remove the second one and update the doc?

Yes.  It isn't critical but reducing confusion is good.
Do you want to cook up the patch for that?

Eric
