Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbXISUJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbXISUJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 16:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbXISUJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 16:09:15 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:18858 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbXISUJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 16:09:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jnwQfVa6siIHq7Rd4kLSg5k7uP8+5Biqq9bDhibCpL88J8/z3jKF3PQc2kvqKkjvKFSmk5SnBbMPob04z5HVdX4u5mG8SuAUYEerkgB4cCa6qo2UXnA82U3pQktPN7aNBxYRmmQt/GS0UrGR5+VYRAfdgXqJWIzxN5KGM6Tmdfw=
Message-ID: <c424c7d0709191309s283a255au9e6841634c18204c@mail.gmail.com>
Date: Wed, 19 Sep 2007 22:09:12 +0200
From: "Ramon Chimeno" <ramon.chimeno@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Disk I/O degraded performance
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

I migrated one of my server from kernel 2.6.18 to the latest 2.6.22
and I experienced lower disk performance for processes that open file
with the O_DIRECT flag.

I did a very simple test program that opens two files with O_DIRECT
flag and reads the files to end. I monitored the time spent to read
the files and I have ~ 40% of difference between 2.6.18 and 2.6.22.

For information, the files are stored on a XFS partition which is part
of a software raid-5 block device (the raid-5 is made with 3 SATA
drives).

Does that make sense to you gurus ? Of course, I didn't change the
configuration (task scheduler, HZ, default I/O scheduler, ...) between
the two kernels.

For information, the code of my test program is pasted below (I
snipped the #include part):
----------------------8<----------------------8<----------------------
#define BSIZE (512*512)
int main(int ac, char * av[])
{
 int   fd[2];
 char* buffer;

 if (ac != 3)  {
   printf("USAGE: %s <FILE-1> <FILE-2>\n", av[0]);
   exit(EXIT_FAILURE);
 }

 if ((fd[0] = open(av[1], O_RDONLY|O_DIRECT)) == -1)
   exit(EXIT_FAILURE);
 if ((fd[1] = open(av[2], O_RDONLY|O_DIRECT)) == -1)
   exit(EXIT_FAILURE);
 if ((buffer = (char *)memalign(4096, BSIZE)) == 0)
   exit(EXIT_FAILURE);

 for (;;)  {
   if (read(fd[0], buffer, BSIZE) != BSIZE)
     break;
   if (read(fd[1], buffer, BSIZE) != BSIZE)
     break;
 }
 close(fd[0]);
 close(fd[1]);
 free(buffer);
 return EXIT_SUCCESS;
}
----------------------8<----------------------8<----------------------

Any help/hint would be appreciate.

-- R.C
