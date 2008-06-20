Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbYFTTcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbYFTTcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 15:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbYFTTbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 15:31:43 -0400
Received: from louie.udel.edu ([128.4.40.12]:42662 "EHLO mail.eecis.udel.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbYFTTbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 15:31:42 -0400
X-Greylist: delayed 1619 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jun 2008 15:31:42 EDT
Message-ID: <485BFF43.80404@cis.udel.edu>
Date: Fri, 20 Jun 2008 15:04:35 -0400
From: Ezra Kissel <kissel@cis.udel.edu>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
To: linux-kernel@vger.kernel.org
Subject: network socket receive splice size
X-Sanitizer: This message has been sanitized!
X-Sanitizer-URL: http://mailtools.anomy.net/
X-Sanitizer-Rev: UDEL-ECECIS: Sanitizer.pm,v 1.64 2002/10/22 MIME-Version: 1.0
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am using the splice syscall in kernel 2.6.25.4 with network socket 
receive to splice incoming and outgoing TCP sockets. I perform something 
like the following:

#define SPLICE_SIZE (12*1024)

int fd[2];
ret = pipe(fd);

ret = splice(src, NULL, fd[1], NULL, SPLICE_SIZE, SPLICE_F_MORE | 
SPLICE_F_MOVE);

bytes_left = ret;

while (bytes_left > 0) {
   ret = splice(fd[0], NULL, sink, NULL, bytes_left, SPLICE_F_NONBLOCK);
   bytes_left -= ret;
}

This works well when SPLICE_SIZE is around 12K or lower, but anything 
much more than that will cause the src splice call to block either right 
away or after a few iterations. It almost seems as though the pipe 
buffer is becoming full although I have used poll to check for both 
sockets and pipe fds before calling splice, and the sink splice call 
always sends the current number of bytes. I have also tried virtually 
all combinations of the SPLICE_F_ options without success. Has anyone 
run into a similar issue with socket-to-socket splicing and larger 
splice sizes? I would really like to use the full 64K splice size to and 
from the pipe.

I should mention that the splice test applications do work correctly 
with 64K splice sizes when splicing to/from a network socket(s) to 
STDOUT or STDIN. Any thoughts?
