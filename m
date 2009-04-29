Return-Path: <linux-kernel-owner+w=401wt.eu-S1762836AbZD2WhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762836AbZD2WhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760288AbZD2WVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:46 -0400
Received: from kroah.org ([198.145.64.141]:40500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759475AbZD2WVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:42 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:29 2009
Message-Id: <20090429220929.139768044@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 41/58] block: revert part of 18ce3751ccd488c78d3827e9f6bf54e6322676fb
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=block-revert-part-of-18ce3751ccd488c78d3827e9f6bf54e6322676fb.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jens Axboe <jens.axboe@oracle.com>

commit 78f707bfc723552e8309b7c38a8d0cc51012e813 upstream.

The above commit added WRITE_SYNC and switched various places to using
that for committing writes that will be waited upon immediately after
submission. However, this causes a performance regression with AS and CFQ
for ext3 at least, since sync_dirty_buffer() will submit some writes with
WRITE_SYNC while ext3 has sumitted others dependent writes without the sync
flag set. This causes excessive anticipation/idling in the IO scheduler
because sync and async writes get interleaved, causing a big performance
regression for the below test case (which is meant to simulate sqlite
like behaviour).

---- test case ----

int main(int argc, char **argv)
{

	int fdes, i;
	FILE *fp;
	struct timeval start;
	struct timeval end;
	struct timeval res;

	gettimeofday(&start, NULL);
	for (i=0; i<ROWS; i++) {
		fp = fopen("test_file", "a");
		fprintf(fp, "Some Text Data\n");
		fdes = fileno(fp);
		fsync(fdes);
		fclose(fp);
	}
	gettimeofday(&end, NULL);

	timersub(&end, &start, &res);
	fprintf(stdout, "time to write %d lines is %ld(msec)\n", ROWS,
			(res.tv_sec*1000000 + res.tv_usec)/1000);

	return 0;
}

-------------------

Thanks to Sean.White@APCC.com for tracking down this performance
regression and providing a test case.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3042,7 +3042,7 @@ int sync_dirty_buffer(struct buffer_head
 	if (test_clear_buffer_dirty(bh)) {
 		get_bh(bh);
 		bh->b_end_io = end_buffer_write_sync;
-		ret = submit_bh(WRITE_SYNC, bh);
+		ret = submit_bh(WRITE, bh);
 		wait_on_buffer(bh);
 		if (buffer_eopnotsupp(bh)) {
 			clear_buffer_eopnotsupp(bh);


