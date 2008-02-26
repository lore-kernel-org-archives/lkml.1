Return-Path: <linux-kernel-owner+w=401wt.eu-S1762843AbYBZPmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762843AbYBZPmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 10:42:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760554AbYBZPl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 10:41:56 -0500
Received: from qb-out-0506.google.com ([72.14.204.229]:34905 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760867AbYBZPl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 10:41:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=QTb1Ur92uK4gt/ekn6M52jhuJoJJNA/8cXbBql77aSXg9ul6hIyxG7VZ2Fvk9t9PWLnJ8XUKhDne8jVqFPm8amYecfxWSbUnkNvz0FyA/tYR/qrRQOthJJSTOYksAgLcRx36aMLY/9I7QQqm8Cv+UKIftW4fCqCkdDc/JkL8eu8=
Message-ID: <412e6f7f0802260741r7ad475c7pfda3f5f8859b673d@mail.gmail.com>
Date: Tue, 26 Feb 2008 23:41:50 +0800
From: "Changli Gao" <xiaosuo@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [BUG] Potential data corruption when splice data spliced from socket to another socket
Cc: "Changli Gao" <xiaosuo@gmail.com>, jens.axboe@oracle.com,
       davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After reviewing the tcp splice receive code, I found that instead of
increasing the page reference counter, pipe buffer holds the socket
buffer by calling skb_get(skb). When you splice this pipe buffer to
another socket, such as a TCP socket, though the function sendpage
returns, the page buffer will be still in use, then you drop the
reference to the skb, so the buffer is free to another process. At
this time, the buffer is shared between socket and another part of
Linux kernel silently. It is possible that the data sent out is
corrupted.

The reason is splice send process knows nothing but page, so before
submitting the buffer to sendpage, we must ensure that the page is an
actual page not a fake one. A solution is adding a member function
get_page, which is used to get a actual page, to structure
pipe_buffer_operations. It the page in structure pipe_buffer isn't an
actual page, a page will be allocated, filled with the corresponding
data and returned. Before calling sendpage, get_page should be called
to get the actual page, and after calling sendpage, the page will be
freed by calling put_page.

Beside splice send process, other code paths maybe have the same problem.

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
