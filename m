Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbYJBXvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbYJBXvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYJBXvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:51:36 -0400
Received: from outbound-mail-120.bluehost.com ([69.89.18.6]:37039 "HELO
	outbound-mail-120.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753345AbYJBXvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:51:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id:X-Identified-User;
	b=GE0NiBmiOPHLsQuVTLPbIyfa2s2bnqxzQUyh+FmYJ0+bn/628NJ/skJwBV2nxC/C8QUFt4GssPT3w/FwooLo7QNtixYgcqOzyiTEBhKQKDfG1FniJW785QhMvnOYp2tM;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] check mapped ranges on sysfs resource files (for 2.6.27)
Date: Thu, 2 Oct 2008 16:51:28 -0700
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <200810021534.38219.jbarnes@virtuousgeek.org> <alpine.LFD.2.00.0810021630100.3341@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810021630100.3341@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_B6V5I9ZtpZzP2m0"
Message-Id: <200810021651.29081.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_B6V5I9ZtpZzP2m0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday, October 2, 2008 4:30 pm Linus Torvalds wrote:
> On Thu, 2 Oct 2008, Jesse Barnes wrote:
> > +	unsigned long map_len = vma->vm_end - vma->vm_start;
> > +	unsigned long map_offset = vma->vm_pgoff << PAGE_SHIFT;
>
> This seems broken for big vm_pgoff values, where that shift will
> potentially overflow, no?

Ah yes, exactly what we want to be checking for in fact.

> Also, it strikes me that we don't seem to check that the resource start is
> page-aligned. We just do
>
> 	vma->vm_pgoff += start >> PAGE_SHIFT;
>
> without checking if we just dropped low bits from 'start'.

Hm, yeah looks like that's a long standing issue...

> Of course, if the length of the resource is bigger than a page, I guess
> the resource is guaranteed to be at least page-aligned, so maybe the
> length check - if it was correct - would be sufficient.
>
> Anyway, it would be *much* better to do the length check in pages rather
> than in bytes, to avoid the overflow condition.
>
> Can somebody test if something like this works? It also prints the actual
> name of the device, not just a random BAR number (but it will print
> everyting in PFN's, I hate potentially losing information).

Yeah, looks much better.  I was using this silly test program to see if the 
earlier code worked.  Just pass in both valid and invalid sizes.

Jesse

--Boundary-00=_B6V5I9ZtpZzP2m0
Content-Type: text/x-csrc;
  charset="iso 8859-15";
  name="sysfs-mmap-test.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="sysfs-mmap-test.c"

#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>

int main(int argc, char *argv[])
{
	size_t len;
	int fd;
	void *ptr;

	if (argc != 3) {
		fprintf(stderr, "usage: %s <file> <mapsize>\n",
			argv[0]);
		return -1;
	}

	len = atoi(argv[2]);

	fd = open(argv[1], O_RDONLY);
	if (fd == -1) {
		fprintf(stderr, "open failed: %s\n", strerror(errno));
		return errno;
	}

	ptr = mmap(NULL, len, PROT_READ, MAP_SHARED, fd, 0);
	if (ptr == MAP_FAILED) {
		fprintf(stderr, "mmap failed: %s\n", strerror(errno));
		return errno;
	}

	printf("mmap of %s with size %zd succeeded\n", argv[1], len);

	munmap(ptr, len); /* ignore any errors, we don't care */
	close(fd);
	return 0;
}

--Boundary-00=_B6V5I9ZtpZzP2m0--
