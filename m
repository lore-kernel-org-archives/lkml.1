Return-Path: <linux-kernel-owner+w=401wt.eu-S1759990AbZACRLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990AbZACRLa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 12:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZACRLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 12:11:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258AbZACRLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 12:11:21 -0500
Date: Sat, 3 Jan 2009 09:10:40 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Trent Piepho <xyzzy@speakeasy.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] printk: Let %pR handle NULL pointers
In-Reply-To: <1230979341-23029-1-git-send-email-xyzzy@speakeasy.org>
Message-ID: <alpine.LFD.2.00.0901030905140.3179@localhost.localdomain>
References: <1230979341-23029-1-git-send-email-xyzzy@speakeasy.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 3 Jan 2009, Trent Piepho wrote:
>
> Have %pR print "[NULL]" for the resource range when passed a NULL pointer.

Wouldn't it be much nicer to just do it for _all_ pointer types?

IOW, a patch more like the appended.

Also, I'm not 100% sure that "[NULL]" is the right thing to print. Not 
that I know if there's anything better. Testing glibc, it prints "(nil)" 
for a NULL string (%s) and "(null)" for a NULL pointer (%p). Which makes 
no more sense than anything else, but maybe we could make the NULL %p case 
at least match that if for no other reason than the fact that it would 
match _something_.

Added the other people who added %pX modifiers to the cc - I guess the 
networking people probably never have NULL pointers there anyway, but 
maybe they have opinions.

		Linus

---
 lib/vsprintf.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 3b77702..4df1884 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -661,6 +661,9 @@ static char *ip4_addr_string(char *buf, char *end, u8 *addr, int field_width,
  */
 static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field_width, int precision, int flags)
 {
+	if (!ptr)
+		return string(buf, end, "[NULL]", field_width, precision, flags);
+
 	switch (*fmt) {
 	case 'F':
 		ptr = dereference_function_descriptor(ptr);
