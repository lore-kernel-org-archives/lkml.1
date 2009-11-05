Return-Path: <linux-kernel-owner+w=401wt.eu-S1758785AbZKEUV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbZKEUV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 15:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758631AbZKEUVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 15:21:24 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:29877 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758587AbZKEUVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 15:21:23 -0500
Subject: [PATCH v2 3/3] page-types: exit early when invoked with -d|--describe
To: akpm@linux-foundation.org, fengguang.wu@intel.com
From: Alex Chiang <achiang@hp.com>
Cc: Haicheng Li <haicheng.li@intel.com>, linux-mm@kvack.org,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Date: Thu, 05 Nov 2009 13:21:26 -0700
Message-ID: <20091105202126.25492.84269.stgit@bob.kio>
In-Reply-To: <20091105201846.25492.52935.stgit@bob.kio>
References: <20091105201846.25492.52935.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a system with large amount of memory (256GB), invoking page-types
can take quite a long time, which is unreasonable considering the user
only wants a description of the flags:

	# time ./page-types -d 0x10
	0x0000000000000010	____D_____________________________	dirty

	real	0m34.285s
	user	0m1.966s
	sys	0m32.313s

This is because we still walk the entire address range.

Exiting early seems like a reasonble solution:

# time ./page-types -d 0x10
	0x0000000000000010	____D_____________________________	dirty

	real	0m0.007s
	user	0m0.001s
	sys	0m0.005s

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Haicheng Li <haicheng.li@intel.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 Documentation/vm/page-types.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Documentation/vm/page-types.c b/Documentation/vm/page-types.c
index 9c09eb5..9cf50ab 100644
--- a/Documentation/vm/page-types.c
+++ b/Documentation/vm/page-types.c
@@ -940,9 +940,8 @@ int main(int argc, char *argv[])
 			parse_bits_mask(optarg);
 			break;
 		case 'd':
-			opt_no_summary = 1;
 			describe_flags(optarg);
-			break;
+			exit(0);
 		case 'l':
 			opt_list = 1;
 			break;

