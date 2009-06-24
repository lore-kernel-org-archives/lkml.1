Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbZFXHgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbZFXHgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZFXHf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:35:57 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47083 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbZFXHf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:35:56 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stefani Seibold <stefani@seibold.net>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
References: <200906182243.n5IMhwuV003008@imap1.linux-foundation.org>
	<1245824444.22613.3.camel@wall-e>
	<20090623233247.7ed661b7.akpm@linux-foundation.org>
	<1245825903.23818.4.camel@wall-e>
	<20090624001302.18de9e21.akpm@linux-foundation.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 24 Jun 2009 00:35:52 -0700
In-Reply-To: <20090624001302.18de9e21.akpm@linux-foundation.org> (Andrew Morton's message of "Wed\, 24 Jun 2009 00\:13\:02 -0700")
Message-ID: <m1my7ykrs7.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, adobriyan@gmail.com, stefani@seibold.net
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [merged] proctxt-update-kernel-filesystem-proctxt-documentation.patch removed from -mm tree
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 24 Jun 2009 08:45:03 +0200 Stefani Seibold <stefani@seibold.net> wrote:
>
>> Am Dienstag, den 23.06.2009, 23:32 -0700 schrieb Andrew Morton:
>> > On Wed, 24 Jun 2009 08:20:44 +0200 Stefani Seibold <stefani@seibold.net> wrote:
>> > 
>> > > what is with the associated
>> > > procfs-provide-stack-information-for-threads-v08.patch
>> > > patch?
>> > > 
>> > > There was no real objections against this patch, so why not merge it for
>> > > 2.6.31?
>> > 
>> > Alexey pointed out that it doesn't actually work.
>> 
>> That is not true... it works. With my patch the kernel does exactly know
>> where the thread stack is and therefor it is easy to determinate the
>> associated map.

Usually yes, but not in all cases.


> On Tue, 16 Jun 2009 02:33:33 +0400 Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
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
>
> Alexey's point is that follow_page() will return NULL if it hits a
> swapped-out stack page and the loop will exit, leading to an incorrect
> (ie: short) return value from get_stack_usage_in_bytes().
>
> Is this claim wrong?


Add to that the code is unnecessarily complicated.

The patch mixes several different changes together.  It deserves being
broken up into at least two patches.

I am concerned about the performance.  Glibc opens /proc/self/maps in
practically every application so doing something like following page
tables requires testing and verifying the performance.

Eric
