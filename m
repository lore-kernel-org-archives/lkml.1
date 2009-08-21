Return-Path: <linux-kernel-owner+w=401wt.eu-S932227AbZHUTlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbZHUTlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 15:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755819AbZHUTlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 15:41:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821AbZHUTla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 15:41:30 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH tracing/kprobes 2/4] x86: Check awk features before generating
	inat-tables.c
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?utf-8?q?Przemys=C5=82aw?= =?utf-8?q?Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 21 Aug 2009 15:43:16 -0400
Message-ID: <20090821194316.12478.57394.stgit@localhost.localdomain>
In-Reply-To: <20090821000108.GC6078@nowhere>
References: <20090821000108.GC6078@nowhere>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check some awk features which old mawk doesn't support.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Przemysław Pawełczyk <przemyslaw@pawelczyk.it>
Cc: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
---

 arch/x86/tools/gen-insn-attr-x86.awk |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
index 93b62c9..19ba096 100644
--- a/arch/x86/tools/gen-insn-attr-x86.awk
+++ b/arch/x86/tools/gen-insn-attr-x86.awk
@@ -4,7 +4,25 @@
 #
 # Usage: awk -f gen-insn-attr-x86.awk x86-opcode-map.txt > inat-tables.c
 
+# Awk implementation sanity check
+function check_awk_implement() {
+	if (!match("abc", "[[:lower:]]+"))
+		return "Your awk doesn't support charactor-class."
+	if (sprintf("%x", 0) != "0")
+		return "Your awk has a printf-format problem."
+	return ""
+}
+
 BEGIN {
+	# Implementation error checking
+	awkchecked = check_awk_implement()
+	if (awkchecked != "") {
+		print "Error: " awkchecked > "/dev/stderr"
+		print "Please try to use gawk." > "/dev/stderr"
+		exit 1
+	}
+
+	# Setup generating tables
 	print "/* x86 opcode map generated from x86-opcode-map.txt */"
 	print "/* Do not change this code. */"
 	ggid = 1
@@ -293,6 +311,8 @@ function convert_operands(opnd,       i,imm,mod)
 }
 
 END {
+	if (awkchecked != "")
+		exit 1
 	# print escape opcode map's array
 	print "/* Escape opcode map array */"
 	print "const insn_attr_t const *inat_escape_tables[INAT_ESC_MAX + 1]" \


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
