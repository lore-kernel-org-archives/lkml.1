Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbYIRQ0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbYIRQ0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 12:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbYIRQ0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 12:26:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54163 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbYIRQ0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 12:26:10 -0400
Message-ID: <48D2811B.8090602@zytor.com>
Date: Thu, 18 Sep 2008 09:26:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Pascal Terjan <pterjan@mandriva.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: edd breaking vesafb
References: <1221751035.26693.8.camel@plop>
In-Reply-To: <1221751035.26693.8.camel@plop>
Content-Type: multipart/mixed;
 boundary="------------000102020401040308030108"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000102020401040308030108
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Pascal Terjan wrote:
> Hello
> 
> I got a report of vesafb no longer working since edd is used on a
> machine (Shuttle FN41SP).
> It's a BIOS bug that was easily workarounded by calling set_video before
> query_edd.
> Does someone see some issue in doing that ?
> 

Yes, it means that we won't get the status and error messages from 
query_edd.  In fact, we changed the ordering specifically for this reason.

The VESA code and EDD code both use the boot code heap.  One could guess 
that the problem is data left on the heap by the EDD code causing a 
failure when combined with a bad BIOS.

Does this patch work for you?

	-hpa

--------------000102020401040308030108
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index cc0ef13..f087238 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -205,7 +205,13 @@ static inline int isdigit(int ch)
 extern char _end[];
 extern char *HEAP;
 extern char *heap_end;
-#define RESET_HEAP() ((void *)( HEAP = _end ))
+
+static inline void *RESET_HEAP(void)
+{
+	HEAP = _end;
+	memset(HEAP, 0, heap_end-HEAP);
+	return HEAP;
+}
 static inline char *__get_heap(size_t s, size_t a, size_t n)
 {
 	char *tmp;

--------------000102020401040308030108--
