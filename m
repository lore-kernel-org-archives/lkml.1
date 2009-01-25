Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbZAYDk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbZAYDk5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 22:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbZAYDkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 22:40:49 -0500
Received: from smtp-out.google.com ([216.239.45.13]:8489 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303AbZAYDks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 22:40:48 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=WDIYO58Yl+tj7ABYT8s8S+S1jDF4IU0Fq7iWWD5EIWZ44WzGVl0bf2qJSM/PKroxF
	kfSggSfA6VyU5QuQ4P9wA==
MIME-Version: 1.0
In-Reply-To: <20090124181924.d633523c.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0901162229420.12858@kitami.corp.google.com>
	 <20090124181924.d633523c.akpm@linux-foundation.org>
Date: Sat, 24 Jan 2009 19:40:41 -0800
Message-ID: <ed628a920901241940k44bda080je94471c1dd802a73@mail.gmail.com>
Subject: Re: Migration of kernel interfaces to seq_files breaks pread() 
	consumers
From: Paul Turner <pjt@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.24.198.88
X-GMailtapped: pjt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2009 at 6:19 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 16 Jan 2009 23:51:35 -0800 (PST) Paul Turner <pjt@google.com> wrote:
>
>>
>> (Specifically) Several interfaces under /proc have been migrated to use
>> seq_files.  This was previously observed to be a problem with VMware's
>> reading of /proc/uptime.  We're now running into the same problem on
>> /proc/<pid>/stat; we have many consumers performing preads on this
>> interface which break under new kernels.
>>
>> Reverting these migrations presents other problems and doesn't scale with
>> everyones' pet dependencies over an abi that's been
>> broken :(
>
> We changed userspace-visible behaviour and broke real applications.
> This is a serious matter.  So serious in fact that your report has
> languished without reply for a week.
>
> Reverting those changes until we have a suitable reimplementation which
> doesn't bust userspace is 100% justifiable.
>
> In which kernel versions is this regression present?

Commit is ee992744ea53db0a90c986fd0a70fbbf91e7f8bd, merged with 2.6.25

>
> What would a revert look like?  Big and ugly or small and simple?  Do
> the original commits (which were they?) still revert OK?
>

There is a race on namespaces that would have to be resolved.  From commit:
"... Currently (as pointed out by Oleg) do_task_stat has a race when calling
   task_pid_nr_ns with the task exiting.  In addition do_task_stat is not
   currently displaying information in the context of the pid namespace that
   mounted the /proc filesystem.  So "cut -d' ' -f 1 /proc/<pid>/stat" may not
   equal <pid>. ..."


>> Part of the problem in implementing pread in seq_files is that we don't
>> know know whether the read was issued by pread(2) or read(2).  It's not
>> nice to shoehorn this information down the stack.  I've attached a
>> skeleton patch which shows one way we could push it up (although something
>> like a second f_pos would be necessary to make it maintain pread
>> semantics against reads).
>>
>> One advantage of this style of approach is that it doesn't break on
>> partial record reads.  But it's a little gross at the same time.
>>
>
> Yes, that is a bit gross.
>
> Does this patch actually 100% solve the problem, or is it a precursor
> to some other fix or what?  It's hard to comment sensibly if it's a
> partial thing with no sign how it will be used.
>

It's not fully robust, the case of two simultaneous preaders on the
same fd isn't something I have any nice answer for given the nature of
seq_files.

Apart from that, as long as we maintain a separate f_pos for the
preads it should be ok.

>> diff --git a/fs/read_write.c b/fs/read_write.c
>> index 2fc2980..744094a 100644
>> --- a/fs/read_write.c
>> +++ b/fs/read_write.c
>> @@ -407,6 +407,16 @@ asmlinkage ssize_t sys_pread64(unsigned int fd, char __user *buf,
>>               ret = -ESPIPE;
>>               if (file->f_mode & FMODE_PREAD)
>>                       ret = vfs_read(file, buf, count, &pos);
>> +             else if (file->f_mode & FMODE_SEQ_FILE) {
>> +                     /*
>> +                      * We break the pread semantic and actually make it
>> +                      * seek, this prevents inconsistent record reads across
>> +                      * boundaries.
>> +                      */
>> +                     vfs_llseek(file, pos, SEEK_SET);
>> +                     ret = vfs_read(file, buf, count, &pos);
>> +                     file_pos_write(file, pos);
>> +             }
>
> Well yes, that's a userspace-visible wrong change too.

Yes -- I mentioned above that to make this into a 'real' patch and
remain not perturb reads we'd need to maintain a second file position
for the preader

But this is getting farther up the ugly tree, I was hoping someone
else might have a more palatable idea :)

>
>>               fput_light(file, fput_needed);
>>       }
>>
>> diff --git a/fs/seq_file.c b/fs/seq_file.c
>> index 3f54dbd..f8c5379 100644
>> --- a/fs/seq_file.c
>> +++ b/fs/seq_file.c
>> @@ -50,6 +50,8 @@ int seq_open(struct file *file, const struct seq_operations *op)
>>
>>       /* SEQ files support lseek, but not pread/pwrite */
>>       file->f_mode &= ~(FMODE_PREAD | FMODE_PWRITE);
>> +     file->f_mode |= FMODE_SEQ_FILE;
>> +
>>       return 0;
>>  }
>>  EXPORT_SYMBOL(seq_open);
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 5f7b912..c3b5916 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -76,6 +76,8 @@ extern int dir_notify_enable;
>>     behavior for cross-node execution/opening_for_writing of files */
>>  #define FMODE_EXEC   16
>>
>> +#define FMODE_SEQ_FILE_PREAD 32
>
> -EWONTCOMPILE, btw.
>
