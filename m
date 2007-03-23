Return-Path: <linux-kernel-owner+w=401wt.eu-S934253AbXCWAxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934253AbXCWAxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 20:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934251AbXCWAxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 20:53:05 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:25616 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934253AbXCWAxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 20:53:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=sTT3ASQmKW0RH6xzBcb+bLbsYcCJVS3a99hQG1AJUHwskKIKiFnA7H55IHOyVw9CitLGZw8/RlB2yQ2aUX9DI2pvkFhcm+BbPIYunCIu7mLhRnXj4seHplIJfUd4B0B/8Y2/+nnnUvKpiInfiqvwvPKIiclVMGlzKFidODbsrgQ=  ;
X-YMail-OSG: YtqKtVoVM1lqcf0WqBJWYWDk57xa9FVKbnFSfEmgOs53cpVICpkar32DNmd2mlVI_Ur1MVqQydp0Chv.ePWNV2p5mtTvLjNNqXG3MGx.jOWjXggLPb9cPw--
Message-ID: <460324DF.6040109@yahoo.com.au>
Date: Fri, 23 Mar 2007 11:52:47 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Bruce Dubbs <bruce.dubbs@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Possible Bug in mincore or mmap
References: <4602D6FD.6030505@gmail.com>
In-Reply-To: <4602D6FD.6030505@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bruce Dubbs wrote:
> When testing an installation with tests from the Linux Test Project, my
> kernels fail one instance of the mincore01 tests:
> 
> mincoremincore01    1  PASS  :  expected failure: errno = 22 (Invalid
> argument)
> mincore01    2  PASS  :  expected failure: errno = 14 (Bad address)
> mincore01    3  FAIL  :  call succeeded unexpectedly
> mincore01    4  PASS  :  expected failure: errno = 12 (Cannot allocate
> memory)01    1  PASS  :  expected failure: errno = 22 (Invalid argument)
> mincore01    2  PASS  :  expected failure: errno = 14 (Bad address)
> mincore01    3  FAIL  :  call succeeded unexpectedly
> mincore01    4  PASS  :  expected failure: errno = 12 (Cannot allocate
> memory)
> 
> I pared down the test to the attached program.  The result is supposed
> to fail as it is asking for memory information 5 times what should be
> allocated.
> 
> Upon experimenting, I found the test works properly if a printf is
> executed before the mmap call.  I have tested on locally built, but
> unmodified, 2.4.25, 2.6.12.5, and a 2.6.20.3 kernels and get the same
> behavior.  The tests fail on IA32 architecture, but not 64-bit kernels.
>  The test always works properly on FC6 and RHEL3.
> 
> I've checked the archives for this issue and could not find anything
> appropriate.
> 
> Could this be a potential security issue as memory that is not supposed
> to be accessible seems to be available to the user?  Is it expected
> behavior?

It shouldn't be a security problem if mincore doesn't actually
return the data.

The other thing is, that test may not be valid, because it doesn't
guarantee that you have nothing mapped immediately after the
global_pointer region. Maybe a difference in address space layout
is causing it to "correctly" fail on x86-64.




> 
> Thanks.
> 
>   -- Bruce
> 
> 
> ------------------------------------------------------------------------
> 
> #include <sys/mman.h>
> #include <stdlib.h>
> #include <string.h>
> #include <stdio.h>
> 
> static int   PAGESIZE;
> static char  file_name[]    = "fooXXXXXX";
> static void* global_pointer = NULL;
> static int   global_len     = 0;
> static int   file_desc      = 0;
> 
> int main(int argc, char **argv)
> {
>     int             i;
>     int             result;
>     char*           buf;
>     unsigned char   vect[20] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
>     
> 
>     PAGESIZE = getpagesize();
>     
>     /* global_pointer will point to a mmapped area of global_len bytes */
>     global_len = PAGESIZE*2;
>     
>     buf = (char*)malloc(global_len);
>     memset(buf, 42, global_len);  // Asterisks 
>     
>     /* create a temporary file */
>     file_desc = mkstemp(file_name);
>     
>     /* fill the temporary file with two pages of data */
>     write(file_desc, buf, global_len);
>     free(buf);
>     
>     // Will work properly as long as print is before mmap function.
>     if ( argc > 1 ) printf("argc=%d\n", argc);
> 
>     /* map the file in memory */
>     global_pointer = mmap( NULL, global_len,
>             PROT_READ|PROT_WRITE|PROT_EXEC, MAP_SHARED, file_desc, 0);
> 
>     // Result should be -1 as the request is 5 times actual mapping
>     result = mincore(global_pointer, (size_t)(global_len*5), vect);
> 
>     // Print some data
>     printf("PAGESIZE=%d\n", PAGESIZE);
>     printf("global_len=%d\n", global_len);
>     printf("global_pointer=0x%x\n", (unsigned int)global_pointer);
>     printf("alloc=%d\n", (global_len+PAGESIZE-1) / PAGESIZE );
>     printf("Result=%d\n", result);
>     printf("vect: ");
> 
>     for ( i=0; i<20; i++) printf("%02x ", vect[i]);
>     printf("\n");
>     
>     // Clean up
>     munmap(global_pointer, (size_t)global_len);
>     close(file_desc);
>     unlink(file_name);
> }


-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
