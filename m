Return-Path: <linux-kernel-owner+w=401wt.eu-S1760432AbYJEQb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760432AbYJEQb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758343AbYJEQXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:23:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57977 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758332AbYJEQXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:23:04 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 65/76] tty: Fallout from tty-move-canon-specials
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:23:02 +0100
Message-ID: <20081005162257.1997.44950.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

Hi Alan,

Today's linux-next build (x86_64 allmodconfig) failed like this:

/drivers/char/tty_ioctl.c: In function 'change_termios':
drivers/isdn/capi/capi.c:1234: error: implicit declaration of function 'n_tty_ioctl'
drivers/isdn/gigaset/ser-gigaset.c: In function 'gigaset_tty_ioctl':
drivers/isdn/gigaset/ser-gigaset.c:648: error: implicit declaration of function 'n_tty_ioctl'

Introduced by commit 686b5e4aea05a80e370dc931b7f4a8d03c80da54
("tty-move-canon-specials").  I added the following patch (which may not
be correct).

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/isdn/capi/capi.c           |    2 +-
 drivers/isdn/gigaset/ser-gigaset.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 871b0cb..798d7f3 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -1231,7 +1231,7 @@ static int capinc_tty_ioctl(struct tty_struct *tty, struct file * file,
 	int error = 0;
 	switch (cmd) {
 	default:
-		error = n_tty_ioctl (tty, file, cmd, arg);
+		error = n_tty_ioctl_helper(tty, file, cmd, arg);
 		break;
 	}
 	return error;
diff --git a/drivers/isdn/gigaset/ser-gigaset.c b/drivers/isdn/gigaset/ser-gigaset.c
index 5e89fa1..cc4f4e4 100644
--- a/drivers/isdn/gigaset/ser-gigaset.c
+++ b/drivers/isdn/gigaset/ser-gigaset.c
@@ -645,7 +645,7 @@ gigaset_tty_ioctl(struct tty_struct *tty, struct file *file,
 	case TCGETS:
 	case TCGETA:
 		/* pass through to underlying serial device */
-		rc = n_tty_ioctl(tty, file, cmd, arg);
+		rc = n_tty_ioctl_helper(tty, file, cmd, arg);
 		break;
 
 	case TCFLSH:
@@ -660,7 +660,7 @@ gigaset_tty_ioctl(struct tty_struct *tty, struct file *file,
 			break;
 		}
 		/* flush the serial port's buffer */
-		rc = n_tty_ioctl(tty, file, cmd, arg);
+		rc = n_tty_ioctl_helper(tty, file, cmd, arg);
 		break;
 
 	case FIONREAD:

