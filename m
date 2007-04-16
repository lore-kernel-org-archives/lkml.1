Return-Path: <linux-kernel-owner+w=401wt.eu-S1752433AbXDPNU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbXDPNU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 09:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbXDPNU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 09:20:29 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:52994 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbXDPNU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 09:20:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Kh2nFgsql7WK3Z+AS76uruR45KHlInPHADqOG+qcIwx2/v/8+9lnKw4jWYBihFIXFefITI4KhQDQizmgwTFCzD2ET8Skt1eoUIJzpT1ekVQRtSg2yu6fU58NMjbVdwcCRvxiYwadeHj/PorW0qD/JN+OzxiFo6q0sIF4aaStHaA=
Message-ID: <cc5198fe0704160620x4f109537mea8146b4743d06d2@mail.gmail.com>
Date: Mon, 16 Apr 2007 16:20:27 +0300
From: "Alex Landau" <landau.alex@gmail.com>
To: sam@ravnborg.org
Subject: [PATCH] kbuild: Handle compressed cpio initramfs-es
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make kbuild handle compressed cpio initramfs-es. An already
compressed cpio is copied directly to usr/, while a non-compressed cpio
is filtered through gzip (no changes here) on its way to usr/.

Signed-off-by: Alex Landau <landau.alex@gmail.com>
---
If the user has created a compressed cpio by other means, this saves
him from uncompressing it, just to be compressed again by kbuild.
--- a/scripts/gen_initramfs_list.sh
+++ b/scripts/gen_initramfs_list.sh
@@ -190,9 +190,10 @@
 	source="$1"
 	if [ -f "$1" ]; then
 		${dep_list}header "$1"
-		is_cpio="$(echo "$1" | sed 's/^.*\.cpio/cpio/')"
+		is_cpio="$(echo "$1" | sed 's/^.*\.cpio\(\..*\)\?/cpio/')"
 		if [ $2 -eq 0 -a ${is_cpio} == "cpio" ]; then
 			cpio_file=$1
+			echo "$1" | grep -q '^.*\.cpio\..*' && is_cpio_compressed="compressed"
 			[ ! -z ${dep_list} ] && echo "$1"
 			return 0
 		fi
@@ -222,6 +223,7 @@
 cpio_list=
 output="/dev/stdout"
 output_file=""
+is_cpio_compressed=

 arg="$1"
 case "$arg" in
@@ -281,7 +283,11 @@
 		cpio_tfile=${cpio_file}
 	fi
 	rm ${cpio_list}
-	cat ${cpio_tfile} | gzip -f -9 - > ${output_file}
+	if [ "${is_cpio_compressed}" = "compressed" ]; then
+		cat ${cpio_tfile} > ${output_file}
+	else
+		cat ${cpio_tfile} | gzip -f -9 - > ${output_file}
+	fi
 	[ -z ${cpio_file} ] && rm ${cpio_tfile}
 fi
 exit 0
