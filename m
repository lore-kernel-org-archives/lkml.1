Return-Path: <linux-kernel-owner+w=401wt.eu-S1763466AbXHCSBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763466AbXHCSBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 14:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbXHCSB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 14:01:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbXHCSB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 14:01:28 -0400
To: linux-kernel@vger.kernel.org
Subject: SysV IPC: shmctl/msgctl/semctl returns EIDRM instead of EINVAL
From: Anton Arapov <aarapov@redhat.com>
X-URL: http://people.redhat.com/aarapov
Date: Fri, 03 Aug 2007 19:59:50 +0200
Message-ID: <m3bqdo1otl.fsf@neuro-laptop.skynet>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Hi!

  SysV code returns EIDRM for collision of IDs. I sure it should return EINVAL.

  Steps to reproduce: (this for shared memory code, for msg/sem it is the same)
   1. Create then drop 2 shmem segments, then create a third.
   2. Try to shmctl(IPC_STAT) the two now-invalid shm IDs.
   3. Note error codes returned.

   One call gives EINVAL, one gives EIDRM due to collision with the third shmem segment.
   Should both give EINVAL, this is what I've got on every other Unix I've tried it on. 

  IPC code is good, EIDRM is justification of EINVAL. But neither SVr4 nor SVID documents EIDRM. 
  Single Unix Specification mentions EINVAL but not EIDRM as a possible failure for shmctl(), so the current kernel behavior is not merely self-inconsistent but a flat violation of the spec. 

  Can somebody explain why do we have EIDRM?

Anton.
SUS: http://www.opengroup.org/onlinepubs/007908799/xsh/shmctl.html


--=-=-=
Content-Type: bug_reproducer
Content-Disposition: attachment; filename=shmctl-bug.c

#include <sys/ipc.h>
#include <sys/shm.h>

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int
main(int argc, char *argv[])
{
    int              shmid1;
    int              shmid2;
    int              shmid3;
    struct shmid_ds  buf;

    /* make and stat 2 shmem segments */
    shmid1 = shmget(0x12345678, 1024 * 1024, IPC_CREAT | IPC_EXCL | 0600);
    if (shmid1 < 0)
    {
	perror("shmget 1 failed");
	exit(1);
    }
    printf("id1 = %d / %#x\n", shmid1, shmid1);

    shmid2 = shmget(0x12345679, 1024 * 1024, IPC_CREAT | IPC_EXCL | 0600);
    if (shmid2 < 0)
    {
	perror("shmget 2 failed");
	exit(1);
    }
    printf("id2 = %d / %#x\n", shmid2, shmid2);

    if (shmctl(shmid1, IPC_STAT, &buf) < 0)
    {
	printf("shmctl(%d / %#x, IPC_STAT): ERROR: %s\n", shmid1, shmid1,
	       strerror(errno));
    }

    if (shmctl(shmid2, IPC_STAT, &buf) < 0)
    {
	printf("shmctl(%d / %#x, IPC_STAT): ERROR: %s\n", shmid2, shmid2,
	       strerror(errno));
    }

    /* remove both */
    if (shmctl(shmid1, IPC_RMID, NULL) < 0)
    {
	printf("shmctl(%d / %#x, IPC_RMID): ERROR: %s\n", shmid1, shmid1,
	       strerror(errno));
    }
    if (shmctl(shmid2, IPC_RMID, NULL) < 0)
    {
	printf("shmctl(%d / %#x, IPC_RMID): ERROR: %s\n", shmid2, shmid2,
	       strerror(errno));
    }

    /* make a third one */
    shmid3 = shmget(0x1234567A, 1024 * 1024, IPC_CREAT | IPC_EXCL | 0600);
    if (shmid3 < 0)
    {
	perror("shmget 3 failed");
	exit(1);
    }
    printf("id3 = %d / %#x\n", shmid3, shmid3);

    /* now observe stat behavior for the two old IDs */

    if (shmctl(shmid1, IPC_STAT, &buf) < 0)
    {
	printf("shmctl(%d / %#x, IPC_STAT): ERROR: %s\n", shmid1, shmid1,
	       strerror(errno));
    }

    if (shmctl(shmid2, IPC_STAT, &buf) < 0)
    {
	printf("shmctl(%d / %#x, IPC_STAT): ERROR: %s\n", shmid2, shmid2,
	       strerror(errno));
    }

    /* clean up by removing third segment */
    if (shmctl(shmid3, IPC_RMID, NULL) < 0)
    {
	printf("shmctl(%d / %#x, IPC_RMID): ERROR: %s\n", shmid3, shmid3,
	       strerror(errno));
    }

    return 0;
}

--=-=-=--
