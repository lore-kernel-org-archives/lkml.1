Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbZEZR4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbZEZR4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 13:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZEZR4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 13:56:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44402 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbZEZR4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 13:56:36 -0400
Subject: Re: [PATCH 1/1 tip] perf: Don't assume /proc/kallsyms is ordered
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, efault@gmx.de,
       mtosatti@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
       cjashfor@linux.vnet.ibm.com
In-Reply-To: <20090526152134.GF4424@ghostprotocols.net>
References: <tip-59d81029b6804c3d5895d07cad77d7dfddc6b5b2@git.kernel.org>
	 <20090526152134.GF4424@ghostprotocols.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 26 May 2009 19:56:22 +0200
Message-Id: <1243360582.23657.23.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 12:21 -0300, Arnaldo Carvalho de Melo wrote:
> Please fix the previous fix with this:

You don't need a second walk through the RB-tree like that, simply
change the lookup function:

The below finds the first entry that has ->start > ip, we then walk
backwards until we find an entry that has start <= ip < end and end > ip
(should never be more than 1).

This way you can deal with holes (like userspace has), and deal with
entries without size (like kallsyms) by setting size to a random large
value.

---

Index: linux-2.6/Documentation/perf_counter/builtin-report.c
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/builtin-report.c
+++ linux-2.6/Documentation/perf_counter/builtin-report.c
@@ -147,16 +147,25 @@ static struct symbol *dso__find_symbol(s
 		return NULL;
 
 	struct rb_node *n = self->syms.rb_node;
+	struct rb_node *last = NULL;
+	struct symbol *s;
 
 	while (n) {
-		struct symbol *s = rb_entry(n, struct symbol, rb_node);
+		last = n;
+		s = rb_entry(n, struct symbol, rb_node);
 
 		if (ip < s->start)
 			n = n->rb_left;
-		else if (ip > s->end)
-			n = n->rb_right;
 		else
+			n = n->rb_right;
+	}
+
+	while (last) {
+		s = rb_entry(last, struct symbol, rb_node);
+		if (s->start <= ip && ip < s->end)
 			return s;
+
+		last = rb_prev(last);
 	}
 
 	return NULL;

