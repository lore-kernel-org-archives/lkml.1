Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966874Ab0B0Boa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 20:44:30 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56730 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966773Ab0B0Bo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 20:44:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=w36YPyDMkJm82yhUQivUl2kBbOjCYjGhdvfGIME+UCisplZnKwPm9aVougcdWZSVoL
         PEQGDJKp58eQRZbAX5qjozwMBbbi9FVNvLfRwE3wkuC6Eqb/cMJJdI2g60EGu7r6X1c4
         oI6Vifn5GUx/+fLX1YD/gEesyaOSHcd1EbZ/Q=
Message-ID: <4B8878F6.8000809@gmail.com>
Date: Sat, 27 Feb 2010 09:44:22 +0800
From: Ang Way Chuang <wcang79@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] dvb-core: Fix DoS bug in ULE decapsulation code that can
 be triggered by an invalid Payload Pointer
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,
   Sorry, I have to resend this email because I think my email didn't 
through linux-media, stable or security mailing list.


ULE (Unidirectional Lightweight Encapsulation RFC 4326) decapsulation
has a bug that causes endless loop when Payload Pointer of MPEG2-TS
frame is 182 or 183. Anyone who sends malicious MPEG2-TS frame will
cause the receiver of ULE SNDU to go into endless loop.

This patch was generated and tested against linux-2.6.32.9 and should
apply cleanly to linux-2.6.33 as well because there was only one typo
fix to dvb_net.c since v2.6.32.

This bug was brought to you by modern day Santa Claus who decided to
shower the satellite dish at Keio University with heavy snow causing huge
burst of errors. We, receiver end, received Santa Claus's gift in the form
of kernel bug.

Care has been taken not to introduce more bug by fixing this bug, but
please scrutinize the code because I always produces buggy code.

Signed-off-by: Ang Way Chuang <wcang79@gmail.com>
---
--- linux-2.6.32.9/drivers/media/dvb/dvb-core/dvb_net.c	2010-02-23 23:38:51.000000000 +0800
+++ linux-2.6.32.9.new/drivers/media/dvb/dvb-core/dvb_net.c	2010-02-25 04:09:18.000000000 +0800
@@ -504,6 +504,7 @@ static void dvb_net_ule( struct net_devi
				       "bytes left in TS.  Resyncing.\n", ts_remain);
				priv->ule_sndu_len = 0;
				priv->need_pusi = 1;
+				ts += TS_SZ;
				continue;
			}



