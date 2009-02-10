Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbZBJTRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbZBJTRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755919AbZBJTEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:04:10 -0500
Received: from kroah.org ([198.145.64.141]:54101 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755875AbZBJTEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:04:08 -0500
Date: Tue, 10 Feb 2009 11:01:03 -0800
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
       alan@lxorguk.ukuu.org.uk, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [patch 38/53] seq_file: fix big-enough lseek() + read()
Message-ID: <20090210190103.GM14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="seq_file-fix-big-enough-lseek-read.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Alexey Dobriyan <adobriyan@gmail.com>

commit f01d1d546abb2f4028b5299092f529eefb01253a upstream.

lseek() further than length of the file will leave stale ->index
(second-to-last during iteration). Next seq_read() will not notice
that ->f_pos is big enough to return 0, but will print last item
as if ->f_pos is pointing to it.

Introduced in commit cb510b8172602a66467f3551b4be1911f5a7c8c2
aka "seq_file: more atomicity in traverse()".

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -102,6 +102,7 @@ static int traverse(struct seq_file *m, loff_t offset)
 		p = m->op->next(m, p, &index);
 	}
 	m->op->stop(m, p);
+	m->index = index;
 	return error;
 
 Eoverflow:

