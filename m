Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbZJPSkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbZJPSkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 14:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbZJPSkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 14:40:06 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53065 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbZJPSkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 14:40:02 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 4/7] checkpatch: fix false errors due to macro concatenation
Date: Fri, 16 Oct 2009 19:39:29 +0100
Message-Id: <1255718372-22805-5-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1255718372-22805-1-git-send-email-apw@canonical.com>
References: <1255718372-22805-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro concatenation (##) sequence can cause false errors when checking
macro's. Checkpatch doesn't currently know about the operator.

For example this line,

+ 	entry = (struct ftrace_raw_##call *)raw_data;                   \

is correct but it produces the following error,

ERROR: need consistent spacing around '*' (ctx:WxB)
+       entry = (struct ftrace_raw_##call *)raw_data;\
                                          ^

The line above doesn't have any spacing problems, and if you remove the
macro concatenation sequence checkpatch doesn't give any errors.

Extend identifier handling to include ## concatenation within the
definition of an identifier.

Reported-by: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 05b10d6..cb2dac3 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -130,7 +130,10 @@ if ($tree) {
 
 my $emitted_corrupt = 0;
 
-our $Ident       = qr{[A-Za-z_][A-Za-z\d_]*};
+our $Ident	= qr{
+			[A-Za-z_][A-Za-z\d_]*
+			(?:\s*\#\#\s*[A-Za-z_][A-Za-z\d_]*)*
+		}x;
 our $Storage	= qr{extern|static|asmlinkage};
 our $Sparse	= qr{
 			__user|
-- 
1.6.3.3

