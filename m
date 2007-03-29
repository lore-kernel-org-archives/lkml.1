Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbXC2HzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbXC2HzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 03:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbXC2HzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 03:55:07 -0400
Received: from latinum.DResearch.DE ([217.9.48.10]:52656 "EHLO
	latinum.dresearch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbXC2HzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 03:55:05 -0400
X-Greylist: delayed 1972 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Mar 2007 03:55:04 EDT
Message-ID: <460B691B.6000701@dresearch.de>
Date: Thu, 29 Mar 2007 09:22:03 +0200
From: Steffen Sledz <sledz@DResearch.DE>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: shmid_ds.shm_nattch bug or misunderstanding?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Mar 2007 07:22:08.0522 (UTC) FILETIME=[F5DB76A0:01C771D2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We've a problem when calling shmctl to determine the number of current attaches on an shared memory segment. Because we see the problem on various 2.
4 and 2.6 kernels i believe it's not a bug but a misunderstanding in using the functions.

A main process allocates shared memory segments and attaches to them. After this it starts some child processes which attach to them too. The childs 
use shmctl(shmid, IPC_STAT, &dsbuf) to determine the shm_nattch. This should never be more than 2. But sometimes we see larger values. :(

Here's a short example.

---------------------------
shmTest.c (the main process):

#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/types.h>
#include <unistd.h>
#include <errno.h>

#define SHM_BLK_SIZE    (64*1024)

static int ipcOpen(int shmid)
{
    void *shmbuf;
    int rval;
    struct shmid_ds dsbuf = {0};

    shmbuf = shmat(shmid, 0, 0);
    if ((int)shmbuf == (-1)) {
        printf("PPID %d: shmat %p failed! errno %d '%s'\n", getpid(), shmid, errno, strerror(errno));
        return -1;
    }
    rval = shmctl(shmid, IPC_STAT, &dsbuf);
    if (rval != 0) {
        printf("PPID %d: shmctl %p failed! errno %d '%s'\n", getpid(), shmid, errno, strerror(errno));
        shmdt(shmbuf);
        return -1;
    }
    printf("PPID %d: shm %p nattch %d cpid %d lpid %d\n", getpid(), shmid, dsbuf.shm_nattch, dsbuf.shm_cpid, dsbuf.shm_lpid);
    return 0;
}
static int ipcClose(int shmid, void *shmbuf)
{
    int rval = shmdt(shmbuf);
    if (rval != 0) {
        printf("PPID %d: ipcClose() shmdt %p failed! errno %d '%s'\n", getpid(), shmid, errno, strerror(errno));
        return -1;
    }
    return 0;
}

int main(int argc, char * argv[])
{
    char path[] = { "shmatPro" };
    unsigned int loops = 1;
    int pShmid[100];
    void * pShmbuf[100];
    int i;

    if(argc >=2) {
        sscanf(argv[1], "%i", &loops);
    }
    if(loops > 100) { loops = 100; }

    for(i=0; i<loops; ++i)
    {
        int pid;
        int rval;

        pShmid[i] = shmget(IPC_PRIVATE, SHM_BLK_SIZE, IPC_CREAT | IPC_EXCL | 0700);
        if (pShmid[i] == (-1))
        {
            printf("PPID %d: shmget failed! errno %d '%s'\n", getpid(), errno, strerror(errno));
            return -1;
        }
        pShmbuf[i] = shmat(pShmid[i], 0, 0);
        if ((int)pShmbuf[i] == (-1)) {
            printf("PPID %d: shmat %p failed! errno %d '%s'\n", getpid(), pShmbuf[i], errno, strerror(errno));
            shmctl(pShmid[i], IPC_RMID, NULL);
            return -1;
        }
        memset(pShmbuf[i], 0, SHM_BLK_SIZE);
        rval = shmdt(pShmbuf[i]);
        if (rval != 0) {
            printf("PPID %d: shmdt %p failed! errno %d '%s'\n", getpid(), pShmbuf[i], errno, strerror(errno));
            shmctl(pShmid[i], IPC_RMID, NULL);
            return -1;
        }

        pid = fork();
        if(-1 == pid) {
            printf("PPID %d: fork failed! errno %d '%s'\n", getpid(), errno, strerror(errno));
            shmctl(pShmid[i], IPC_RMID, NULL);
            return -1;
        } else if( 0 == pid) {
            const char *argv[256];
            char tt[16];

            sprintf(tt, "%08X", pShmid[i]);
            argv[0] = (char*)path;
            argv[1] = tt;
            argv[2] = NULL;
            argv[255] = NULL;

            execv(path, (char**)argv);
            printf("PID %d: execv failed! errno %d '%s'\n", getpid(), errno, strerror(errno));
            exit(errno);
        }
        ipcOpen(pShmid[i]);
    }

    sleep(3);

    for(i=0; i<loops; ++i) {
        ipcClose(pShmid[i], pShmbuf[i]);
        shmctl(pShmid[i], IPC_RMID, NULL);
    }
    return 0;
}

---------------------------
shmatPro.c (the childs):

#include <sys/types.h>
#include <sys/shm.h>
#include <sys/ipc.h>
#include <errno.h>

int main(int argc, char * argv[])
{
    int shmid;
    void *shmbuf;
    int rval;
    struct shmid_ds dsbuf = {0};

    if(argc < 2) {
        printf(" PID %d: missing argument shm!\n", getpid());
        return -1;
    }
    if(1 != sscanf(argv[1], "%X", &shmid)) {
        printf(" PID %d: sscanf of argument shm '%s' failed!\n", getpid(), argv[1]);
        return -1;
    }
    shmbuf = shmat(shmid, 0, 0);
    if ((int)shmbuf == (-1)) {
        printf(" PID %d: shmat %p failed! errno %d '%s'\n", getpid(), shmid, errno, strerror(errno));
        return -1;
    }
    rval = shmctl(shmid, IPC_STAT, &dsbuf);
    if (rval != 0) {
        printf(" PID %d: shmctl %p failed! errno %d '%s'\n", getpid(), shmid, errno, strerror(errno));
        shmdt(shmbuf);
        return -1;
    }
    printf(" PID %d: shm %p nattch %d cpid %d lpid %d\n", getpid(), shmid, dsbuf.shm_nattch, dsbuf.shm_cpid, dsbuf.shm_lpid);
    sleep(1);
    rval = shmctl(shmid, IPC_STAT, &dsbuf);
    if (rval != 0) {
        printf(" PID %d: shmctl %p failed! errno %d '%s'\n", getpid(), shmid, errno, strerror(errno));
        shmdt(shmbuf);
        return -1;
    }
    printf(" PID %d: shm %p nattch %d cpid %d lpid %d\n", getpid(), shmid, dsbuf.shm_nattch, dsbuf.shm_cpid, dsbuf.shm_lpid);
    rval = shmdt(shmbuf);
    if (rval != 0) {
        printf(" PID %d: shmdt %p failed! errno %d '%s'\n", getpid(), shmid, errno, strerror(errno));
        return -1;
    }
    return 0;
}
---------------------------
a log from running "shmTest 30" on 2.6.18.8-0.1-default #1 SMP Fri Mar 2 13:51:59 UTC 2007 i686 i686 i386 GNU/Linux:

 PID 6234: shm 0x798006 nattch 1 cpid 6233 lpid 6234
 PID 6234: shm 0x798006 nattch 2 cpid 6233 lpid 6261
 PID 6235: shm 0x7a0007 nattch 1 cpid 6233 lpid 6235
 PID 6235: shm 0x7a0007 nattch 2 cpid 6233 lpid 6261
 PID 6236: shm 0x7a8008 nattch 1 cpid 6233 lpid 6236
 PID 6236: shm 0x7a8008 nattch 2 cpid 6233 lpid 6261
 PID 6238: shm 0x7b800a nattch 1 cpid 6233 lpid 6238
 PID 6238: shm 0x7b800a nattch 2 cpid 6233 lpid 6261
 PID 6239: shm 0x7c000b nattch 1 cpid 6233 lpid 6239
 PID 6239: shm 0x7c000b nattch 2 cpid 6233 lpid 6261
 PID 6240: shm 0x7c800c nattch 1 cpid 6233 lpid 6240
 PID 6240: shm 0x7c800c nattch 2 cpid 6233 lpid 6261
 PID 6241: shm 0x7d000d nattch 1 cpid 6233 lpid 6241
 PID 6241: shm 0x7d000d nattch 2 cpid 6233 lpid 6261
 PID 6237: shm 0x7b0009 nattch 3 cpid 6233 lpid 6233
 PID 6237: shm 0x7b0009 nattch 2 cpid 6233 lpid 6261
 PID 6242: shm 0x7d800e nattch 1 cpid 6233 lpid 6242
 PID 6242: shm 0x7d800e nattch 2 cpid 6233 lpid 6261
 PID 6243: shm 0x7e000f nattch 1 cpid 6233 lpid 6243
 PID 6243: shm 0x7e000f nattch 2 cpid 6233 lpid 6261
 PID 6244: shm 0x7e8010 nattch 1 cpid 6233 lpid 6244
 PID 6244: shm 0x7e8010 nattch 2 cpid 6233 lpid 6261
 PID 6245: shm 0x7f0011 nattch 1 cpid 6233 lpid 6245
 PID 6245: shm 0x7f0011 nattch 2 cpid 6233 lpid 6261
 PID 6246: shm 0x7f8012 nattch 1 cpid 6233 lpid 6246
 PID 6246: shm 0x7f8012 nattch 2 cpid 6233 lpid 6261
 PID 6247: shm 0x800013 nattch 1 cpid 6233 lpid 6247
 PID 6247: shm 0x800013 nattch 2 cpid 6233 lpid 6261
 PID 6248: shm 0x808014 nattch 1 cpid 6233 lpid 6248
 PID 6248: shm 0x808014 nattch 2 cpid 6233 lpid 6261
 PID 6249: shm 0x810015 nattch 1 cpid 6233 lpid 6249
 PID 6249: shm 0x810015 nattch 2 cpid 6233 lpid 6261
 PID 6250: shm 0x818016 nattch 1 cpid 6233 lpid 6250
 PID 6250: shm 0x818016 nattch 2 cpid 6233 lpid 6261
 PID 6251: shm 0x820017 nattch 1 cpid 6233 lpid 6251
 PID 6251: shm 0x820017 nattch 2 cpid 6233 lpid 6261
 PID 6252: shm 0x828018 nattch 1 cpid 6233 lpid 6252
 PID 6252: shm 0x828018 nattch 2 cpid 6233 lpid 6261
 PID 6253: shm 0x830019 nattch 1 cpid 6233 lpid 6253
 PID 6253: shm 0x830019 nattch 2 cpid 6233 lpid 6261
 PID 6254: shm 0x83801a nattch 1 cpid 6233 lpid 6254
 PID 6254: shm 0x83801a nattch 2 cpid 6233 lpid 6261
 PID 6255: shm 0x84001b nattch 1 cpid 6233 lpid 6255
 PID 6255: shm 0x84001b nattch 2 cpid 6233 lpid 6261
 PID 6256: shm 0x84801c nattch 1 cpid 6233 lpid 6256
 PID 6256: shm 0x84801c nattch 2 cpid 6233 lpid 6261
 PID 6257: shm 0x85001d nattch 1 cpid 6233 lpid 6257
 PID 6257: shm 0x85001d nattch 2 cpid 6233 lpid 6261
 PID 6258: shm 0x85801e nattch 1 cpid 6233 lpid 6258
 PID 6258: shm 0x85801e nattch 2 cpid 6233 lpid 6261
 PID 6259: shm 0x86001f nattch 1 cpid 6233 lpid 6259
 PID 6259: shm 0x86001f nattch 2 cpid 6233 lpid 6261
 PID 6260: shm 0x868020 nattch 1 cpid 6233 lpid 6260
 PID 6260: shm 0x868020 nattch 2 cpid 6233 lpid 6261
 PID 6262: shm 0x878022 nattch 1 cpid 6233 lpid 6262
 PID 6262: shm 0x878022 nattch 2 cpid 6233 lpid 6263
 PID 6263: shm 0x880023 nattch 1 cpid 6233 lpid 6263
 PID 6263: shm 0x880023 nattch 2 cpid 6233 lpid 6233
 PID 6261: shm 0x870021 nattch 2 cpid 6233 lpid 6261
 PID 6261: shm 0x870021 nattch 2 cpid 6233 lpid 6261
PPID 6233: shm 0x798006 nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x7a0007 nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x7a8008 nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x7b0009 nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x7b800a nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x7c000b nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x7c800c nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x7d000d nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x7d800e nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x7e000f nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x7e8010 nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x7f0011 nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x7f8012 nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x800013 nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x808014 nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x810015 nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x818016 nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x820017 nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x828018 nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x830019 nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x83801a nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x84001b nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x84801c nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x85001d nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x85801e nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x86001f nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x868020 nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x870021 nattch 1 cpid 6233 lpid 6233
PPID 6233: shm 0x878022 nattch 2 cpid 6233 lpid 6233
PPID 6233: shm 0x880023 nattch 2 cpid 6233 lpid 6233

see e.g. shm 0x7b0009

Thx for any help,
Steffen

