Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbZLVVZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbZLVVZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 16:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbZLVVZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 16:25:36 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:41850 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbZLVVZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 16:25:36 -0500
Subject: Re: [PATCH 04/27] Driver core: devtmpfs: prevent concurrent
 subdirectory creation and removal
From: Kay Sievers <kay.sievers@vrfy.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <cc557aab0912221056o534beb03r8ce0a98d8aaa1e36@mail.gmail.com>
References: <20091211212642.GA6624@kroah.com>
	 <1260570289-6997-4-git-send-email-gregkh@suse.de>
	 <cc557aab0912210537pdc076e7p5c90303fb6a32b66@mail.gmail.com>
	 <ac3eb2510912210637n629ec609vf838a8b572867ffa@mail.gmail.com>
	 <cc557aab0912220610w7c3c57aaq3b6d96f6eb7085ca@mail.gmail.com>
	 <ac3eb2510912220857g752a8d5ek20a37a79f053fb58@mail.gmail.com>
	 <cc557aab0912221056o534beb03r8ce0a98d8aaa1e36@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 22:25:16 +0100
Message-Id: <1261517116.2101.2.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-22 at 20:56 +0200, Kirill A. Shutemov wrote:
> On Tue, Dec 22, 2009 at 6:57 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> > On Tue, Dec 22, 2009 at 15:10, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> >> On Mon, Dec 21, 2009 at 4:37 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> >>> On Mon, Dec 21, 2009 at 14:37, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> >>>> v2.6.33-rc1-96-gdd59f6c:
> >>>> I guess it can be related to this commit.
> >>>
> >>> The fix is already pending here:
> >>>  http://patchwork.kernel.org/patch/68337/
> >>
> >> One more problem: you don't unlock dirlock if kstrdup() failed.
> >
> > Oh right, will send a fix tomorrow.
> 
> Reported-by Kirill A. Shutemov <kirill@shutemov.name>

Thanks!

Kay



From: Kay Sievers <kay.sievers@vrfy.org>
Subject: devtmpfs: unlock mutex in case of string allocation error

Reported-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/base/devtmpfs.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -101,8 +101,10 @@ static int create_path(const char *nodep
 
 		/* parent directories do not exist, create them */
 		path = kstrdup(nodepath, GFP_KERNEL);
-		if (!path)
-			return -ENOMEM;
+		if (!path) {
+			err = -ENOMEM;
+			goto out;
+		}
 		s = path;
 		for (;;) {
 			s = strchr(s, '/');
@@ -117,6 +119,7 @@ static int create_path(const char *nodep
 		}
 		kfree(path);
 	}
+out:
 	mutex_unlock(&dirlock);
 	return err;
 }


