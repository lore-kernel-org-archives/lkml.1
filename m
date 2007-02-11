Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223AbXBKAU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbXBKAU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 19:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbXBKAU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 19:20:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbXBKAU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 19:20:26 -0500
Date: Sat, 10 Feb 2007 19:20:20 -0500
From: Dave Jones <davej@redhat.com>
To: William Cohen <wcohen@redhat.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Size of 2.6.20 task_struct on x86_64 machines
Message-ID: <20070211002020.GA6849@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	William Cohen <wcohen@redhat.com>, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <45CB4C55.4070902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45CB4C55.4070902@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 11:14:13AM -0500, William Cohen wrote:
 > This past week I was playing around with that pahole tool
 > (http://oops.ghostprotocols.net:81/acme/dwarves/) and looking at the
 > size of various struct in the kernel. I was surprised by the size of
 > the task_struct on x86_64, approaching 4K.  I looked through the
 > fields in task_struct and found that a number of them were declared as
 > "unsigned long" rather than "unsigned int" despite them appearing okay
 > as 32-bit sized fields. On x86_64 "unsigned long" ends up being 8
 > bytes in size and forces 8 byte alignment. Is there a reason there
 > a reason they are "unsigned long"?
 > 
 > The patch below drops the size of the struct from 3808 bytes (60
 > 64-byte cachelines) to 3760 bytes (59 64-byte cachelines). A couple
 > other fields in the task struct take a signficant amount of space:
 > 
 > struct thread_struct       thread;               688
 > struct held_lock           held_locks[30];       1680
 > 
 > CONFIG_LOCKDEP is turned on in the .config

I sent this .. http://lkml.org/lkml/2007/1/2/299
last month which shrinks task struct by 480 bytes when lockdep
is enabled. Ingo acked it, but then it fell on the floor.

Here it is again..

		Dave

Shrink the held_lock struct by using bitfields.
This shrinks task_struct on lockdep enabled kernels by 480 bytes.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index ea097dd..ba81cce 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -175,11 +175,11 @@ struct held_lock {
 	 * The following field is used to detect when we cross into an
 	 * interrupt context:
 	 */
-	int				irq_context;
-	int				trylock;
-	int				read;
-	int				check;
-	int				hardirqs_off;
+	unsigned char irq_context:1;
+	unsigned char trylock:1;
+	unsigned char read:2;
+	unsigned char check:1;
+	unsigned char hardirqs_off:1;
 };
 
 /*

-- 
http://www.codemonkey.org.uk
