Return-Path: <linux-kernel-owner+w=401wt.eu-S932929AbZLJFqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbZLJFqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 00:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932850AbZLJFqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 00:46:40 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:40008 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932846AbZLJFqj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 00:46:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=o7y0Sn/ZcG4bWjgS0lyEt9VvsX4RFoxV1hBkitQC7A8OvGZvVh3/TZwyRliD5cvk4a
         96PCItYUTjDki3qaBRQrCGotiJ1S+o1RxXE4SrASH72vmUxzLRPG0QfZAPQ6HFGf/nwE
         NUgfOmHBKXmWl3WKdE3ll/UgQpMcKCi1XdWzo=
MIME-Version: 1.0
Date: Thu, 10 Dec 2009 13:46:46 +0800
Message-ID: <6304b52b0912092146u15d9ac00s7b1cb4008d2a6676@mail.gmail.com>
Subject: [PATCH]about eicon: array subscript is above array bounds
From: Jerry Leo <jerryleo860202@gmail.com>
To: isdn@linux-pingi.de
Cc: linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       i4ldeveloper@listserv.isdn4linux.de
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Karsten Keil,

       When i compile eicon,there have some waning look like this:

          CC [M]  drivers/isdn/hardware/eicon/message.o
drivers/isdn/hardware/eicon/message.c: In function ‘add_b23’:
drivers/isdn/hardware/eicon/message.c:8426: warning: array subscript
is above array bounds
drivers/isdn/hardware/eicon/message.c:8427: warning: array subscript
is above array bounds
drivers/isdn/hardware/eicon/message.c:8434: warning: array subscript
is above array bounds
drivers/isdn/hardware/eicon/message.c:8435: warning: array subscript
is above array bounds
drivers/isdn/hardware/eicon/message.c:8436: warning: array subscript
is above array bounds
drivers/isdn/hardware/eicon/message.c:8447: warning: array subscript
is above array bounds

I think the array is short then be used,because the array's max length
is 20, then it will use long than this, the code is in
"drivers/isdn/hardware/eicon/divacapi.h" 1360L, 50994C  :


#define T30_MAX_STATION_ID_LENGTH       20
#define T30_MAX_SUBADDRESS_LENGTH       20
#define T30_MAX_PASSWORD_LENGTH         20

typedef struct t30_info_s T30_INFO;
struct t30_info_s {
 byte          code;
 byte          rate_div_2400;
 byte          resolution;
 byte          data_format;
 byte          pages_low;
 byte          pages_high;
 byte          operating_mode;
 byte          control_bits_low;
 byte          control_bits_high;
 byte          feature_bits_low;
 byte          feature_bits_high;
 byte          recording_properties;
 byte          universal_6;
 byte          universal_7;
 byte          station_id_len;
 byte          head_line_len;
 byte          station_id[T30_MAX_STATION_ID_LENGTH];
/* byte          head_line[];      */
/* byte          sub_sep_length;   */
/* byte          sub_sep_field[];  */
/* byte          pwd_length;       */
/* byte          pwd_field[];      */
/* byte          nsf_info_length;   */
/* byte          nsf_info_field[];  */
};

"drivers/isdn/hardware/eicon/message.c" 15071L, 487328C

       if (pos != 0)
       {
         if (CAPI_MAX_DATE_TIME_LENGTH + 2 +
b3_config_parms[3].length > CAPI_MAX_HEAD_LINE_SPACE)
           pos = 0;
         else
         {
           ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ' ';
           ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ' ';
           len = (byte)b3_config_parms[2].length;
           if (len > 20)
             len = 20;
           if (CAPI_MAX_DATE_TIME_LENGTH + 2 + len + 2 +
b3_config_parms[3].length <= CAPI_MAX_HEAD_LINE_SPACE)
           {
             for (i = 0; i < len; i++)
               ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ((byte
 *)b3_config_parms[2].info)[1+i];
             ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ' ';
             ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ' ';
           }
         }
       }



can this patch commit?

diff --git a/linux-2.6/drivers/isdn/hardware/eicon/divacapi.h
b/linux-2.6/drivers/isdn/hardware/eicon/divacapi.h.orig
index d9462f7..9f5b680 100644
--- a/linux-2.6/drivers/isdn/hardware/eicon/divacapi.h
+++ b/linux-2.6/drivers/isdn/hardware/eicon/divacapi.h.orig
@@ -445,7 +445,7 @@ struct _DIVA_CAPI_ADAPTER {
 #define CAPI_MAX_HEAD_LINE_SPACE        89
 #define CAPI_MAX_DATE_TIME_LENGTH       18

-#define T30_MAX_STATION_ID_LENGTH       30
+#define T30_MAX_STATION_ID_LENGTH       20
 #define T30_MAX_SUBADDRESS_LENGTH       20
 #define T30_MAX_PASSWORD_LENGTH         20



                                      Jerry Leo
