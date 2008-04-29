Return-Path: <linux-kernel-owner+w=401wt.eu-S1751586AbYD2RWC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbYD2RWC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:22:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757222AbYD2RUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:20:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757193AbYD2RUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:20:15 -0400
Date: Tue, 29 Apr 2008 10:18:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tom Quetchenbach <virtualphtn@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [05/37] tcp: tcp_probe buffer overflow and incorrect return value
Message-ID: <20080429171803.GF14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tcp-tcp_probe-buffer-overflow-and-incorrect-return-value.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Tom Quetchenbach <virtualphtn@gmail.com>

[ Upstream commit: 8d390efd903485923419584275fd0c2aa4c94183 ]

tcp_probe has a bounds-checking bug that causes many programs (less,
python) to crash reading /proc/net/tcp_probe. When it outputs a log
line to the reader, it only checks if that line alone will fit in the
reader's buffer, rather than that line and all the previous lines it
has already written.

tcpprobe_read also returns the wrong value if copy_to_user fails--it
just passes on the return value of copy_to_user (number of bytes not
copied), which makes a failure look like a success.

This patch fixes the buffer overflow and sets the return value to
-EFAULT if copy_to_user fails.

Patch is against latest net-2.6; tested briefly and seems to fix the
crashes in less and python.

Signed-off-by: Tom Quetchenbach <virtualphtn@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp_probe.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/net/ipv4/tcp_probe.c
+++ b/net/ipv4/tcp_probe.c
@@ -190,19 +190,18 @@ static ssize_t tcpprobe_read(struct file
 
 		width = tcpprobe_sprint(tbuf, sizeof(tbuf));
 
-		if (width < len)
+		if (cnt + width < len)
 			tcp_probe.tail = (tcp_probe.tail + 1) % bufsize;
 
 		spin_unlock_bh(&tcp_probe.lock);
 
 		/* if record greater than space available
 		   return partial buffer (so far) */
-		if (width >= len)
+		if (cnt + width >= len)
 			break;
 
-		error = copy_to_user(buf + cnt, tbuf, width);
-		if (error)
-			break;
+		if (copy_to_user(buf + cnt, tbuf, width))
+			return -EFAULT;
 		cnt += width;
 	}
 

-- 
