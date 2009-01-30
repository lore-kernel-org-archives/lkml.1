Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbZA3GKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbZA3GKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 01:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZA3GKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 01:10:06 -0500
Received: from smtp-out.google.com ([216.239.33.17]:57257 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbZA3GKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 01:10:04 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=jgL5189TWAOnVORthzUIuZHFSjBgtSsYoF0kcCGr4GIeazq4iQZt0ov8scsaAbkwl
	D69rmzmPsyrGwdddCoSAw==
MIME-Version: 1.0
In-Reply-To: <m1bptp8pkk.fsf@fess.ebiederm.org>
References: <Pine.LNX.4.64.0901162229420.12858@kitami.corp.google.com>
	 <20090124181924.d633523c.akpm@linux-foundation.org>
	 <20090125120818.GA4454@x200.localdomain>
	 <m1r62obev3.fsf@fess.ebiederm.org>
	 <Pine.LNX.4.64.0901291719520.26444@kitami.corp.google.com>
	 <m1bptp8pkk.fsf@fess.ebiederm.org>
Date: Thu, 29 Jan 2009 22:09:55 -0800
Message-ID: <ed628a920901292209y4df66fabk26942422a135af0a@mail.gmail.com>
Subject: Re: Migration of kernel interfaces to seq_files breaks pread() 
	consumers
From: Paul Turner <pjt@google.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.18
X-GMailtapped: pjt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 7:01 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Paul Turner <pjt@google.com> writes:
>>
>> Thanks Eric,
>>
>> Moving the position into the seq_file structure is much cleaner.  Basic
>> tests seem to work ok.
>
> Thanks.
>
>> Few comments:
>> - seq_open needs its fmode opened up to take advantage of this [patch
>> below]
>
> Good point.
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
>
>> - There's still the inherent problem of reads peturbing other reads (both
>> read and pread).  Our applications should be ok with this, however it does
>> deviate from the supposedly thread-safe pread semantics.
>
> I don't see this not being thread safe.
>
> If the data that is returned is stable.  We should not see anything
> changing.  Otherwise it is all bets are off in any case.
>

With just reads you had stability on the record level at least.
Concurrent reads/seeks on a file made it obvious where things weren't
thread safe.

Obviously userspace doing stupid things isn't a kernel problem but it
could become one in the future if a previously safe concurrent pread
interface is migrated to use seqfile.

> Because seq_read happens under m->lock I don't see how there will
> be anything thread unsafe.
>
> The position that changes is just an internal implementation detail to
> keep track of which data that we have cached.

I'm only referring to unstable records since every time we seek we
trash the cache.

>
>>
>> - Paul
>>
>> ---
>>  fs/seq_file.c |    2 --
>>  1 files changed, 0 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/seq_file.c b/fs/seq_file.c
>> index cd63d69..aa3621f 100644
>> --- a/fs/seq_file.c
>> +++ b/fs/seq_file.c
>> @@ -48,8 +48,6 @@ int seq_open(struct file *file, const struct seq_operations
>> *op)
>>        */
>>       file->f_version = 0;
>>
>> -     /* SEQ files support lseek, but not pread/pwrite */
>> -     file->f_mode &= ~(FMODE_PREAD | FMODE_PWRITE);
>>       return 0;
>>  }
>>  EXPORT_SYMBOL(seq_open);
>> --
>> 1.5.4.5
>
