Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbZKEQeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbZKEQeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 11:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756450AbZKEQeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 11:34:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755171AbZKEQeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 11:34:22 -0500
Date: Thu, 5 Nov 2009 08:32:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jiri Kosina <jkosina@suse.cz>
cc: Michael Gilbert <michael.s.gilbert@gmail.com>,
       Michael Buesch <mb@bu3sch.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: CVE-2009-2584
In-Reply-To: <alpine.LRH.2.00.0911051620510.31913@twin.jikos.cz>
Message-ID: <alpine.LFD.2.01.0911050831330.31845@localhost.localdomain>
References: <20091104170542.e40b12ec.michael.s.gilbert@gmail.com> <alpine.LRH.2.00.0911051620510.31913@twin.jikos.cz>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 5 Nov 2009, Jiri Kosina wrote:
>  
> +	memset(buf, 0, sizeof(buf));
>  	if (strncpy_from_user(buf, userbuf, sizeof(buf) - 1) < 0)
>  		return -EFAULT;
> -	buf[count - 1] = '\0';

Why isn't this just

	buf[sizeof(buf) - 1] = 0;

which was almost certainly the _intention_ of the code in the first 
place, since 'count' has absolutely nothing to do with the copy from user 
space as it is written.

I'm also convinced we do _not_ want 'strncpy' there, since we do have the 
size of the write. Doing a strncpy_from_user() is actually _wrong_ if the 
user buffer itself is smaller than the kernel buffer and isn't 
NUL-terminated.

So that strncpy crap needs to go. It's wrong.

In other words it would all look a whole lot more natural (and correct) 
like the appended patch.

Untested, of course. And since almost nobody has the hardware, so it's not 
like it's ever likely to _be_ tested.

		Linus

---
 drivers/misc/sgi-gru/gruprocfs.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/sgi-gru/gruprocfs.c b/drivers/misc/sgi-gru/gruprocfs.c
index ccd4408..c0e17b0 100644
--- a/drivers/misc/sgi-gru/gruprocfs.c
+++ b/drivers/misc/sgi-gru/gruprocfs.c
@@ -164,7 +164,9 @@ static ssize_t options_write(struct file *file, const char __user *userbuf,
 	unsigned long val;
 	char buf[80];
 
-	if (strncpy_from_user(buf, userbuf, sizeof(buf) - 1) < 0)
+	if (count >= sizeof(buf))
+		count = sizeof(buf)-1;
+	if (copy_from_user(buf, userbuf, count))
 		return -EFAULT;
 	buf[count - 1] = '\0';
 	if (!strict_strtoul(buf, 10, &val))
