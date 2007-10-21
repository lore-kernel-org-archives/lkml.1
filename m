Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbXJUKCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbXJUKCO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 06:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbXJUKCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 06:02:00 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:45842 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751359AbXJUKB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 06:01:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FiTTeRY3EeCCWDuhoRuKvOQvqww9DMZ4rGA8mBt2TEMf0J3pabedpdkZD+z9OM3l3d+5dNXWhzX9Jz5E/HcMJBJtGFBw2HIAf05/4E7rzTCkZOlfnX9dKrlkub+BlpUpyz0wX6JPwp/etXlJ55nHULpD+NWE4BmyDluEMI+4ovg=  ;
X-YMail-OSG: ie6BvRwVM1n18wMo8tSutWCf4e8Geq1uB27tg7GmOXZRmEsZ4Mk_Fz_bc1TQrhDoZvkA2SP5wg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] rd: Use a private inode for backing storage
Date: Sun, 21 Oct 2007 19:56:50 +1000
User-Agent: KMail/1.9.5
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
References: <200710151028.34407.borntraeger@de.ibm.com> <200710210928.58265.borntraeger@de.ibm.com> <m1zlycc1ut.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1zlycc1ut.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710211956.50624.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 October 2007 18:23, Eric W. Biederman wrote:
> Christian Borntraeger <borntraeger@de.ibm.com> writes:

> Let me put it another way.  Looking at /proc/slabinfo I can get
> 37 buffer_heads per page.  I can allocate 10% of memory in
> buffer_heads before we start to reclaim them.  So it requires just
> over 3.7 buffer_heads on very page of low memory to even trigger
> this case.  That is a large 1k filesystem or a weird sized partition,
> that we have written to directly.

On a highmem machine it it could be relatively common.


> > I still dont fully understand what issues you have with my patch.
> > - it obviously fixes the problem
> > - I am not aware of any regression it introduces
> > - its small
>
> My primary issue with your patch is that it continues the saga the
> trying to use buffer cache to store the data which is a serious
> review problem, and clearly not what we want to do long term.

You don't want to change that for a stable patch, however.
It fixes the bug.


> > One concern you had, was the fact that buffer heads are out of sync with
> > struct pages. Testing your first patch revealed that this is actually
> > needed by reiserfs - and maybe others.
> > I can also see, that my patch looks a bit like a bandaid that cobbles the
> > rd pieces together.
> >
> > Is there anything else, that makes my patch unmergeable in your
> > opinion?
>
> For linus's tree the consensus is that to fix rd.c that we
> need to have a backing store that is stored somewhere besides
> in the page cache/buffer cache for /dev/ram0.   Doing that prevents
> all of the weird issues.
>
> Now we have the question of which patch gets us there.  I contend
> I have implemented it with my last little patch that this thread
> is a reply to.  Nick hasn't seen that just yet.

Or ever will. It wasn't that my whole argument against it is
based on that I mistakenly thought your patch served the bdev
inode directly from its backing store.


> So if we have a small patch that can implement the proper long
> term fix I contend we are in better shape.

I just don't think what you have is the proper fix. Calling
into the core vfs and vm because right now it does something
that works for you but is completely unrelated to what you
are conceptually doing is not the right fix.

Also, the patch I posted is big because it did other stuff
with dynamically allocated ramdisks from loop (ie. a modern
rewrite). As it is applied to rd.c and split into chunks, the
actual patch to switch to the new backing store isn't actually
that big. I'll submit it to -mm after things stabilise after
the merge window too.
