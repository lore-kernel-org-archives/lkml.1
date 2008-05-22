Return-Path: <linux-kernel-owner+w=401wt.eu-S933127AbYEVIDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127AbYEVIDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 04:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760617AbYEVID2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 04:03:28 -0400
Received: from relay1.sgi.com ([192.48.171.29]:43558 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760172AbYEVIDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 04:03:24 -0400
Date: Thu, 22 May 2008 03:03:24 -0500
From: Paul Jackson <pj@sgi.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove unnecessary memmove() in cgroup_path()
Message-Id: <20080522030324.2b650f93.pj@sgi.com>
In-Reply-To: <48352127.20804@cn.fujitsu.com>
References: <48352127.20804@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai wrote:
> memmove() is unnecessary in cgroup_path(), the following patch will remove it.

True, I think -- memmove() can be removed as you suggest.

However, it makes the code a little harder to read, in my opinion,
because the meaning of the "@buf" parameter passed into cgroup_path()
is no longer quite the same as the meaning of that same parameter,
upon return from cgroup_path().

I have a fairly consistent preference for code clarity, even if it
means an occassional extra bit of code gets executed, unless we're
on some code path where the performance gained from the tighter code
is important.  I don't think that cgroup_path() is on such a path;
however I could be wrong on that point.  Did you discover this non-
essential call to memmove() by code reading, or by observing that
it was causing some noticeable performance loss for some situation
that you care about?

If we did go with this patch as you suggest, then I would like to
suggest that we elaborate your explanation of what the "@buf"
parameter to cgroup_path() means.

Your patch states:

+ * @buf: *buf is the buffer to write the path into, and it was set
+ *       to the start of the path when return

I would suggest stating instead something like:

  * @buf: On entry, @buf is a pointer to a pointer to a buffer of
  *       length @buflen into which the path will be written.  In most
  *       cases, excepting some trivial cases such as returning "/",
  *       the path will be written into the -high- end of the buffer,
  *       and the pointer to which buf points will be updated on
  *       return from cgroup_path() to point to the beginning of that
  *       path, somewhere within the original passed in buffer.


One more minor suggestion ... your patch has:
-		char *pathbuf;
+		char *pathbuf, *path;

and later on it has:
-	char *buf;
+	char *buf, *path;

Could you use the same variable names, when referring to the same
things, in both places?  It makes the code a little easier to read.

Overall, however, I am not sure I like this patch, unless you have good
performance reasons to get rid of that memmove().  The complications to
what the "@buf" parameter to cgroup_path() means just aren't worth it,
in my current opinion.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
