Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbZCNLJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbZCNLJN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 07:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbZCNLI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 07:08:58 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:48333 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbZCNLI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 07:08:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=obfiSackzVjGtw/2weE7xAZQX9dOuO/GR/M1BX+hBCSOr4aQLd1RK7/ojtjaHPV3nY
         JIMkoQkuWujNq3qt4mW8pblg4/eMDCIsjVER+3bq1e2I5pdVCyWa2MPob7iCXLo7ALio
         GjmbaptT+4RKt36nmjWltd4lgzaF1tWlxnw2c=
Date: Sat, 14 Mar 2009 12:08:50 +0100
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: tip.git regression from "vsprintf: unify the format decoding
	layer for its 3 users"
Message-ID: <20090314110850.GA5174@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BB5708.1090604@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/14 Jeremy Fitzhardinge <jeremy@goop.org>:
> Change fef20d9c1380f04ba9492d6463148db07b413708, "vsprintf: unify the format
> decoding layer for its 3 users", causes a regression in xenbus which results
> in no devices getting attached to a new domain.  Reverting
> fef20d9c1380f04ba9492d6463148db07b413708 and
> 39e874f8afbdb3745e2406ce4ecbde9ac4cbaa78 fixes the problem.
>
> I haven't identified what format string is being handled wrongly, so I don't
> know what the precise bug is.  The most complex looking format in use seems
> to be %.*s; there's also "%s/%s", "%i" and "%lX".

Hi,

At least %.*s seems to be broken. How about this patch?

Vegard


diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index dc16743..be3001f 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -398,7 +398,7 @@ static noinline char* put_dec(char *buf, unsigned long long num)
 
 enum format_type {
 	FORMAT_TYPE_NONE, /* Just a string part */
-	FORMAT_TYPE_WITDH,
+	FORMAT_TYPE_WIDTH,
 	FORMAT_TYPE_PRECISION,
 	FORMAT_TYPE_CHAR,
 	FORMAT_TYPE_STR,
@@ -770,7 +770,7 @@ static int format_decode(const char *fmt, struct printf_spec *spec)
 	const char *start = fmt;
 
 	/* we finished early by reading the field width */
-	if (spec->type == FORMAT_TYPE_WITDH) {
+	if (spec->type == FORMAT_TYPE_WIDTH) {
 		if (spec->field_width < 0) {
 			spec->field_width = -spec->field_width;
 			spec->flags |= LEFT;
@@ -828,7 +828,7 @@ static int format_decode(const char *fmt, struct printf_spec *spec)
 		spec->field_width = skip_atoi(&fmt);
 	else if (*fmt == '*') {
 		/* it's the next argument */
-		spec->type = FORMAT_TYPE_WITDH;
+		spec->type = FORMAT_TYPE_WIDTH;
 		return ++fmt - start;
 	}
 
@@ -843,7 +843,7 @@ precision:
 				spec->precision = 0;
 		} else if (*fmt == '*') {
 			/* it's the next argument */
-			spec->type = FORMAT_TYPE_WITDH;
+			spec->type = FORMAT_TYPE_PRECISION;
 			return ++fmt - start;
 		}
 	}
@@ -1002,7 +1002,7 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 			break;
 		}
 
-		case FORMAT_TYPE_WITDH:
+		case FORMAT_TYPE_WIDTH:
 			spec.field_width = va_arg(args, int);
 			break;
 
@@ -1306,7 +1306,7 @@ do {									\
 		case FORMAT_TYPE_NONE:
 			break;
 
-		case FORMAT_TYPE_WITDH:
+		case FORMAT_TYPE_WIDTH:
 		case FORMAT_TYPE_PRECISION:
 			save_arg(int);
 			break;
@@ -1472,7 +1472,7 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
 			break;
 		}
 
-		case FORMAT_TYPE_WITDH:
+		case FORMAT_TYPE_WIDTH:
 			spec.field_width = get_arg(int);
 			break;
 
