Return-Path: <linux-kernel-owner+w=401wt.eu-S1761602AbYCCT1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761602AbYCCT1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756139AbYCCT1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:27:15 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55962 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756133AbYCCT1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:27:14 -0500
Date: Mon, 3 Mar 2008 14:27:12 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [patch] Re: using long instead of atomic_t when only set/read
 is required
In-Reply-To: <20080303174422.GB13869@elf.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0803031422080.3611-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Pavel Machek wrote:

> Ok... can we get Alan Stern's patch into Documentation/atomic_ops.txt
> , then? I was not aware of this, and there seems to be lot of
> confusion around...
> 
> Plus... I really don't think we can "just access" this as normal
> pointers... due to the compiler issues Alan Cox mentioned, and due to
> the ACCESS_ONCE() issue.

Here's an updated version of the patch, including the issue Alan Cox 
brought up.

Alan Stern

-----------------------------------------------------------------

Atomicity of reads of write for pointers and integral types (other than 
long long) should be documented, along with the limitations imposed by 
the compiler.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/Documentation/atomic_ops.txt
===================================================================
--- usb-2.6.orig/Documentation/atomic_ops.txt
+++ usb-2.6/Documentation/atomic_ops.txt
@@ -21,6 +21,24 @@ local_t is very similar to atomic_t. If 
 updated by one CPU, local_t is probably more appropriate. Please see
 Documentation/local_ops.txt for the semantics of local_t.
 
+For all properly-aligned pointer and integral types other than long
+long, the kernel requires simple reads and writes to be atomic with
+respect to each other.  That is, if one CPU reads a pointer value at
+the same time as another CPU overwrites the pointer, it is guaranteed
+that the reader will obtain either the old or the new value of the
+pointer, never some mish-mash combination of the two.  Likewise, if
+one CPU writes a long value at the same time as another CPU does, it
+is guaranteed that one or the other of the values will end up stored
+in memory, not some mish-mash combination of bits.
+
+Thus, if all you need is atomicity of reading and writing then you can
+use plain old ints, longs, or pointers; you don't need to use
+atomic_t.  But note: This guarantee emphatically does not apply to
+long long values or unaligned values!  Note also that gcc does not
+guarantee to compile all C assignment expressions into simple writes.
+For example, a statement like "x = a + b" might cause gcc to emit code
+equivalent to "x = a; x += b", which is decidedly non-atomic.
+
 The first operations to implement for atomic_t's are the initializers and
 plain reads.
 

