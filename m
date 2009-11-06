Return-Path: <linux-kernel-owner+w=401wt.eu-S932670AbZKFWcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670AbZKFWcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932326AbZKFWcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:32:35 -0500
Received: from kroah.org ([198.145.64.141]:56988 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514AbZKFWXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:14 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:47 2009
Message-Id: <20091106221547.296924651@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Buesch <mb@bu3sch.de>, Jiri Kosina <jkosina@suse.cz>,
       Michael Gilbert <michael.s.gilbert@gmail.com>
Subject: [62/99] sgi-gru: decrapfiy options_write() function
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=sgi-gru-decrapfiy-options_write-function.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Linus Torvalds <torvalds@linux-foundation.org>

commit d39b7dd1dcbf394a1cb897457c862dafe9a20ac5 upstream.

Not a single line of actual code in the function was really
fundamentally correct.

Problems ranged from lack of proper range checking, to removing the last
character written (which admittedly is usually '\n'), to not accepting
hex numbers even though the 'show' routine would show the data in that
format.

This tries to do better.

Acked-by: Michael Buesch <mb@bu3sch.de>
Tested-and-acked-by: Jack Steiner <steiner@sgi.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Michael Gilbert <michael.s.gilbert@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/sgi-gru/gruprocfs.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/misc/sgi-gru/gruprocfs.c
+++ b/drivers/misc/sgi-gru/gruprocfs.c
@@ -161,14 +161,15 @@ static int options_show(struct seq_file 
 static ssize_t options_write(struct file *file, const char __user *userbuf,
 			     size_t count, loff_t *data)
 {
-	unsigned long val;
-	char buf[80];
+	char buf[20];
 
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


