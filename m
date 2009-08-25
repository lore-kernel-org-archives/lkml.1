Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbZHYSyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbZHYSyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbZHYSyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:54:11 -0400
Received: from server1.wserver.cz ([82.113.45.157]:50815 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbZHYSyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:54:10 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: tony.luck@intel.com
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 1/1] ia64: pci_br, fix infinite loop
Date: Tue, 25 Aug 2009 20:54:10 +0200
Message-Id: <1251226450-25280-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When
* there is almost out of ates
* one asks for more than one ate
* there are some available at the end of ate array
then the inner for loop will end without incrementing 'index'. This
means the outer loop will start at the same point finding it's available
and runs the inner loop again from the same index. This repeats forever.

Hence make sure we check we were at the end of ate array and return
an error in such case.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Found-by: Jeff Mahoney <jeffm@novell.com>
---
 arch/ia64/sn/pci/pcibr/pcibr_ate.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/sn/pci/pcibr/pcibr_ate.c b/arch/ia64/sn/pci/pcibr/pcibr_ate.c
index 239b3ce..5bc34ea 100644
--- a/arch/ia64/sn/pci/pcibr/pcibr_ate.c
+++ b/arch/ia64/sn/pci/pcibr/pcibr_ate.c
@@ -54,6 +54,8 @@ static int find_free_ate(struct ate_resource *ate_resource, int start,
 					break;
 				}
 			}
+			if (i >= ate_resource->num_ate)
+				return -1;
 		} else
 			index++;	/* Try next ate */
 	}
-- 
1.6.3.3

