Return-Path: <linux-kernel-owner+w=401wt.eu-S1751521AbZH1N3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbZH1N3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 09:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbZH1N3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 09:29:37 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:54567 "EHLO
	QMTA01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446AbZH1N3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 09:29:36 -0400
Message-ID: <4A97DBC1.3000508@xyzw.org>
Date: Fri, 28 Aug 2009 06:29:37 -0700
From: Brian Rogers <brian@xyzw.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] inotify:  Ensure we alwasy write the terminating NULL.
References: <m1skffj64t.fsf@fess.ebiederm.org>	<1251299483.2308.32.camel@dhcp231-106.rdu.redhat.com> <m1iqg9k17v.fsf_-_@fess.ebiederm.org>
In-Reply-To: <m1iqg9k17v.fsf_-_@fess.ebiederm.org>
Content-Type: multipart/mixed;
 boundary="------------020605050003020006000308"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020605050003020006000308
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Eric W. Biederman wrote:
> Before the rewrite copy_event_to_user always wrote a terqminating '\0'
> byte to user space after the filename.  Since the rewrite that
> terminating byte was skipped if your filename is exactly a multiple of
> event_size.  Ouch!
>
> So add one byte to name_size before we round up and use clear_user to
> set userspace to zero like /dev/zero does instead of copying the
> strange nul_inotify_event.  I can't quite convince myself len_to_zero
> will never exceed 16 and even if it doesn't clear_user should be more
> efficient and a more accurate reflection of what the code is trying to
> do.
>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>   

I found that this change prevents my Ubuntu Karmic system from booting. 
It just idles forever very early in the process. Probably a boot script 
is waiting for an event that it doesn't receive properly.

> -	name_len = roundup(event->name_len, event_size);
> +	name_len = roundup(event->name_len + 1, event_size);
>   

This means the test later on will now always evaluate to true:
> if (name_len) {

And in cases where that test previously would have failed, the code now 
outputs a block full of zeros. Assuming that's bad and the test was 
important, I coded the attached naive fix, which is working for me.


--------------020605050003020006000308
Content-Type: text/x-patch;
 name="0001-inotify-Fix-events-with-no-pathname.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-inotify-Fix-events-with-no-pathname.patch"

>From 1be7a610013b47be1257d2b0296d872d6bed7416 Mon Sep 17 00:00:00 2001
From: Brian Rogers <brian@xyzw.org>
Date: Fri, 28 Aug 2009 04:46:51 -0700
Subject: [PATCH] inotify: Fix events with no pathname

When an event has no pathname, there's no need to pad it with a null byte and
therefore generate an inotify_event sized block of zeros. This fixes a
regression introduced by commit 0db501bd0610ee0c0aca84d927f90bcccd09e2bd where
my system wouldn't finish booting because some process was being confused by
this.

Signed-off-by: Brian Rogers <brian@xyzw.org>
---
 fs/notify/inotify/inotify_user.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 0e781bc..d94ce8b 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -199,7 +199,10 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 	/* round up event->name_len so it is a multiple of event_size
 	 * plus an extra byte for the terminating '\0'.
 	 */
-	name_len = roundup(event->name_len + 1, event_size);
+	if (event->name_len > 0)
+		name_len = roundup(event->name_len + 1, event_size);
+	else
+		name_len = 0;
 	inotify_event.len = name_len;
 
 	inotify_event.mask = inotify_mask_to_arg(event->mask);
-- 
1.6.3.3


--------------020605050003020006000308--
