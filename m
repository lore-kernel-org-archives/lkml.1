Return-Path: <linux-kernel-owner+w=401wt.eu-S1761348AbYEMX6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761348AbYEMX6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 19:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757551AbYEMX5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 19:57:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:32990 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773AbYEMX5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 19:57:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lNfjjjeJBfKdhHkr8k/1pURy9vhFOK8PMeGkDoAYjEwjNq7MqJr9FwjT4unXp2V0L0qTjno9VCcARqw+SkcLiL6L9MKsRz8IkIGdITzqQw3xFXk5TI/40udDJdX0NHMwGFhePotLUuC/qSSfgv2zQNlXhz74YHYHWg63a9NgpLQ=
Subject: [PATCH 3/3] lib: add range check to avoid overflow
	simple_strtoul/ull
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain
Date: Tue, 13 May 2008 16:57:44 -0700
Message-Id: <1210723064.6191.12.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a simple range check to avoid overflowing an UL, ULL
respectively.  The strict versions will catch this case now
as the strlen call will be longer than the number of characters
read. Previously, the simple function would read as long as there
were valied hexadecimal characters remaining.

The simple_strtol/ll still can overflow producing sign errors, but
maybe those users should be using the strict versions then?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
As Alexey noted, the strict versions are a bit of a joke if they
can overflow in the simple cases, here's one way of closing the
gap for the strict functions and simple_strtoul/simple_strtoull

simple_strtol/simple_strtoll still has a (narrower) chance at overflow
and is not totally safe...use the strict versions then.

 lib/vsprintf.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 3547fb5..89f2620 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -57,6 +57,7 @@ static u8 chartou8(char ch)
 unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base)
 {
 	unsigned long result = 0;
+	unsigned long maxval;
 	u8 value;
 
 	if (!base)
@@ -65,9 +66,12 @@ unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base)
 	if (base == 16 && cp[0] == '0' && TOLOWER(cp[1]) == 'x')
 			cp += 2;
 
+	maxval = ULONG_MAX / base;
 	while (isxdigit(*cp) && (value = chartou8(*cp) < base)) {
 		result = result * base + value;
 		cp++;
+		if (result > maxval)
+			break;
 	}
 
 	if (endp)
@@ -99,6 +103,7 @@ EXPORT_SYMBOL(simple_strtol);
 unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base)
 {
 	unsigned long long result = 0;
+	unsigned long long maxval;
 	u8 value;
 
 	if (!base)
@@ -107,9 +112,12 @@ unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int bas
 	if (base == 16 && cp[0] == '0' && TOLOWER(cp[1]) == 'x')
 		cp += 2;
 
+	maxval = ULLONG_MAX / base;
 	while (isxdigit(*cp) && (value = chartou8(*cp) < base)) {
 		result = result * base + value;
 		cp++;
+		if (result > maxval)
+			break;
 	}
 
 	if (endp)
-- 
1.5.5.1.482.g0f174

