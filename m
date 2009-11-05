Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbZKERjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbZKERjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 12:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbZKERjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 12:39:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755119AbZKERjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 12:39:31 -0500
Date: Thu, 5 Nov 2009 09:38:21 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jiri Kosina <jkosina@suse.cz>
cc: Michael Gilbert <michael.s.gilbert@gmail.com>,
       Michael Buesch <mb@bu3sch.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: CVE-2009-2584
In-Reply-To: <alpine.LFD.2.01.0911050831330.31845@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0911050923580.31845@localhost.localdomain>
References: <20091104170542.e40b12ec.michael.s.gilbert@gmail.com> <alpine.LRH.2.00.0911051620510.31913@twin.jikos.cz> <alpine.LFD.2.01.0911050831330.31845@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Nov 2009, Linus Torvalds wrote:
> 
> Untested, of course. And since almost nobody has the hardware, so it's not 
> like it's ever likely to _be_ tested.
> 
> 		Linus
> 
> ---
>  drivers/misc/sgi-gru/gruprocfs.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/misc/sgi-gru/gruprocfs.c b/drivers/misc/sgi-gru/gruprocfs.c
> index ccd4408..c0e17b0 100644
> --- a/drivers/misc/sgi-gru/gruprocfs.c
> +++ b/drivers/misc/sgi-gru/gruprocfs.c
> @@ -164,7 +164,9 @@ static ssize_t options_write(struct file *file, const char __user *userbuf,
>  	unsigned long val;
>  	char buf[80];
>  
> -	if (strncpy_from_user(buf, userbuf, sizeof(buf) - 1) < 0)
> +	if (count >= sizeof(buf))
> +		count = sizeof(buf)-1;
> +	if (copy_from_user(buf, userbuf, count))
>  		return -EFAULT;
>  	buf[count - 1] = '\0';

And it's wrong. That 'count-1' was always wrong. It seems to _depend_ on 
people doing things like

	echo number > /proc/..

and the 'echo' adding a '\n' at the end, and then 'buf[count-1] = 0' 
clearing away the '\n'.

Which is pointless, since '\n' at the end is the _one_ thing 
strict_strtoul() accepts. And it's wrong, because it means that

	echo -n number > /proc..

fails.

In other words, the whole function is utter sh*t as far as I can tell. 
There's basically not a single correct line in the whole thing.

Even the 'strict_strtoul()' line is absolute and utter crap, since it 
forces decimal numbers, but 'options_show()' will then show it as a hex 
number (and a hex number is natural, since it's a set of flags). It also 
doesn't actually return an error if you write some invalid value, and it's 
totally pointless to have that 'val' temporary, since the strict_strtoul 
function only writes the result if it is successful _anyway_.

The size of the buffer is also insane. Since the _only_ thing we will ever 
accept is a number, there's no point in allowing all that many characters. 
And silently ignoring the extra characters kind of makes the whole 
'strict' part of 'strict_strtoul()' pointless.

So here's a second try. I guess the 'return count/-EFAULT' lines were
actually correct after all. So it wasn't _all_ buggy or insane.

Still entirely untested.

		Linus

---
 drivers/misc/sgi-gru/gruprocfs.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/sgi-gru/gruprocfs.c b/drivers/misc/sgi-gru/gruprocfs.c
index ccd4408..762f179 100644
--- a/drivers/misc/sgi-gru/gruprocfs.c
+++ b/drivers/misc/sgi-gru/gruprocfs.c
@@ -161,14 +161,15 @@ static int options_show(struct seq_file *s, void *p)
 static ssize_t options_write(struct file *file, const char __user *userbuf,
 			     size_t count, loff_t *data)
 {
-	unsigned long val;
-	char buf[80];
+	char buf[16];
 
-	if (strncpy_from_user(buf, userbuf, sizeof(buf) - 1) < 0)
+	if (count >= sizeof(buf))
+		return -EINVAL;
+	if (copy_from_user(buf, userbuf, count))
 		return -EFAULT;
-	buf[count - 1] = '\0';
-	if (!strict_strtoul(buf, 10, &val))
-		gru_options = val;
+	buf[count] = '\0';
+	if (strict_strtoul(buf, 0, &gru_options))
+		return -EINVAL;
 
 	return count;
 }
