Return-Path: <linux-kernel-owner+w=401wt.eu-S965362AbXBLUWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965362AbXBLUWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 15:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965318AbXBLUWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 15:22:39 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:53952 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965362AbXBLUWi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 15:22:38 -0500
Date: Mon, 12 Feb 2007 12:18:55 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Jochen =?ISO-8859-1?Q?Vo=DF" ?= <jochen.voss@googlemail.com>
Cc: "Andi Kleen" <ak@suse.de>, "Christoph Hellwig" <hch@infradead.org>,
       "Segher Boessenkool" <segher@kernel.crashing.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86 for review III] [1/29] i386: avoid gcc extension
Message-Id: <20070212121855.4611d910.randy.dunlap@oracle.com>
In-Reply-To: <ef1cd66f0702121143i765ccd1ere8ecb28eeaab5759@mail.gmail.com>
References: <20070212551.664370000@suse.de>
	<ef1cd66f0702121143i765ccd1ere8ecb28eeaab5759@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Feb 2007 19:43:36 +0000 Jochen Voß wrote:

> Hi,
> 
> On 12/02/07, Andi Kleen <ak@suse.de> wrote:
> > setcc() in math-emu is written as a gcc extension statement expression
> > macro that returns a value.  However, it's not used that way and it's not
> > needed like that, so just make it a do-while non-extension macro so that we
> > don't use an extension when it's not needed.
> 
> This description ...
> 
> ... seems to contradict the implementation.  No "do-while" here.
> 
> I hope this helps,

Yes, thanks.  First version was do-while, latter was inline.

Here's an updated patch/description.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

setcc() in math-emu is written as a gcc extension statement expression
macro that returns a value.  However, it's not used that way and it's
not needed like that, so just make it an inline void so that
we don't use an extension when it's not needed.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/i386/math-emu/status_w.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- linux-2620-rc2.orig/arch/i386/math-emu/status_w.h
+++ linux-2620-rc2/arch/i386/math-emu/status_w.h
@@ -48,9 +48,11 @@
 
 #define status_word() \
   ((partial_status & ~SW_Top & 0xffff) | ((top << SW_Top_Shift) & SW_Top))
-#define setcc(cc) ({ \
-  partial_status &= ~(SW_C0|SW_C1|SW_C2|SW_C3); \
-  partial_status |= (cc) & (SW_C0|SW_C1|SW_C2|SW_C3); })
+static inline void setcc(int cc)
+{
+	partial_status &= ~(SW_C0|SW_C1|SW_C2|SW_C3);
+	partial_status |= (cc) & (SW_C0|SW_C1|SW_C2|SW_C3);
+}
 
 #ifdef PECULIAR_486
    /* Default, this conveys no information, but an 80486 does it. */
