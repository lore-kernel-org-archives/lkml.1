Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbYKKWyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbYKKWyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYKKWx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:53:58 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:49856 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbYKKWx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:53:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dnI+os6O8vt4uUi5SbG4wXM1Xx+Y8v026oL8e2jI2L5Yi4nMZR/HB+0SY8yo7NXKmb
         stvyMnaM2YvwQB+rP6JsNuQL0JfnW9/GnB/NOoYBV/7vWIvYHbfVezrtyy6rE7kLz5Fi
         IiFiDy06/8f/NdtkcNu0QHwxAC5r0aVG4Nkm0=
Message-ID: <19f34abd0811111453q51412aaas3cd01cc2e8398cd7@mail.gmail.com>
Date: Tue, 11 Nov 2008 23:53:56 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data to userspace
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>, greg@kroah.com, mingo@elte.hu,
       viro@zeniv.linux.org.uk, ebiederm@xmission.com, Yoshiya.Koyama@hp.com,
       rjw@sisk.pl, penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
       kay.sievers@vrfy.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20081111141412.b52469d2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0810251014s7968557br38e43aa0b9cdcf09@mail.gmail.com>
	 <200810252241.53601.rjw@sisk.pl> <m163nggvhq.fsf@frodo.ebiederm.org>
	 <19f34abd0810261408w61b1e2dbvb9a0e16ce5a10022@mail.gmail.com>
	 <19f34abd0811040139t8334502i7a5d8501c5fe95ac@mail.gmail.com>
	 <20081104151234.GH28946@ZenIV.linux.org.uk>
	 <20081106100410.GN4890@elte.hu> <20081107190544.GA1551@kroah.com>
	 <20081107231205.GA2528@x200.localdomain>
	 <20081111141412.b52469d2.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 11:14 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> I queued the below for 2.6.28 inclusion and tagged for -stable
> backporting.
>
>
>
> From: Al Viro <viro@ZenIV.linux.org.uk>
>
> Vegard sayeth:
>
> When I run readlink on the /proc/*/exe-file for udevd, the kernel
> returns some unitialized data to userspace:
>
> # strace -e trace=readlink readlink /proc/4762/exe
> readlink("/proc/4762/exe", "/sbin/udevd", 1025) = 30
>
> You can see it because the kernel thinks that the string is 30 bytes
> long, but in fact it is only 12 (including the '\0').
>
> If we explicitly clear the buffer before calling readlink, we can also
> see that some garbage has been filled in there, after the string:
>
> # ./readlink /proc/4762/exe
> readlink(/proc/4762/exe) = 30
> 2f7362696e2f7564657664000000ffffffad4effffffadffffffdeffffffffffffffff202864656c657465642900000000000000000000000000000
>
> (Output is from following simple program:)
>
> #include <stdio.h>
> #include <string.h>
> #include <unistd.h>
>
> int main(int argc, char *argv[])
> {
>        char buf[1024];

Should probably have been unsigned char.

>        int i;
>        ssize_t n;
>
>        memset(buf, 0, sizeof(buf));
>        n = readlink(argv[1], buf, sizeof(buf));
>
>        printf("readlink(%s) = %d\n", argv[1], n);
>
>        for (i = 0; i < sizeof(buf); ++i)
>                printf("%02x", buf[i]);

Or maybe it was the wrong format string. Negative numbers become very
long (with many extra "ff"s) in output. I guess it doesn't really
matter, though...

That said, Alexey also had an error in HIS testcase:

On Tue, Nov 4, 2008 at 11:34 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> #include <stdio.h>
> #include <string.h>
> #include <unistd.h>
>
> int main(void)
> {
>        int fd, fd1;
>        char buf[64], buf1[64], img[42000];
>        ssize_t len;
>
>        fd = open("/proc/self/exe", O_RDONLY);
>
>        readlink("/proc/self/exe", buf, sizeof(buf));
>        strcpy(buf1, buf);
>        strcat(buf1, ".xxx");
>        unlink(buf1);
>        fd1 = open(buf1, O_WRONLY|O_CREAT);

Without the third argument to open with O_CREAT, file permissions may
be very strange :-)

Is this small program suitable for inclusion in LTP, maybe? We can
verify that kernel does the right thing by testing readlink(buf) ==
strlen(buf).

But thanks for the fix and attribution!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
