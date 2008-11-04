Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbYKDKbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbYKDKbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 05:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbYKDKbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 05:31:06 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:8621 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbYKDKbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 05:31:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U2tB+RKY6EndNT46hSbUfYBZXT9aP2+AiPW6y6CFHKiXCXafX2j1NjUMLpADQ9DFgv
         HC067/ER2JsoF6w40mVCuCX2XVU4XmJuypnEZjTSyBjkzb9tHhFWsduEgmNPRNGR1Zlg
         K6X8IXLn1vPT94GvfvJrIbAEVJFM5/T8bEUvk=
Date: Tue, 4 Nov 2008 13:34:21 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       "Koyama, Yoshiya" <Yoshiya.Koyama@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-fsdevel@vger.kernel.org
Subject: Re: v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data
	to userspace
Message-ID: <20081104103421.GB20682@x200.localdomain>
References: <19f34abd0810251014s7968557br38e43aa0b9cdcf09@mail.gmail.com> <200810252241.53601.rjw@sisk.pl> <m163nggvhq.fsf@frodo.ebiederm.org> <19f34abd0810261408w61b1e2dbvb9a0e16ce5a10022@mail.gmail.com> <19f34abd0811040139t8334502i7a5d8501c5fe95ac@mail.gmail.com> <20081104100050.GA10398@x200.localdomain> <20081104100757.GB10398@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104100757.GB10398@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 01:07:57PM +0300, Alexey Dobriyan wrote:
> On Tue, Nov 04, 2008 at 01:00:50PM +0300, Alexey Dobriyan wrote:
> > On Tue, Nov 04, 2008 at 10:39:19AM +0100, Vegard Nossum wrote:
> > > # uname -a
> > > Linux ubuntu 2.6.28-rc2-next-20081031 #60 SMP Sat Nov 1 13:19:49 CET
> > > 2008 i686 GNU/Linux
> > > # prelink -mRf /sbin/udevd
> > > # ./a.out /proc/4764/exe
> > > warning: /proc/4764/exe: got return value 38, expected 11
> > > 2f7362696e2f756465766400fffffffffdfffffffffffff7ffffbfff202864656c6574656429
> > > /sbin/udevd                  (deleted)
> > 
> > reproduced
> 
> prelink does
> 
> 	rename("/sbin/udevd.#prelink#.N6pvOJ", "/sbin/udevd")

OK, here is obvious (lame) reproducer, second readlink returns 32 while first
returns 18:

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main(void)
{
	int fd, fd1;
	char buf[64], buf1[64], img[42000];
	ssize_t len;

	fd = open("/proc/self/exe", O_RDONLY);

	readlink("/proc/self/exe", buf, sizeof(buf));
	strcpy(buf1, buf);
	strcat(buf1, ".xxx");
	unlink(buf1);
	fd1 = open(buf1, O_WRONLY|O_CREAT);
	len = read(fd, img, sizeof(img));
	close(fd);
	write(fd1, img, len);
	close(fd1);
	rename(buf1, buf);

	readlink("/proc/self/exe", buf, sizeof(buf));

	return 0;
}
