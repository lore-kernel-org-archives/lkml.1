Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbYIQNrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbYIQNrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 09:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYIQNrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 09:47:32 -0400
Received: from mailer1.option.com ([81.246.70.162]:33577 "EHLO
	mailer1.option.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbYIQNrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 09:47:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AocBAE2n0EgKAAAZ/2dsb2JhbAAIuHmBZw
Message-ID: <48D10A70.8050202@option.com>
Date: Wed, 17 Sep 2008 15:47:28 +0200
From: Denis Joseph Barrow <D.Barow@option.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "Amit S. Kale" <amitkale@linsyssoft.com>,
       Tom Rini <trini@kernel.crashing.org>,
       Jason Wessel <jason.wessel@windriver.com>, David Grothe <dave@gcom.com>,
       Tigran Aivazian <tigran@sco.com>, linux-kernel@vger.kernel.org
Subject: getting false SIGTRAP breakpoints in kernel i.e. kernel hung unless
 gdb remotely attached on x86 & cont is issued
Content-Type: multipart/mixed;
 boundary="------------050607020500070205060407"
X-OriginalArrivalTime: 17 Sep 2008 13:47:28.0897 (UTC) FILETIME=[ECEA3710:01C918CB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050607020500070205060407
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi ladies/gentlemen,
The kernel I'm running gdb with is 2.6.27-rc4
The false sigtrap is occuring in ia32_sysenter_target in arch/x86/kernel/entry_32.S:303
when gdb is stepped from the user process as described below

To reproduce
compile kernel with kgdb support 
compile my randsleep program attached using the .mk script
as root
attach randsleep to an idle serial port e.g. /dev/ttyS0 by typing
randsleep /dev/ttyS0
from another bash shell type
ps -aux | grep randsleep

gdb ./randsleep
attach <pid of randsleep>

You should get messages from gdb like
Attaching to program: /home/djbarrow/devel2/randsleep/randsleep, process 6397
Reading symbols from /lib/tls/i686/cmov/libc.so.6...done.
Loaded symbols for /lib/tls/i686/cmov/libc.so.6
Reading symbols from /lib/ld-linux.so.2...done.
Loaded symbols for /lib/ld-linux.so.2
0xb7fda430 in __kernel_vsyscall ()

Now type step.

The machine is now hung until gdb attaches remotely.


-- 
best regards,
D.J. Barrow

--------------050607020500070205060407
Content-Type: text/x-csrc;
 name="randsleep.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="randsleep.c"

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/time.h>
#include <time.h>  
#include <signal.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>

#define READLEN (128)
void sigalrm(int signal)
{
	fprintf(stderr,"atcmd_response_read timed out.\n");
	exit(-1);
}
void atcmd_response_read(int fd)
{
	int i,count;
	char tmpbuf;
	//alarm(5);
	for (i=0;;i++) {
		count=read(fd,&tmpbuf,1);
		if (count < 0) {
			perror("read failed\n");
			exit(-1);
		}

		if (count == 1 )
		{
			printf("%c",tmpbuf);
			if( i > 2&& (tmpbuf==0xd || tmpbuf==0xa))
				break;
		}
	}
	fflush(stdout);
	alarm(0);
}

void atcmd_write(int fd, char *buf)
{
	ssize_t written=0,retval;
	size_t count=strlen(buf);
	
	while (written < count) {
		retval=write(fd, &buf[written], 1);
		if (retval < 0) {
			perror("write failed\n");
			exit(-1);
		}
		if(retval==1)
			printf("%c",buf[written]);
		written+=retval;
	}
}


double getrand()
{
	int rnd;
	double randfloat;
	rnd=rand();
	return (double)rnd/(double)RAND_MAX;

	
}
int main(int argc,char *argv[])
{
	int fd;
	int count;
	char *devname;
	char tmpbuff[READLEN];
	int  i;
	if (argc != 2) {
		fprintf(stderr,"Usage:\n"
			"randsleep <hso application port>\n");
		return -1;
	}
	devname=argv[1];

	fd=open(devname,O_RDWR);
	if (fd<0) {
		perror("open failed");
		return -1;
	}
	signal(SIGALRM,sigalrm);
	atcmd_write(fd,"ATE0\r\n");
	atcmd_response_read(fd);
	for(i=0;;i++)
	{
		printf("\nLoop %d\n",i);
	        
		atcmd_write(fd,"AT\r\n");
		usleep(getrand()*(double)4000000);
		atcmd_response_read(fd);
		usleep(getrand()*(double)4000000);
	}

}

--------------050607020500070205060407
Content-Type: text/plain;
 name="mk"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="mk"

Z2NjIHJhbmRzbGVlcC5jIC1nIC1vIHJhbmRzbGVlcA==
--------------050607020500070205060407--
