Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbYKCTrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbYKCTrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 14:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbYKCTrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 14:47:15 -0500
Received: from hs-out-0708.google.com ([64.233.178.248]:21743 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbYKCTrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 14:47:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=iJAHkvi7K9B8EI2frFHMBbhbLQe/m7P9KJX/PCdqyekXWwW3Qju3uLYv2t5YqsT8Df
         Kz9t8+svhJmAXlgKaGtLdV27U4WB+OGnHBGMuxqfIC+iRKwDusevHbUGxo89e+fERLFm
         WbYvEkaLXNaf1JlG3PnCePSyGr2oihVfrRXv0=
Message-ID: <524f69650811031147g6c133ed8wc8031a8586d66eaa@mail.gmail.com>
Date: Mon, 3 Nov 2008 13:47:10 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Jeff Layton" <jlayton@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Do iov_len and iov_base have to be reset after EAGAIN on kernel_recvmsg?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cifs_demultiplex_thread Shirish suggested changing the following to
handle the case in which EAGAIN is returned from kernel_recvmsg and
has corrupted the value of iov_len and iov_base

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -417,10 +417,16 @@ incomplete_rcv:
 			msleep(1); /* minimum sleep to prevent looping
 				allowing socket to clear and app threads to set
 				tcpStatus CifsNeedReconnect if server hung */
-			if (pdu_length < 4)
+			if (pdu_length < 4) {
+				iov.iov_base = (4 - pdu_length) +
+							(char *)smb_buffer;
+				iov.iov_len = pdu_length;
+				smb_msg.msg_control = NULL;
+				smb_msg.msg_controllen = 0;
 				goto incomplete_rcv;

based on Sridhar's comment:

"i think you are running into a case where kernel_recvmsg() is called
via 'goto incomplete_rcv'
It happens if the previous call fails with EAGAIN.  If you want to
call recvmsg() after EAGAIN failure, you need to reset iov."

It sounds strange to reset iov_len and iov_base on EAGAIN or ENOSPACE
from the socket, but seems harmless ... but what about resetting
msg_control and msg_controllen ... is that ever necessary?  Is that
safe?

-- 
Thanks,

Steve
