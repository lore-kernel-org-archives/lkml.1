Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbYGaKYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbYGaKYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756553AbYGaKYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:24:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:29383 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420AbYGaKYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:24:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SA6iq9wTVS8I7q3kTevyC5H6rVgardH2ZhHN2YcL49waSQjRkN3DhamBf86RyiZDPR
         UdcXubYD0g2Z448F+C+vJeGerNQiRk8FE/0f+wHcDQpyEDrdTluBkbTupRG+np/tmWXB
         F+UjaCc/yOZXossX6paFfgq+dHYtUsIa3ZCHU=
Message-ID: <9debc4410807310324m4a76aaf5s253242e5cc2bb130@mail.gmail.com>
Date: Thu, 31 Jul 2008 15:54:30 +0530
From: "Maxin John" <maxin.john@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: regarding mprotect() implementation in 2.6.26 kernel
In-Reply-To: <9debc4410807310315n4da5beafh853a71f532420e9a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9debc4410807310315n4da5beafh853a71f532420e9a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Christoph Hellwig,

( I guess you are the right person to ask this question ?)

The POSIX.2 specification of mprotect() says:

errorno should be set as ENOMEM if the addresses in the range [addr,
(addr + len)] are invalid for the address space of a process, or
specify one or more pages which are not mapped.

However, in the mprotect implementation  (asmlinkage long
sys_mprotect(unsigned long start, size_t len, unsigned long prot)) in
linux/mm/mprotect.c file, if we call mprotect() with start as NULL and
len as 0, mprotect() returns 0 and it is not setting the errono.The
following code confirms this behaviour.


*********** mprotect check code ********************

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <errno.h>
#include <sys/mman.h>

int main()
{

       int fd, ret;
       char *address;
       errno = 0;

       fd = open("./mmap_file", O_CREAT | O_RDWR, 766);
       address = (char *) mmap(0, 100, PROT_READ, MAP_SHARED, fd, 0);

       /* address argument is NULL and length argument is 0 */

       if ((ret = mprotect(NULL, 0, PROT_READ)) == -1) {
               printf("%s Error \n", strerror(errno));
               printf("mprotect functionality is correct.\n");
       } else {
               printf("mprotect functionality needs to be verified \n");
               exit(EXIT_FAILURE);
       }
       close(fd);
       return 0;
}

*********** mprotect check code ********************

Is there a reason to return 0 when the len is 0 and start is NULL ? Is
it intentional ? If not, it should be fixed.

Cheers,

Maxin B. John
Bangalore, India
