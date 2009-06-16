Return-Path: <linux-kernel-owner+w=401wt.eu-S1759180AbZFPTjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759180AbZFPTjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756632AbZFPTjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:39:31 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:58980 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710AbZFPTja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:39:30 -0400
To: Stefani Seibold <stefani@seibold.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: + procfs-provide-stack-information-for-threads-v08.patch added to -mm tree
References: <200906152202.n5FM25VD021536@imap1.linux-foundation.org>
	<20090615223333.GA8734@x200.localdomain>
	<1245133026.17989.2.camel@wall-e>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 16 Jun 2009 12:39:28 -0700
In-Reply-To: <1245133026.17989.2.camel@wall-e> (Stefani Seibold's message of "Tue\, 16 Jun 2009 08\:17\:06 +0200")
Message-ID: <m1ski03r4f.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: stefani@seibold.net, mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefani Seibold <stefani@seibold.net> writes:

> Am Dienstag, den 16.06.2009, 02:33 +0400 schrieb Alexey Dobriyan:
>> On Mon, Jun 15, 2009 at 03:02:05PM -0700, akpm@linux-foundation.org wrote:
>> >      procfs-provide-stack-information-for-threads-v08.patch
>> > --- a/fs/proc/array.c~procfs-provide-stack-information-for-threads-v08
>> 
>> > +++ a/fs/proc/array.c
>> > @@ -321,6 +321,54 @@ static inline void task_context_switch_c
>> >  			p->nivcsw);
>> >  }
>> >  
>> > +static inline unsigned long get_stack_usage_in_bytes(struct vm_area_struct *vma,
>> > +					struct task_struct *p)
>> > +{
>> > +	unsigned long	i;
>> > +	struct page	*page;
>> > +	unsigned long	stkpage;
>> > +
>> > +	stkpage = KSTK_ESP(p) & PAGE_MASK;
>> > +
>> > +#ifdef CONFIG_STACK_GROWSUP
>> > +	for (i = vma->vm_end; i-PAGE_SIZE > stkpage; i -= PAGE_SIZE) {
>> > +
>> > +		page = follow_page(vma, i-PAGE_SIZE, 0);
>> 
>> How can this work?
>> 
>> If stack page got swapped out, you'll get smaller than actual result.
>> 
>
> If you tell me how to do it in the right way, i can fix it!

You are attempting to answer two questions here.
1) Where do the thread stacks reside.
2) What is the maximum stack space that has been used.

Just listing the thread stacks seems like a small O(1) change.

Computing how much stack space has been used looks trickier.
Perhaps you could map them with MAP_GROWSDOWN?  Of course that
has the problem that you don't stop growing your stack until
it bumps into something else.  Not ideal for a thread stack.

Eric

