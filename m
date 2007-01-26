Return-Path: <linux-kernel-owner+w=401wt.eu-S1751020AbXAZKhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751020AbXAZKhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 05:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932608AbXAZKhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 05:37:40 -0500
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:23306 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbXAZKhj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 05:37:39 -0500
X-IronPort-AV: i="4.13,242,1167627600"; 
   d="scan'208"; a="397481603:sNHT27909728"
From: "Matthew Kirk" <mkirk01@rcn.com>
To: <linux-kernel@vger.kernel.org>
Subject: fsync occasionally very slow
Date: Fri, 26 Jan 2007 05:37:38 -0500
Message-ID: <001a01c74136$0028ecf0$6600a8c0@charm>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1250"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-index: AcdBNf/QsRczZ+KuR+ytDGFLU3Tbiw==
X-Junkmail-Status: score=10/50, host=mr08.lnh.mail.rcn.net
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A09020B.45B9D9F1.006B,ss=1,fgs=0,
	ip=207.172.4.11,
	so=2006-05-09 23:27:51,
	dmn=5.2.125/2006-10-10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am working on an application that fsync(2) files and directories as
needed.    I’m seeing intermittent stalls on fsync that can last many
seconds.  The file system is mounted ext3, however I have reproduced the
problem with ext2.  The as scheduler is in use.   I have also tried
deadline.  I have tried 2.6.12.3 (what I’m currently deploying on – yes, I
know it’s old) and 2.6.15 (highest kernel I could easily get to run).  I
have reproduced the problem on both machines with high performance raid
controllers and without.  I haven’t been able to find any reported issues
that describe this problem in a relatively recent kernel (though I did find
some comments about 2.0).

In the original application, data is received from another machine via many
threads.  These threads all write occasionally, usually in chunks of about
1K or 100K (I have also tried using 10M chunks, though some percentage are
still very small).   Half of all files are in the 10-15MB range.  The other
half are very small.  There are also log files that get appended to
regularly. Except for logs, we fsync right before each file is closed.  We
also fsync directories.  Everything is on a single large stripe.  In the
regular application, fsync can happen from any of a number of threads. 

In the application, if one call to fsync blocks, other threads that
subsequently call fsync while the first one is blocked appear to also block.
Once the first thread's fsync releases, the others appear to release too.

I’m not 100% sure it’s fsync vs. some other file system issue.  When I
instrument my code I find that about 90% of the stalls are on fsync, with
the remainder being on other file system operations (e.g. write).  If I
disable fsync in the application I still see stalls, though a little less
frequently.

When running I see what appear to be normal numbers of pdflush jobs (range
2-8, usually 4-5).  When I get application stalls the system is still
otherwise responsive.  I can still start processes, write files, etc.
Typically there are 4-5 pdflushes during stalls too.  CPU utilization (user)
is about 10% and I/O wait is 60-70%.  According to iostat, although blocks
are sometimes getting written during these stalls, they frequently are not.

I have reproduced what I think is the same problem in the stand-alone,
single-threaded source code attached, which opens files, writes to them, and
then only when done writing all files, fsyncs them and closes them in the
order in which they were written. In the standalone application, the first
files that get written take virtually no time to fsync (already flushed),
then once files start to be flushed time will increase, however at least one
file will take a couple seconds to flush, where the others will be in the
range of a few thousandths of a second.

I’m not sure where to go with this now and would appreciate any insights you
have.

Thanks!
Matt Kirk


#include <errno.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <fcntl.h>
#include <string>
#include <iostream>
#include <ostream>
#include <sstream>
const unsigned int bigsize = 10248576;
const unsigned int smallsize = 10248576;

char *buff;
int main (int argc, const char *argv[]) { 
   int q;
   int innerloop = 100;
   int outerloop = 1000;
   int dofsync = 1;
   if (argc > 1) { 
      dofsync=(atoi(argv[1]));
   }
   if (argc > 2) { 
      innerloop=(atoi(argv[2]));
   }
   if (argc == 4) {
      outerloop=(atoi(argv[3]));
   }
   buff = new char[bigsize];
   memset(buff, 1, bigsize);
   int fd[innerloop];
   for (int r = 0; r < outerloop; r++) { 
      struct timeval starttimer,endtimer;
      gettimeofday(&starttimer, NULL);
      int count;
      for (int q = 0; q < innerloop; q++) {
         std::stringstream s; 
         s << "file_" << q+(r*outerloop);
         fd[q] = open(s.str().c_str(), O_RDWR+O_CREAT+O_APPEND);
         if (fd[q] == -1) { std::cout << "Failed to open " << s.str() << "
due to " << errno << std::endl; return(0); }
         if (q % 4 != 1) { 
            count = write(fd[q],(void*) buff, bigsize);
            if (count != bigsize) { std::cout << "write returned " << count
<< " with errno " << errno << std::endl; return (0); }
         } else { 
            count = write(fd[q],(void*) buff, smallsize);
            if (count != smallsize) { 
               std::cout << "write returned " << count << " with errno " <<
errno << std::endl; 
               return (0);
            } 
         }
      }

      for (int q = 0; q < innerloop; q++) {
         struct timeval mytimer, mytimer2;
         gettimeofday(&mytimer, NULL);
         if (dofsync) { 
            count = fsync(fd[q]);
         } else { 
            count = fdatasync(fd[q]);
         }
         gettimeofday(&mytimer2, NULL);
         if (mytimer.tv_usec > mytimer2.tv_usec) {
            mytimer2.tv_sec -= (mytimer.tv_sec+1);
            mytimer2.tv_usec += (1000000-mytimer.tv_usec);
         } else { 
            mytimer2.tv_sec -= mytimer.tv_sec;
            mytimer2.tv_usec -= mytimer.tv_usec;
         }
         
         if (count != 0) { std::cout << "fsync returned " << count << " with
errno " << errno << std::endl; } else { 
            std::cout << " elapsed time for sync of descriptor" << fd[q] << 
	      " was " << mytimer2.tv_sec << "s " << mytimer2.tv_usec 
		      << "usec" << std::endl;
            count = close(fd[q]);
         }
      }
      gettimeofday(&endtimer, NULL);
      if (starttimer.tv_usec > endtimer.tv_usec) {
         endtimer.tv_sec -= (starttimer.tv_sec+1);
         endtimer.tv_usec += (1000000-starttimer.tv_usec);
      } else { 
         endtimer.tv_sec -= starttimer.tv_sec;
         endtimer.tv_usec -= starttimer.tv_usec;
      }
      std::cout << " elapsed time for pass " << r << " was " << 
	endtimer.tv_sec << "s " << endtimer.tv_usec << " usec " <<
std::endl;
   }
   return 0;  
}






-- 
No virus found in this outgoing message.
Checked by AVG Free Edition.
Version: 7.1.410 / Virus Database: 268.17.11/652 - Release Date: 1/25/2007
 
