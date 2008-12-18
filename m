Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752221AbYLRLsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbYLRLsV (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 06:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbYLRLsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 06:48:04 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38245 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbYLRLsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 06:48:03 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2008-12-16-00-43 uploaded (fs)
Cc: kosaki.motohiro@jp.fujitsu.com, Randy Dunlap <randy.dunlap@oracle.com>,
        linux-kernel@vger.kernel.org, npiggin@suse.de
In-Reply-To: <20081216102136.08ba1714.akpm@linux-foundation.org>
References: <4947ECD8.6050500@oracle.com> <20081216102136.08ba1714.akpm@linux-foundation.org>
Message-Id: <20081218200145.D7B3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 18 Dec 2008 20:47:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 16 Dec 2008 10:00:56 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > Randy Dunlap wrote:
> > > akpm@linux-foundation.org wrote:
> > >> The mm-of-the-moment snapshot 2008-12-16-00-43 has been uploaded to
> > >>
> > >>    http://userweb.kernel.org/~akpm/mmotm/
> > >>
> > >> It contains the following patches against 2.6.28-rc8:
> > >>
> > >> fs-symlink-write_begin-allocation-context-fix.patch
> > > 
> > > Nick,
> > > 
> > > fuse and reiser4 still use __grab_cache_page() although your patch
> > > removed it:
> > > 
> > > build-r7257.out:/local/linsrc/tmp/mmotm-2008-1216-0043/fs/reiser4/plugin/file/file_conversi
> > > on.c:689: error: implicit declaration of function '__grab_cache_page'
> > > build-r7257.out:make[3]: *** [fs/reiser4/plugin/file/file_conversion.o] Error 1
> > > 
> > > build-r7248.out:/local/linsrc/tmp/mmotm-2008-1216-0043/fs/fuse/file.c:792: error: implicit declaration of function '__grab_cache_page'
> > > build-r7248.out:make[3]: *** [fs/fuse/file.o] Error 1
> > 
> > 
> > One more related error:
> > 
> > build-r7258.out:/local/linsrc/tmp/mmotm-2008-1216-0043/fs/ubifs/file.c:251: error: 'flags' undeclared (first use in this function)
> > build-r7258.out:make[3]: *** [fs/ubifs/file.o] Error 1
> 
> thanks, I dropped it.

I'm sad ;)

I have fixing patch. this patch series have

1) reiser4 fix
2) ubifs fix
3) fuse fix



Tested on mmotm1217 + fs-symlink-write_begin-allocation-context-fix.patch

==
Subject: [PATCH 1/3] fix reiser4 build error of fs-symlink-write_begin-allocation-context-fix.patch

build fix.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/reiser4/plugin/file/file_conversion.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: b/fs/reiser4/plugin/file/file_conversion.c
===================================================================
--- a/fs/reiser4/plugin/file/file_conversion.c
+++ b/fs/reiser4/plugin/file/file_conversion.c
@@ -686,7 +686,8 @@ int reiser4_write_begin_careful(struct f
 	start = pos & (PAGE_CACHE_SIZE - 1);
 	end = start + len;
 
-	page = __grab_cache_page(mapping, index);
+	page = grab_cache_page_write_begin(mapping, index,
+					   flags & AOP_FLAG_NOFS);
 	*pagep = page;
 	if (!page)
 		return -ENOMEM;




