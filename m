Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbZBCBTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbZBCBTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 20:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbZBCBS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 20:18:58 -0500
Received: from 89-43-179-112.volio.ro ([89.43.179.112]:2916 "EHLO
	server2.radioconsult.ro" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750845AbZBCBS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 20:18:57 -0500
X-Greylist: delayed 1466 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Feb 2009 20:18:57 EST
Message-ID: <498795C5.70507@radioconsult.ro>
Date: Tue, 03 Feb 2009 02:54:29 +0200
From: Catalin Ionescu <catalin.ionescu@radioconsult.ro>
Reply-To: catalin.ionescu@radioconsult.ro
Organization: Radio Consult SRL
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: MAP_LOCKED caused speed penalty
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using 2.6.26 on a Debian box with Ahthlon64 X2 and 2.6.29-rc3-git3
on an Orion5x based board. The issue is visible on both, though not so
significant on the Athlon64.

For testing I have combined from 2 disks on two SATA ports. With just
one disk the problem is not visible at all.

When using the buffer allocating code with the MAP_LOCKED flag the
direct transfer speed to the disk is significantly lower then when the
MAP_LOCKED flag is not used.

Orion5x ->  150MB/s vs. 205MB/s
Athlon64 -> 165MB/s vs. 180MB/s

The test code is:

#include <aio.h>
#include <errno.h>
#include <fcntl.h>
#include <libaio.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/param.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/types.h>

////////////////////////////////////////////////////////////////////////////////
#define BufferSize      0x00100000
#define BuffersNum      ((0x40000000/BufferSize)*512)
#define DrivesNum       2
static const char *Drives[]={"/dev/sdb","/dev/sdc","/dev/sdd","/dev/sde"};
#define BuffsPerDrive   (0x01000000/BufferSize/DrivesNum)
////////////////////////////////////////////////////////////////////////////////
int main(void)
{ void *Buf[DrivesNum][BuffsPerDrive],*Buf_[DrivesNum][BuffsPerDrive];
  int fd[DrivesNum];
  size_t i,j,BufIdx;
  uint32_t StartTime,LastTime;
  uint32_t _StepsNum;
  uint64_t _TotalTime;
  io_context_t Ctx[DrivesNum];
  struct iocb CBs[DrivesNum][BuffsPerDrive];
  struct iocb *CBPs[DrivesNum][BuffsPerDrive];
  struct timeval tv;

  //  Opens the files.
  for (i=0;i<DrivesNum;i++)
    if ((fd[i]=open(Drives[i],O_DIRECT|O_LARGEFILE|O_WRONLY))==-1)
perror(Drives[i]);
  //  Allocates the memory blocks from which the write should be done.
  for (i=0;i<DrivesNum;i++)
    for (j=0;j<BuffsPerDrive;j++)
    { //Buf_[i][j]=malloc(BufferSize+4096);

Buf_[i][j]=mmap(NULL,(BufferSize+4096)&-4096,PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);

//Buf_[i][j]=mmap(NULL,(BufferSize+4096)&-4096,PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS|MAP_LOCKED,-1,0);
      Buf[i][j]=(void *)(((uint32_t)Buf_[i][j])&-4096);
    }
  for (i=0;i<DrivesNum;i++)
  { Ctx[i]=NULL;
    j=io_setup(64,&Ctx[i]);
    if (j) printf("io_setup %d - Error %d\n",i,j);
    for (j=0;j<BuffsPerDrive;j++) CBPs[i][j]=&CBs[i][j];
  }
  BufIdx=0;
  for (_TotalTime=0,_StepsNum=1;_StepsNum<=BuffersNum;_StepsNum++)
  { gettimeofday(&tv,NULL);
    StartTime=tv.tv_sec*1000000+tv.tv_usec;
    for (i=0;i<DrivesNum;i++) if (fd[i]!=-1)
    { struct io_event Ev;

      if (_StepsNum>=BuffsPerDrive) io_getevents(Ctx[i],1,1,&Ev,NULL);

io_prep_pwrite(&CBs[i][BufIdx],fd[i],Buf[i][BufIdx],BufferSize,(uint64_t)_StepsNum*BufferSize);
      io_submit(Ctx[i],1,&CBPs[i][BufIdx]);
    }
    gettimeofday(&tv,NULL);
    _TotalTime+=(LastTime=tv.tv_sec*1000000+tv.tv_usec-StartTime);
    BufIdx=(BufIdx+1)%BuffsPerDrive;
    if (!(_StepsNum%10)) printf("Step %u/%u - %.02lf MB/s - %.02lf MB/s
         \r",
                                _StepsNum,BuffersNum,

(float)BufferSize*DrivesNum/(int32_t)LastTime,

(float)BufferSize*DrivesNum*(int32_t)_StepsNum/(int64_t)_TotalTime);
  }
  for (i=0;i<DrivesNum;i++) io_destroy(Ctx[i]);
  //  Frees the memory blocks.
  for (i=0;i<DrivesNum;i++)
    for (j=0;j<BuffsPerDrive;j++)
      //free(Buf_[i][j]);
      munmap(Buf_[i][j],(BufferSize+4096)&-4096);
  //  Closes all opened files.
  for (i=0;i<DrivesNum;i++) if (fd[i]!=-1) close(fd[i]);
}
////////////////////////////////////////////////////////////////////////////////
