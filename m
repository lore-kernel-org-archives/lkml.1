Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbZGCMh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbZGCMh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbZGCMhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:37:17 -0400
Received: from ey-out-1920.google.com ([74.125.78.147]:48491 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbZGCMhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:37:13 -0400
Message-ID: <4A4DFB77.1080700@petalogix.com>
Date: Fri, 03 Jul 2009 14:37:11 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>,
       John Williams <john.williams@petalogix.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Grant Likely <grant.likely@secretlab.ca>, subrata@linux.vnet.ibm.com
Subject: mmap syscall problem
Content-Type: multipart/mixed;
 boundary="------------040404010105000505070108"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040404010105000505070108
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi all,

I am trying to solve problem with mmap syscall on Microblaze which I have.
I am running mmap01 test program from LTP. In attachment is hacked
version and inline version is below too.

Here is the simple mmap test description
1. open temp file
2. write there hello word (in my case ABCD\n EFGH\n - for better tracing
0x41424344 0a20 45464748 0a20)
3. then find a place for allocation of mmap
4. before mmap fill this place with A - whole place (0x41 in hex)
5. then called mmap - map file with string to place which was filled by A.
6a. Correct behavior is that this place must contain only the same data
as was in file (not any A chars) (the rest of chars should be zero)
6b. Wrong behavior is that this place contain any (0x41) data - which is
my case

The facts which I know:
1. Problem is not relate with caches - We tried to run in on system
without cache and the problem is the same
2. Microblaze implementation of sys_mmap02 is the same as is for sparc,
blackfin, m68k and others.
Arnd: Anyway maybe worth to move sys_mmap2 to any generic location. What
do you think?

I copy&paste two output of that program. First checking loop show that
there are old data and second that
data are correct from address 0x10026010. Every run I am getting
different values - sometimes

First log
# ./mmap
dummy 0x10005050, addr 0x10026000, sbrk 0x100006c0 0x1000
file size=0x18, first writing addr=0x10026018
0x10026000: 0x41414141
0x10026004: 0x41414141
0x10026008: 0x41414141
0x1002600c: 0x41414141
0x10026010: 0x41414141
0x10026014: 0x41414141
0x10026018: 0x41414141
0x1002601c: 0x41414141
0x10026020: 0x41414141
0x10026024: 0x41414141
0x10026028: 0x41414141
0x1002602c: 0x41414141
0x10026030: 0x41414141
0x10026034: 0x41414141
0x10026038: 0x41414141
------------
0x10026000: 0x41424344
0x10026004: 0x0a204546
0x10026008: 0x47480a20
0x1002600c: 0x626c6120
0x10026010: 0x626c6120
0x10026014: 0x626c610a
0x10026018: 0x11121300
0x1002601c: 0x00000000
0x10026020: 0x00000000
0x10026024: 0x00000000
0x10026028: 0x00000000
0x1002602c: 0x00000000
0x10026030: 0x00000000
0x10026034: 0x00000000
0x10026038: 0x00000000

Second log
# ./mmap
dummy 0x10005050, addr 0x10026000, sbrk 0x100006c0 0x1000
file size=0x18, first writing addr=0x10026018
0x10026000: 0x41414141
0x10026004: 0x41414141
0x10026008: 0x41414141
0x1002600c: 0x41414141
0x10026010: 0x626c6120
0x10026014: 0x626c610a
0x10026018: 0x11121300
0x1002601c: 0x00000000
0x10026020: 0x00000000
0x10026024: 0x00000000
0x10026028: 0x00000000
0x1002602c: 0x00000000
0x10026030: 0x00000000
0x10026034: 0x00000000
0x10026038: 0x00000000
------------
0x10026000: 0x41424344
0x10026004: 0x0a204546
0x10026008: 0x47480a20
0x1002600c: 0x626c6120
0x10026010: 0x626c6120
0x10026014: 0x626c610a
0x10026018: 0x11121300
0x1002601c: 0x00000000
0x10026020: 0x00000000
0x10026024: 0x00000000
0x10026028: 0x00000000
0x1002602c: 0x00000000
0x10026030: 0x00000000
0x10026034: 0x00000000
0x10026038: 0x00000000


If I add any code which do any loop for delay program a little bit -
program passed that's why
I think that my problem could be related with any timing issue.
I tried to run that test on x86 and there is no problem with that test
but doesn't mean that
the problem is not there too (just x86 is much faster than Microblaze)

Do you have any idea what could be wrong?

Thanks for your hints,
Michal


/*
 *
 *   Copyright (c) International Business Machines  Corp., 2001
 *
 *   This program is free software;  you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
 *   the GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program;  if not, write to the Free Software
 *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

/*
 * Test Name: mmap01
 *
 * Test Description:
 *  Verify that, mmap() succeeds when used to map a file where size of the
 *  file is not a multiple of the page size, the memory area beyond the end
 *  of the file to the end of the page is accessible. Also, verify that
 *  this area is all zeroed and the modifications done to this area are
 *  not written to the file.
 *
 * Expected Result:
 *  mmap() should succeed returning the address of the mapped region.
 *  The memory area beyond the end of file to the end of page should be
 *  filled with zero.
 *  The changes beyond the end of file should not get written to the file.
 *
 * Algorithm:
 *  Setup:
 *   Setup signal handling.
 *   Pause for SIGUSR1 if option specified.
 *   Create temporary directory.
 *
 *  Test:
 *   Loop if the proper options are given.
 *   Execute system call
 *   Check return code, if system call failed (return=-1)
 *    Log the errno and Issue a FAIL message.
 *   Otherwise,
 *    Verify the Functionality of system call
 *      if successful,
 *        Issue Functionality-Pass message.
 *      Otherwise,
 *        Issue Functionality-Fail message.
 *  Cleanup:
 *   Print timing stats if options given
 *   Delete the temporary directory created.
 *
 * Usage:  <for command-line>
 *  mmap01 [-c n] [-f] [-i n] [-I x] [-P x] [-t]
 *     where,  -c n : Run n copies concurrently.
 *             -f   : Turn off functionality Testing.
 *           -i n : Execute test n times.
 *           -I x : Execute test for x seconds.
 *           -P x : Pause for x seconds between iterations.
 *           -t   : Turn on syscall timing.
 *
 * HISTORY
 *    07/2001 Ported by Wayne Boyer
 *
 * RESTRICTIONS:
 *  None.
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <signal.h>
#include <stdint.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/shm.h>

#define TEMPFILE    "mmapfile"

char *TCID = "mmap01";        /* Test program identifier.    */
int TST_TOTAL = 1;        /* Total number of test cases. */
extern int Tst_count;        /* Test Case counter for tst_* routines */
char *addr;            /* addr of memory mapped region */
char *dummy;            /* dummy string */
size_t page_sz;            /* system page size */
size_t file_sz;            /* mapped file size */
int fildes;            /* file descriptor for tempfile */
char Cmd_buffer[BUFSIZ];    /* command buffer to hold test command */

void setup();            /* Main setup function of test */
void cleanup();            /* cleanup function for the test */

int main(int ac, char **av)
{
    int lc;            /* loop counter */
    char *msg;        /* message returned from parse_opts */
    int i;
    /* Perform global setup for test */
    struct stat stat_buf;
    char write_buf[] = "ABCD\n EFGH\n"; //41424344

    /* Creat a temporary file used for mapping */
    if ((fildes = open(TEMPFILE, O_RDWR | O_CREAT, 0666)) < 0) {
        printf( "open() on %s Failed, errno=%d : %s", TEMPFILE, errno,
strerror(errno));
        cleanup();
    }

    /* Write some data into temporary file */
    if (write(fildes, write_buf, strlen(write_buf)) != strlen(write_buf)) {
        printf("write() on %s Failed, errno=%d : %s", TEMPFILE, errno,
strerror(errno));
        cleanup();
    }

    /* Get the size of temporary file */
    if (stat(TEMPFILE, &stat_buf) < 0) {
        printf( "stat() on %s Failed, errno=%d : %s", TEMPFILE, errno,
strerror(errno));
        cleanup();
    }
    file_sz = stat_buf.st_size;

    /* Get the system page size */
    if ((page_sz = getpagesize()) < 0) {
        printf("getpagesize() fails to get system page size");
        cleanup();
    }

    /* Allocate and initialize dummy string of system page size bytes */
    if ((dummy = (char *)calloc(page_sz, sizeof(char))) == NULL) {
        printf("calloc() failed to allocate space");
        cleanup();
    }

    /*
     * Initialize addr to align with the first segment boundary address
     * above the break address of the process.
     */
    addr = (void *)(((intptr_t) sbrk(0) + (SHMLBA - 1)) & ~(SHMLBA - 1));

    printf("dummy 0x%x, addr 0x%x, sbrk 0x%x 0x%x\n", dummy, addr, sbrk,
SHMLBA);

    /* Set the break address of the process to the addr plus one
     * page size.
     */
    if ((intptr_t) sbrk(SHMLBA + page_sz) == -1) {
        printf("sbrk(SHMLBA + page_sz) failed");
        cleanup();
    }

    /* Initialize one page region from addr with 'A' */
    memset(addr, 'A', page_sz);


#if 0
/* delayed loops */
/* Hera is one loop which read all data which are in addr -> all are
0x41414141 which is correct */
    int *test = (int *)addr;

    /* +1 caused that I read one word after allocated space */
    for( i = 0; i<(page_sz/4 + 1); i++) {
        printf("0x%x: 0x%x\n", test, *test);
        test++;
    }


/* test with printf - on nfs works, on initramfs sometimes failed */
    printf("hello\n");

/* test with syscall */
    sync();
#endif

        /*
         * Call mmap to map the temporary file beyond EOF
         * with write access.
         */
        errno = 0;
        addr = mmap(addr, page_sz, PROT_READ | PROT_WRITE,
                MAP_FILE | MAP_SHARED | MAP_FIXED, fildes, 0);

        /* Check for the return value of mmap() */
        if (addr == MAP_FAILED) {
            printf("mmap() Failed on %s, errno=%d : %s",
                 TEMPFILE, errno, strerror(errno));
        }


    printf("file size=0x%x, first writing addr=0x%x\n", file_sz,
&addr[file_sz]);

/* 1. checking loop after mmap */
/* read fist 15 words mmap memory */
    int *file = (int *)addr;
    for( i = 0; i<(15); i++) {
        printf("0x%x: 0x%08x\n", file, *file);
        file++;
    }

    /*
     * Initialize memory beyond file size
     */
    addr[file_sz] = 0x11;
    addr[file_sz + 1] = 0x12;
    addr[file_sz + 2] = 0x13;

/* 2. checking after writing - always is correct */
    printf("------------\n");
    file = (int *)addr;
    for( i = 0; i<(15); i++) {
        printf("0x%x: 0x%08x\n", file, *file);
        file++;
    }

    /*
     * Synchronize the mapped memory region
     * with the file.
     */
    if (msync(addr, page_sz, MS_SYNC) != 0) {
        printf("msync() failed to "
                "synchronize mapped file, error:%d",
                errno);
        cleanup();
    }

    /* Create the command which will be executed in the test */
    sprintf(Cmd_buffer, "grep XYZ %s > /dev/null", TEMPFILE);


    /*
        * Now, Search for the pattern 'XYZ' in the
        * temporary file.  The pattern should not be
        * found and the return value should be 1.
        */
    if (system(Cmd_buffer) != 0) {
        printf("Functionality of mmap() successful");
    } else {
        printf("Specified pattern found in file");
    }




        /* Clean up things in case we are looping */
        /* Unmap the mapped memory */
        if (munmap(addr, page_sz) != 0) {
            printf("munmap() fails to unmap the "
                 "memory, errno=%d", errno);
        }




    /* Call cleanup() to undo setup done for the test. */
    cleanup();
     /*NOTREACHED*/ return 0;
}                /* End main */

/*
 * cleanup() - performs all ONE TIME cleanup for this test at
 *             completion or premature exit.
 *           Free the memory allocated to  variable.
 *           Remove the temporary directory created.
 */
void cleanup()
{
    /*
     * print timing stats if that option was specified.
     */
    close(fildes);

    /* Free the memory allocated for dummy string */
    if (dummy) {
        free(dummy);
    }
}











-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663


--------------040404010105000505070108
Content-Type: text/x-csrc;
 name="mmap.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mmap.c"

/*
 *
 *   Copyright (c) International Business Machines  Corp., 2001
 *
 *   This program is free software;  you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
 *   the GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program;  if not, write to the Free Software
 *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

/*
 * Test Name: mmap01
 *
 * Test Description:
 *  Verify that, mmap() succeeds when used to map a file where size of the
 *  file is not a multiple of the page size, the memory area beyond the end
 *  of the file to the end of the page is accessible. Also, verify that
 *  this area is all zeroed and the modifications done to this area are
 *  not written to the file.
 *
 * Expected Result:
 *  mmap() should succeed returning the address of the mapped region.
 *  The memory area beyond the end of file to the end of page should be
 *  filled with zero.
 *  The changes beyond the end of file should not get written to the file.
 *
 * Algorithm:
 *  Setup:
 *   Setup signal handling.
 *   Pause for SIGUSR1 if option specified.
 *   Create temporary directory.
 *
 *  Test:
 *   Loop if the proper options are given.
 *   Execute system call
 *   Check return code, if system call failed (return=-1)
 *	Log the errno and Issue a FAIL message.
 *   Otherwise,
 *	Verify the Functionality of system call
 *      if successful,
 *		Issue Functionality-Pass message.
 *      Otherwise,
 *		Issue Functionality-Fail message.
 *  Cleanup:
 *   Print timing stats if options given
 *   Delete the temporary directory created.
 *
 * Usage:  <for command-line>
 *  mmap01 [-c n] [-f] [-i n] [-I x] [-P x] [-t]
 *     where,  -c n : Run n copies concurrently.
 *             -f   : Turn off functionality Testing.
 *	       -i n : Execute test n times.
 *	       -I x : Execute test for x seconds.
 *	       -P x : Pause for x seconds between iterations.
 *	       -t   : Turn on syscall timing.
 *
 * HISTORY
 *	07/2001 Ported by Wayne Boyer
 *
 * RESTRICTIONS:
 *  None.
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <signal.h>
#include <stdint.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/shm.h>

#define TEMPFILE	"mmapfile"

char *TCID = "mmap01";		/* Test program identifier.    */
int TST_TOTAL = 1;		/* Total number of test cases. */
extern int Tst_count;		/* Test Case counter for tst_* routines */
char *addr;			/* addr of memory mapped region */
char *dummy;			/* dummy string */
size_t page_sz;			/* system page size */
size_t file_sz;			/* mapped file size */
int fildes;			/* file descriptor for tempfile */
char Cmd_buffer[BUFSIZ];	/* command buffer to hold test command */

void setup();			/* Main setup function of test */
void cleanup();			/* cleanup function for the test */

int main(int ac, char **av)
{
	int lc;			/* loop counter */
	char *msg;		/* message returned from parse_opts */
	int i;
	/* Perform global setup for test */
	struct stat stat_buf;
	char write_buf[] = "ABCD\n EFGH\n"; //41424344 

	/* Creat a temporary file used for mapping */
	if ((fildes = open(TEMPFILE, O_RDWR | O_CREAT, 0666)) < 0) {
		printf( "open() on %s Failed, errno=%d : %s", TEMPFILE, errno, strerror(errno));
		cleanup();
	}

	/* Write some data into temporary file */
	if (write(fildes, write_buf, strlen(write_buf)) != strlen(write_buf)) {
		printf("write() on %s Failed, errno=%d : %s", TEMPFILE, errno, strerror(errno));
		cleanup();
	}

	/* Get the size of temporary file */
	if (stat(TEMPFILE, &stat_buf) < 0) {
		printf( "stat() on %s Failed, errno=%d : %s", TEMPFILE, errno, strerror(errno));
		cleanup();
	}
	file_sz = stat_buf.st_size;

	/* Get the system page size */
	if ((page_sz = getpagesize()) < 0) {
		printf("getpagesize() fails to get system page size");
		cleanup();
	}

	/* Allocate and initialize dummy string of system page size bytes */
	if ((dummy = (char *)calloc(page_sz, sizeof(char))) == NULL) {
		printf("calloc() failed to allocate space");
		cleanup();
	}

	/*
	 * Initialize addr to align with the first segment boundary address
	 * above the break address of the process.
	 */
	addr = (void *)(((intptr_t) sbrk(0) + (SHMLBA - 1)) & ~(SHMLBA - 1));

	printf("dummy 0x%x, addr 0x%x, sbrk 0x%x 0x%x\n", dummy, addr, sbrk, SHMLBA);

	/* Set the break address of the process to the addr plus one
	 * page size.
	 */
	if ((intptr_t) sbrk(SHMLBA + page_sz) == -1) {
		printf("sbrk(SHMLBA + page_sz) failed");
		cleanup();
	}

	/* Initialize one page region from addr with 'A' */
	memset(addr, 'A', page_sz);


#if 0
/* delayed loops */
/* Hera is one loop which read all data which are in addr -> all are 0x41414141 which is correct */
	int *test = (int *)addr;

	/* +1 caused that I read one word after allocated space */ 
	for( i = 0; i<(page_sz/4 + 1); i++) {
		printf("0x%x: 0x%x\n", test, *test);
		test++;
	}


/* test with printf - on nfs works, on initramfs sometimes failed */
	printf("hello\n");

/* test with syscall */
	sync();
#endif

		/*
		 * Call mmap to map the temporary file beyond EOF
		 * with write access.
		 */
		errno = 0;
		addr = mmap(addr, page_sz, PROT_READ | PROT_WRITE,
			    MAP_FILE | MAP_SHARED | MAP_FIXED, fildes, 0);

		/* Check for the return value of mmap() */
		if (addr == MAP_FAILED) {
			printf("mmap() Failed on %s, errno=%d : %s",
				 TEMPFILE, errno, strerror(errno));
		}


	printf("file size=0x%x, first writing addr=0x%x\n", file_sz, &addr[file_sz]);

/* 1. checking loop after mmap */
/* read fist 15 words mmap memory */
	int *file = (int *)addr;
	for( i = 0; i<(15); i++) {
		printf("0x%x: 0x%08x\n", file, *file);
		file++;
	}

	/*
	 * Initialize memory beyond file size
	 */
	addr[file_sz] = 0x11;
	addr[file_sz + 1] = 0x12;
	addr[file_sz + 2] = 0x13;

/* 2. checking after writing - always is correct */
	printf("------------\n");
	file = (int *)addr;
	for( i = 0; i<(15); i++) {
		printf("0x%x: 0x%08x\n", file, *file);
		file++;
	}

	/*
	 * Synchronize the mapped memory region
	 * with the file.
	 */
	if (msync(addr, page_sz, MS_SYNC) != 0) {
		printf("msync() failed to "
				"synchronize mapped file, error:%d",
				errno);
		cleanup();
	}

	/* Create the command which will be executed in the test */
	sprintf(Cmd_buffer, "grep XYZ %s > /dev/null", TEMPFILE);


	/*
		* Now, Search for the pattern 'XYZ' in the
		* temporary file.  The pattern should not be
		* found and the return value should be 1.
		*/
	if (system(Cmd_buffer) != 0) {
		printf("Functionality of mmap() successful");
	} else {
		printf("Specified pattern found in file");
	}




		/* Clean up things in case we are looping */
		/* Unmap the mapped memory */
		if (munmap(addr, page_sz) != 0) {
			printf("munmap() fails to unmap the "
				 "memory, errno=%d", errno);
		}




	/* Call cleanup() to undo setup done for the test. */
	cleanup();
	 /*NOTREACHED*/ return 0;
}				/* End main */

/*
 * cleanup() - performs all ONE TIME cleanup for this test at
 *             completion or premature exit.
 *	       Free the memory allocated to  variable.
 *	       Remove the temporary directory created.
 */
void cleanup()
{
	/*
	 * print timing stats if that option was specified.
	 */
	close(fildes);

	/* Free the memory allocated for dummy string */
	if (dummy) {
		free(dummy);
	}
}

--------------040404010105000505070108--
