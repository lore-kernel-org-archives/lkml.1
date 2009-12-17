Return-Path: <linux-kernel-owner+w=401wt.eu-S936096AbZLQBlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936096AbZLQBlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:41:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758376AbZLQBkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:40:49 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:32542 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763639AbZLQBjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:39:51 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAPoaKUurR7H+/2dsb2JhbAC+NpcChCsE
X-IronPort-AV: E=Sophos;i="4.47,409,1257120000"; 
   d="scan'208";a="451016770"
From: Roland Dreier <rdreier@cisco.com>
To: Andrew Isaacson <adi@vmware.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Masami Hiramatsu <mhiramat@redhat.com>, Rob Landley <rob@landley.net>
Subject: Re: CONFIG_KPROBES=y build requires gawk
References: <20091216235617.GA12267@hexapodia.org>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 16 Dec 2009 17:39:48 -0800
In-Reply-To: <20091216235617.GA12267@hexapodia.org> (Andrew Isaacson's message
	of "Wed, 16 Dec 2009 15:56:17 -0800")
Message-ID: <adabphy750b.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Dec 2009 01:39:49.0063 (UTC) FILETIME=[D1FE3D70:01CA7EB9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any reason not to apply the patch below, to allow more awk
implementations to be used?  After all, it's not like we're going to put
non-ASCII characters into the map file...

===

x86: Don't use POSIX character classes in gen-insn-attr-x86.awk

Not all awk implementations (including the default awk in Ubuntu 9.10)
support POSIX character classes.  Since x86-opcode-map.txt is plain
ASCII, we can just use explicit ranges for lower case, alphabetic, and
alphanumeric characters instead.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 arch/x86/tools/gen-insn-attr-x86.awk |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

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
