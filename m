Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbZEMA7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbZEMA7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbZEMA6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:58:48 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:11207 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbZEMA6r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:58:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=pmX7xUP2B5ZnYsBN51uLfITOx72xPN0TDRSq0qTnSfhaKaVn/qwPZx1VvcJVznvR66
         dXPxbOCy6cj6xDUwCv/mP38vIIkHwkxAHyT0qWYOl5XPAe0LGUw3D0KnfpIb6cpZNcay
         P/9p/rQ5N4Vqzs7rDYiGp74Vh3NgQpK2UxgOU=
MIME-Version: 1.0
Reply-To: Hiroyuki.Mach@gmail.com
In-Reply-To: <d51f89b0905112354k566d6de9lad4351d1ebc71759@mail.gmail.com>
References: <feaf5ed90905080049j78a4ab54x53ce65f22a3ea6a4@mail.gmail.com> 
	<d51f89b0905112354k566d6de9lad4351d1ebc71759@mail.gmail.com>
From: Hiroyuki Machida <Hiroyuki.Mach@gmail.com>
Date: Wed, 13 May 2009 09:58:27 +0900
X-Google-Sender-Auth: 6082e521dae5c381
Message-ID: <feaf5ed90905121758o161c204dncafa46cebdd9c24b@mail.gmail.com>
Subject: Re: epoll_create(0) becomes not to fail (Re: issue with epoll system 
	call)
To: rohit verma <rohit.170309@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
I think it's better to read, before submitting report/patch

http://kernelnewbies.org/FoundBug
http://kernelnewbies.org/UpstreamMerge/SubmittingPatches

----
Hiroyuki Machida



On Tue, May 12, 2009 at 3:54 PM, rohit verma <rohit.170309@gmail.com> wrote:
> hi,
>
> I have created a patch for epoll_create syscall as shown below. Plz
> have a check and
> get back to me.
>
> diff a/fs/eventpoll.c   b/fs/eventpoll.c
>
>
>
> --- eventpoll_orig.c    2009-05-12 12:07:27.000000000 +0530
> +++ eventpoll.c 2009-05-12 12:10:14.000000000 +0530
> @@ -1136,7 +1136,7 @@
>  SYSCALL_DEFINE1(epoll_create, int, size)
>  {
> -       if (size < 0)
> +       if (size <= 0)
>                 return -EINVAL;
>         return sys_epoll_create1(0);
>
>
>
> Since there might be some formatting problems, i'm also attaching the
> patch in this
> mail.
>
> Regards,
> Rohit
>
>
>
> On Fri, May 8, 2009 at 1:19 PM, Hiroyuki Machida
> <Hiroyuki.Mach@gmail.com> wrote:
>>
>> Hi  Verma,
>>
>> I think your point is right. but descriptions looks not straight forward.
>> And title of the message is very confusable.
>> I think descriptions like following would be easy to understand, and
>> you should attach a your signed-off patch to fix the bug.
>>
>>
>> Thanks,
>> Hiro
>>
>> ----
>>
>> The following patch changed behavior of epoll_create(0);
>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9fe5ad9c8cef9ad5873d8ee55d1cf00d9b607df0;hp=e38b36f325153eaadd1c2a7abc5762079233e540
>>
>>
>> Before applying the patch,
>> sys_epoll_create2(int size, int flags)
>> returned -EINVAL,  with size=0;
>>
>> But,  if-condtion which is introduced in sys_epoll_create() by this patch,
>> looks to fail to consider case of size==0 as follows;
>>
>>  asmlinkage long sys_epoll_create(int size)
>>  {
>> -       return sys_epoll_create2(size, 0);
>> +       if (size < 0)
>> +               return -EINVAL;
>> +
>> +       return sys_epoll_create1(0);
>>  }
>>
>>
>> ---
>> Hiroyuki Machida
>>
>>
>>
>> On Thu, May 7, 2009 at 4:10 PM, rohit verma <rohit.170309@gmail.com> wrote:
>> > hi all,
>> >
>> > The man pages of epoll_create says - "Since Linux 2.6.8, the size
>> > argument is unused.  (The kernel dynamically sizes the required data
>> > structures without needing this initial hint.)" .
>> >
>> > Also, it says that the syscall returns EINVAL , when size is not
>> > positive. (i.e For, any value greater than 0, the kernel dynamically
>> > sizes the required data stuctures). When size is zero or less than
>> > zero, it has to return with error as EINVAL.
>> >
>> > the link:  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9fe5ad9c8cef9ad5873d8ee55d1cf00d9b607df0;hp=e38b36f325153eaadd1c2a7abc5762079233e540
>> >
>> > shows the latest patch of the epoll syscall. here , the syscall says:
>> >
>> > asmlinkage long sys_epoll_create(int size)
>> > {
>> > - return sys_epoll_create2(size,0);
>> > + if (size < 0)
>> > +  return -EINVAL;
>> > +
>> > +return sys_epoll_create1(0);
>> > }
>> >
>> > So if size = 0, it returns success which might not be the expected
>> > result. So i feel that the condition check should be
>> > " if (size <= 0) ". could u please check on this and reply me..
>> >
>> > Thank you,
>> >
>> > Regards,
>> > rohit
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>> >
>
