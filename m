Return-Path: <linux-kernel-owner+w=401wt.eu-S1757651AbZGFIJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651AbZGFIJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 04:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZGFIJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 04:09:14 -0400
Received: from ishtar.tlinx.org ([64.81.245.74]:51033 "EHLO Ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbZGFIJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 04:09:13 -0400
Message-ID: <4A51B127.8080807@tlinx.org>
Date: Mon, 06 Jul 2009 01:09:11 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: pipe(2), read/write, maximums and behavior.
X-Stationery: 0.4.9
Content-Type: multipart/mixed;
 boundary="------------090704070705030503000705"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090704070705030503000705
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I've seen a few shells claim to limit pipe sizes to 8 512Byte buffers.
Don't know where they get this value or how they think it applies, but
it certainly doesn't seem to apply in linux.   However, I'm not
sure what limits do apply compared to available memory. 

I suppose, starting off, one might look at at a maximum of
(Physical+Swap-resident-non-swappable mem)/2 as a top limit.

A test machine I have has 8GB physical memory with a bit over 4GB
of swap space making for about 12GB of memory.

If total memory was to go toward my proglet that splits into a master
writer and slave pipe reader, they'd have to split memory to have
matching buffer read/write sizes. I'd "expect", (I think) at least
a 2GB write/read to work, and possibly a 4GB write/read to work
with alot of swap activity -- that's assuming there are no other
restraints in dividing 12GB of address space.

As it turns out -- the program dies at 2GB (the 1GB write/read works)
but when the program tries a 2GB write & read it refuses the full write
and the child gets less than 2GB.

The master gets back that it wrote 2097148KB, though it tried to
write 2097152KB (and the child receives the 2GB-4K buffer upon read).

This is on a x86_64 machine, and unsigned long values are 8-bytes
wide and being used with the read and write calls for lengths.

Shouldn't a 2GB read/write work?  At most, together the master
and slave would have only used 4GB for each to have a 2GB buffer.

How would one determine the maximum size for 1 huge read or write 
through the pipe (from the pipe system call)?

On 2GHz multi-core machines, I get about 512MB/s throughput.

I attached the source file so anyone can see my methodology.

you have to include "-lrt" on the gcc command line as it uses
clock_gettime to estimate the time for the write call (the read
call always comes back with values too small to be reasonable, so
I don't bother printing them.




--------------090704070705030503000705
Content-Type: text/plain;
 name="piptst.c"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="piptst.c"

#define __USE_LARGEFILE64 1
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <strings.h>
#include <time.h>

#define PAR_WAIT_TO_HUP 3
int pipefd[2];
int controlfd[2];
int pid;

void getout(int stat, char * msg) {
	char errmsg[128];
	char *id;
	id=(pid>0)?"parent":" child";
	snprintf(errmsg, sizeof(errmsg), "%s: %s", id, msg);
	perror(errmsg);
	if (pid>0) {
		close(pipefd[1]);
		close(controlfd[0]);
		sleep(PAR_WAIT_TO_HUP);
		kill(pid, 1);	/* SIGHUP */
	} else {
		close(pipefd[0]);
		close(controlfd[1]);
	}
	exit(stat);
}


void sighandler() {
	char errmsg[128];
	char *id;
	id=(pid>0)?"parent":" child";
	snprintf(errmsg, sizeof(errmsg), "%s: %s", id, 
			"SIGPIPE: We are talking, but nobody's listening!\n");
	getout(8, "pipe write");
	
}

typedef struct timespec * timeval;


timeval get_elapsed(timeval elapsed, timeval start, timeval end) {
	int borrow=0;
	double result;
	if (start->tv_nsec >end->tv_nsec) {
		end->tv_nsec += 1000*1000*1000;
		borrow=1;
	}
	elapsed->tv_nsec = end->tv_nsec - start->tv_nsec;
	if (borrow) --end->tv_sec;
	elapsed->tv_sec = end->tv_sec - start->tv_sec;
	return elapsed; 
}


char * ht (char *buff, int bufflen, timeval tv) {

	bzero(buff, bufflen);

	/* if time sex and nsecs both equal 0 return zero */

	if (tv->tv_sec==0 && tv->tv_nsec==0) {
		snprintf(buff, bufflen, "0.0 seconds");
		return buff;
	}

	/* if < 1 sec, display fraction in nano, micro or milli- seconds */

	if (tv->tv_sec==0 && tv->tv_nsec!=0) {
		char * unit;
		int nanos=tv->tv_nsec;
		if (nanos<1000) {
			unit="ns";
		} else if (nanos < 1000000 && nanos>=1000) {
			nanos/=1000;
			unit="µs";
		} else {
			nanos/=1000000;
			unit="ms";
		}
		snprintf(buff, bufflen, "%d%s", nanos, unit);
	} else if (tv->tv_sec > 0) {
		double t = ((double) tv->tv_sec) + ((double) tv->tv_nsec)/(double)1000000000.0;
		snprintf(buff, bufflen, "%-5.3lf seconds", t);
	}
	
	return buff;
}

typedef const char * String;

static const String suffixes [] = {"B", "KB", "MB", "GB", "TB"};
static const int num_suffixes = sizeof(suffixes)/sizeof(String);

char * h (char *buff, int bufflen, unsigned long nb) {
	int si=0;
	int index_of_last_suffix = num_suffixes-1;

	bzero(buff, bufflen);	
	
	for (si=0; si<index_of_last_suffix && nb>1023 && (nb % 1024)==0; ++si) {
		nb >>= 10;
	}
	snprintf(buff, bufflen, "%d%s", nb, suffixes[si]);
	return buff;
}

child_pipe_reader() {
	unsigned long buffsize;	/* units of 1K */
	unsigned long bytes_read;
	char * cbuff;
	/* child reader */
	close(pipefd[1]);
	close(controlfd[0]);
	while (1) {
		char lbuff[20];
		char fbuff[20];
		struct timespec start, end, elapsed;
		double secs;
		bytes_read=read(pipefd[0], &buffsize, sizeof(buffsize));
		if (bytes_read <0 ) {
			getout(14, "reading size of buffer from parent");
		}
		if (bytes_read != sizeof(buffsize)) {
			getout(15, "wrong number of bytes read for sizeof(buffsize)");
		}
		cbuff = malloc(buffsize*1024);
		if ((long int) cbuff <0) {
			getout(13, "child malloc");
		}
		printf(" child: reading %s from parent\n", 
				h(lbuff, sizeof(lbuff), buffsize*1024));
		if (clock_gettime(CLOCK_REALTIME, &start)<0) {
			perror(" child: clock_gettime start");
			exit(18);
		}
		bytes_read=read(pipefd[0], cbuff, buffsize*1024);
		if (clock_gettime(CLOCK_REALTIME, &end)<0) {
			perror(" child: clock_gettime end");
			exit(19);
		}
		get_elapsed(&elapsed, &start, &end);
		free(cbuff);
		if (bytes_read <0 ) {
			getout(16, "reading from parent");
		}
		if (bytes_read != buffsize*1024) {
			char errmsg[128];
			char lbuff1[20];
			char lbuff2[20];

			snprintf(errmsg, sizeof(errmsg),
				"read of %s only returned %s. Exiting\n",
				h(lbuff1, sizeof(lbuff1), buffsize*1024),
				h(lbuff2, sizeof(lbuff2), bytes_read)
				);
			getout(17, errmsg);
		}
		printf(" child: successfully read %s from parent\n", 
				h(lbuff, sizeof(lbuff), buffsize*1024));
		write(controlfd[1], &bytes_read, sizeof(bytes_read) );
	}
}

parent_pipe_writer() {
	unsigned long buffsize=1;	/* units of 1K */
	unsigned long bytes_written;
	char * pbuff;
	close(pipefd[0]);
	close(controlfd[1]);
	/* parent writer */
	while (1) {
		char lbuff[20];
		char fbuff[20];
		int child_read_bytes;
		struct timespec start, end, elapsed;
		double secs;
		/* first try to allocate buffer to write from */
		pbuff = malloc(buffsize*1024);
		if ((long int) pbuff <0) {		/* die if can't alloc */
			getout(3, "malloc");
		}
		/* write size of buffer to child */
		bytes_written=write(pipefd[1], &buffsize, sizeof(buffsize));
		if (bytes_written <0 ) {
			free(pbuff);
			getout(4, "writing size of buffer to child");
		}
		if (bytes_written != sizeof(buffsize)) {	/* would be bad if 
													   couldn't write size */
			free(pbuff);
			getout(5, 
				"wrong number of bytes written for sizeof(buffsize)");
		}
		printf("parent: writing %s to child\n", 
				h(lbuff, sizeof(lbuff), buffsize*1024));
		if (clock_gettime(CLOCK_REALTIME, &start)<0) {
			perror("parent: clock_gettime start");
			exit(9);
		}
		bytes_written=write(pipefd[1], pbuff, buffsize*1024);
		if (clock_gettime(CLOCK_REALTIME, &end)<0) {
			perror("parent: clock_gettime end");
			exit(10);
		}
		get_elapsed(&elapsed, &start, &end);
		free(pbuff);
		if (bytes_written <0 ) {
			getout(6, "writing buff to child");
		}
		if (bytes_written != buffsize*1024) {
			char errmsg[128];
			char lbuff1[20],lbuff2[20];
			snprintf(errmsg, sizeof(errmsg),
					"write of %s only wrote %s. Exiting\n",
					h(lbuff1, sizeof(lbuff1), buffsize*1024), 
					h(lbuff2, sizeof(lbuff2), bytes_written)
					);
			getout(7, errmsg);
		}
		printf("parent: successfullly wrote %s to child in %s\n", 
				h(lbuff, sizeof(lbuff), buffsize*1024), 
				ht(fbuff, sizeof(fbuff), &elapsed));
		buffsize <<=1;
		read(controlfd[0], &child_read_bytes, sizeof(child_read_bytes));
	}
}


main ()
{

	/* only 1 instance of parent writer and child reader in this
	 * test case, so only 1 pair of pipe descriptors */
	
	
	if (pipe(pipefd)<0) {
		perror("pipefd pipe");
		exit(1);
	}

	if (pipe(controlfd)<0) {
		perror("controlfd pipe");
		exit(1);
	}
	
	signal(SIGPIPE, sighandler);


	pid=fork();
	if (pid<0) {
		perror("fork");
		exit(2);
	}
	/* no lvalue as neither sub should return */
	pid ? parent_pipe_writer(): child_pipe_reader();
	perror("FATAL: unexpected return from proc");
	exit(-1);
}


/* vim:ts=4:sw=4
 */

--------------090704070705030503000705--
