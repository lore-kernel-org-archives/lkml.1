Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbYKQH3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbYKQH3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYKQHVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:25 -0500
Received: from kroah.org ([198.145.64.141]:38464 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754603AbYKQHVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:14 -0500
Date: Sun, 16 Nov 2008 23:15:43 -0800
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
       alan@lxorguk.ukuu.org.uk, Alexey Dobriyan <adobriyan@gmail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 23/46] net: fix /proc/net/snmp as memory corruptor
Message-ID: <20081117071543.GX29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-fix-proc-net-snmp-as-memory-corruptor.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <dada1@cosmosbay.com>

commit b971e7ac834e9f4bda96d5a96ae9abccd01c1dd8 upstream.

icmpmsg_put() can happily corrupt kernel memory, using a static
table and forgetting to reset an array index in a loop.

Remove the static array since its not safe without proper locking.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/proc.c |   58 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 28 deletions(-)

--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -237,43 +237,45 @@ static const struct snmp_mib snmp4_net_l
 	SNMP_MIB_SENTINEL
 };
 
+static void icmpmsg_put_line(struct seq_file *seq, unsigned long *vals,
+			     unsigned short *type, int count)
+{
+	int j;
+
+	if (count) {
+		seq_printf(seq, "\nIcmpMsg:");
+		for (j = 0; j < count; ++j)
+			seq_printf(seq, " %sType%u",
+				type[j] & 0x100 ? "Out" : "In",
+				type[j] & 0xff);
+		seq_printf(seq, "\nIcmpMsg:");
+		for (j = 0; j < count; ++j)
+			seq_printf(seq, " %lu", vals[j]);
+	}
+}
+
 static void icmpmsg_put(struct seq_file *seq)
 {
 #define PERLINE	16
 
-	int j, i, count;
-	static int out[PERLINE];
+	int i, count;
+	unsigned short type[PERLINE];
+	unsigned long vals[PERLINE], val;
 	struct net *net = seq->private;
 
 	count = 0;
 	for (i = 0; i < ICMPMSG_MIB_MAX; i++) {
-
-		if (snmp_fold_field((void **) net->mib.icmpmsg_statistics, i))
-			out[count++] = i;
-		if (count < PERLINE)
-			continue;
-
-		seq_printf(seq, "\nIcmpMsg:");
-		for (j = 0; j < PERLINE; ++j)
-			seq_printf(seq, " %sType%u", i & 0x100 ? "Out" : "In",
-					i & 0xff);
-		seq_printf(seq, "\nIcmpMsg: ");
-		for (j = 0; j < PERLINE; ++j)
-			seq_printf(seq, " %lu",
-				snmp_fold_field((void **) net->mib.icmpmsg_statistics,
-				out[j]));
-		seq_putc(seq, '\n');
-	}
-	if (count) {
-		seq_printf(seq, "\nIcmpMsg:");
-		for (j = 0; j < count; ++j)
-			seq_printf(seq, " %sType%u", out[j] & 0x100 ? "Out" :
-				"In", out[j] & 0xff);
-		seq_printf(seq, "\nIcmpMsg:");
-		for (j = 0; j < count; ++j)
-			seq_printf(seq, " %lu", snmp_fold_field((void **)
-				net->mib.icmpmsg_statistics, out[j]));
+		val = snmp_fold_field((void **) net->mib.icmpmsg_statistics, i);
+		if (val) {
+			type[count] = i;
+			vals[count++] = val;
+		}
+		if (count == PERLINE) {
+			icmpmsg_put_line(seq, vals, type, count);
+			count = 0;
+		}
 	}
+	icmpmsg_put_line(seq, vals, type, count);
 
 #undef PERLINE
 }

-- 
