Return-Path: <linux-kernel-owner+w=401wt.eu-S933257AbZHVSnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257AbZHVSnH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 14:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933228AbZHVSnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 14:43:06 -0400
Received: from server1.wserver.cz ([82.113.45.157]:57508 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933153AbZHVSnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 14:43:04 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Armin Schindler <mac@melware.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/2] ISDN: eicon, use offsetof
Date: Sat, 22 Aug 2009 20:43:03 +0200
Message-Id: <1250966584-29496-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use offsetof instead of explicit implementation.
* fixes bug with omitted & like:
  len = (byte)(((T30_INFO *) 0)->station_id + 20)
* avoids compiler warnings with wrong sizes (pointer-to-char cast):
  len = (byte)(&(((T30_INFO *) 0)->universal_6));
* cleanups the code

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/isdn/hardware/eicon/message.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/message.c b/drivers/isdn/hardware/eicon/message.c
index 27d5dd6..ae89fb8 100644
--- a/drivers/isdn/hardware/eicon/message.c
+++ b/drivers/isdn/hardware/eicon/message.c
@@ -2692,7 +2692,7 @@ static byte connect_b3_req(dword Id, word Number, DIVA_CAPI_ADAPTER *a,
           if (!(fax_control_bits & T30_CONTROL_BIT_MORE_DOCUMENTS)
            || (fax_feature_bits & T30_FEATURE_BIT_MORE_DOCUMENTS))
           {
-            len = (byte)(&(((T30_INFO *) 0)->universal_6));
+            len = offsetof(T30_INFO, universal_6);
             fax_info_change = false;
             if (ncpi->length >= 4)
             {
@@ -2754,7 +2754,7 @@ static byte connect_b3_req(dword Id, word Number, DIVA_CAPI_ADAPTER *a,
                     for (i = 0; i < w; i++)
                       ((T30_INFO   *)(plci->fax_connect_info_buffer))->station_id[i] = fax_parms[4].info[1+i];
                     ((T30_INFO   *)(plci->fax_connect_info_buffer))->head_line_len = 0;
-                    len = (byte)(((T30_INFO *) 0)->station_id + 20);
+                    len = offsetof(T30_INFO, station_id) + 20;
                     w = fax_parms[5].length;
                     if (w > 20)
                       w = 20;
@@ -2788,7 +2788,7 @@ static byte connect_b3_req(dword Id, word Number, DIVA_CAPI_ADAPTER *a,
                 }
                 else
                 {
-                  len = (byte)(&(((T30_INFO *) 0)->universal_6));
+                  len = offsetof(T30_INFO, universal_6);
                 }
                 fax_info_change = true;
 
@@ -2892,7 +2892,7 @@ static byte connect_b3_res(dword Id, word Number, DIVA_CAPI_ADAPTER *a,
     && (plci->nsf_control_bits & T30_NSF_CONTROL_BIT_ENABLE_NSF)
     && (plci->nsf_control_bits & T30_NSF_CONTROL_BIT_NEGOTIATE_RESP))
    {
-            len = ((byte)(((T30_INFO *) 0)->station_id + 20));
+            len = offsetof(T30_INFO, station_id) + 20;
             if (plci->fax_connect_info_length < len)
             {
               ((T30_INFO *)(plci->fax_connect_info_buffer))->station_id_len = 0;
@@ -3802,7 +3802,7 @@ static byte manufacturer_res(dword Id, word Number, DIVA_CAPI_ADAPTER *a,
       break;
     }
     ncpi = &m_parms[1];
-    len = ((byte)(((T30_INFO *) 0)->station_id + 20));
+    len = offsetof(T30_INFO, station_id) + 20;
     if (plci->fax_connect_info_length < len)
     {
       ((T30_INFO *)(plci->fax_connect_info_buffer))->station_id_len = 0;
@@ -6844,7 +6844,7 @@ static void nl_ind(PLCI *plci)
         if ((plci->requested_options_conn | plci->requested_options | a->requested_options_table[plci->appl->Id-1])
           & ((1L << PRIVATE_FAX_SUB_SEP_PWD) | (1L << PRIVATE_FAX_NONSTANDARD)))
         {
-          i = ((word)(((T30_INFO *) 0)->station_id + 20)) + ((T30_INFO   *)plci->NL.RBuffer->P)->head_line_len;
+          i = offsetof(T30_INFO, station_id) + 20 + ((T30_INFO   *)plci->NL.RBuffer->P)->head_line_len;
           while (i < plci->NL.RBuffer->length)
             plci->ncpi_buffer[++len] = plci->NL.RBuffer->P[i++];
         }
@@ -7236,7 +7236,7 @@ static void nl_ind(PLCI *plci)
     {
       plci->RData[1].P = plci->RData[0].P;
       plci->RData[1].PLength = plci->RData[0].PLength;
-      plci->RData[0].P = v120_header_buffer + (-((int) v120_header_buffer) & 3);
+      plci->RData[0].P = v120_header_buffer + (-((unsigned long)v120_header_buffer) & 3);
       if ((plci->NL.RBuffer->P[0] & V120_HEADER_EXTEND_BIT) || (plci->NL.RLength == 1))
         plci->RData[0].PLength = 1;
       else
@@ -8473,7 +8473,7 @@ static word add_b23(PLCI *plci, API_PARSE *bp)
             fax_control_bits |= T30_CONTROL_BIT_ACCEPT_SEL_POLLING;
           }
             len = nlc[0];
-          pos = ((byte)(((T30_INFO *) 0)->station_id + 20));
+          pos = offsetof(T30_INFO, station_id) + 20;
    if (pos < plci->fax_connect_info_length)
    {
      for (i = 1 + plci->fax_connect_info_buffer[pos]; i != 0; i--)
@@ -8525,7 +8525,7 @@ static word add_b23(PLCI *plci, API_PARSE *bp)
       }
 
       PUT_WORD(&(((T30_INFO *)&nlc[1])->control_bits_low), fax_control_bits);
-      len = ((byte)(((T30_INFO *) 0)->station_id + 20));
+      len = offsetof(T30_INFO, station_id) + 20;
       for (i = 0; i < len; i++)
         plci->fax_connect_info_buffer[i] = nlc[1+i];
       ((T30_INFO   *) plci->fax_connect_info_buffer)->head_line_len = 0;
-- 
1.6.3.3

