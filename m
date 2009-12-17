Return-Path: <linux-kernel-owner+w=401wt.eu-S1761506AbZLQA4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761506AbZLQA4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763469AbZLQA4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:56:34 -0500
Received: from kroah.org ([198.145.64.141]:44537 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761552AbZLQAyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:54:44 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 16:47:09 2009
Message-Id: <20091217004708.982827493@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 16:46:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Bohac <jbohac@suse.cz>, Tony Luck <tony.luck@intel.com>,
       Dennis Schridde <devurandom@gmx.net>
Subject: [14/18] [IA64] fix csum_ipv6_magic()
In-Reply-To: <20091217005306.GA6230@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jiri Bohac <jbohac@suse.cz>

commit 5afe18d2f58812f3924edbd215464e5e3e8545e7 upstream.

The 32-bit parameters (len and csum) of csum_ipv6_magic() are passed in 64-bit
registers in2 and in4. The high order 32 bits of the registers were never
cleared, and garbage was sometimes calculated into the checksum.

Fix this by clearing the high order 32 bits of these registers.

Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: Dennis Schridde <devurandom@gmx.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/ia64/lib/ip_fast_csum.S |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/ia64/lib/ip_fast_csum.S
+++ b/arch/ia64/lib/ip_fast_csum.S
@@ -96,20 +96,22 @@ END(ip_fast_csum)
 GLOBAL_ENTRY(csum_ipv6_magic)
 	ld4	r20=[in0],4
 	ld4	r21=[in1],4
-	dep	r15=in3,in2,32,16
+	zxt4	in2=in2
 	;;
 	ld4	r22=[in0],4
 	ld4	r23=[in1],4
-	mux1	r15=r15,@rev
+	dep	r15=in3,in2,32,16
 	;;
 	ld4	r24=[in0],4
 	ld4	r25=[in1],4
-	shr.u	r15=r15,16
+	mux1	r15=r15,@rev
 	add	r16=r20,r21
 	add	r17=r22,r23
+	zxt4	in4=in4
 	;;
 	ld4	r26=[in0],4
 	ld4	r27=[in1],4
+	shr.u	r15=r15,16
 	add	r18=r24,r25
 	add	r8=r16,r17
 	;;


