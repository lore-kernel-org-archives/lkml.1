Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbZBHKwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbZBHKwf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 05:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbZBHKw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 05:52:27 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:35660 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbZBHKw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 05:52:26 -0500
Date: Sun, 8 Feb 2009 12:52:22 +0200
From: Sami Farin <safari-kernel@safari.iki.fi>
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.28.4 regression: mmap fails if mlockall used
Message-ID: <20090208105222.hj7zhcyxyqfjeobt@m.safari.iki.fi>
Mail-Followup-To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wbuogm33ghr3t2c6"
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wbuogm33ghr3t2c6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

2.6.28.2 + gcc-4.3.2-7 works.
2.6.28.4 + gcc-4.4.0-0.16 does not work.
I run x86_64 SMP kernel.

# strace ./a.out ntp
12:10:14.780726 mmap(NULL, 2147624, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = -1 EFAULT (Bad address) <0.000038>
12:10:14.780809 close(3)                = 0 <0.000012>
12:10:14.780856 munmap(0x7f3476e0d000, 421232) = 0 <0.000145>
12:10:14.781054 write(2, "./a.out: getpwnam failed: Success\n"..., 34./a.out: getpwnam failed: Success
) = 34 <0.000015>

I can do malloc(3000000), then mmap call is
12:50:20.694207 mmap(NULL, 3002368, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f8a8d16b000 <0.003078>

-- 
"When playing Russian roulette, the fact that the first shot
 got off safely is little comfort for the next." - Richard Feynman


--wbuogm33ghr3t2c6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="getpw.c"

#include <string.h>
#include <errno.h>
#include <stdio.h>
#include <sys/types.h>
#include <pwd.h>
#include <sys/mman.h>

int main(int argc, char *argv[])
{
  struct passwd *pw;

  if (mlockall(MCL_CURRENT | MCL_FUTURE) == -1) {
    fprintf(stderr, "%s: mlockall failed: %s\n",
            argv[0], strerror(errno));
  }
  if (argc != 2) return 1;
  errno = 0;
  pw = getpwnam(argv[1]);
  if (pw == NULL) {
    fprintf(stderr, "%s: getpwnam failed: %s\n",
            argv[0], strerror(errno));
    return 1;
  }
  fprintf(stdout, "uid=%u gid=%u\n",
          (unsigned int)pw->pw_uid, (unsigned int)pw->pw_gid);
  fflush(stdout);
  return 0;
}


--wbuogm33ghr3t2c6--
