Return-Path: <linux-kernel-owner+w=401wt.eu-S1761649AbXEVFIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761649AbXEVFIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 01:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756073AbXEVFIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 01:08:23 -0400
Received: from fed1rmmtao101.cox.net ([68.230.241.45]:44746 "EHLO
	fed1rmmtao101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbXEVFIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 01:08:22 -0400
From: Junio C Hamano <junkio@cox.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: [PATCH 3/3] Make ide dma blacklist handling a bit saner.
References: <20070521145042.GA6957@redhat.com>
	<20070521171551.0f81a0be@the-village.bc.nu>
	<7v3b1pbgeo.fsf_-_@assigned-by-dhcp.cox.net>
Date: Mon, 21 May 2007 22:08:21 -0700
In-Reply-To: <7v3b1pbgeo.fsf_-_@assigned-by-dhcp.cox.net> (Junio C. Hamano's
	message of "Mon, 21 May 2007 22:01:35 -0700")
Message-ID: <7vps4ta1iy.fsf_-_@assigned-by-dhcp.cox.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Earlier, the matching of (model,rev) in ide-dma black/white list
handling was to consider "ALL" in the table to match any
revision.  This changes the wildcard to NULL.  This way, the
DMA_BLACK_LIST macro used in the previous patch does not have to
use a slightly funky compile time constant expression to convert
NULL to "ALL".

Signed-off-by: Junio C Hamano <junkio@cox.net>
---

 * I do not really know what I am doing in the mips area, but
   that architecture specific table seems to be used by the same
   ide_in_drive_list() function, so the entries are matched to
   the updated code.

 drivers/ide/ide-dma.c                     |   14 +++++++-------
 include/asm-mips/mach-au1x00/au1xxx_ide.h |   28 ++++++++++++++--------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index a6a2074..c0b5b10 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -91,16 +91,16 @@
 
 static const struct drive_list_entry drive_whitelist [] = {
 
-	{ "Micropolis 2112A"	,       "ALL"		},
-	{ "CONNER CTMA 4000"	,       "ALL"		},
-	{ "CONNER CTT8000-A"	,       "ALL"		},
-	{ "ST34342A"		,	"ALL"		},
+	{ "Micropolis 2112A"	,       NULL		},
+	{ "CONNER CTMA 4000"	,       NULL		},
+	{ "CONNER CTT8000-A"	,       NULL		},
+	{ "ST34342A"		,	NULL		},
 	{ NULL			,	NULL		}
 };
 
 static const struct drive_list_entry drive_blacklist [] = {
 
-#define DMA_BLACK_LIST(model,rev) { (model), (rev==NULL ? "ALL" : (rev)) }
+#define DMA_BLACK_LIST(model,rev) { (model), (rev) }
 #include "dma-blacklist.h"
 #undef DMA_BLACK_LIST
 	{ NULL			,	NULL		}
@@ -120,8 +120,8 @@ int ide_in_drive_list(struct hd_driveid *id, const struct drive_list_entry *driv
 {
 	for ( ; drive_table->id_model ; drive_table++)
 		if ((!strcmp(drive_table->id_model, id->model)) &&
-		    ((strstr(id->fw_rev, drive_table->id_firmware)) ||
-		     (!strcmp(drive_table->id_firmware, "ALL"))))
+		    (!drive_table->id_firmware ||
+		     strstr(id->fw_rev, drive_table->id_firmware)))
 			return 1;
 	return 0;
 }
diff --git a/include/asm-mips/mach-au1x00/au1xxx_ide.h b/include/asm-mips/mach-au1x00/au1xxx_ide.h
index 8fcae21..4663e8b 100644
--- a/include/asm-mips/mach-au1x00/au1xxx_ide.h
+++ b/include/asm-mips/mach-au1x00/au1xxx_ide.h
@@ -88,26 +88,26 @@ static const struct drive_list_entry dma_white_list [] = {
 /*
  * Hitachi
  */
-        { "HITACHI_DK14FA-20"    ,       "ALL"           },
-        { "HTS726060M9AT00"      ,       "ALL"           },
+        { "HITACHI_DK14FA-20"    ,       NULL            },
+        { "HTS726060M9AT00"      ,       NULL            },
 /*
  * Maxtor
  */
-        { "Maxtor 6E040L0"      ,       "ALL"           },
-        { "Maxtor 6Y080P0"      ,       "ALL"           },
-        { "Maxtor 6Y160P0"      ,       "ALL"           },
+        { "Maxtor 6E040L0"      ,       NULL            },
+        { "Maxtor 6Y080P0"      ,       NULL            },
+        { "Maxtor 6Y160P0"      ,       NULL            },
 /*
  * Seagate
  */
-        { "ST3120026A"          ,       "ALL"           },
-        { "ST320014A"           ,       "ALL"           },
-        { "ST94011A"            ,       "ALL"           },
-        { "ST340016A"           ,       "ALL"           },
+        { "ST3120026A"          ,       NULL            },
+        { "ST320014A"           ,       NULL            },
+        { "ST94011A"            ,       NULL            },
+        { "ST340016A"           ,       NULL            },
 /*
  * Western Digital
  */
-        { "WDC WD400UE-00HCT0"  ,       "ALL"           },
-        { "WDC WD400JB-00JJC0"  ,       "ALL"           },
+        { "WDC WD400UE-00HCT0"  ,       NULL            },
+        { "WDC WD400JB-00JJC0"  ,       NULL            },
         { NULL                  ,       NULL            }
 };
 
@@ -116,9 +116,9 @@ static const struct drive_list_entry dma_black_list [] = {
 /*
  * Western Digital
  */
-        { "WDC WD100EB-00CGH0"  ,       "ALL"           },
-        { "WDC WD200BB-00AUA1"  ,       "ALL"           },
-        { "WDC AC24300L"        ,       "ALL"           },
+        { "WDC WD100EB-00CGH0"  ,       NULL            },
+        { "WDC WD200BB-00AUA1"  ,       NULL            },
+        { "WDC AC24300L"        ,       NULL            },
         { NULL                  ,       NULL            }
 };
 #endif
-- 
1.5.2.24.g93d4


