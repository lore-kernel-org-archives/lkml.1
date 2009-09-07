Return-Path: <linux-kernel-owner+w=401wt.eu-S1752617AbZIGJNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbZIGJNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 05:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbZIGJNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 05:13:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34057 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbZIGJNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 05:13:49 -0400
Date: Mon, 7 Sep 2009 19:13:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Joe Peterson <joe@skyrush.com>
Subject: linux-next: manual merge of the tty tree with the  tree
Message-Id: <20090907191347.fe010955.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/char/n_tty.c between commit
37f81fa1f63ad38e16125526bb2769ae0ea8d332 ("n_tty: do O_ONLCR translation
as a single write") from Linus' tree and commit
bb2d17d83926bf9d70b922031aeb49ca896e0b3d ("tty: n_tty: honor opost flag
for echoes") from the tty tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/char/n_tty.c
index 4e28b35,71308b6..0000000
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@@ -292,53 -292,56 +292,55 @@@ static int do_output_char(unsigned cha
  	if (!space)
  		return -1;
  
- 	switch (c) {
- 	case '\n':
- 		if (O_ONLRET(tty))
- 			tty->column = 0;
- 		if (O_ONLCR(tty)) {
- 			if (space < 2)
- 				return -1;
- 			tty->canon_column = tty->column = 0;
- 			tty->ops->write(tty, "\r\n", 2);
- 			return 2;
- 		}
- 		tty->canon_column = tty->column;
- 		break;
- 	case '\r':
- 		if (O_ONOCR(tty) && tty->column == 0)
- 			return 0;
- 		if (O_OCRNL(tty)) {
- 			c = '\n';
+ 	if (O_OPOST(tty)) {
+ 		switch (c) {
+ 		case '\n':
  			if (O_ONLRET(tty))
+ 				tty->column = 0;
+ 			if (O_ONLCR(tty)) {
+ 				if (space < 2)
+ 					return -1;
  				tty->canon_column = tty->column = 0;
 -				tty_put_char(tty, '\r');
 -				tty_put_char(tty, c);
++				tty->ops->write(tty, "\r\n", 2);
+ 				return 2;
+ 			}
+ 			tty->canon_column = tty->column;
  			break;
- 		}
- 		tty->canon_column = tty->column = 0;
- 		break;
- 	case '\t':
- 		spaces = 8 - (tty->column & 7);
- 		if (O_TABDLY(tty) == XTABS) {
- 			if (space < spaces)
- 				return -1;
+ 		case '\r':
+ 			if (O_ONOCR(tty) && tty->column == 0)
+ 				return 0;
+ 			if (O_OCRNL(tty)) {
+ 				c = '\n';
+ 				if (O_ONLRET(tty))
+ 					tty->canon_column = tty->column = 0;
+ 				break;
+ 			}
+ 			tty->canon_column = tty->column = 0;
+ 			break;
+ 		case '\t':
+ 			spaces = 8 - (tty->column & 7);
+ 			if (O_TABDLY(tty) == XTABS) {
+ 				if (space < spaces)
+ 					return -1;
+ 				tty->column += spaces;
+ 				tty->ops->write(tty, "        ", spaces);
+ 				return spaces;
+ 			}
  			tty->column += spaces;
- 			tty->ops->write(tty, "        ", spaces);
- 			return spaces;
- 		}
- 		tty->column += spaces;
- 		break;
- 	case '\b':
- 		if (tty->column > 0)
- 			tty->column--;
- 		break;
- 	default:
- 		if (!iscntrl(c)) {
- 			if (O_OLCUC(tty))
- 				c = toupper(c);
- 			if (!is_continuation(c, tty))
- 				tty->column++;
+ 			break;
+ 		case '\b':
+ 			if (tty->column > 0)
+ 				tty->column--;
+ 			break;
+ 		default:
+ 			if (!iscntrl(c)) {
+ 				if (O_OLCUC(tty))
+ 					c = toupper(c);
+ 				if (!is_continuation(c, tty))
+ 					tty->column++;
+ 			}
+ 			break;
  		}
- 		break;
  	}
  
  	tty_put_char(tty, c);
