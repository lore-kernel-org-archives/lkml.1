Return-Path: <linux-kernel-owner+w=401wt.eu-S1760126AbZEHHum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126AbZEHHum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 03:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759114AbZEHHuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 03:50:16 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:52678 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758287AbZEHHuO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 03:50:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:from:date:x-google-sender-auth
         :message-id:subject:to:cc:content-type:content-transfer-encoding;
        b=A9PcsB7wvG1xGcTeKH9wGwOnZUQ9KP3iS3uQQSuSAjFp8X6/e7RaP5qDMdJ+Uc1a1Z
         82Ybm5PudEJ4NyBjPG6UI35BD3G+wvOFD6Iv8FpMKo/uaJPUzzE05Ac4WGCPGM0FKjqT
         1kPNQg7UjEXS233+TfUrZ0KQ5swiMv1lgg08U=
MIME-Version: 1.0
Reply-To: Hiroyuki.Mach@gmail.com
From: Hiroyuki Machida <Hiroyuki.Mach@gmail.com>
Date: Fri, 8 May 2009 16:49:54 +0900
X-Google-Sender-Auth: 1d02f9df1f758602
Message-ID: <feaf5ed90905080049j78a4ab54x53ce65f22a3ea6a4@mail.gmail.com>
Subject: epoll_create(0) becomes not to fail (Re: issue with epoll system 
	call)
To: rohit verma <rohit.170309@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Verma,

I think your point is right. but descriptions looks not straight forward.
And title of the message is very confusable.
I think descriptions like following would be easy to understand, and
you should attach a your signed-off patch to fix the bug.


Thanks,
Hiro

----

The following patch changed behavior of epoll_create(0);

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9fe5ad9c8cef9ad5873d8ee55d1cf00d9b607df0;hp=e38b36f325153eaadd1c2a7abc5762079233e540


Before applying the patch,
sys_epoll_create2(int size, int flags)
returned -EINVAL,  with size=0;

But,  if-condtion which is introduced in sys_epoll_create() by this patch,
looks to fail to consider case of size==0 as follows;

 asmlinkage long sys_epoll_create(int size)
 {
-       return sys_epoll_create2(size, 0);
+       if (size < 0)
+               return -EINVAL;
+
+       return sys_epoll_create1(0);
 }


---
Hiroyuki Machida



On Thu, May 7, 2009 at 4:10 PM, rohit verma <rohit.170309@gmail.com> wrote:
> hi all,
>
> The man pages of epoll_create says - "Since Linux 2.6.8, the size
> argument is unused.  (The kernel dynamically sizes the required data
> structures without needing this initial hint.)" .
>
> Also, it says that the syscall returns EINVAL , when size is not
> positive. (i.e For, any value greater than 0, the kernel dynamically
> sizes the required data stuctures). When size is zero or less than
> zero, it has to return with error as EINVAL.
>
> the link:  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9fe5ad9c8cef9ad5873d8ee55d1cf00d9b607df0;hp=e38b36f325153eaadd1c2a7abc5762079233e540
>
> shows the latest patch of the epoll syscall. here , the syscall says:
>
> asmlinkage long sys_epoll_create(int size)
> {
> - return sys_epoll_create2(size,0);
> + if (size < 0)
> +  return -EINVAL;
> +
> +return sys_epoll_create1(0);
> }
>
> So if size = 0, it returns success which might not be the expected
> result. So i feel that the condition check should be
> " if (size <= 0) ". could u please check on this and reply me..
>
> Thank you,
>
> Regards,
> rohit
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
