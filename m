Return-Path: <linux-kernel-owner+w=401wt.eu-S933083AbXCVT1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083AbXCVT1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933985AbXCVT1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:27:41 -0400
Received: from nlpi042.sbcis.sbc.com ([207.115.36.71]:13359 "EHLO
	nlpi042.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933083AbXCVT1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:27:40 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Mar 2007 15:27:40 EDT
Message-ID: <4602D6FD.6030505@gmail.com>
Date: Thu, 22 Mar 2007 14:20:29 -0500
From: Bruce Dubbs <bruce.dubbs@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2pre) Gecko/20070119 SeaMonkey/1.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Possible Bug in mincore or mmap
Content-Type: multipart/mixed;
 boundary="------------070805020606080809060007"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070805020606080809060007
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

When testing an installation with tests from the Linux Test Project, my
kernels fail one instance of the mincore01 tests:

mincoremincore01    1  PASS  :  expected failure: errno = 22 (Invalid
argument)
mincore01    2  PASS  :  expected failure: errno = 14 (Bad address)
mincore01    3  FAIL  :  call succeeded unexpectedly
mincore01    4  PASS  :  expected failure: errno = 12 (Cannot allocate
memory)01    1  PASS  :  expected failure: errno = 22 (Invalid argument)
mincore01    2  PASS  :  expected failure: errno = 14 (Bad address)
mincore01    3  FAIL  :  call succeeded unexpectedly
mincore01    4  PASS  :  expected failure: errno = 12 (Cannot allocate
memory)

I pared down the test to the attached program.  The result is supposed
to fail as it is asking for memory information 5 times what should be
allocated.

Upon experimenting, I found the test works properly if a printf is
executed before the mmap call.  I have tested on locally built, but
unmodified, 2.4.25, 2.6.12.5, and a 2.6.20.3 kernels and get the same
behavior.  The tests fail on IA32 architecture, but not 64-bit kernels.
 The test always works properly on FC6 and RHEL3.

I've checked the archives for this issue and could not find anything
appropriate.

Could this be a potential security issue as memory that is not supposed
to be accessible seems to be available to the user?  Is it expected
behavior?

Thanks.

  -- Bruce

--------------070805020606080809060007
Content-Type: text/plain;
 name="min.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="min.c"

#include <sys/mman.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

static int   PAGESIZE;
static char  file_name[]    = "fooXXXXXX";
static void* global_pointer = NULL;
static int   global_len     = 0;
static int   file_desc      = 0;

int main(int argc, char **argv)
{
    int             i;
    int             result;
    char*           buf;
    unsigned char   vect[20] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    

    PAGESIZE = getpagesize();
    
    /* global_pointer will point to a mmapped area of global_len bytes */
    global_len = PAGESIZE*2;
    
    buf = (char*)malloc(global_len);
    memset(buf, 42, global_len);  // Asterisks 
    
    /* create a temporary file */
    file_desc = mkstemp(file_name);
    
    /* fill the temporary file with two pages of data */
    write(file_desc, buf, global_len);
    free(buf);
    
    // Will work properly as long as print is before mmap function.
    if ( argc > 1 ) printf("argc=%d\n", argc);

    /* map the file in memory */
    global_pointer = mmap( NULL, global_len,
            PROT_READ|PROT_WRITE|PROT_EXEC, MAP_SHARED, file_desc, 0);

    // Result should be -1 as the request is 5 times actual mapping
    result = mincore(global_pointer, (size_t)(global_len*5), vect);

    // Print some data
    printf("PAGESIZE=%d\n", PAGESIZE);
    printf("global_len=%d\n", global_len);
    printf("global_pointer=0x%x\n", (unsigned int)global_pointer);
    printf("alloc=%d\n", (global_len+PAGESIZE-1) / PAGESIZE );
    printf("Result=%d\n", result);
    printf("vect: ");

    for ( i=0; i<20; i++) printf("%02x ", vect[i]);
    printf("\n");
    
    // Clean up
    munmap(global_pointer, (size_t)global_len);
    close(file_desc);
    unlink(file_name);
}

--------------070805020606080809060007--
