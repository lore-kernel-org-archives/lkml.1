Return-Path: <linux-kernel-owner+w=401wt.eu-S1752558AbZJWQTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbZJWQTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 12:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbZJWQTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 12:19:54 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:59516 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbZJWQTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 12:19:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=gF7XaHyPWDhRh5g9Nj5D9nqHtttmJ4LII819feiKrzzUPVkgq/x2NS9x0jZySD9wv8
         VoeDHrBHGcZv1Qr6LpXBGwjk1eqV/scF2yBJWd4JD/0Sd3VkMddHUqPqlF8/m8LVhhrn
         0hWGg0alMZUezHUP6ogVpp3D++W+iL3Eq9EOQ=
Message-ID: <4AE1DA17.30902@gmail.com>
Date: Fri, 23 Oct 2009 18:30:15 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>, linux-cachefs@redhat.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] CacheFiles: Cleanup redundant tests on unsigned
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variables are unsigned so the test `>= 0' is always true,
the `< 0' test always fails. The other part of
the test catches wrapped values.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 fs/cachefiles/bind.c   |    6 ++----
 fs/cachefiles/daemon.c |    6 +++---
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/cachefiles/bind.c b/fs/cachefiles/bind.c
index 3797e00..ce776f6 100644
--- a/fs/cachefiles/bind.c
+++ b/fs/cachefiles/bind.c
@@ -39,13 +39,11 @@ int cachefiles_daemon_bind(struct cachefiles_cache *cache, char *args)
 	       args);
 
 	/* start by checking things over */
-	ASSERT(cache->fstop_percent >= 0 &&
-	       cache->fstop_percent < cache->fcull_percent &&
+	ASSERT(cache->fstop_percent < cache->fcull_percent &&
 	       cache->fcull_percent < cache->frun_percent &&
 	       cache->frun_percent  < 100);
 
-	ASSERT(cache->bstop_percent >= 0 &&
-	       cache->bstop_percent < cache->bcull_percent &&
+	ASSERT(cache->bstop_percent < cache->bcull_percent &&
 	       cache->bcull_percent < cache->brun_percent &&
 	       cache->brun_percent  < 100);
 
diff --git a/fs/cachefiles/daemon.c b/fs/cachefiles/daemon.c
index 4618516..bb30d01 100644
--- a/fs/cachefiles/daemon.c
+++ b/fs/cachefiles/daemon.c
@@ -220,7 +220,7 @@ static ssize_t cachefiles_daemon_write(struct file *file,
 	if (test_bit(CACHEFILES_DEAD, &cache->flags))
 		return -EIO;
 
-	if (datalen < 0 || datalen > PAGE_SIZE - 1)
+	if (datalen > PAGE_SIZE - 1)
 		return -EOPNOTSUPP;
 
 	/* drag the command string into the kernel so we can parse it */
@@ -385,7 +385,7 @@ static int cachefiles_daemon_fstop(struct cachefiles_cache *cache, char *args)
 	if (args[0] != '%' || args[1] != '\0')
 		return -EINVAL;
 
-	if (fstop < 0 || fstop >= cache->fcull_percent)
+	if (fstop >= cache->fcull_percent)
 		return cachefiles_daemon_range_error(cache, args);
 
 	cache->fstop_percent = fstop;
@@ -457,7 +457,7 @@ static int cachefiles_daemon_bstop(struct cachefiles_cache *cache, char *args)
 	if (args[0] != '%' || args[1] != '\0')
 		return -EINVAL;
 
-	if (bstop < 0 || bstop >= cache->bcull_percent)
+	if (bstop >= cache->bcull_percent)
 		return cachefiles_daemon_range_error(cache, args);
 
 	cache->bstop_percent = bstop;
