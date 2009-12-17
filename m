Return-Path: <linux-kernel-owner+w=401wt.eu-S1751430AbZLQFLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbZLQFLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 00:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbZLQFLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 00:11:13 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:7668 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbZLQFLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 00:11:11 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADNMKUurR7Hu/2dsb2JhbAC+VZZ/hCsE
X-IronPort-AV: E=Sophos;i="4.47,410,1257120000"; 
   d="scan'208";a="451102705"
From: Roland Dreier <rdreier@cisco.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andrew Isaacson <adi@vmware.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Rob Landley <rob@landley.net>
Subject: Re: CONFIG_KPROBES=y build requires gawk
References: <20091216235617.GA12267@hexapodia.org>
	<adabphy750b.fsf@roland-alpha.cisco.com> <4B29A686.9070603@redhat.com>
	<ada3a3a6xs6.fsf@roland-alpha.cisco.com> <4B29BA13.7020502@redhat.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 16 Dec 2009 21:11:09 -0800
In-Reply-To: <4B29BA13.7020502@redhat.com> (Masami Hiramatsu's message of
	"Wed, 16 Dec 2009 23:56:51 -0500")
Message-ID: <aday6l25gnm.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Dec 2009 05:11:10.0090 (UTC) FILETIME=[587966A0:01CA7ED7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > As Al Viro said, if we run awk with LC_ALL=C, then the characters will be
 > sorted as ASCII. So, your patch is OK if you can add LC_ALL=C just before
 > $(AWK). (I'm not so sure whether Makefile can accept it...)

OK, updated patch:

===

x86: Don't use POSIX character classes in gen-insn-attr-x86.awk

Not all awk implementations (including the default awk in Ubuntu 9.10)
support POSIX character classes.  Since x86-opcode-map.txt is plain
ASCII, we can just use explicit ranges for lower case, alphabetic, and
alphanumeric characters instead.  We set LC_ALL=C when invoking awk so
that ASCII ranges are never misinterpreted.

I verified that the Debian version of mawk, which doesn't have POSIX
character set suport, generates the byte-for-byte the same inat-tables.c
after this patch as gawk did on an unpatched kernel.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 arch/x86/lib/Makefile                |    2 +-
 arch/x86/tools/gen-insn-attr-x86.awk |   10 ++++------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 45b20e4..0c46d60 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -5,7 +5,7 @@
 inat_tables_script = $(srctree)/arch/x86/tools/gen-insn-attr-x86.awk
 inat_tables_maps = $(srctree)/arch/x86/lib/x86-opcode-map.txt
 quiet_cmd_inat_tables = GEN     $@
-      cmd_inat_tables = $(AWK) -f $(inat_tables_script) $(inat_tables_maps) > $@ || rm -f $@
+      cmd_inat_tables = LC_ALL=C $(AWK) -f $(inat_tables_script) $(inat_tables_maps) > $@ || rm -f $@
 
 $(obj)/inat-tables.c: $(inat_tables_script) $(inat_tables_maps)
 	$(call cmd,inat_tables)
diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
index 7a68506..eaf11f5 100644
--- a/arch/x86/tools/gen-insn-attr-x86.awk
+++ b/arch/x86/tools/gen-insn-attr-x86.awk
@@ -6,8 +6,6 @@
 
 # Awk implementation sanity check
 function check_awk_implement() {
-	if (!match("abc", "[[:lower:]]+"))
-		return "Your awk doesn't support charactor-class."
 	if (sprintf("%x", 0) != "0")
 		return "Your awk has a printf-format problem."
 	return ""
@@ -44,12 +42,12 @@ BEGIN {
 	delete gtable
 	delete atable
 
-	opnd_expr = "^[[:alpha:]/]"
+	opnd_expr = "^[A-Za-z/]"
 	ext_expr = "^\\("
 	sep_expr = "^\\|$"
-	group_expr = "^Grp[[:alnum:]]+"
+	group_expr = "^Grp[0-9A-Za-z]+"
 
-	imm_expr = "^[IJAO][[:lower:]]"
+	imm_expr = "^[IJAO][a-z]"
 	imm_flag["Ib"] = "INAT_MAKE_IMM(INAT_IMM_BYTE)"
 	imm_flag["Jb"] = "INAT_MAKE_IMM(INAT_IMM_BYTE)"
 	imm_flag["Iw"] = "INAT_MAKE_IMM(INAT_IMM_WORD)"
@@ -62,7 +60,7 @@ BEGIN {
 	imm_flag["Ob"] = "INAT_MOFFSET"
 	imm_flag["Ov"] = "INAT_MOFFSET"
 
-	modrm_expr = "^([CDEGMNPQRSUVW/][[:lower:]]+|NTA|T[012])"
+	modrm_expr = "^([CDEGMNPQRSUVW/][a-z]+|NTA|T[012])"
 	force64_expr = "\\([df]64\\)"
 	rex_expr = "^REX(\\.[XRWB]+)*"
 	fpu_expr = "^ESC" # TODO
