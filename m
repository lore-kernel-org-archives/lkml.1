Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbXKSJa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbXKSJa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 04:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbXKSJas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 04:30:48 -0500
Received: from styx.suse.cz ([82.119.242.94]:45429 "EHLO elijah.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752693AbXKSJas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 04:30:48 -0500
Subject: [CIFS] still incorrect cifs_reconnect fix?
From: Petr Tesarik <ptesarik@suse.cz>
To: linux-cifs-client@lists.samba.org
Cc: Steve French <smfrench@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: SuSE CR
Date: Mon, 19 Nov 2007 10:30:45 +0100
Message-Id: <1195464645.29063.12.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while merging commits f01d5e14e764b14b6bf5512678523d009254b209 and
638b250766272fcaaa0f7ed2776f58f4ac701914 into SLES10, I've noticed that
there's apparently a bug. The code currently looks like this:

		pdu_length = 4; /* enough to get RFC1001 header */
incomplete_rcv:
		length =
		    kernel_recvmsg(csocket, &smb_msg,
				&iov, 1, pdu_length, 0 /* BB other flags? */);

/* ... some irrelevant code left out ... */

		} else if (length < 4) {	/* <----- HERE IS THE PROBLEM
			cFYI(1, ("less than four bytes received (%d bytes)",
			      length));
			pdu_length -= length;
			msleep(1);
			goto incomplete_rcv;
		}

I think we should be checking for length < pdu_length, not for length <
4, because if we read 2 bytes in the first run and 2 bytes in the second
un, CIFS will still treat the second run as incomplete (and possibly run
in an infinite loop). Am I missing something obvious?

Kind regards,
Petr Tesarik

