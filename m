Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbYAIKmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbYAIKmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 05:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbYAIKmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 05:42:15 -0500
Received: from mail01a.internetmailserver.net ([64.79.161.46]:47290 "HELO
	mail01.internetmailserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1751149AbYAIKmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 05:42:14 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jan 2008 05:42:14 EST
Message-ID: <39848.76.189.45.79.1199874932.squirrel@webmail.kavaga.com>
Date: Wed, 9 Jan 2008 02:35:32 -0800 (PST)
Subject: Possible 2.6.24-rc7 issue w/respect to pthreads
From: tom@kavaga.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20080109023532_35125"
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_20080109023532_35125
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

To Whom It May Concern,

After I patched my 2.6.23 kernel to 2.6.24-rc7 this morning, I noticed
some odd behavior with respect to POSIX threads in a test program I had
written (originally to test epoll.)

The behavior is as follows:

1.  main() creates a new thread of execution with pthread_create
2.  thread_func() immediately calls pthread_detach(), which is supposed to
ensure that thread resources are cleaned up when the thread terminates.
3.  The spawned thread sleeps and then prints a message "got here"
4.  The main thread calls pthread_join().  According to the POSIX
documentation, this should suspend execution until the spawned thread has
terminated.

What I'm seeing is that the main thread terminates immediately.  If I
comment out the call to pthread_detach(), the program runs normally.  If I
boot with my 2.6.23 kernel, the program runs normally.

I'm not sure if this is some oversight on my part but similar programs
operate correctly on my Debian etch installation with 2.6.18 as well as
with the newer 23 kernel, but not with the patch.

If you have any questions, don't hesitate to email me; my address is
provided below.

See Attached (bug.c)

Tom R. Dial
tom@kavaga.com
------=_20080109023532_35125
Content-Type: text/x-csrc; name="bug.c"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="bug.c"

//
// bug.c
//
// Author: Tom R. Dial  <tom@kavaga.com>
//
// This simple program demonstrates what I believe to be a problem
// with the 2.6.24-rc7 kernel.  thread_func() starts by calling
// pthread_detach(), which according to POSIX (as I read it) is
// *supposed* to ensure that thread resources are cleaned up when
// the thread terminates.  This seemed to work in 2.6.23, but when
// I applied the patch for rc7, I noticed that main() seems to
// terminate immediately.  The sample program sleeps and prints
// a message from the spawned thread.  The call to pthread_join()
// in main should ensure that this message gets printed.  If the
// call to pthread_detach() is commented out, the program functions
// as expected and prints the "got here" message.  If the call
// to pthread_detach() is made, the program exits immediately
// without printing the error message.
//
// gcc -Wall -lpthread -o bug bug.c

#include <errno.h>
#include <pthread.h>
#include <stdio.h>
#include <unistd.h>

void* thread_func(void* param)
{
   int ptd = 0;
   ptd = pthread_detach( pthread_self() );
   //printf("pthread_detach() returned %d, errno=%d\n", ptd, errno );
   sleep( 10 );
   printf("got here\n");
   return 0;
}

int main(int argc, char** argv)
{
   pthread_t thread = 0;
   int status = 0;
   
   status = pthread_create( &thread, 0, thread_func, 0 );
   if (status < 0)
   {
      printf( "pthread_create() returned %d, errno=%d\n", status, errno );
      return 0;            
   }
   
   pthread_join( thread, 0 );
   
   return 0;
}
------=_20080109023532_35125--


