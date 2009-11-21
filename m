Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbZKUWKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbZKUWKD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 17:10:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756842AbZKUWKC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 17:10:02 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:56262 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840AbZKUWKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 17:10:01 -0500
Message-ID: <4B086536.7080402@freemail.hu>
Date: Sat, 21 Nov 2009 23:09:58 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Dave Boutcher <boutcher@us.ibm.com>, Santiago Leon <santil@us.ibm.com>,
       Linda Xie <lxie@us.ibm.com>, FUJITA Tomonori <tomof@acm.org>,
       linux-scsi@vger.kernel.org
CC: cocci@diku.dk, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] ibmvscsi: remove redundant zero fill
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32711; Body=7 Fuz1=7
	Fuz2=7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The buffer is first zeroed out by memset(). Then strncpy() is used to
fill the content. The strncpy() function also pads the string till the
end of the specified length, which is redundant. The strncpy() does not
ensures that the string will be properly closed with 0. Use strlcpy()
instead.

The semantic match that finds this kind of pattern is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression buffer;
expression size;
expression str;
@@
	memset(buffer, 0, size);
	...
-	strncpy(
+	strlcpy(
	buffer, str, sizeof(buffer)
	);
@@
expression buffer;
expression size;
expression str;
@@
	memset(&buffer, 0, size);
	...
-	strncpy(
+	strlcpy(
	&buffer, str, sizeof(buffer));
@@
expression buffer;
identifier field;
expression size;
expression str;
@@
	memset(buffer, 0, size);
	...
-	strncpy(
+	strlcpy(
	buffer->field, str, sizeof(buffer->field)
	);
@@
expression buffer;
identifier field;
expression size;
expression str;
@@
	memset(&buffer, 0, size);
	...
-	strncpy(
+	strlcpy(
	buffer.field, str, sizeof(buffer.field));
// </smpl>

On strncpy() vs strlcpy() see http://www.gratisoft.us/todd/papers/strlcpy.html .

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -u -p a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c 2009-09-10 00:13:59.000000000 +0200
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c 2009-11-21 22:10:13.000000000 +0100
@@ -339,7 +339,7 @@ int send_adapter_info(struct iu_entry *i
 	memset(info, 0, sizeof(*info));

 	strcpy(info->srp_version, "16.a");
-	strncpy(info->partition_name, partition_name,
+	strlcpy(info->partition_name, partition_name,
 		sizeof(info->partition_name));
 	info->partition_number = partition_number;
 	info->mad_version = 1;
diff -u -p a/drivers/scsi/ibmvscsi/rpa_vscsi.c b/drivers/scsi/ibmvscsi/rpa_vscsi.c
--- a/drivers/scsi/ibmvscsi/rpa_vscsi.c 2009-09-10 00:13:59.000000000 +0200
+++ b/drivers/scsi/ibmvscsi/rpa_vscsi.c 2009-11-21 22:10:15.000000000 +0100
@@ -181,7 +181,7 @@ static void set_adapter_info(struct ibmv
 	dev_info(hostdata->dev, "SRP_VERSION: %s\n", SRP_VERSION);
 	strcpy(hostdata->madapter_info.srp_version, SRP_VERSION);

-	strncpy(hostdata->madapter_info.partition_name, partition_name,
+	strlcpy(hostdata->madapter_info.partition_name, partition_name,
 			sizeof(hostdata->madapter_info.partition_name));

 	hostdata->madapter_info.partition_number = partition_number;

