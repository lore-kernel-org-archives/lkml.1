Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbXDJUjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbXDJUjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 16:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbXDJUjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 16:39:46 -0400
Received: from mabruk.micah.cowan.name ([66.150.225.51]:57704 "EHLO
	mabruk.micah.cowan.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbXDJUjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 16:39:45 -0400
X-Greylist: delayed 1158 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Apr 2007 16:39:45 EDT
Message-ID: <461BF183.10007@cowan.name>
Date: Tue, 10 Apr 2007 13:20:19 -0700
From: Micah Cowan <micah@cowan.name>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Use of SIGXFSZ outside of soft limits
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I would like to object to a non-standard and, IMHO, ill-advised 
application of SIGXFSZ to non-rlimit-related filesize limits, and 
request that its use be minimized as much as possible. SUSv3 does not 
sanction its use in any situation other than that of exceeding the "soft 
file size limit for the process". While, of course, we are free to do as 
we like, and ignore the standards when it is advisable to do so, in this 
case, it seems fairly clear that sending an unexpected signal whose 
default action is to dump core, instead of the standard-approved 
behavior of returning an error signal and setting errno to EFBIG, is a 
move in the wrong direction. I'd say it's the wrong thing to do for 
resource-limited file sizes as well, but that at least is 
standard-mandated, and I guess we're pretty much stuck with it.

The problem, currently, is that users are encountering issues when they 
use cp or mv, etc, to transfer large files from one filesystem to 
another (for example, from ext3 to vfat). If the file size is greater 
than 4g, cp will abort with SIGXFSZ. This is annoying to users, 
particularly if there was more than one source file for the command (a 
hierarchical copy, for instance). In such a case, they would normally 
expect failure for the one problem source file, followed by continued 
processing of the remaining source files.

Now, of course, the coreutils guys could block or handle SIGXFSZ, which 
is exactly what I proposed when I was under my initial impression that 
the OS had license to send SIGXFSZ under these circumstances. Also, 
users could wrap the binaries with their own program that first blocks 
the signal, allowing it to get an EFBIG error instead.

The problem is, that in order to avoid abnormal termination, every 
program that ever uses write() would need to trap SIGXFSZ: "fixing" cp, 
mv, dd and install would only help alleviate the problem for the most 
"likely" programs to encounter the issue.

Furthermore, in addition to being (IMO) the wrong thing to do from a 
practical usability standpoint, it is also the wrong thing to do from a 
standards-conformance standpoint. If one looks at what SUSv3 has to say 
about it at 
http://www.opengroup.org/onlinepubs/000095399/functions/write.html :

<<<
If a write() requests that more bytes be written than there is room for 
(for example, [XSI] [Option Start]  the process' file size limit or 
[Option End] the physical end of a medium), only as many bytes as there 
is room for shall be written. For example, suppose there is space for 20 
bytes more in a file before reaching a limit. A write of 512 bytes will 
return 20. The next write of a non-zero number of bytes would give a 
failure return (except as noted below).
 >>>

Among the exceptions "noted below" is:

<<<
[XSI] [Option Start] If the request would cause the file size to exceed 
the soft file size limit for the process and there is no room for any 
bytes to be written, the request shall fail and the implementation shall 
generate the SIGXFSZ signal for the thread. [Option End]
 >>>

but no exception is made for file size limits other than "soft... 
process" limits; thus the requirement that the "next write of a non-zero 
number of bytes would give a failure return" still stands.

I would therefore propose that we eliminate the signalling of SIGXFSZ in 
all cases other than the case of the requested write causing a file's 
size to exceed limits set by setrlimit(RLIMIT_FSIZE, ...). I'd be happy 
to submit a patch to this effect if there is agreement that this is the 
right thing to do.

( Brief discussion with coreutils folks: 
http://lists.gnu.org/archive/html/bug-coreutils/2007-04/msg00070.html )

-- 
Micah J. Cowan
Programmer, musician, typesetting enthusiast, gamer...
http://micah.cowan.name/

