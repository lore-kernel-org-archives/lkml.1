Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbYKXUA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbYKXUA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 15:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYKXUAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 15:00:12 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:49870 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbYKXUAL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 15:00:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=yHqB0WHYqtLNbKyaEUFMMz8FBQoGr8GlHzeBm0iRaWf1w5XjxLqPbDNebPMNqYZADe
         UKZV7P25SIGDsQZLVohnQBtNoik/XYsWgdG5xed6c62GU0S5MFIOIslVAyLz1WxpFtLZ
         ZZc6rtxzI6iBKHTD4CuZKC1OwaGiDI8ehUEqE=
Message-ID: <c62985530811241200s5b021463qa93cce1685602fcb@mail.gmail.com>
Date: Mon, 24 Nov 2008 21:00:09 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Arnaldo Carvalho de Melo" <acme@redhat.com>,
       "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: Human readable output for function return tracer
In-Reply-To: <20081124193954.GI26466@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <c62985530811240639w574659c0nd0a54e6c1fb1197a@mail.gmail.com>
	 <20081124181515.GG26466@ghostprotocols.net>
	 <c62985530811241110o32a601ddud0cfc02a9767a7d8@mail.gmail.com>
	 <20081124193954.GI26466@ghostprotocols.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/24 Arnaldo Carvalho de Melo <acme@redhat.com>:
> Em Mon, Nov 24, 2008 at 08:10:47PM +0100, Frédéric Weisbecker escreveu:
>> 2008/11/24 Arnaldo Carvalho de Melo <acme@redhat.com>:
>> > I do something like that in my ctracer tool[1], take a look at one of
>> > the callgraphs:
>> >
>> > http://oops.ghostprotocols.net:81/ostra/dccp/tx/
>>
>>
>> Oh yes, that's what I would see as an end result. Except that it would be more
>> easy for me to have the time of execution on the left (I don't need the time
>> they are called since it's just a cost measure).
>>
>>
>> > I.e. the leaf functions doesn't use {}
>>
>> I guess I could avoid it too..
>>
>>
>> > On ctracer I didn't had this problem as I don't trace all functions,
>> > just the ones that receive as one of its parameters a pointer to the
>> > desired struct, and this pointer is present in all the trace buffer
>> > entries,
>>
>> How do you do this tracing by only passing a structure?
>
> [acme@doppio linux-2.6-x86]$ pfunct --verbose --class=inode fs/ext4/ext4.ko | head
> ext4_fsblk_t ext4_new_blocks(handle_t * handle, struct inode * inode, ext4_lblk_t iblock, ext4_fsblk_t goal, long unsigned int * count, int * errp);
> ext4_fsblk_t ext4_new_meta_blocks(handle_t * handle, struct inode * inode, ext4_fsblk_t goal, long unsigned int * count, int * errp);
> ext4_fsblk_t ext4_new_meta_block(handle_t * handle, struct inode * inode, ext4_fsblk_t goal, int * errp);
> void ext4_free_blocks(handle_t * handle, struct inode * inode, ext4_fsblk_t block, long unsigned int count, int metadata);
> int ext4_check_dir_entry(const char  * function, struct inode * dir, struct ext4_dir_entry_2 * de, struct buffer_head * bh, long unsigned int offset);
> int ext4_release_dir(struct inode * inode, struct file * filp);
> int ext4_release_file(struct inode * inode, struct file * filp);
> void vfs_dq_init(struct inode * inode);
> struct inode * ext4_new_inode(handle_t * handle, struct inode * dir, int mode);
> void ext4_free_inode(handle_t * handle, struct inode * inode);
> [acme@doppio linux-2.6-x86]$
>
> My first attempt at this kind of tracing used a sparse (the kernel
> checker tool uses it too), preprocessing and inserting the calls if,
> looking that the tokens, I found I was at the start of a function source
> code, and, for return tracing I just looke for return calls, inserting
> at each return point, in the source code, the call, that way I could
> even know which one of the returns were taken, and how many times.
>
> Looking at Steven's redefinition of "if", I think we could do the same
> for returns 8)
>
> Then I used the DWARF debug info to find out which functions in the
> objects of interest have as one of its args a pointer to the struct of
> interest, i.e. I find its methods, then write a kernel module
> registering jprobes and kretprobes for the functions I was interested
> in.
>
> Then I moved this to generate a systemtap script.


Ok. I see now...

> Then came the mcount approach, but it lacked return hooks.
>
> Thanks to you I guess now I should rewrite this thing again :-)


:-)

>> > so as part of postprocessing it separates the callgraphs per
>> > object.
>>
>> I would like to separate the callgraph per thread. I'm not sure how. Perhaps
>> by only drawing a simple
>>
>> ------8<----- switch to task nr x -----------8<-------------------
>
> Well, you can record, for each entry, the thread id, but then you will
> not know to what file, say, a close operation relates to.


The pid is registered automatically for each trace that uses the ring-buffer.
This way I will be able to find the files related :-)
