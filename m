Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbYE1VWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbYE1VWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbYE1VWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:22:23 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:62733 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbYE1VWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:22:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UeLQ+Uho/oIOaDZoZdPQ+oZTudngnk5ZDvEm1ku0hyZuQBvJAWsiPFkrOwPhX2smaXt226ij8l0EjrJc/sV6+TgonyevvLPu/BmlnaF1fmL6MBOa6H7nAYURishN5X75VdQJgQF9UmaxIWxt9ad+xQ+xs04lMmxBFtZCxI2ljVg=
Message-ID: <d8d698ae0805281422i212ef0c3ocd8b28ccd9e0b70d@mail.gmail.com>
Date: Wed, 28 May 2008 18:22:20 -0300
From: "Fausto Richetti Blanco" <fausto.blanco@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Pipe buffers' limit of 16 * 4K
Cc: riel@redhat.com, fausto.blanco@gmail.com
In-Reply-To: <d8d698ae0805261043u125b653ve73d067cd92caa16@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d8d698ae0805231255i4d0da724p68cb2b9376134797@mail.gmail.com>
	 <d8d698ae0805231719g4202edf2k947bba4128385ab6@mail.gmail.com>
	 <20080523205630.444fe2b9@bree.surriel.com>
	 <d8d698ae0805261043u125b653ve73d067cd92caa16@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think you did not receive it so I'm sending again....

On Mon, May 26, 2008 at 2:43 PM, Fausto Richetti Blanco
<fausto.blanco@gmail.com> wrote:
> Hi Rik,
>
>    I'll try to explain my problem...
>
>    Well, we have a cgi which uses a lib. This lib is used by a lot of
> other systems and we don't want to change it nor create a specific
> version of the lib to solve our problem. The webserver passes the post
> content to the cgi via stdin which, in this case, is a pipe.
>
>    Our problem is that our application must look at the post content
> (ie.: by reading stdin and, consequently, removing its content from
> the pipe buffer), take some decisions and then call the lib. The lib
> itself will also look at the stdin and here is the problem: since our
> application had already consumed the input content, we must restore it
> in order to the lib to be able to read it again.
>
>    We can't write to stdin because we only have access to the 'read
> side' of the pipe. The way we find to circumvent this is by creating
> another pipe. So, our application reads the stdin and saves its
> content in a buffer. To restore the stdin, we are doing this:
>
>        void restore_input(void){
>                int filedes[2];
>                pipe(filedes);
>                write(filedes[1], newstdin, stdbuffsz); // *1
>                close(filedes[1]);
>                close(STDIN_FILENO);
>                dup2(filedes[0], STDIN_FILENO);
>                close(filedes[0]);
>        }
>        //  *1 newstdin is the buffer we have saved the input
>
>    So, we can:
>        read_input_and_save_it()
>        take_our_decisions()
>        restore_input()
>        call_the_lib()
>
>    It works very well, except when the input has more than 4K (or 16
> * 4K in more recent kernels) because the restore_input() blocks at
> this limit.
>
>    I kwow there are other solutions to my problem (e.g: using a
> thread, moving our decisions to the lib, etc...) by I'm wondering if
> making the pipe buffers' limit adjustable is not a good idea. Maybe it
> should be helpful for another things too (like Jan Engelhardt said in
> his email).
>
>    In fact, I didn't find any way of restoring the input (with the
> input being the 'read side' of a pipe) other than using pipes. That's
> because I've decided to ask this in the linux-kernel list. Is there a
> reason for this limit not to be an adjustable parameter ?
>
>    Thanks in advance,
>
>          Fausto Richetti Blanco
>
> On Fri, May 23, 2008 at 9:56 PM, Rik van Riel <riel@redhat.com> wrote:
>> On Fri, 23 May 2008 21:19:13 -0300
>> "Fausto Richetti Blanco" <fausto.blanco@gmail.com> wrote:
>>
>>> Hello guys,
>>>
>>>        I'm working with a 2.6.9 kernel (ok, I know it's quite old) and
>>> faced a problem with the 4K (one page) buffer limit for the pipes.
>>> I've found that in the 2.6.11 the pipes' buffers were changed to a
>>> circular list of pages which increased this limit to 16 * 4K. This
>>> limit is hardcoded here /usr/src/linux/include/linux/pipe_fs_i.h:6
>>> #define PIPE_BUFFERS (16)
>>>
>>>        Is there a reason for this not to be an adjustable parameter
>>> (eg.: by an ulimit in the userspace) ?
>>
>> What is the problem you found?
>>
>> Why do you need to change the limit from 16?
>>
>> Did it bring you any performance enhancements?
>>
>> If so, how much?
>>
>> --
>> All rights reversed.
>>
>
