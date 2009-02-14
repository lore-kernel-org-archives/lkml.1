Return-Path: <linux-kernel-owner+w=401wt.eu-S1761528AbZBNBnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761528AbZBNBnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761984AbZBNBQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:44 -0500
Received: from kroah.org ([198.145.64.141]:50639 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763651AbZBNBQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:35 -0500
Date: Fri, 13 Feb 2009 17:13:34 -0800
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
       alan@lxorguk.ukuu.org.uk, Clement Lecigne <clement.lecigne@netasq.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 31/48] net: 4 bytes kernel memory disclosure in
	SO_BSDCOMPAT gsopt try #2
Message-ID: <20090214011334.GL17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline; filename="net-4-bytes-kernel-memory-disclosure-in-so_bsdcompat-gsopt-try-2.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Clément Lecigne <clement.lecigne@netasq.com>

[ Upstream commit df0bca049d01c0ee94afb7cd5dfd959541e6c8da ]

In function sock_getsockopt() located in net/core/sock.c, optval v.val
is not correctly initialized and directly returned in userland in case
we have SO_BSDCOMPAT option set.

This dummy code should trigger the bug:

int main(void)
{
	unsigned char buf[4] = { 0, 0, 0, 0 };
	int len;
	int sock;
	sock = socket(33, 2, 2);
	getsockopt(sock, 1, SO_BSDCOMPAT, &buf, &len);
	printf("%x%x%x%x\n", buf[0], buf[1], buf[2], buf[3]);
	close(sock);
}

Here is a patch that fix this bug by initalizing v.val just after its
declaration.

Signed-off-by: Clément Lecigne <clement.lecigne@netasq.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/sock.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -696,6 +696,8 @@ int sock_getsockopt(struct socket *sock,
 	if (len < 0)
 		return -EINVAL;
 
+	v.val = 0;
+
 	switch(optname) {
 	case SO_DEBUG:
 		v.val = sock_flag(sk, SOCK_DBG);

