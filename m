Return-Path: <linux-kernel-owner+w=401wt.eu-S934300AbYETPZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934300AbYETPZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932645AbYETPZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:25:34 -0400
Received: from visualserver.org ([84.242.66.126]:40698 "EHLO visualserver.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932867AbYETPZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:25:33 -0400
Date: Tue, 20 May 2008 17:25:29 +0200 (CEST)
From: Soumyadip Das Mahapatra <kernelhacker@visualserver.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
cc: Harvey Harrison <harvey.harrison@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] bitreversal program
In-Reply-To: <961aa3350805200513i4e02716eh79da76345718c3b2@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0805201716160.25111@visualserver.org>
References: <Pine.LNX.4.64.0805191859411.18461@visualserver.org> 
 <1211229736.5915.86.camel@brick>  <Pine.LNX.4.64.0805201254240.18899@visualserver.org>
 <961aa3350805200513i4e02716eh79da76345718c3b2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-visualserver.org-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: 77FD42FB42.11F9B
X-visualserver.org-MailScanner: Found to be clean
X-visualserver.org-MailScanner-From: kernelhacker@visualserver.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for giving a reply Akinobu :-)
I forgot that bitrev8() is static in header file. Sorry for that.

Below is my new patch considering this. Cant it be applicable?
Please review it.

I know that my bitrev8() takes more instructions than that
of yours. But we have to think about faster access of cpu cache over that
of memory cache(which your bit_rev_table uses).

Thanks anyway ;-)

---Inline Attachment---
--- a/include/linux/bitrev.h    2008-04-17 08:19:44.000000000 +0530
+++ b/include/linux/bitrev.h    2008-05-20 20:41:13.000000000 +0530
@@ -3,11 +3,49 @@

  #include <linux/types.h>

-extern u8 const byte_rev_table[256];
+/**
+ * Here is a generalised bit reversal program
+ * @x: word to get bits reversed
+ * @k: key, explained below
+ * for k = 31, it reverses the bits of word(32 bit)
+ * for k = 24, it reverses the bytes in word
+ * for k = 7, it reverses the bits in every byte without
+ * changing the positions of bytes in a word
+ * and for k = 16 it swaps the left and right halves of a
+ * word
+ */
+
+static inline u32 gen_bit_rev(u32 x, u32 k)
+{
+       if(k & 1)
+               x = (x & 0x55555555) << 1 | (x & 0xaaaaaaaa) >> 1;
+       if(k & 2)
+               x = (x & 0x33333333) << 2 | (x & 0xcccccccc) >> 2;
+       if(k & 4)
+               x = (x & 0x0f0f0f0f) << 4 | (x & 0xf0f0f0f0) >> 4;
+       if(k & 8)
+               x = (x & 0x00ff00ff) << 8 | (x & 0xff00ff00) >> 8;
+       if(k & 16)
+               x = (x & 0x0000ffff) << 16 | (x & 0xffff0000) >> 16;
+
+       return x;
+}
+
+/**
+ * bitrev8(): function for reversing bits of a byte
+ * @byte: the byte to get its bits reversed
+ */

  static inline u8 bitrev8(u8 byte)
  {
-       return byte_rev_table[byte];
+       u8 k = 7;
+       if(k & 1)
+               byte = (byte & 0x5555) << 1 | (byte & 0xaaaa) >> 1;
+       if(k & 2)
+               byte = (byte & 0x3333) << 2 | (byte & 0xcccc) >> 2;
+       if(k & 4)
+               byte = (byte & 0x0f0f) << 4 | (byte & 0xf0f0) >> 4;
+       return byte;
  }

  extern u32 bitrev32(u32 in);



-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

