Return-Path: <linux-kernel-owner+w=401wt.eu-S1757697AbZELGzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697AbZELGzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 02:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbZELGy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 02:54:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:24430 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785AbZELGy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 02:54:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pzZTrorlRTfw3+7lXR9p3ZSZQ9B9oSiIg/Ut1UC2OBmgfuHl/BM1Qh51VuQvAa+la0
         9j+H25HFpqwscPXE9Ut7mKmIm5QyxiHpeuUHGcjXmjBYAXk/e3Cn5KAsYiwRru/vquxR
         j/eKUgaMNOqBbg5clIbCVQNLmGTQdNNv4tXuw=
MIME-Version: 1.0
In-Reply-To: <feaf5ed90905080049j78a4ab54x53ce65f22a3ea6a4@mail.gmail.com>
References: <feaf5ed90905080049j78a4ab54x53ce65f22a3ea6a4@mail.gmail.com>
Date: Tue, 12 May 2009 12:24:55 +0530
Message-ID: <d51f89b0905112354k566d6de9lad4351d1ebc71759@mail.gmail.com>
Subject: Re: epoll_create(0) becomes not to fail (Re: issue with epoll system 
	call)
From: rohit verma <rohit.170309@gmail.com>
To: Hiroyuki.Mach@gmail.com
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0cd29ac28513f00469b192a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd29ac28513f00469b192a4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

hi,

I have created a patch for epoll_create syscall as shown below. Plz
have a check and
get back to me.

diff a/fs/eventpoll.c=A0=A0 b/fs/eventpoll.c



--- eventpoll_orig.c=A0=A0=A0 2009-05-12 12:07:27.000000000 +0530
+++ eventpoll.c 2009-05-12 12:10:14.000000000 +0530
@@ -1136,7 +1136,7 @@
=A0SYSCALL_DEFINE1(epoll_create, int, size)
=A0{
-=A0=A0=A0=A0=A0=A0 if (size < 0)
+=A0=A0=A0=A0=A0=A0 if (size <=3D 0)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
=A0=A0=A0=A0=A0=A0=A0 return sys_epoll_create1(0);



Since there might be some formatting problems, i'm also attaching the
patch in this
mail.

Regards,
Rohit



On Fri, May 8, 2009 at 1:19 PM, Hiroyuki Machida
<Hiroyuki.Mach@gmail.com> wrote:
>
> Hi =A0Verma,
>
> I think your point is right. but descriptions looks not straight forward.
> And title of the message is very confusable.
> I think descriptions like following would be easy to understand, and
> you should attach a your signed-off patch to fix the bug.
>
>
> Thanks,
> Hiro
>
> ----
>
> The following patch changed behavior of epoll_create(0);
>
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dco=
mmitdiff;h=3D9fe5ad9c8cef9ad5873d8ee55d1cf00d9b607df0;hp=3De38b36f325153eaa=
dd1c2a7abc5762079233e540
>
>
> Before applying the patch,
> sys_epoll_create2(int size, int flags)
> returned -EINVAL, =A0with size=3D0;
>
> But, =A0if-condtion which is introduced in sys_epoll_create() by this pat=
ch,
> looks to fail to consider case of size=3D=3D0 as follows;
>
> =A0asmlinkage long sys_epoll_create(int size)
> =A0{
> - =A0 =A0 =A0 return sys_epoll_create2(size, 0);
> + =A0 =A0 =A0 if (size < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> +
> + =A0 =A0 =A0 return sys_epoll_create1(0);
> =A0}
>
>
> ---
> Hiroyuki Machida
>
>
>
> On Thu, May 7, 2009 at 4:10 PM, rohit verma <rohit.170309@gmail.com> wrot=
e:
> > hi all,
> >
> > The man pages of epoll_create says - "Since Linux 2.6.8, the size
> > argument is unused.=A0 (The kernel dynamically sizes the required data
> > structures without needing this initial hint.)" .
> >
> > Also, it says that the syscall returns EINVAL , when size is not
> > positive. (i.e For, any value greater than 0, the kernel dynamically
> > sizes the required data stuctures). When size is zero or less than
> > zero, it has to return with error as EINVAL.
> >
> > the link: =A0http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux=
-2.6.git;a=3Dcommitdiff;h=3D9fe5ad9c8cef9ad5873d8ee55d1cf00d9b607df0;hp=3De=
38b36f325153eaadd1c2a7abc5762079233e540
> >
> > shows the latest patch of the epoll syscall. here , the syscall says:
> >
> > asmlinkage long sys_epoll_create(int size)
> > {
> > - return sys_epoll_create2(size,0);
> > + if (size < 0)
> > +=A0 return -EINVAL;
> > +
> > +return sys_epoll_create1(0);
> > }
> >
> > So if size =3D 0, it returns success which might not be the expected
> > result. So i feel that the condition check should be
> > " if (size <=3D 0) ". could u please check on this and reply me..
> >
> > Thank you,
> >
> > Regards,
> > rohit
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at =A0http://www.tux.org/lkml/
> >

--000e0cd29ac28513f00469b192a4
Content-Type: application/octet-stream; name="epoll.patch"
Content-Disposition: attachment; filename="epoll.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fum8u7pd1

LS0tIGV2ZW50cG9sbF9vcmlnLmMJMjAwOS0wNS0xMiAxMjowNzoyNy4wMDAwMDAwMDAgKzA1MzAK
KysrIGV2ZW50cG9sbC5jCTIwMDktMDUtMTIgMTI6MTA6MTQuMDAwMDAwMDAwICswNTMwCkBAIC0x
MTM2LDcgKzExMzYsNyBAQAogCiBTWVNDQUxMX0RFRklORTEoZXBvbGxfY3JlYXRlLCBpbnQsIHNp
emUpCiB7Ci0JaWYgKHNpemUgPCAwKQorCWlmIChzaXplIDw9IDApCiAJCXJldHVybiAtRUlOVkFM
OwogCiAJcmV0dXJuIHN5c19lcG9sbF9jcmVhdGUxKDApOwo=
--000e0cd29ac28513f00469b192a4--
