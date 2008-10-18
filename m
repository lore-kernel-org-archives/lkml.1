Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378AbYJRTXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbYJRTXH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbYJRTGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:06:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:38849 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbYJRTGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:06:30 -0400
Date: Sat, 18 Oct 2008 11:57:36 -0700
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
       alan@lxorguk.ukuu.org.uk, Jens Axboe <ens.axboe@oracle.com>
Subject: [patch 10/14] Dont allow splice() to files opened with O_APPEND
Message-ID: <20081018185736.GK17196@suse.de>
References: <20081018185031.236868964@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="don-t-allow-splice-to-files-opened-with-o_append.patch"
In-Reply-To: <20081018185658.GA17196@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Linus Torvalds <torvalds@linux-foundation.org>

commit efc968d450e013049a662d22727cf132618dcb2f upstream

This is debatable, but while we're debating it, let's disallow the
combination of splice and an O_APPEND destination.

It's not entirely clear what the semantics of O_APPEND should be, and
POSIX apparently expects pwrite() to ignore O_APPEND, for example.  So
we could make up any semantics we want, including the old ones.

But Miklos convinced me that we should at least give it some thought,
and that accepting writes at arbitrary offsets is wrong at least for
IS_APPEND() files (which always have O_APPEND set, even if the reverse
isn't true: you can obviously have O_APPEND set on a regular file).

So disallow O_APPEND entirely for now.  I doubt anybody cares, and this
way we have one less gray area to worry about.

Reported-and-argued-for-by: Miklos Szeredi <miklos@szeredi.hu>
Acked-by: Jens Axboe <ens.axboe@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/splice.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/splice.c
+++ b/fs/splice.c
@@ -891,6 +891,9 @@ static long do_splice_from(struct pipe_i
 	if (unlikely(!(out->f_mode & FMODE_WRITE)))
 		return -EBADF;
 
+	if (unlikely(out->f_flags & O_APPEND))
+		return -EINVAL;
+
 	ret = rw_verify_area(WRITE, out, ppos, len);
 	if (unlikely(ret < 0))
 		return ret;

-- 
