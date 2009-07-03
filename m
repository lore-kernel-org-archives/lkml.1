Return-Path: <linux-kernel-owner+w=401wt.eu-S1755629AbZGCAno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbZGCAno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 20:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbZGCAnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 20:43:37 -0400
Received: from mail-vw0-f202.google.com ([209.85.212.202]:34214 "EHLO
	mail-vw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbZGCAng convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 20:43:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XdM1hjnSHC7MgWY5VF5qKqmrgMDh0/Da9YuU2L0jjhjdFRWlDyJXYhkDKeae0vmuGp
         2XH7hf5uLz+C7sTgpmN4tFMrILV/rhgnxTQG7BNWHighTiF0EtEP7DqB7yovpVnqz0eg
         uVE1kqK9YuQQWHx7c5W+JG+nCypYVmQ314j+I=
MIME-Version: 1.0
In-Reply-To: <20090702102138.GF6372@cr0.nay.redhat.com>
References: <412e6f7f0907020036y76abbc7du99c7b695f725be4@mail.gmail.com>
	 <20090702091309.GB6372@cr0.nay.redhat.com>
	 <412e6f7f0907020218m1f4a9651l2c682a9905925bcd@mail.gmail.com>
	 <20090702094620.GE6372@cr0.nay.redhat.com>
	 <412e6f7f0907020304u166b6d17id1bcf5d334b45c53@mail.gmail.com>
	 <20090702102138.GF6372@cr0.nay.redhat.com>
Date: Fri, 3 Jul 2009 08:43:39 +0800
Message-ID: <412e6f7f0907021743m6ed8ae10uecd13c4fc4ec7cbb@mail.gmail.com>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
From: Changli Gao <xiaosuo@gmail.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 6:21 PM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
> On Thu, Jul 02, 2009 at 06:04:02PM +0800, Changli Gao wrote:
>>On Thu, Jul 2, 2009 at 5:46 PM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
>>>>Are you familiar with splice() and tee()? They both use pipes as kernel buffers.
>>>
>>> You are not answering the question, obviously.
>>When you use pipes as kernel buffer handlers, two fd isn't necessary.
>>Using one will save half of fd resources. Is it obviously?
>
> Not really.. I can't see any reason why you use this method to save
> fd's... pick read(2)/write(2).
In order to use splice, you must have pipe first. The common code is:

int fd[2];

pipe(fd);
splice(infd, NULL, fd[1], NULL, getpagesize(), SPLICE_F_MOVE);
splice(fd[0], NULL, outfd, NULL, getpagesize(), SPLICE_F_MOVE);
close(fd[0]);
close(fd[1]);

if pipe supports NULL argument, and returnes a RW pipe fd in that
case, the code will become:

int fd;

fd = pipe(NULL);
splice(infd, NULL, fd, NULL, getpagesize(), SPLICE_F_MOVE);
splice(fd, NULL, outfd, NULL, getpagesize(), SPLICE_F_MOVE);
close(fd);

One fd is saved.

>
>>
>>>
>>> And you snipped too much, how can you return that fd? Using the return value?
>>one RW file descriptor is returned. I have answered this in the first post.
>
> No, you never say *how* it is returned.
return value. save in %eax in i386.

>
>>
>>> Ah! This will probably break the user-space program...
>>>
>>I don't think so. As a skillful programmer, who will trasfter pipe() a
>>NULL pointer? In any way, it is break sth, but not very seriously, and
>>won't affact any right and robust program.
>
> Huh? Isn't the code sample below too common?
>
> if (pipe(...))
>   perror("pipe");
>
> Currently pipe(2) can make sure this is robust.
>
> You are trying to break it...
>

It depends on the argument for pipe, if the argument is NULL, it
breaks the code above.



-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
