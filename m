Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbYGVXal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbYGVXal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbYGVXUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:20:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:58006 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756787AbYGVXU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:20:28 -0400
Date: Tue, 22 Jul 2008 16:16:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Cortland Setlow <csetlow@tower-research.com>,
       Andres Salomon <dilinger@debian.org>, Jonathan Corbet <corbet@lwn.net>
Subject: [patch 36/47] ov7670: clean up ov7670_read semantics
Message-ID: <20080722231657.GK8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ov7670-clean-up-ov7670_read-semantics.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Andres Salomon <dilinger@queued.net>

commit bca5c2c550f16d2dc2d21ffb7b4712bd0a7d32a9 upstream

Cortland Setlow pointed out a bug in ov7670.c where the result from
ov7670_read() was just being checked for !0, rather than <0.  This made me
realize that ov7670_read's semantics were rather confusing; it both fills
in 'value' with the result, and returns it.  This is goes against general
kernel convention; so rather than fixing callers, let's fix the function.

This makes ov7670_read return <0 in the case of an error, and 0 upon
success. Thus, code like:

res = ov7670_read(...);
if (!res)
	goto error;

.will work properly.

Signed-off-by: Cortland Setlow <csetlow@tower-research.com>
Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/ov7670.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -406,8 +406,10 @@ static int ov7670_read(struct i2c_client
 	int ret;
 
 	ret = i2c_smbus_read_byte_data(c, reg);
-	if (ret >= 0)
+	if (ret >= 0) {
 		*value = (unsigned char) ret;
+		ret = 0;
+	}
 	return ret;
 }
 

-- 
