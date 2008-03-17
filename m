Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbYCQX0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbYCQX0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 19:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbYCQX0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 19:26:33 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:21938 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbYCQX0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 19:26:32 -0400
Message-ID: <47DEFE26.80101@msgid.tls.msk.ru>
Date: Tue, 18 Mar 2008 02:26:30 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: RFC: /dev/stdin, symlinks & permissions
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just come across an.. interesting (to me anyway) issue.

There are files - /dev/stdin, /dev/stdout & /dev/stderr -
which are handy sometimes and are available on several
*nix variants (including at least Solaris).

On Linux they're usually "implemented" as symlinks pointed
to /proc/self/fd/{0,1,2}, respectively.  Which, in turn,
are symlinks pointing to the actual files.

For example, in a root ssh session, /dev/stdin may look
like (omitting details):

   # ls -l /dev/stdin
   /dev/stdin -> /proc/self/fd/0
   # ls -l /proc/self/fd/0
   /proc/self/fd/0 -> /dev/pts/0
   # ls -l /dev/pts/0
   crw--w---- 1 root tty 136, 0 Mar 18 02:19 /dev/pts/0

So far so good.  Now, I change uid to something else, --
doing su(8) to "mjt".  /proc/self changed obviously,
but stdin &Co is still here, and points to the same
/dev/pts/0.  But *its* permissions/ownership did not
change!  So now I can't, for example,

  $ echo x > /dev/stdout
  bash: /dev/stdout: Permission denied

which is quite unexpected - I for one expect /dev/stdout
to work the way very similar to /dev/tty, to mean "current
standard output regardless of any permissions etc".

For example in Solaris the whole /proc/self/fd (equivalent)
is in /dev/, and all the files in there has permissions
similar to /dev/tty:

  # ls -l /dev/stdout
  /dev/stdin -> ./fd/0
  #ls -l /dev/fd/0
  crw-rw-rw-   1 root     root     306,  0 Mar 17 18:03 /dev/fd/0

To summarize.  I understand where the whole thing comes from.
I understand kernel does not provide /dev/stdin &Co, this
interface is provided by distributions.

But the current way is half-broken, and it can't be corrected
from userspace.

Should kernel support something similar to other systems, less
broken than current /dev/stdin&Co symlinks?

Thanks!

/mjt
